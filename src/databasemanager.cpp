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
    bool isUpdate = data.contains("id") && data["id"].toInt() > 0;

    if (isUpdate) {
        query.prepare("UPDATE timers SET name = :name, config = :config WHERE id = :id");
        query.bindValue(":id", data["id"].toInt());
    } else {
        query.prepare("INSERT INTO timers (name, config) VALUES (:name, :config)");
    }

    QString name = data["name"].toString();
    QJsonObject json = QJsonObject::fromVariantMap(data);
    QJsonDocument doc(json);
    query.bindValue(":name", name);
    query.bindValue(":config", QString(doc.toJson(QJsonDocument::Compact)));

    if(!query.exec()) qCritical() << "Timer Save Error:" << query.lastError().text();
    else qDebug() << (isUpdate ? "Timer Updated" : "Timer Added");
}

void DatabaseManager::addAlarm(const QVariantMap& data) {
    QSqlQuery query;
    bool isUpdate = data.contains("id") && data["id"].toInt() > 0;

    if (isUpdate) {
        query.prepare("UPDATE alarms SET name = :name, config = :config WHERE id = :id");
        query.bindValue(":id", data["id"].toInt());
    } else {
        query.prepare("INSERT INTO alarms (name, config) VALUES (:name, :config)");
    }

    QString name = data["name"].toString();
    QJsonObject json = QJsonObject::fromVariantMap(data);
    QJsonDocument doc(json);
    query.bindValue(":name", name);
    query.bindValue(":config", QString(doc.toJson(QJsonDocument::Compact)));

    if(!query.exec()) qCritical() << "Alarm Save Error:" << query.lastError().text();
    else qDebug() << (isUpdate ? "Alarm Updated" : "Alarm Added");
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

// Implement Delete
void DatabaseManager::deleteTimer(int id) {
    QSqlQuery query; query.prepare("DELETE FROM timers WHERE id = :id");
    query.bindValue(":id", id); query.exec();
}
void DatabaseManager::deleteAlarm(int id) {
    QSqlQuery query; query.prepare("DELETE FROM alarms WHERE id = :id");
    query.bindValue(":id", id); query.exec();
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
