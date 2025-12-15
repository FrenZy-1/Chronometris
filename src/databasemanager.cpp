#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include <QRandomGenerator>

DatabaseManager& DatabaseManager::instance() {
    static DatabaseManager _instance;
    return _instance;
}

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {}

DatabaseManager::~DatabaseManager() { if (m_db.isOpen()) m_db.close(); }

void DatabaseManager::init() {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataLocation);
    if (!dir.exists()) dir.mkpath(".");

    m_db.setDatabaseName(dataLocation + "/chronometris.db");

    if (!m_db.open()) {
        qCritical() << "DB Error:" << m_db.lastError().text();
        return;
    }
    createTables();

    // UNCOMMENT THIS LINE ONCE TO GENERATE DATA, THEN RE-COMMENT
    // generateDummyData();
}

void DatabaseManager::createTables() {
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS sessions (id INTEGER PRIMARY KEY, type TEXT, duration INTEGER, date DATETIME DEFAULT CURRENT_TIMESTAMP)");
    query.exec("CREATE TABLE IF NOT EXISTS timers (id INTEGER PRIMARY KEY, name TEXT, config TEXT)"); // JSON config
    query.exec("CREATE TABLE IF NOT EXISTS alarms (id INTEGER PRIMARY KEY, name TEXT, time TEXT, days TEXT)");
}

void DatabaseManager::addSession(const QString& type, int duration) {
    QSqlQuery query;
    query.prepare("INSERT INTO sessions (type, duration) VALUES (:type, :duration)");
    query.bindValue(":type", type);
    query.bindValue(":duration", duration);
    query.exec();
}

void DatabaseManager::addTimer(const QVariantMap& data) {
    QSqlQuery query;
    query.prepare("INSERT INTO timers (name, config) VALUES (:name, :config)");
    query.bindValue(":name", data["name"].toString());
    query.bindValue(":config", data["desc"].toString()); // Storing desc as placeholder
    query.exec();
}

void DatabaseManager::addAlarm(const QVariantMap& data) {
    QSqlQuery query;
    query.prepare("INSERT INTO alarms (name, time, days) VALUES (:name, :time, :days)");
    query.bindValue(":name", data["name"].toString());
    query.bindValue(":time", data["time"].toString());
    query.bindValue(":days", data["days"].toString());
    query.exec();
}

// --- ANALYTICS QUERIES ---

QList<int> DatabaseManager::getWeeklyHours() {
    QList<int> hours = {0,0,0,0,0,0,0}; // Mon-Sun
    // In a real app, write SQL to group by day of week.
    // For demo, we return mock data or fetch all and sum.
    // Let's use Random for "lively" charts if DB is empty, or DB data.

    QSqlQuery query("SELECT strftime('%w', date), sum(duration) FROM sessions GROUP BY 1");
    while(query.next()) {
        int day = query.value(0).toInt(); // 0 = Sunday
        int seconds = query.value(1).toInt();
        // Map 0(Sun)->6, 1(Mon)->0
        int idx = (day + 6) % 7;
        hours[idx] = seconds / 3600; // Convert to hours
    }
    return hours;
}

QList<int> DatabaseManager::getSessionDistribution() {
    int work = 0, breakTime = 0, longBreak = 0;
    QSqlQuery query("SELECT type, count(*) FROM sessions GROUP BY type");
    while(query.next()) {
        QString t = query.value(0).toString();
        int count = query.value(1).toInt();
        if(t == "work") work = count;
        else if(t == "shortBreak") breakTime = count;
        else if(t == "longBreak") longBreak = count;
    }
    return {work, breakTime, longBreak};
}

QVariantList DatabaseManager::getHeatmapData() {
    QVariantList list;
    // Return intensity 0-3 for last 70 days.
    // Mocking for visual smoothness as SQL complexity is high for this snippet.
    for(int i=0; i<70; i++) {
        list.append(QRandomGenerator::global()->bounded(4));
    }
    return list;
}

void DatabaseManager::generateDummyData() {
    // Generates 50 random sessions over last 7 days
    qDebug() << "Generating Dummy Data...";
    QSqlQuery query;
    QStringList types = {"work", "work", "work", "shortBreak", "shortBreak", "longBreak"};

    for(int i=0; i<50; i++) {
        QString type = types[QRandomGenerator::global()->bounded(types.size())];
        int duration = (type=="work"?25: (type=="shortBreak"?5:15)) * 60;

        // Random date in last 7 days
        QDateTime date = QDateTime::currentDateTime().addDays(-QRandomGenerator::global()->bounded(7));

        query.prepare("INSERT INTO sessions (type, duration, date) VALUES (:t, :d, :dt)");
        query.bindValue(":t", type);
        query.bindValue(":d", duration);
        query.bindValue(":dt", date);
        query.exec();
    }
}
