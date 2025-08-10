#include "../inc/NotiController.h"
#include "Common/constant.h"
#include <QByteArray>
#include <QTime>

NotiController* NotiController::instance = nullptr;

bool NotiController::getNotiFromServer() {
    bool ret = false;
    QString url = URL_USER_REGISTER;
    HttpClientImpl::getInstance()->sendGetRequest(QUrl(url), [&](QByteArray response) {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        QJsonObject json = jsonDoc.object();

        if (json.empty() || json["success"].toBool() == false) {
            LOG(LogLevel::ERROR, "Error: get noti from server failed");
            ret = false;
        } else {
            this->setQmlNotiIF(json["data"].toArray());
            Count = json["data"].toArray().size();
            LOG(LogLevel::INFO, "Get noti from server success");
            ret = true;
        }
    });

    return ret;
}

void NotiController::setQmlNotiIF(const QJsonArray &qmlNotiIF) {
    if (qmlNotiIF.isEmpty()) {
        LOG(LogLevel::INFO, "data empty");
        Q_EMIT qmlNotiIFChanged(m_QmlNotiIF);
        return;
    }

    if (m_QmlNotiIF == qmlNotiIF) {
        LOG(LogLevel::INFO, "data is same with old data");
        Q_EMIT qmlNotiIFChanged(m_QmlNotiIF);
        return;
    }
    if (!m_notiModel) {
        LOG(LogLevel::INFO, "model is empty");
        return;
    }
    m_notiModel->clear();
    m_QmlNotiIF = qmlNotiIF;
    m_notiModel->setNotiModelList(qmlNotiIF);
    LOG(LogLevel::INFO, "success: set data success");
    Q_EMIT qmlNotiIFChanged(m_QmlNotiIF);
}

void NotiController::addNotiRealTime(QString content) {
    Notification noti(content);
    m_notiModel->addNotification(noti, m_notiModel->getNotiModel());
    Q_EMIT qmlNotiIFChanged(m_QmlNotiIF);
}

QJsonArray NotiController::getQmlNotiIF() {
    return m_notiModel->getNotiModelList();
}

QString NotiController::getNotiCount() const {
    return QString::number(Count);
}
