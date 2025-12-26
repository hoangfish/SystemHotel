#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include "Common/constant.h"
#include "Logger/inc/logger.h"
// Controller cũ
#include "MVC/Controller/inc/UserController.h"
#include "MVC/Controller/inc/RoomController.h"
#include "MVC/Controller/inc/AdminController.h"
// Các service từ dự án face
#include "Booting/inc/BootingApp.h"
#include "Camera/inc/CamThreadMgr.h"
#include "ComputingServ/FaceCheck/inc/FaceCheckService.h"
#include "Auth/Login/inc/authService.h"
#include "Middlewares/ImgProvider/inc/ImageProvider.h"
#include "Middlewares/ImgProvider/inc/ImageStreamObserver.h"
#include "Middlewares/ImgProvider/inc/ConFaceCheck.h"
#include "Middlewares/ImgProvider/inc/UIFrameConsumer.h"
#include "ComputingServ/FaceMesh/inc/FaceMeshService.h"

int main(int argc, char *argv[])
{
    qDebug() << "QRC list:" << QDir(":/Device").entryList();
    QGuiApplication app(argc, argv);
    ImageProvider * liveImageProvider(new ImageProvider);
    CamThreadMgr::getInstance()->setCameraIndex(0);
    QQuickStyle::setStyle("Material");

    LOG(LogLevel::INFO, "========================================");
    LOG(LogLevel::INFO, "Hotel System + Face Check-In STARTED");
    LOG(LogLevel::INFO, "========================================");

    // Khởi động camera ngay từ đầu
    CamThreadMgr::getInstance()->setCameraIndex(0);
     auto uiConsumer = std::make_unique<UIFrameConsumer>();
    uiConsumer->setConsumerName("UIPreview");
    uiConsumer->setConsumerId(0);
    uiConsumer->setSleepTime(0);              // không delay để UI mượt
    CamThreadMgr::getInstance()->addConsumer(std::move(uiConsumer));

    std::unique_ptr<Consumer<cv::Mat>> conFaceCheck = std::make_unique<ConFaceCheckIpml>();
    conFaceCheck->setSleepTime(50);
    conFaceCheck->setConsumerName("conFaceCheck");
    conFaceCheck->setConsumerId(1);
    CamThreadMgr::getInstance()->addConsumer(std::move(conFaceCheck));
    CamThreadMgr::getInstance()->startProducer();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("UserController", UserController::getInstance());
    engine.rootContext()->setContextProperty("RoomController", RoomController::getInstance());
    engine.rootContext()->setContextProperty("AdminController", AdminController::getInstance());
    engine.rootContext()->setContextProperty("FaceCheckService", FaceCheckService::getInstance());
    engine.rootContext()->setContextProperty("CamThreadService", CamThreadMgr::getInstance());
    engine.rootContext()->setContextProperty("AuthService", AuthService::getInstance());
    engine.rootContext()->setContextProperty("liveImageProvider", liveImageProvider);
    engine.rootContext()->setContextProperty("VideoStreamer", &VideoStreamer::getInstance());

    engine.addImageProvider(QLatin1String("live"), liveImageProvider);

    FaceMeshService::getInstance()->load("500m");

    QObject::connect(&VideoStreamer::getInstance(), &VideoStreamer::newImage, liveImageProvider, &ImageProvider::updateImage);

    const QUrl url(QStringLiteral("qrc:/Pkg/MVC/Views/main.qml"));
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        LOG(LogLevel::ERROR, "Failed to load QML!");
        return -1;
    }

    return app.exec();
}