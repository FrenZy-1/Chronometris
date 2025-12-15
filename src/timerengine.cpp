#include "TimerEngine.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    setupQueue();
}

void TimerEngine::setupQueue() {
    m_sessionQueue.clear();
    // 1
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"shortBreak", 5 * 60});
    // 2
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"shortBreak", 5 * 60});
    // 3
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"shortBreak", 5 * 60});
    // 4
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"longBreak", 15 * 60});
}

QString TimerEngine::currentType() const {
    if (m_sessionQueue.empty()) return "idle";
    return m_sessionQueue.front().type;
}

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

void TimerEngine::skip() {
    completeSession();
}

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
        Session currentSession = m_sessionQueue.front();

        // --- DATABASE SAVE ---
        QSqlQuery query;
        query.prepare("INSERT INTO sessions (cycle_type, duration_seconds) VALUES (:type, :duration)");
        query.bindValue(":type", currentSession.type);
        query.bindValue(":duration", currentSession.duration);
        query.exec();
        // ---------------------

        m_historyStack.push(currentSession);
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

void TimerEngine::undoLastSession() {
    if (!m_historyStack.isEmpty()) {
        Session last = m_historyStack.pop();
        m_sessionQueue.push_front(last);
        stop();
        emit typeChanged();
    }
}
