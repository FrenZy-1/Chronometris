#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantMap>
#include <QVariantList>

class DatabaseManager {
public:
    static DatabaseManager& instance();

    void addTimer(const QVariantMap& data);
    void addAlarm(const QVariantMap& data);

    QVariantList getTimers();
    QVariantList getAlarms();

    void deleteTimer(int id);
    void deleteAlarm(int id);

private:
    DatabaseManager();
    void createTables();
    QSqlDatabase m_db;
};

#endif // DATABASEMANAGER_H
