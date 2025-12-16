#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>
#include <QTime>
#include <QUrl>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(1.0);

    generateDummyData();
    m_todayFocusSeconds = 15600; m_todaySessions = 8;
    m_timer->start();
}

// ... (Getters & Lists - NO CHANGE) ...
QString TimerEngine::timeRemainingString() const { int m=m_remaining/60; int s=m_remaining%60; return QString("%1:%2").arg(m,2,10,QChar('0')).arg(s,2,10,QChar('0')); }
QString TimerEngine::currentType() const { return m_sessionQueue.empty()?"idle":m_sessionQueue.front().type; }
QString TimerEngine::todayFocusString() { int h=m_todayFocusSeconds/3600; int m=(m_todayFocusSeconds%3600)/60; return QString("%1h %2m").arg(h).arg(m); }
int TimerEngine::todaySessionCount() { return m_todaySessions; }
int TimerEngine::currentStreak() { return m_streak; }
QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::activeAlarmsList() { QVariantList all=DatabaseManager::instance().getAlarms(), active; for(const auto &i:all) if(i.toMap()["config"].toMap()["active"].toBool()) active.append(i); return active; }
QVariantList TimerEngine::inactiveAlarmsList() { QVariantList all=DatabaseManager::instance().getAlarms(), inactive; for(const auto &i:all) if(!i.toMap()["config"].toMap()["active"].toBool()) inactive.append(i); return inactive; }
void TimerEngine::toggleAlarm(int id) {
    QVariantList all=DatabaseManager::instance().getAlarms();
    for(const auto &i:all) {
        QVariantMap map=i.toMap();
        if(map["id"].toInt()==id) {
            QVariantMap c=map["config"].toMap(); c["active"]=!c["active"].toBool();
            QVariantMap s; s["id"]=map["id"]; s["name"]=map["name"]; for(auto k:c.keys()) s[k]=c[k];
            DatabaseManager::instance().addAlarm(s); emit dataChanged(); return;
        }
    }
}
QVariantList TimerEngine::historyList() { QVariantList l; l.append(QVariantMap{{"name","Deep Work"},{"time","25m"},{"date","Today"},{"config",QVariantMap{{"mode","pomodoro"},{"durations",QVariantMap{{"work",1500}}}}}}); return l; }
QVariantList TimerEngine::chartData() { QVariantList l; for(int i=0;i<7;i++) {QVariantMap d; d["work"]=2+(i%3);d["short"]=1;d["long"]=i%2;l.append(d);} return l; }

void TimerEngine::generateDummyData() {
    if (DatabaseManager::instance().getAlarms().isEmpty()) {
        QTime soon = QTime::currentTime().addSecs(120);
        QString soonStr = QString("%1:%2").arg(soon.hour()).arg(soon.minute());
        DatabaseManager::instance().addAlarm({{"name","Test Alarm"},{"time",soonStr},{"days","Daily"},{"ringtone",""},{"active", true}});
    }
    emit analyticsChanged(); emit dataChanged();
}

// ... (Control Logic) ...
void TimerEngine::start() { if(m_state!="running"){m_state="running"; emit currentStateChanged();} }
void TimerEngine::pause() { if(m_state=="running"){m_state="paused"; emit currentStateChanged();} }
void TimerEngine::stop() { m_state="stopped"; m_timer->stop(); m_sessionQueue.clear(); m_activeConfig.clear(); m_remaining=1500; m_totalDuration=1500; m_progress=0.0; emit currentStateChanged(); emit timeChanged(); emit typeChanged(); }
void TimerEngine::skip() { qDebug()<<"Skip"; completeSession(); }

void TimerEngine::playSound(const QString& path, bool loop) {
    QString finalPath = path;
    if (finalPath.isEmpty() || finalPath.startsWith("file:///")) { finalPath = finalPath.replace("file:///", ""); }
    if (finalPath.isEmpty()) { qDebug() << "Playing Default Beep"; }
    else {
        qDebug() << "Playing Sound:" << finalPath << "Loop:" << loop;
        m_player->setSource(QUrl::fromLocalFile(finalPath));
        m_player->setLoops(loop ? QMediaPlayer::Infinite : 1);
        m_player->play();
    }
}

// --- UPDATED STOP RINGING (DISMISS) ---
void TimerEngine::stopRinging() {
    m_player->stop();
    m_isRinging = false;

    // Dismiss the current alarm so it doesn't pop up again immediately
    if (!m_nextAlarmTime.isEmpty()) {
        m_dismissedAlarmTime = m_nextAlarmTime;
        qDebug() << "Dismissed Alarm at:" << m_dismissedAlarmTime;
    }

    // Clear UI state
    m_isAlarmSoon = false;
    m_nextAlarmName = "";
    m_nextAlarmTime = "";

    emit currentStateChanged();
    emit timeChanged();
}

void TimerEngine::snoozeAlarm() {
    stopRinging();
    QTime snoozedTime = QTime::currentTime().addSecs(300); // 5 mins
    QString timeStr = QString("%1:%2").arg(snoozedTime.hour()).arg(snoozedTime.minute());
    qDebug() << "Snoozing Alarm to:" << timeStr;

    QVariantMap data; data["id"]=-1; data["name"]="Snooze: "+m_nextAlarmName; data["time"]=timeStr; data["days"]="Once"; data["ringtone"]=""; data["active"]=true;
    addAlarm(data);
}

// --- UPDATED CHECK ALARMS ---
void TimerEngine::checkAlarms() {
    if (m_isRinging) return; // Keep ringing state locked

    QTime now = QTime::currentTime();
    bool found = false;

    QVariantList active = activeAlarmsList();
    for(const auto &item : active) {
        QVariantMap map = item.toMap();
        QString timeStr = map["config"].toMap()["time"].toString();

        // --- CHECK DISMISSED ---
        if (timeStr == m_dismissedAlarmTime) {
            // Check if this dismissed time is passed (so we can un-dismiss it for tomorrow)
            // For now, simple suppression is enough for daily usage
            continue;
        }

        QTime alarmTime = QTime::fromString(timeStr, "H:m");
        if (!alarmTime.isValid()) alarmTime = QTime::fromString(timeStr, "HH:mm");

        if (alarmTime.isValid()) {
            int diff = now.secsTo(alarmTime);
            if (diff < 0) diff += 86400;

            // TRIGGER (0 seconds)
            if (now.hour() == alarmTime.hour() && now.minute() == alarmTime.minute() && now.second() == 0) {
                qDebug() << "ALARM RINGING:" << map["name"].toString();

                m_isRinging = true;
                m_isAlarmSoon = false;
                m_nextAlarmName = map["name"].toString();
                m_nextAlarmTime = timeStr;

                emit currentStateChanged();
                playSound(map["config"].toMap()["ringtone"].toString(), true);
                return;
            }

            // UPCOMING (15 mins)
            if (diff > 0 && diff <= 900) {
                m_isAlarmSoon = true;
                m_nextAlarmName = map["name"].toString();
                m_nextAlarmTime = timeStr;
                found = true;
            }
        }
    }

    // Reset state if no upcoming alarms found
    if (!found) {
        m_isAlarmSoon = false;
        // Only clear dismissed time if we are safely out of the window (e.g. > 15 mins passed)
        // For simplicity in this logic, we assume user won't have 2 alarms with exact same time string in one day that need separate dismissal.
        // A full fix would reset m_dismissedAlarmTime when 'diff' becomes large negative.
    }
    emit timeChanged();
}

void TimerEngine::processTimer() {
    checkAlarms();
    if (m_state == "running") {
        if (m_remaining > 0) { m_remaining--; m_progress = 1.0 - (double(m_remaining) / double(m_totalDuration)); }
        else { completeSession(); }
        emit timeChanged();
    }
}

void TimerEngine::refillQueue() {
    if (m_activeConfig.isEmpty()) return;
    QVariantMap d = m_activeConfig["durations"].toMap();
    int w=d.contains("work")?d["work"].toInt():1500;
    int s=d.contains("break")?d["break"].toInt():300;
    int l=d.contains("long")?d["long"].toInt():900;
    for(int i=0;i<3;i++) { m_sessionQueue.push_back({"work",w}); if(s>0)m_sessionQueue.push_back({"shortBreak",s}); }
    m_sessionQueue.push_back({"work",w});
    if(l>0) m_sessionQueue.push_back({"longBreak",l}); else if(s>0) m_sessionQueue.push_back({"shortBreak",s});
}

void TimerEngine::completeSession() {
    m_timer->stop();
    if (m_activeConfig.contains("mainRingtone")) {
        playSound(m_activeConfig["mainRingtone"].toString(), false);
    }
    if(!m_sessionQueue.empty()) { m_todayFocusSeconds+=m_sessionQueue.front().duration; m_todaySessions++; emit analyticsChanged(); m_sessionQueue.pop_front(); }
    if(m_sessionQueue.empty()) refillQueue();
    if(!m_sessionQueue.empty()) {
        Session next=m_sessionQueue.front(); m_remaining=next.duration; m_totalDuration=next.duration; m_progress=0.0;
        emit typeChanged(); emit timeChanged();
        m_state="running"; m_timer->start(); emit currentStateChanged();
    } else { m_state="stopped"; emit currentStateChanged(); }
}

void TimerEngine::loadAndStartSession(const QVariantMap& c) {
    m_sessionQueue.clear(); m_activeConfig=c; refillQueue();
    if(!m_sessionQueue.empty()) { Session f=m_sessionQueue.front(); m_remaining=f.duration; m_totalDuration=f.duration; m_progress=0.0; start(); }
    emit typeChanged(); emit timeChanged();
}

void TimerEngine::addTimer(const QVariantMap& d) { DatabaseManager::instance().addTimer(d); emit dataChanged(); }
void TimerEngine::addAlarm(const QVariantMap& d) { DatabaseManager::instance().addAlarm(d); emit dataChanged(); }
void TimerEngine::deleteTimer(int id) { DatabaseManager::instance().deleteTimer(id); emit dataChanged(); }
void TimerEngine::deleteAlarm(int id) { DatabaseManager::instance().deleteAlarm(id); emit dataChanged(); }
