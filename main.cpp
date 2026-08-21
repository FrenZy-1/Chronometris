#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle> // Essential for Material/Universal styles
#include "src/DatabaseManager.h"
#include "src/TimerEngine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Organization details for QSettings/Path storage
    app.setOrganizationName("Chronometris");
    app.setOrganizationDomain("chronometris.com");

    // FORCE MATERIAL STYLE (Cleanest look for this app)
    QQuickStyle::setStyle("Material");

    // Create the Timer Engine
    TimerEngine timerEngine;

    QQmlApplicationEngine engine;

    // EXPOSE ENGINE TO QML
    engine.rootContext()->setContextProperty("engine", &timerEngine);

    const QUrl url(u"qrc:/Chronometris/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
