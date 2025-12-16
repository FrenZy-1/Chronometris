#ifndef TIMERENGINE_H
#define TIMERENGINE_H

#include <QObject>
#include <QTimer>
#include <deque>
#include <QVariantMap>

struct Session {
    QString type;
    int duration;
};

class TimerEngine : public QObject {
    Q_OBJECT

    // ... (Keep existing Time/Progress properties) ...
    Q_PROPERTY(double progress READ progress NOTIFY timeChanged)
    Q_PROPERTY(int timeRemaining READ timeRemaining NOTIFY timeChanged)
    Q_PROPERTY(QString timeRemainingString READ timeRemainingString NOTIFY timeChanged)
    Q_PROPERTY(QString currentType READ currentType NOTIFY typeChanged)
    Q_PROPERTY(QString currentState READ currentState NOTIFY currentStateChanged)
    Q_PROPERTY(bool isAlarmSoon READ isAlarmSoon NOTIFY timeChanged)
    Q_PROPERTY(QString nextAlarmName READ nextAlarmName NOTIFY timeChanged)
    Q_PROPERTY(QString nextAlarmTime READ nextAlarmTime NOTIFY timeChanged)

    // --- UPDATED LISTS ---
    Q_PROPERTY(QVariantList timersList READ timersList NOTIFY dataChanged)
    // We split alarms into two lists for the UI
    Q_PROPERTY(QVariantList activeAlarmsList READ activeAlarmsList NOTIFY dataChanged)
    Q_PROPERTY(QVariantList inactiveAlarmsList READ inactiveAlarmsList NOTIFY dataChanged)
    Q_PROPERTY(QVariantList historyList READ historyList NOTIFY analyticsChanged)

    Q_PROPERTY(QString todayFocusString READ todayFocusString NOTIFY analyticsChanged)
    Q_PROPERTY(int todaySessionCount READ todaySessionCount NOTIFY analyticsChanged)
    Q_PROPERTY(int currentStreak READ currentStreak NOTIFY analyticsChanged)
    Q_PROPERTY(QVariantList chartData READ chartData NOTIFY analyticsChanged)

public:
    explicit TimerEngine(QObject *parent = nullptr);

    // Getters
    double progress() const { return m_progress; }
    int timeRemaining() const { return m_remaining; }
    QString timeRemainingString() const;
    QString currentState() const { return m_state; }
    QString currentType() const;
    bool isAlarmSoon();
    QString nextAlarmName();
    QString nextAlarmTime();

    QString todayFocusString();
    int todaySessionCount();
    int currentStreak();

    QVariantList timersList();
    // New List Getters
    QVariantList activeAlarmsList();
    QVariantList inactiveAlarmsList();

    QVariantList historyList();
    QVariantList chartData();

    // Invokables
    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void skip();
    Q_INVOKABLE void loadAndStartSession(const QVariantMap& config);
    Q_INVOKABLE void addTimer(const QVariantMap& data);
    Q_INVOKABLE void addAlarm(const QVariantMap& data);
    Q_INVOKABLE void deleteTimer(int id);
    Q_INVOKABLE void deleteAlarm(int id);
    Q_INVOKABLE void generateDummyData();
    Q_INVOKABLE void toggleAlarm(int id); // <--- NEW TOGGLE FUNCTION

signals:
    void timeChanged();
    void currentStateChanged();
    void typeChanged();
    void analyticsChanged();
    void dataChanged();

private:
    void processTimer();
    void completeSession();
    void refillQueue();

    QTimer *m_timer;
    std::deque<Session> m_sessionQueue;
    QVariantMap m_activeConfig;

    QString m_state = "stopped";
    int m_remaining = 1500;
    int m_totalDuration = 1500;
    double m_progress = 0.0;

    int m_todayFocusSeconds = 0;
    int m_todaySessions = 0;
    int m_streak = 3;
};

#endif // TIMERENGINE_H
