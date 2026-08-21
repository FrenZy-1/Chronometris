#ifndef TIMERENGINE_H
#define TIMERENGINE_H

#include <QObject>
#include <QTimer>
#include <deque>
#include <QVariantMap>
#include <QTime>
#include <QMediaPlayer>
#include <QAudioOutput>

struct Session {
    QString type;
    int duration;
};

class TimerEngine : public QObject {
    Q_OBJECT

    // ... (Keep existing properties) ...
    Q_PROPERTY(double progress READ progress NOTIFY timeChanged)
    Q_PROPERTY(int timeRemaining READ timeRemaining NOTIFY timeChanged)
    Q_PROPERTY(QString timeRemainingString READ timeRemainingString NOTIFY timeChanged)
    Q_PROPERTY(QString currentType READ currentType NOTIFY typeChanged)
    Q_PROPERTY(QString currentState READ currentState NOTIFY currentStateChanged)

    Q_PROPERTY(bool isAlarmSoon READ isAlarmSoon NOTIFY timeChanged)
    Q_PROPERTY(bool isRinging READ isRinging NOTIFY currentStateChanged)
    Q_PROPERTY(QString nextAlarmName READ nextAlarmName NOTIFY timeChanged)
    Q_PROPERTY(QString nextAlarmTime READ nextAlarmTime NOTIFY timeChanged)

    Q_PROPERTY(QVariantList timersList READ timersList NOTIFY dataChanged)
    Q_PROPERTY(QVariantList activeAlarmsList READ activeAlarmsList NOTIFY dataChanged)
    Q_PROPERTY(QVariantList inactiveAlarmsList READ inactiveAlarmsList NOTIFY dataChanged)
    Q_PROPERTY(QVariantList historyList READ historyList NOTIFY analyticsChanged)
    Q_PROPERTY(QString todayFocusString READ todayFocusString NOTIFY analyticsChanged)
    Q_PROPERTY(int todaySessionCount READ todaySessionCount NOTIFY analyticsChanged)
    Q_PROPERTY(int currentStreak READ currentStreak NOTIFY analyticsChanged)
    Q_PROPERTY(QVariantList chartData READ chartData NOTIFY analyticsChanged)

public:
    explicit TimerEngine(QObject *parent = nullptr);

    double progress() const { return m_progress; }
    int timeRemaining() const { return m_remaining; }
    QString timeRemainingString() const;
    QString currentState() const { return m_state; }
    QString currentType() const;

    bool isAlarmSoon() const { return m_isAlarmSoon; }
    bool isRinging() const { return m_isRinging; }
    QString nextAlarmName() const { return m_nextAlarmName; }
    QString nextAlarmTime() const { return m_nextAlarmTime; }

    QString todayFocusString();
    int todaySessionCount();
    int currentStreak();

    QVariantList timersList();
    QVariantList activeAlarmsList();
    QVariantList inactiveAlarmsList();
    QVariantList historyList();
    QVariantList chartData();

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
    Q_INVOKABLE void toggleAlarm(int id);
    Q_INVOKABLE void stopRinging();
    Q_INVOKABLE void snoozeAlarm();

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
    void checkAlarms();
    void playSound(const QString& path, bool loop);

    QTimer *m_timer;
    std::deque<Session> m_sessionQueue;
    QVariantMap m_activeConfig;

    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;

    QString m_state = "stopped";
    int m_remaining = 1500;
    int m_totalDuration = 1500;
    double m_progress = 0.0;

    int m_todayFocusSeconds = 0;
    int m_todaySessions = 0;
    int m_streak = 3;

    bool m_isAlarmSoon = false;
    bool m_isRinging = false;
    QString m_nextAlarmName = "";
    QString m_nextAlarmTime = "";
    QString m_dismissedAlarmTime = ""; // <--- NEW: Tracks suppressed alarm
};

#endif // TIMERENGINE_H
