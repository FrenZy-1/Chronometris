#include "DatabaseManager.h"
#include <QDebug>
#include <QSqlError>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>

DatabaseManager& DatabaseManager::instance() {
    static DatabaseManager instance;
    return instance;
}

DatabaseManager::DatabaseManager() {
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) dir.mkpath(".");

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dataPath + "/chronometris.db");

    if (!m_db.open()) {
        qDebug() << "Error: connection with database failed";
    } else {
        createTables();
    }
}

void DatabaseManager::createTables() {
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS timers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, config TEXT)");
    query.exec("CREATE TABLE IF NOT EXISTS alarms (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, config TEXT)");
}

void DatabaseManager::addTimer(const QVariantMap& data) {
    QSqlQuery query;
    QVariantMap config;

    // PACK EVERYTHING NOT ID/NAME INTO CONFIG
    for(auto key : data.keys()) {
        if(key != "id" && key != "name") {
            config[key] = data[key];
        }
    }

    QString configJson = QJsonDocument::fromVariant(config).toJson(QJsonDocument::Compact);

    if (data["id"].toInt() != -1) {
        query.prepare("UPDATE timers SET name = :name, config = :config WHERE id = :id");
        query.bindValue(":id", data["id"]);
    } else {
        query.prepare("INSERT INTO timers (name, config) VALUES (:name, :config)");
    }

    query.bindValue(":name", data["name"]);
    query.bindValue(":config", configJson);

    if(!query.exec()) qDebug() << "AddTimer Error:" << query.lastError();
}

void DatabaseManager::addAlarm(const QVariantMap& data) {
    QSqlQuery query;
    QVariantMap config;

    // PACK EVERYTHING NOT ID/NAME INTO CONFIG
    for(auto key : data.keys()) {
        if(key != "id" && key != "name") {
            config[key] = data[key];
        }
    }

    QString configJson = QJsonDocument::fromVariant(config).toJson(QJsonDocument::Compact);

    if (data["id"].toInt() != -1) {
        query.prepare("UPDATE alarms SET name = :name, config = :config WHERE id = :id");
        query.bindValue(":id", data["id"]);
    } else {
        query.prepare("INSERT INTO alarms (name, config) VALUES (:name, :config)");
    }

    query.bindValue(":name", data["name"]);
    query.bindValue(":config", configJson);

    if(!query.exec()) qDebug() << "AddAlarm Error:" << query.lastError();
}

QVariantList DatabaseManager::getTimers() {
    QVariantList list;
    QSqlQuery query("SELECT * FROM timers");
    while (query.next()) {
        QVariantMap map;
        map["id"] = query.value("id");
        map["name"] = query.value("name");
        QJsonDocument doc = QJsonDocument::fromJson(query.value("config").toByteArray());
        map["config"] = doc.toVariant().toMap();
        list.append(map);
    }
    return list;
}

QVariantList DatabaseManager::getAlarms() {
    QVariantList list;
    QSqlQuery query("SELECT * FROM alarms");
    while (query.next()) {
        QVariantMap map;
        map["id"] = query.value("id");
        map["name"] = query.value("name");
        QJsonDocument doc = QJsonDocument::fromJson(query.value("config").toByteArray());
        map["config"] = doc.toVariant().toMap();
        list.append(map);
    }
    return list;
}

void DatabaseManager::deleteTimer(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM timers WHERE id = :id");
    query.bindValue(":id", id);
    query.exec();
}

void DatabaseManager::deleteAlarm(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM alarms WHERE id = :id");
    query.bindValue(":id", id);
    query.exec();
}
