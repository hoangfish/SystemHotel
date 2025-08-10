#include "../inc/UserController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "constant.h"
#include "Logger/inc/logger.h"
UserController* UserController::instance = nullptr;

UserController::UserController(QObject *parent) : QObject(parent) {
    m_httpClient = HttpClientImpl::getInstance();
    m_userModel = new UserModel(this);
}

void UserController::registerUser(const QString &firstName, const QString &lastName,
                                 const QString &email, const QString &phone,
                                 const QString &password) {
    QJsonObject json;
    json["firstName"] = firstName;
    json["lastName"] = lastName;
    json["email"] = email;
    json["phone"] = phone;
    json["password"] = password;

    m_httpClient->sendPostRequest(QUrl(URL_USER_REGISTER), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            LOG(LogLevel::INFO, "Register request successful");
            Q_EMIT registerSuccess();
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Register failed: " + errorMsg.toStdString());
            Q_EMIT registerFailed(errorMsg);
        }
    });
}

void UserController::loginUser(const QString &emailOrPhone, const QString &password) {
    QJsonObject json;
    json["emailOrPhone"] = emailOrPhone;
    json["password"] = password;

    m_httpClient->sendPostRequest(QUrl(URL_USER_LOGIN), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonObject userObj = obj["data"].toObject();
            QString firstName = userObj["firstName"].toString();
            QString lastName = userObj["lastName"].toString();
            m_userModel->setFirstName(firstName);
            m_userModel->setLastName(lastName);
            LOG(LogLevel::INFO, "Login successful and user data updated");
            Q_EMIT loginSuccess(firstName, lastName);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Login failed: " + errorMsg.toStdString());
            Q_EMIT loginFailed(errorMsg);
        }
    });
}

void UserController::logoutUser() {
    QJsonObject json;
    // Tạm thời không gửi dữ liệu, vì server chưa yêu cầu token
    m_httpClient->sendPostRequest(QUrl(URL_USER_LOGOUT), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            m_userModel->setFirstName("");
            m_userModel->setLastName("");
            LOG(LogLevel::INFO, "Logout request successful");
            Q_EMIT logoutSuccess();
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Logout failed: " + errorMsg.toStdString());
            Q_EMIT logoutFailed(errorMsg);
        }
    });
}

void UserController::getBookingHistory() {
    m_httpClient->sendGetRequest(QUrl(URL_BOOKING_HISTORY), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonArray bookingsArray = obj["data"].toArray();
            QVariantList bookings;
            for (const QJsonValue &value : bookingsArray) {
                QJsonObject bookingObj = value.toObject();
                bookings.append(QVariantMap{
                    {"room", bookingObj["room"].toString()},
                    {"date", bookingObj["date"].toString()},
                    {"status", bookingObj["status"].toString()}
                });
            }
            LOG(LogLevel::INFO, "Booking history retrieved successfully");
            Q_EMIT bookingHistorySuccess(bookings);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Booking history failed: " + errorMsg.toStdString());
            Q_EMIT bookingHistoryFailed(errorMsg);
        }
    });
}