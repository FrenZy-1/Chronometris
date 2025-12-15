#ifndef TIMERENGINE_H
#define TIMERENGINE_H

#include <QObject>
#include <QTimer>
#include <deque>
#include <stack>
#include <QVariantMap>

struct Session {
    QString type;
    int duration;
};

class TimerEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(double progress READ progress NOTIFY timeChanged)
    Q_PROPERTY(int timeRemaining READ timeRemaining NOTIFY timeChanged)
    Q_PROPERTY(QString currentType READ currentType NOTIFY typeChanged)
    Q_PROPERTY(QString currentState READ currentState NOTIFY currentStateChanged)

    // ANALYTICS PROPERTIES
    Q_PROPERTY(QList<int> chartData READ chartData NOTIFY analyticsChanged)
    Q_PROPERTY(QList<int> pieData READ pieData NOTIFY analyticsChanged)
    Q_PROPERTY(QVariantList heatmapData READ heatmapData NOTIFY analyticsChanged)

public:
    explicit TimerEngine(QObject *parent = nullptr);

    double progress() const { return m_progress; }
    int timeRemaining() const { return m_remaining; }
    QString currentState() const { return m_state; }
    QString currentType() const;

    // Actions
    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void skip();

    // Add Data
    Q_INVOKABLE void addTimer(const QVariantMap& data);
    Q_INVOKABLE void addAlarm(const QVariantMap& data);
    Q_INVOKABLE void generateDummyData();

    // Analytics Getters
    QList<int> chartData();
    QList<int> pieData();
    QVariantList heatmapData();

signals:
    void timeChanged();
    void currentStateChanged();
    void typeChanged();
    void analyticsChanged(); // Triggers chart redraw

private:
    void setupQueue();
    void processTimer();
    void completeSession();

    QTimer *m_timer;
    // DSA: Deque for Queue, Stack for History
    std::deque<Session> m_sessionQueue;
    std::stack<Session> m_historyStack;

    QString m_state = "stopped";
    int m_remaining = 1500;
    int m_totalDuration = 1500;
    double m_progress = 0.0;
};

#endif // TIMERENGINE_H
