#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    generateDummyData();
    m_todayFocusSeconds = 15600; m_todaySessions = 8;
}

// ... (Getters) ...
QString TimerEngine::timeRemainingString() const {
    int m = m_remaining / 60; int s = m_remaining % 60;
    return QString("%1:%2").arg(m, 2, 10, QChar('0')).arg(s, 2, 10, QChar('0'));
}
QString TimerEngine::currentType() const { return m_sessionQueue.empty() ? "idle" : m_sessionQueue.front().type; }
QString TimerEngine::todayFocusString() { int h = m_todayFocusSeconds/3600; int m=(m_todayFocusSeconds%3600)/60; return QString("%1h %2m").arg(h).arg(m); }
int TimerEngine::todaySessionCount() { return m_todaySessions; }
int TimerEngine::currentStreak() { return m_streak; }

// ... (Lists) ...
QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::activeAlarmsList() {
    QVariantList all = DatabaseManager::instance().getAlarms();
    QVariantList active;
    for(const auto &item : all) { if(item.toMap()["config"].toMap()["active"].toBool()) active.append(item); }
    return active;
}
QVariantList TimerEngine::inactiveAlarmsList() {
    QVariantList all = DatabaseManager::instance().getAlarms();
    QVariantList inactive;
    for(const auto &item : all) { if(!item.toMap()["config"].toMap()["active"].toBool()) inactive.append(item); }
    return inactive;
}
void TimerEngine::toggleAlarm(int id) {
    QVariantList all = DatabaseManager::instance().getAlarms();
    for(const auto &item : all) {
        QVariantMap map = item.toMap();
        if(map["id"].toInt() == id) {
            QVariantMap config = map["config"].toMap();
            config["active"] = !config["active"].toBool();
            QVariantMap saveMap; saveMap["id"] = map["id"]; saveMap["name"] = map["name"];
            for(auto k : config.keys()) { saveMap[k] = config[k]; }
            DatabaseManager::instance().addAlarm(saveMap);
            emit dataChanged(); return;
        }
    }
}
QVariantList TimerEngine::historyList() {
    QVariantList list;
    list.append(QVariantMap{{"name", "Deep Work"}, {"time", "25m"}, {"date", "Today"}, {"config", QVariantMap{{"mode", "pomodoro"}, {"durations", QVariantMap{{"work", 1500}, {"break", 300}}}}}});
    return list;
}
QVariantList TimerEngine::chartData() { QVariantList l; for(int i=0;i<7;i++) {QVariantMap d; d["work"]=2+(i%3);d["short"]=1;d["long"]=i%2;l.append(d);} return l; }
void TimerEngine::generateDummyData() {
    if (DatabaseManager::instance().getAlarms().isEmpty()) {
        DatabaseManager::instance().addAlarm({{"name","Daily Standup"},{"time","10:00"},{"days","Daily"},{"ringtone",""},{"active", true}});
    }
    emit analyticsChanged(); emit dataChanged();
}

// ... (Helpers) ...
bool TimerEngine::isAlarmSoon() { return false; }
QString TimerEngine::nextAlarmName() { return ""; }
QString TimerEngine::nextAlarmTime() { return ""; }

void TimerEngine::start() { if (m_state != "running") { m_state = "running"; m_timer->start(); emit currentStateChanged(); } }
void TimerEngine::pause() { if (m_state == "running") { m_state = "paused"; m_timer->stop(); emit currentStateChanged(); } }

void TimerEngine::stop() {
    m_state = "stopped"; m_timer->stop();
    m_sessionQueue.clear();
    m_activeConfig.clear(); // Clear config
    m_remaining = 1500; m_totalDuration = 1500; m_progress = 0.0;
    emit currentStateChanged(); emit timeChanged(); emit typeChanged();
}

void TimerEngine::skip() {
    qDebug() << "Skip requested.";
    completeSession();
}

void TimerEngine::processTimer() {
    if (m_remaining > 0) { m_remaining--; m_progress = 1.0 - (double(m_remaining) / double(m_totalDuration)); emit timeChanged(); }
    else { completeSession(); }
}

// --- UNIFIED REFILL LOGIC ---
void TimerEngine::refillQueue() {
    if (m_activeConfig.isEmpty()) {
        qDebug() << "Refill failed: Config empty";
        return;
    }

    QVariantMap durations = m_activeConfig["durations"].toMap();

    // Load durations with fallbacks (0 if missing, to prevent crashes, but logically we want >0)
    int work = durations.contains("work") ? durations["work"].toInt() : 1500;
    int shortBreak = durations.contains("break") ? durations["break"].toInt() : 300;
    int longBreak = durations.contains("long") ? durations["long"].toInt() : 900;

    QString mode = m_activeConfig["mode"].toString().toLower();
    qDebug() << "Refilling Queue. Mode:" << mode << "Work:" << work << "Break:" << shortBreak;

    // LOGIC: Use Standard Pomodoro Cycle for BOTH 'pomodoro' and 'custom'
    // Pattern: Work -> Short -> Work -> Short -> Work -> Short -> Work -> Long

    // 1. First 3 cycles (Work + Short Break)
    for(int i=0; i<3; i++) {
        m_sessionQueue.push_back({"work", work});
        // Only add break if duration is valid (> 0)
        if (shortBreak > 0) {
            m_sessionQueue.push_back({"shortBreak", shortBreak});
        }
    }

    // 2. Final cycle (Work + Long Break)
    m_sessionQueue.push_back({"work", work});

    if (longBreak > 0) {
        m_sessionQueue.push_back({"longBreak", longBreak});
    } else if (shortBreak > 0) {
        // If user set Long Break to 0 but has Short Break, default to Short Break
        m_sessionQueue.push_back({"shortBreak", shortBreak});
    }
    // If both breaks are 0, it behaves as a continuous Work loop.
}

void TimerEngine::completeSession() {
    m_timer->stop();
    if (!m_sessionQueue.empty()) {
        qDebug() << "Completed session:" << m_sessionQueue.front().type;
        m_todayFocusSeconds += m_sessionQueue.front().duration;
        m_todaySessions++;
        emit analyticsChanged();
        m_sessionQueue.pop_front();
    }

    // If queue empty, generate more cycles (Infinite Loop)
    if (m_sessionQueue.empty()) refillQueue();

    if(!m_sessionQueue.empty()) {
        Session next = m_sessionQueue.front();
        qDebug() << "Starting next session:" << next.type << "Duration:" << next.duration;
        m_remaining = next.duration;
        m_totalDuration = next.duration;
        m_progress = 0.0;

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
    qDebug() << "Loading Session Config:" << config;
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
