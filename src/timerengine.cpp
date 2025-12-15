#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QDebug>
#include <QDateTime>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);
    setupQueue();
}

void TimerEngine::setupQueue() {
    m_sessionQueue.clear();
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"shortBreak", 5 * 60});
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"longBreak", 15 * 60});
}

QString TimerEngine::currentType() const {
    if (m_sessionQueue.empty()) return "idle";
    return m_sessionQueue.front().type;
}

bool TimerEngine::isAlarmSoon() { return true; } // Mock for UI test
QString TimerEngine::nextAlarmName() { return "Daily Standup"; }
QString TimerEngine::nextAlarmTime() { return "10:00 AM"; }

void TimerEngine::start() {
    if (m_state != "running") {
        m_state = "running";
        m_timer->start();
        emit currentStateChanged();
        emit typeChanged();
    }
}

void TimerEngine::pause() {
    if (m_state == "running") {
        m_state = "paused";
        m_timer->stop();
        emit currentStateChanged();
    }
}

void TimerEngine::stop() {
    m_state = "stopped";
    m_timer->stop();
    if (!m_sessionQueue.empty()) {
        m_remaining = m_sessionQueue.front().duration;
        m_totalDuration = m_remaining;
        m_progress = 0.0;
    }
    emit currentStateChanged();
    emit timeChanged();
    emit typeChanged();
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
    m_timer->stop();
    m_state = "stopped";
    emit currentStateChanged();

    if (!m_sessionQueue.empty()) {
        Session current = m_sessionQueue.front();
        DatabaseManager::instance().addSession(current.type, current.duration);
        emit analyticsChanged();

        m_historyStack.push(current);
        m_sessionQueue.pop_front();

        if (m_sessionQueue.empty()) setupQueue();

        Session next = m_sessionQueue.front();
        m_remaining = next.duration;
        m_totalDuration = next.duration;
        m_progress = 0.0;

        emit typeChanged();
        emit timeChanged();
    }
}

// --- DATA METHODS ---
void TimerEngine::addTimer(const QVariantMap& data) {
    DatabaseManager::instance().addTimer(data);
    emit dataChanged(); // Updates List
}

void TimerEngine::addAlarm(const QVariantMap& data) {
    DatabaseManager::instance().addAlarm(data);
    emit dataChanged(); // Updates List
}

QVariantList TimerEngine::timersList() { return DatabaseManager::instance().getTimers(); }
QVariantList TimerEngine::alarmsList() { return DatabaseManager::instance().getAlarms(); }

// Analytics
void TimerEngine::generateDummyData() {
    DatabaseManager::instance().generateDummyData();
    emit analyticsChanged();
}

void TimerEngine::loadAndStartSession(const QVariantMap& config) {
    m_sessionQueue.clear();

    // Parse the JSON map
    QVariantMap durations = config["durations"].toMap();
    int work = durations["work"].toInt();
    int sBreak = durations["break"].toInt();
    int lBreak = durations["long"].toInt();

    // Build Queue based on mode
    if(config["mode"].toString() == "pomodoro") {
        m_sessionQueue.push_back({"work", work});
        m_sessionQueue.push_back({"shortBreak", sBreak});
        // ... add more steps ...
    } else {
        // Custom single run or simple loop
        m_sessionQueue.push_back({"work", work});
    }

    // Set immediate state
    if(!m_sessionQueue.empty()) {
        Session first = m_sessionQueue.front();
        m_remaining = first.duration;
        m_totalDuration = first.duration;
        m_progress = 0.0;
        start(); // Auto-start
    }
}

void TimerEngine::deleteTimer(int id) {
    DatabaseManager::instance().deleteTimer(id);
    emit dataChanged();
}
void TimerEngine::deleteAlarm(int id) {
    DatabaseManager::instance().deleteAlarm(id);
    emit dataChanged();
}

QVariantList TimerEngine::chartData() {
    // Return standard object structure for 3-bar chart
    QVariantList list;
    for(int i=0; i<7; i++) {
        QVariantMap day; day["work"]=3; day["short"]=1; day["long"]=2;
        list.append(day);
    }
    return list; // Or connect to DB real stats
}
QList<int> TimerEngine::pieData() { return DatabaseManager::instance().getSessionDistribution(); }
QVariantList TimerEngine::heatmapData() { return DatabaseManager::instance().getHeatmapData(); }
