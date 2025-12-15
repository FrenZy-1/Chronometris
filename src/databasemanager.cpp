#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include <QRandomGenerator>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

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

    if (!m_db.open()) { qCritical() << "DB Error:" << m_db.lastError().text(); return; }
    createTables();
}

void DatabaseManager::createTables() {
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS sessions (id INTEGER PRIMARY KEY, type TEXT, duration INTEGER, date DATETIME DEFAULT CURRENT_TIMESTAMP)");
    // Both tables now use 'config' TEXT to store complex JSON data
    query.exec("CREATE TABLE IF NOT EXISTS timers (id INTEGER PRIMARY KEY, name TEXT, config TEXT)");
    query.exec("CREATE TABLE IF NOT EXISTS alarms (id INTEGER PRIMARY KEY, name TEXT, config TEXT)");
}

void DatabaseManager::addTimer(const QVariantMap& data) {
    QSqlQuery query;
    query.prepare("INSERT INTO timers (name, config) VALUES (:name, :config)");
    QString name = data["name"].toString();
    // Serialize Map to JSON String
    QJsonObject json = QJsonObject::fromVariantMap(data);
    QJsonDocument doc(json);
    query.bindValue(":name", name);
    query.bindValue(":config", QString(doc.toJson(QJsonDocument::Compact)));

    if(!query.exec()) qCritical() << "Add Timer Error:" << query.lastError().text();
    else qDebug() << "Timer Saved:" << name;
}

void DatabaseManager::addAlarm(const QVariantMap& data) {
    QSqlQuery query;
    query.prepare("INSERT INTO alarms (name, config) VALUES (:name, :config)");
    QString name = data["name"].toString();
    // Serialize Map to JSON String
    QJsonObject json = QJsonObject::fromVariantMap(data);
    QJsonDocument doc(json);
    query.bindValue(":name", name);
    query.bindValue(":config", QString(doc.toJson(QJsonDocument::Compact)));

    if(!query.exec()) qCritical() << "Add Alarm Error:" << query.lastError().text();
    else qDebug() << "Alarm Saved:" << name;
}

// --- FETCH LISTS ---
QVariantList DatabaseManager::getTimers() {
    QVariantList list;
    QSqlQuery query("SELECT id, name, config FROM timers ORDER BY id DESC");
    while(query.next()) {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["name"] = query.value(1).toString();
        // Parse JSON back to QVariantMap
        QJsonDocument doc = QJsonDocument::fromJson(query.value(2).toByteArray());
        map["config"] = doc.toVariant().toMap();
        list.append(map);
    }
    return list;
}

QVariantList DatabaseManager::getAlarms() {
    QVariantList list;
    QSqlQuery query("SELECT id, name, config FROM alarms ORDER BY id DESC");
    while(query.next()) {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["name"] = query.value(1).toString();
        // Parse JSON back to QVariantMap
        QJsonDocument doc = QJsonDocument::fromJson(query.value(2).toByteArray());
        map["config"] = doc.toVariant().toMap();
        list.append(map);
    }
    return list;
}

// --- ANALYTICS ---
void DatabaseManager::addSession(const QString& type, int duration) {
    QSqlQuery query; query.prepare("INSERT INTO sessions (type, duration) VALUES (:t, :d)");
    query.bindValue(":t", type); query.bindValue(":d", duration); query.exec();
}

QList<int> DatabaseManager::getWeeklyStats() {
    // Return mock [2,5,3...] if empty, or implement SQL logic
    return {2, 4, 3, 5, 2, 1, 0};
}
QList<int> DatabaseManager::getSessionDistribution() { return {10, 5, 2}; }
QVariantList DatabaseManager::getHeatmapData() {
    QVariantList l; for(int i=0;i<70;i++) l.append(QRandomGenerator::global()->bounded(4)); return l;
}
void DatabaseManager::generateDummyData() {}
