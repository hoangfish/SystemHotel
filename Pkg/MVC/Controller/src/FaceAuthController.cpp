#include "../inc/FaceAuthController.h"

// ===== THÊM DÒNG NÀY – BẮT BUỘC! =====
#include "MVC/Controller/inc/UserController.h"
// =====================================

#include "Camera/inc/CamThreadMgr.h"
#include "ComputingServ/FaceCheck/inc/FaceCheckService.h"
#include "ImgProvider/inc/ConFaceCheck.h"
#include "ImgProvider/inc/ImageStreamObserver.h"
#include "Logger/inc/logger.h"

FaceAuthController* FaceAuthController::m_instance = nullptr;

FaceAuthController* FaceAuthController::getInstance()
{
    if (!m_instance) {
        m_instance = new FaceAuthController();
    }
    return m_instance;
}

FaceAuthController::FaceAuthController(QObject* parent) : QObject(parent)
{
    connect(&VideoStreamer::getInstance(), &VideoStreamer::newImage,
            this, &FaceAuthController::newCameraFrame);

    connect(&VideoStreamer::getInstance(), &VideoStreamer::loginSuccess, this, [=]() {
        if (m_isChecking) {
            LOG(LogLevel::INFO, "Face recognized successfully for user: " + m_currentUserId.toStdString());
            Q_EMIT faceCheckSuccess();
            stopFaceCheck();
        }
    });
}

FaceAuthController::~FaceAuthController()
{
    stopFaceCheck();
}

void FaceAuthController::setCurrentUserId(const QString& id)
{
    if (m_currentUserId == id) return;

    m_currentUserId = id;
    FaceCheckService::getInstance()->init(id);
    Q_EMIT currentUserIdChanged();
}

void FaceAuthController::startFaceCheck(const QString& userId)
{
    if (m_isChecking) {
        LOG(LogLevel::WARNING, "Face check is already running");
        return;
    }

    // ← DÒNG NÀY BÂY GIỜ ĐÃ BIẾT UserController LÀ GÌ NHỜ INCLUDE Ở TRÊN!
    //QString targetId = userId.isEmpty() ? UserController::getInstance()->getUserId() : userId;
    setCurrentUserId(userId);
    
    m_isChecking = true;
    Q_EMIT isCheckingChanged();

    m_faceConsumer = std::make_unique<ConFaceCheckIpml>();
    m_faceConsumer->setConsumerId(88);
    m_faceConsumer->setConsumerName("faceauth_hotel");
    m_faceConsumer->setSleepTime(0);

    CamThreadMgr::getInstance()->addConsumer(std::move(m_faceConsumer));
    LOG(LogLevel::INFO, "Truoc startConsumerByID");
    CamThreadMgr::getInstance()->startConsumerByID(88);

    LOG(LogLevel::INFO, "FaceAuth started for user: " + userId.toStdString());
}

void FaceAuthController::stopFaceCheck()
{
    if (!m_isChecking) return;

    CamThreadMgr::getInstance()->stopConsumerByID(88);
    m_faceConsumer.reset();
    m_isChecking = false;
    Q_EMIT isCheckingChanged();

    LOG(LogLevel::INFO, "FaceAuth stopped");
}