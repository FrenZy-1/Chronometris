#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>
#include <QTime>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    generateDummyData();
    m_todayFocusSeconds = 15600; m_todaySessions = 8;
    m_timer->start();
}

// ... (Getters) ...
QString TimerEngine::timeRemainingString() const { int m=m_remaining/60; int s=m_remaining%60; return QString("%1:%2").arg(m,2,10,QChar('0')).arg(s,2,10,QChar('0')); }
QString TimerEngine::currentType() const { return m_sessionQueue.empty()?"idle":m_sessionQueue.front().type; }
QString TimerEngine::todayFocusString() { int h=m_todayFocusSeconds/3600; int m=(m_todayFocusSeconds%3600)/60; return QString("%1h %2m").arg(h).arg(m); }
int TimerEngine::todaySessionCount() { return m_todaySessions; }
int TimerEngine::currentStreak() { return m_streak; }

// ... (Lists) ...
QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::activeAlarmsList() {
    QVariantList all=DatabaseManager::instance().getAlarms(), active;
    for(const auto &i:all) if(i.toMap()["config"].toMap()["active"].toBool()) active.append(i);
    return active;
}
QVariantList TimerEngine::inactiveAlarmsList() {
    QVariantList all=DatabaseManager::instance().getAlarms(), inactive;
    for(const auto &i:all) if(!i.toMap()["config"].toMap()["active"].toBool()) inactive.append(i);
    return inactive;
}

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

QVariantList TimerEngine::historyList() {
    QVariantList l; l.append(QVariantMap{{"name","Deep Work"},{"time","25m"},{"date","Today"},{"config",QVariantMap{{"mode","pomodoro"},{"durations",QVariantMap{{"work",1500}}}}}});
    return l;
}
QVariantList TimerEngine::chartData() { QVariantList l; for(int i=0;i<7;i++) {QVariantMap d; d["work"]=2+(i%3);d["short"]=1;d["long"]=i%2;l.append(d);} return l; }

void TimerEngine::generateDummyData() {
    if (DatabaseManager::instance().getAlarms().isEmpty()) {
        // Add specific upcoming alarm for testing (Current Time + 2 mins)
        QTime soon = QTime::currentTime().addSecs(120);
        QString soonStr = QString("%1:%2").arg(soon.hour()).arg(soon.minute());

        DatabaseManager::instance().addAlarm({{"name","Test Alarm"},{"time",soonStr},{"days","Daily"},{"ringtone",""},{"active", true}});
        DatabaseManager::instance().addAlarm({{"name","Morning Meds"},{"time","08:00"},{"days","Daily"},{"ringtone",""},{"active", true}});
        DatabaseManager::instance().addAlarm({{"name","Night Routine"},{"time","22:00"},{"days","Daily"},{"ringtone",""},{"active", false}});
    }
    emit analyticsChanged(); emit dataChanged();
}

// NOTE: removed isAlarmSoon, nextAlarmName, nextAlarmTime because they are inline in header

// ... (Control Logic) ...
void TimerEngine::start() { if(m_state!="running"){m_state="running"; emit currentStateChanged();} }
void TimerEngine::pause() { if(m_state=="running"){m_state="paused"; emit currentStateChanged();} }
void TimerEngine::stop() { m_state="stopped"; m_timer->stop(); m_sessionQueue.clear(); m_activeConfig.clear(); m_remaining=1500; m_totalDuration=1500; m_progress=0.0; emit currentStateChanged(); emit timeChanged(); emit typeChanged(); }
void TimerEngine::skip() { qDebug()<<"Skip"; completeSession(); }

// --- FIXED ALARM CHECKER ---
void TimerEngine::checkAlarms() {
    QTime now = QTime::currentTime();
    bool found = false;

    QVariantList active = activeAlarmsList();
    for(const auto &item : active) {
        QVariantMap map = item.toMap();
        QString timeStr = map["config"].toMap()["time"].toString();

        QTime alarmTime = QTime::fromString(timeStr, "H:m");
        if (!alarmTime.isValid()) alarmTime = QTime::fromString(timeStr, "HH:mm");

        if (alarmTime.isValid()) {
            int diff = now.secsTo(alarmTime);

            // Handle Midnight Wrapping
            if (diff < 0) diff += 86400;

            // Check if within 15 mins (900s)
            if (diff >= 0 && diff <= 900) {
                m_isAlarmSoon = true;
                m_nextAlarmName = map["name"].toString();
                m_nextAlarmTime = timeStr;
                found = true;
                break;
            }
        }
    }

    if (!found && m_isAlarmSoon) {
        m_isAlarmSoon = false;
    }
    emit timeChanged();
}

void TimerEngine::processTimer() {
    checkAlarms(); // Check every second
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
