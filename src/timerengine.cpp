#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    // MOCK DATA GENERATION ON STARTUP
    generateDummyData();

    // Initialize mock stats
    m_todayFocusSeconds = 15600;
    m_todaySessions = 8;
}

QString TimerEngine::timeRemainingString() const {
    int m = m_remaining / 60;
    int s = m_remaining % 60;
    return QString("%1:%2").arg(m, 2, 10, QChar('0')).arg(s, 2, 10, QChar('0'));
}

QString TimerEngine::currentType() const {
    if (m_sessionQueue.empty()) return "idle";
    return m_sessionQueue.front().type;
}

// --- STATS LOGIC ---
QString TimerEngine::todayFocusString() {
    int h = m_todayFocusSeconds / 3600;
    int m = (m_todayFocusSeconds % 3600) / 60;
    return QString("%1h %2m").arg(h).arg(m);
}
int TimerEngine::todaySessionCount() { return m_todaySessions; }
int TimerEngine::currentStreak() { return m_streak; }

// --- LISTS ---
QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::alarmsList() { return DatabaseManager::instance().getAlarms(); }

QVariantList TimerEngine::historyList() {
    QVariantList list;

    // History Item 1
    QVariantMap item1;
    item1["name"] = "Deep Work Cycle";
    item1["time"] = "25m";
    item1["date"] = "Today";
    // Config to Re-run
    item1["config"] = QVariantMap{
        {"mode", "pomodoro"},
        {"durations", QVariantMap{{"work", 1500}, {"break", 300}, {"long", 900}}}
    };
    list.append(item1);

    // History Item 2
    QVariantMap item2;
    item2["name"] = "Email Triage";
    item2["time"] = "15m";
    item2["date"] = "Yesterday";
    item2["config"] = QVariantMap{
        {"mode", "custom"},
        {"durations", QVariantMap{{"work", 900}}}
    };
    list.append(item2);

    return list;
}

QVariantList TimerEngine::chartData() {
    QVariantList list;
    for(int i=0; i<7; i++) {
        QVariantMap day; day["work"]=2+(i%3); day["short"]=1; day["long"]=(i%2);
        list.append(day);
    }
    return list;
}

// --- DUMMY DATA GENERATOR ---
void TimerEngine::generateDummyData() {
    if (alarmsList().isEmpty()) {
        DatabaseManager::instance().addAlarm({
            {"name", "Daily Standup"}, {"time", "10:00"}, {"days", "Daily"}, {"ringtone", ""}, {"active", true}
        });
        DatabaseManager::instance().addAlarm({
            {"name", "Gym Time"}, {"time", "17:30"}, {"days", "[1,3,5]"}, {"ringtone", ""}, {"active", true}
        });
        DatabaseManager::instance().addAlarm({
            {"name", "Meds"}, {"time", "08:00"}, {"days", "Daily"}, {"ringtone", ""}, {"active", false}
        });
    }
    emit analyticsChanged();
    emit dataChanged();
}

// ... (Standard Engine Logic: Start, Pause, Stop, Alarm) ...
bool TimerEngine::isAlarmSoon() { return false; }
QString TimerEngine::nextAlarmName() { return ""; }
QString TimerEngine::nextAlarmTime() { return ""; }

void TimerEngine::start() {
    if (m_state != "running") { m_state = "running"; m_timer->start(); emit currentStateChanged(); }
}
void TimerEngine::pause() {
    if (m_state == "running") { m_state = "paused"; m_timer->stop(); emit currentStateChanged(); }
}
void TimerEngine::stop() {
    m_state = "stopped"; m_timer->stop();
    if(!m_sessionQueue.empty()) { m_remaining = m_sessionQueue.front().duration; m_totalDuration=m_remaining; m_progress=0.0; }
    emit currentStateChanged(); emit timeChanged();
}
void TimerEngine::skip() { completeSession(); }

void TimerEngine::processTimer() {
    if (m_remaining > 0) {
        m_remaining--;
        m_progress = 1.0 - (double(m_remaining) / double(m_totalDuration));
        emit timeChanged();
    } else {
        completeSession();
    }
}

void TimerEngine::completeSession() {
    m_timer->stop(); m_state = "stopped"; emit currentStateChanged();
    if (!m_sessionQueue.empty()) {
        Session current = m_sessionQueue.front();
        m_todayFocusSeconds += current.duration; m_todaySessions++; emit analyticsChanged();
        m_sessionQueue.pop_front();
        if(!m_sessionQueue.empty()) {
            Session next = m_sessionQueue.front();
            m_remaining = next.duration; m_totalDuration = next.duration; m_progress=0.0;
            emit typeChanged(); emit timeChanged();
        }
    }
}

void TimerEngine::loadAndStartSession(const QVariantMap& config) {
    m_sessionQueue.clear();
    QVariantMap durations = config["durations"].toMap();
    int work = durations["work"].toInt();
    if(config["mode"].toString() == "pomodoro") {
        m_sessionQueue.push_back({"work", work});
        m_sessionQueue.push_back({"shortBreak", durations["break"].toInt()});
    } else {
        m_sessionQueue.push_back({"work", work});
    }
    if(!m_sessionQueue.empty()) {
        m_remaining = m_sessionQueue.front().duration; m_totalDuration=m_remaining; m_progress=0.0;
        if(m_state!="running") start();
    }
    emit typeChanged(); emit timeChanged();
}

void TimerEngine::addTimer(const QVariantMap& data) { DatabaseManager::instance().addTimer(data); emit dataChanged(); }
void TimerEngine::addAlarm(const QVariantMap& data) { DatabaseManager::instance().addAlarm(data); emit dataChanged(); }
void TimerEngine::deleteTimer(int id) { DatabaseManager::instance().deleteTimer(id); emit dataChanged(); }
void TimerEngine::deleteAlarm(int id) { DatabaseManager::instance().deleteAlarm(id); emit dataChanged(); }
