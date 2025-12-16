#include "../inc/UserController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "constant.h"
#include "Logger/inc/logger.h"
#include "ComputingServ/FaceCheck/inc/FaceCheckService.h"
#include <QFile>
#include <QTextStream>
#include "Booting/inc/BootingApp.h"

UserController* UserController::instance = nullptr;

UserController::UserController(QObject *parent) : QObject(parent) {
    m_httpClient = HttpClientImpl::getInstance();
    m_userModel = new UserModel(this);

    connect(FaceCheckService::getInstance(), &FaceCheckService::cosineScore, this, [=](float score, bool matched) {
        if (matched && !m_userModel->Id().isEmpty() && m_isLoginMode) {
            LOG(LogLevel::INFO, "Face matched! Auto login for userId: " + m_userModel->Id().toStdString());
            Q_EMIT faceLoginSuccess();
            setIsLoginMode(false);
        }
    });
}

QString UserController::getUserId() {
    LOG(LogLevel::INFO, "GetUserID: " + m_userModel->Id().toStdString());
    return m_userModel->Id();
}

QString UserController::getFirstName() {
    return m_userModel->firstName();
}

QString UserController::getLastName() {
    return m_userModel->lastName();
}

QString UserController::getEmail() {
    return m_userModel->email();
}

QString UserController::getPhone() {
    return m_userModel->phone();
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
            QString id = userObj["userId"].toString();
            QString email = userObj["email"].toString();
            QString phone = userObj["phone"].toString();
            m_userModel->setFirstName(firstName);
            m_userModel->setLastName(lastName);
            m_userModel->setId(id);
            m_userModel->setEmail(email);
            m_userModel->setPhone(phone);
            LOG(LogLevel::INFO, "Login successful and user data updated" + id.toStdString());
            Q_EMIT loginSuccess(firstName, lastName);
            auto token = "123";
            std::map<std::string, std::string> query = {{"token", token}};
            SocketIoClient::getInstance().connectToServer(URL_SERVER_SOCKET, query);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Login failed: " + errorMsg.toStdString());
            Q_EMIT loginFailed(errorMsg);
        }
    });
}

void UserController::logoutUser() {
    QJsonObject json;
    m_httpClient->sendPostRequest(QUrl(URL_USER_LOGOUT), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            m_userModel->setFirstName("");
            m_userModel->setLastName("");
            m_userModel->setId("");
            m_userModel->setEmail("");
            m_userModel->setPhone("");
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
    QString url = QString(URL_BOOKING_HISTORY) + m_userModel->Id() + "/bookings";
    m_httpClient->sendGetRequest(QUrl(url), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonArray bookingsArray = obj["data"].toArray();
            QVariantList bookings;
            for (const QJsonValue &value : bookingsArray) {
                QJsonObject bookingObj = value.toObject();
                bool isCheckIn = bookingObj["isCheckIn"].toBool();
                bool isCheckOut = bookingObj["isCheckOut"].toBool();
                QString checkIn = QDateTime::fromString(bookingObj["checkInDate"].toString(), Qt::ISODate).toString("dd/MM/yyyy");
                QString checkOut = QDateTime::fromString(bookingObj["checkOutDate"].toString(), Qt::ISODate).toString("dd/MM/yyyy");
                QString checkInDate = bookingObj["checkInDate"].toString();
                QString checkOutDate = bookingObj["checkOutDate"].toString();
                QDateTime checkInDate1 = QDateTime::fromString(bookingObj["checkInDate"].toString(), Qt::ISODate);
                QDateTime checkOutDate1 = QDateTime::fromString(bookingObj["checkOutDate"].toString(), Qt::ISODate);
                int nights = checkInDate1.daysTo(checkOutDate1);
                double totalPrice = bookingObj["price"].toDouble() * nights;
                bookings.append(QVariantMap{
                    {"bookingId", bookingObj["roomId"].toString() + "-" + checkIn},
                    {"bookingCode", bookingObj["bookingCode"].toString()},
                    {"isCheckIn", isCheckIn},
                    {"isCheckOut", isCheckOut},
                    {"checkIn", checkIn},
                    {"checkOut", checkOut},
                    {"checkInDate", checkInDate},
                    {"checkOutDate", checkOutDate},
                    {"guest", m_userModel->firstName() + " " + m_userModel->lastName()},
                    {"price", totalPrice},
                    {"status", bookingObj["status"].toString()},
                    {"roomId", bookingObj["roomId"].toString()}
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

void UserController::cancelBooking(const QString &bookingCode, const QString&roomId, const QString &action) {
    QJsonObject json;
    json["userId"] = getUserId();
    json["roomId"] = roomId;
    json["bookingCode"] = bookingCode;
    json["action"] = action;
    m_httpClient->sendPostRequest(QUrl(URL_USER_CANCEL), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            std::string tmp = action.toStdString();
            LOG(LogLevel::INFO, tmp + " successfully");
            Q_EMIT bookingCancelled(action, roomId);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Cancel failed: " + errorMsg.toStdString());
            Q_EMIT cancelFailed(errorMsg);
        }
    });
}

void UserController::readDeviceIdAndFetchUser() {
    QFile file(PATH_DEVICE_ID);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        LOG(LogLevel::ERROR, "Cannot open DeviceId.txt at " + std::string(PATH_DEVICE_ID));
        return;
    }
    QTextStream in(&file);
    QString deviceID = in.readLine().trimmed();
    file.close();
    if (deviceID.isEmpty()) {
        LOG(LogLevel::ERROR, "DeviceID is empty in file");
        return;
    }
    LOG(LogLevel::INFO, "Read DeviceID from file: " + deviceID.toStdString());
    QJsonObject json;
    json["DeviceID"] = deviceID;
    m_httpClient->sendPostRequest(QUrl(URL_GET_USER_BY_DEVICEID), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonObject data = obj["data"].toObject();
            QString userId = data["userId"].toString();
            QString firstName = data["firstName"].toString();
            QString lastName = data["lastName"].toString();
            QString email = data["email"].toString();
            QString phone = data["phone"].toString();
            m_userModel->setId(userId);
            m_userModel->setFirstName(firstName);
            m_userModel->setLastName(lastName);
            m_userModel->setEmail(email);
            m_userModel->setPhone(phone);
            LOG(LogLevel::INFO, "Fetched full user info from DeviceID: " + deviceID.toStdString());
            BootApp::getInstance().init(userId);
            FaceCheckService::getInstance()->setPatternStr(userId);
            FaceCheckService::getInstance()->loadDatabase();
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::WARNING, "No user found for DeviceID: " + errorMsg.toStdString());
        }
    });
}

bool UserController::isLoginMode() const {
    return m_isLoginMode;
}

void UserController::setIsLoginMode(bool mode) {
    if (m_isLoginMode != mode) {
        m_isLoginMode = mode;
        Q_EMIT isLoginModeChanged();
    }
}