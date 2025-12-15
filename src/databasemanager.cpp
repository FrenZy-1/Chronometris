#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

DatabaseManager& DatabaseManager::instance() {
    static DatabaseManager _instance;
    return _instance;
}

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
}

DatabaseManager::~DatabaseManager() {
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void DatabaseManager::init() {
    // 1. Setup the SQLite Database File
    m_db = QSqlDatabase::addDatabase("QSQLITE");

    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataLocation);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString dbPath = dataLocation + "/chronometris.db";
    m_db.setDatabaseName(dbPath);

    qDebug() << "Database path:" << dbPath;

    // 2. Open the Database
    if (!m_db.open()) {
        qCritical() << "Error opening database:" << m_db.lastError().text();
        return;
    }

    // 3. Create Tables
    createTables();
}

void DatabaseManager::createTables() {
    QSqlQuery query;

    // 1. TIMERS & ALARMS TABLE
    // storing both in one table with a 'type' discriminator as per your requirements
    bool success = query.exec(
        "CREATE TABLE IF NOT EXISTS timers ("
        "   id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "   type TEXT,"                  // 'timer' or 'alarm'
        "   name TEXT,"
        "   description TEXT,"
        "   state BOOLEAN,"              // true = running, false = paused/stopped
        "   snoozed BOOLEAN,"
        "   snooze_time INTEGER DEFAULT 15,"
        "   work_duration INTEGER,"
        "   break_duration INTEGER,"
        "   long_break_duration INTEGER,"
        "   scheduled BOOLEAN,"
        "   schedule_time TEXT,"         // Format: HH:mm
        "   schedule_date TEXT,"         // Format: YYYY-MM-DD
        "   repeat BOOLEAN,"
        "   repeat_days TEXT,"           // JSON or comma-separated string: "Mon,Tue,Wed"
        "   delete_after_ring BOOLEAN"
        ")"
        );

    if (!success) {
        qCritical() << "Failed to create 'timers' table:" << query.lastError().text();
    }

    // 2. SESSIONS HISTORY TABLE (Linked List / Log Data)
    success = query.exec(
        "CREATE TABLE IF NOT EXISTS sessions ("
        "   id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "   timer_name TEXT,"
        "   cycle_type TEXT,"            // work, shortBreak, longBreak
        "   duration_seconds INTEGER,"
        "   completed_at DATETIME DEFAULT CURRENT_TIMESTAMP"
        ")"
        );

    if (!success) {
        qCritical() << "Failed to create 'sessions' table:" << query.lastError().text();
    }

    // 3. SETTINGS TABLE (Hash Map Storage)
    success = query.exec(
        "CREATE TABLE IF NOT EXISTS settings ("
        "   key TEXT PRIMARY KEY,"
        "   value TEXT"
        ")"
        );

    if (!success) {
        qCritical() << "Failed to create 'settings' table:" << query.lastError().text();
    }
}
