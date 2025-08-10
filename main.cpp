#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include "Common/constant.h"
#include "Logger/inc/logger.h"
#include "MVC/Controller/inc/UserController.h"
#include "SocketIO/inc/NotiCtrl.h"
// int main(int argc, char *argv[])
// {
//     QGuiApplication app(argc, argv);

//     QQmlApplicationEngine engine;
//     const QUrl url(QStringLiteral("qrc:/Pkg/MVC/Views/main.qml"));
//     QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//                      &app, [url](QObject *obj, const QUrl &objUrl) {
//         if (!obj && url == objUrl)
//             QCoreApplication::exit(-1);
//     }, Qt::QueuedConnection);

//     engine.load(url);

//     return app.exec();
// }
#include <iostream>

int main(int argc, char *argv[]) {
    QGuiApplication       app(argc, argv);
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Material");
    // <======================== START BOOTING APP ========================>
    LOG(LogLevel::INFO, "Start app");

    // register object C++
    engine.rootContext()->setContextProperty("UserController", UserController::getInstance());
    engine.rootContext()->setContextProperty("UserModel", UserController::getInstance()->getUserModel());
    engine.rootContext()->setContextProperty("NotiService", &NotiCtrl::getInstance());

    engine.load(QUrl(QStringLiteral("qrc:/Pkg/MVC/Views/main.qml")));

    return app.exec();
}

