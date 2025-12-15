#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    // Auto-populate on first run
    generateDummyData();

    m_todayFocusSeconds = 15600;
    m_todaySessions = 8;
}

// ... (Getters for Time, Type, Stats, Lists - keep same as before) ...
QString TimerEngine::timeRemainingString() const {
    int m = m_remaining / 60;
    int s = m_remaining % 60;
    return QString("%1:%2").arg(m, 2, 10, QChar('0')).arg(s, 2, 10, QChar('0'));
}
QString TimerEngine::currentType() const {
    if (m_sessionQueue.empty()) return "idle";
    return m_sessionQueue.front().type;
}
QString TimerEngine::todayFocusString() { int h = m_todayFocusSeconds / 3600; int m = (m_todayFocusSeconds % 3600) / 60; return QString("%1h %2m").arg(h).arg(m); }
int TimerEngine::todaySessionCount() { return m_todaySessions; }
int TimerEngine::currentStreak() { return m_streak; }
QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::alarmsList() { return DatabaseManager::instance().getAlarms(); }
QVariantList TimerEngine::historyList() {
    QVariantList list;
    list.append(QVariantMap{{"name", "Deep Work Cycle"}, {"time", "25m"}, {"date", "Today"},
                            {"config", QVariantMap{{"mode", "pomodoro"}, {"durations", QVariantMap{{"work", 1500}, {"break", 300}, {"long", 900}}}}}});
    return list;
}
QVariantList TimerEngine::chartData() { QVariantList l; for(int i=0;i<7;i++) {QVariantMap d; d["work"]=2+(i%3);d["short"]=1;d["long"]=i%2;l.append(d);} return l; }
void TimerEngine::generateDummyData() { if(alarmsList().isEmpty()){ DatabaseManager::instance().addAlarm({{"name","Standup"},{"time","10:00"},{"days","Daily"},{"ringtone",""}}); } emit analyticsChanged(); emit dataChanged(); }
bool TimerEngine::isAlarmSoon() { return false; }
QString TimerEngine::nextAlarmName() { return ""; }
QString TimerEngine::nextAlarmTime() { return ""; }

// ... (Start, Pause, Stop) ...
void TimerEngine::start() { if (m_state != "running") { m_state = "running"; m_timer->start(); emit currentStateChanged(); } }
void TimerEngine::pause() { if (m_state == "running") { m_state = "paused"; m_timer->stop(); emit currentStateChanged(); } }
void TimerEngine::stop() {
    m_state = "stopped"; m_timer->stop();
    m_sessionQueue.clear();
    if (!m_activeConfig.isEmpty()) refillQueue();
    if(!m_sessionQueue.empty()) {
        m_remaining = m_sessionQueue.front().duration;
        m_totalDuration=m_remaining; m_progress=0.0;
    }
    emit currentStateChanged(); emit timeChanged(); emit typeChanged();
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

// --- CORRECT QUEUE LOGIC ---
void TimerEngine::refillQueue() {
    if (m_activeConfig.isEmpty()) return;

    QVariantMap durations = m_activeConfig["durations"].toMap();
    int work = durations["work"].toInt();
    int shortBreak = durations["break"].toInt();
    int longBreak = durations["long"].toInt();

    if(m_activeConfig["mode"].toString() == "pomodoro") {
        // Standard: Work, Short, Work, Short, Work, Short, Work, Long
        for(int i=0; i<3; i++) {
            m_sessionQueue.push_back({"work", work});
            m_sessionQueue.push_back({"shortBreak", shortBreak});
        }
        m_sessionQueue.push_back({"work", work});
        m_sessionQueue.push_back({"longBreak", longBreak});
    } else {
        m_sessionQueue.push_back({"work", work});
    }
}

void TimerEngine::completeSession() {
    m_timer->stop();

    if (!m_sessionQueue.empty()) {
        Session current = m_sessionQueue.front();
        m_todayFocusSeconds += current.duration; m_todaySessions++; emit analyticsChanged();
        m_sessionQueue.pop_front();
    }

    if (m_sessionQueue.empty()) refillQueue();

    if(!m_sessionQueue.empty()) {
        Session next = m_sessionQueue.front();
        m_remaining = next.duration;
        m_totalDuration = next.duration;
        m_progress=0.0;
        emit typeChanged(); emit timeChanged();

        m_state = "running";
        m_timer->start();
        emit currentStateChanged();
    } else {
        m_state = "stopped";
        emit currentStateChanged();
    }
}

void TimerEngine::loadAndStartSession(const QVariantMap& config) {
    m_sessionQueue.clear();
    m_activeConfig = config;
    refillQueue();

    if(!m_sessionQueue.empty()) {
        Session first = m_sessionQueue.front();
        m_remaining = first.duration;
        m_totalDuration = first.duration;
        m_progress = 0.0;
        start();
    }
    emit typeChanged(); emit timeChanged();
}

void TimerEngine::addTimer(const QVariantMap& data) { DatabaseManager::instance().addTimer(data); emit dataChanged(); }
void TimerEngine::addAlarm(const QVariantMap& data) { DatabaseManager::instance().addAlarm(data); emit dataChanged(); }
void TimerEngine::deleteTimer(int id) { DatabaseManager::instance().deleteTimer(id); emit dataChanged(); }
void TimerEngine::deleteAlarm(int id) { DatabaseManager::instance().deleteAlarm(id); emit dataChanged(); }
