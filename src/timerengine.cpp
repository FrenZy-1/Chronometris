// src/TimerEngine.cpp
#include "TimerEngine.h"
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    m_timer->setInterval(1000); // 1 second
    connect(m_timer, &QTimer::timeout, this, &TimerEngine::processTimer);

    setupQueue();
}

void TimerEngine::setupQueue() {
    // Implementing the specific Pomodoro Queue requested
    m_sessionQueue.push_back({"work", 25 * 60});
    m_sessionQueue.push_back({"shortBreak", 5 * 60});
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
    // Reset to initial duration of current session
    if (!m_sessionQueue.empty()) {
        m_remaining = m_sessionQueue.front().duration;
        m_totalDuration = m_remaining;
        m_progress = 0.0;
    }
    emit currentStateChanged();
    emit timeChanged();
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
    stop();

    if (!m_sessionQueue.empty()) {
        // Push to History Stack (Stack Implementation)
        m_historyStack.push(m_sessionQueue.front());

        // Remove from Queue
        m_sessionQueue.pop_front();

        // If Queue is empty, refill it (Circular logic)
        if (m_sessionQueue.empty()) setupQueue();

        // Prepare next session
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
        // Pop from history and push back to front of queue
        Session last = m_historyStack.pop();
        m_sessionQueue.push_front(last);

        // Reset state to this restored session
        stop();
        emit typeChanged();
    }
}
