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
    Q_PROPERTY(QString timeRemainingString READ timeRemainingString NOTIFY timeChanged) // NEW
    Q_PROPERTY(QString currentType READ currentType NOTIFY typeChanged)
    Q_PROPERTY(QString currentState READ currentState NOTIFY currentStateChanged)

    // ANALYTICS
    Q_PROPERTY(QVariantList chartData READ chartData NOTIFY analyticsChanged)
    Q_PROPERTY(QList<int> pieData READ pieData NOTIFY analyticsChanged)
    Q_PROPERTY(QVariantList heatmapData READ heatmapData NOTIFY analyticsChanged)

public:
    explicit TimerEngine(QObject *parent = nullptr);

    double progress() const { return m_progress; }
    int timeRemaining() const { return m_remaining; }

    // Helper to format 00:00 string in C++
    QString timeRemainingString() const {
        int m = m_remaining / 60;
        int s = m_remaining % 60;
        return QString("%1:%2").arg(m, 2, 10, QChar('0')).arg(s, 2, 10, QChar('0'));
    }

    QString currentState() const { return m_state; }
    QString currentType() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void skip();
    Q_INVOKABLE void addTimer(const QVariantMap& data);
    Q_INVOKABLE void addAlarm(const QVariantMap& data);
    Q_INVOKABLE void generateDummyData();

    QVariantList chartData();
    QList<int> pieData();
    QVariantList heatmapData();

    Q_PROPERTY(bool isAlarmSoon READ isAlarmSoon NOTIFY timeChanged)
    Q_PROPERTY(QString nextAlarmName READ nextAlarmName NOTIFY timeChanged)
    Q_PROPERTY(QString nextAlarmTime READ nextAlarmTime NOTIFY timeChanged)

    bool isAlarmSoon(); // Returns true if < 15 mins
    QString nextAlarmName();
    QString nextAlarmTime();

signals:
    void timeChanged();
    void currentStateChanged();
    void typeChanged();
    void analyticsChanged();

private:
    void setupQueue();
    void processTimer();
    void completeSession();

    QTimer *m_timer;
    std::deque<Session> m_sessionQueue;
    std::stack<Session> m_historyStack;

    QString m_state = "stopped";
    int m_remaining = 1500;
    int m_totalDuration = 1500;
    double m_progress = 0.0;
};

#endif // TIMERENGINE_H
