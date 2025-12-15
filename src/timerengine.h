// src/TimerEngine.h
#ifndef TIMERENGINE_H
#define TIMERENGINE_H

#include <QObject>
#include <QTimer>
#include <QStack>
#include <queue>
#include <deque>

struct Session {
    QString type; // "work", "shortBreak", "longBreak"
    int duration; // in seconds
};

class TimerEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentState READ currentState NOTIFY currentStateChanged)
    Q_PROPERTY(int timeRemaining READ timeRemaining NOTIFY timeChanged)
    Q_PROPERTY(double progress READ progress NOTIFY timeChanged)
    Q_PROPERTY(QString currentType READ currentType NOTIFY typeChanged)

public:
    explicit TimerEngine(QObject *parent = nullptr);

    // QML Invokables
    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void skip();
    Q_INVOKABLE void undoLastSession(); // STACK implementation

    QString currentState() const { return m_state; }
    int timeRemaining() const { return m_remaining; }
    double progress() const { return m_progress; }
    QString currentType() const;

signals:
    void currentStateChanged();
    void timeChanged();
    void typeChanged();

private:
    QTimer *m_timer;
    QString m_state = "stopped"; // "running", "paused", "stopped"
    int m_remaining = 1500;
    int m_totalDuration = 1500;
    double m_progress = 0.0;

    // DATA STRUCTURES
    std::deque<Session> m_sessionQueue; // QUEUE: Upcoming sessions
    QStack<Session> m_historyStack;     // STACK: For Undo functionality

    void setupQueue();
    void processTimer();
    void completeSession();
};

#endif // TIMERENGINE_H
