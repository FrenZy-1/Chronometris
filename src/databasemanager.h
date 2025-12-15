#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    // Singleton Accessor
    static DatabaseManager& instance();

    // Initialization
    void init();

private:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    QSqlDatabase m_db;
    void createTables();
};

#endif // DATABASEMANAGER_H
