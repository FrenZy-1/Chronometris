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

    QQmlApplicationEngine engine;

    // Register C++ Types to QML
    qmlRegisterType<TimerEngine>("Chronometris.Core", 1, 0, "TimerEngine");

    const QUrl url(QStringLiteral("qrc:/Chronometris/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
