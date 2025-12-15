#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>
#include <QList>

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    static DatabaseManager& instance();
    void init();

    // Commands
    void addSession(const QString& type, int duration);
    void addTimer(const QVariantMap& data);
    void addAlarm(const QVariantMap& data);

    // Queries
    QList<int> getWeeklyStats();
    QList<int> getSessionDistribution();
    QVariantList getHeatmapData();

    // NEW: Fetch Lists for UI
    QVariantList getTimers();
    QVariantList getAlarms();

    void deleteTimer(int id);
    void deleteAlarm(int id);

    void generateDummyData();

private:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();
    QSqlDatabase m_db;
    void createTables();
};

#endif // DATABASEMANAGER_H
