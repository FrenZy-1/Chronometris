#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/DatabaseManager.h"
#include "src/TimerEngine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Chronometris");
    app.setOrganizationDomain("chronometris.com");

    // Initialize Database
    DatabaseManager::instance().init();

    // Create the Engine
    TimerEngine timerEngine;

    QQmlApplicationEngine engine;

    // EXPOSE TO QML AS A GLOBAL PROPERTY "engine"
    engine.rootContext()->setContextProperty("engine", &timerEngine);

    const QUrl url(QStringLiteral("qrc:/Chronometris/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
