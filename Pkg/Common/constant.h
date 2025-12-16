#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QString>
#include <QStandardPaths>
#include <QDir>

#define URL_SERVER_BACKEND "http://127.0.0.1:3000"
#define URL_SERVER_SOCKET "http://127.0.0.1:3001"

#define URL_USER_REGISTER URL_SERVER_BACKEND "/api/v1/users/register"
#define URL_USER_LOGIN URL_SERVER_BACKEND "/api/v1/users/login"
#define URL_USER_LOGOUT URL_SERVER_BACKEND "/api/v1/users/logout"
#define URL_BOOKING_HISTORY URL_SERVER_BACKEND "/api/v1/users/"
#define URL_ROOMS URL_SERVER_BACKEND "/api/v1/rooms"
#define URL_USERUPDATE URL_SERVER_BACKEND "/api/v1/users/update"
#define URL_ROOMSUPDATE URL_SERVER_BACKEND "/api/v1/rooms/update"
#define URL_USER_CANCEL URL_SERVER_BACKEND "/api/v1/users/cancel"
#define URL_ROOMSTYPE URL_SERVER_BACKEND "/api/v1/rooms/type"
#define URL_ADMIN_LOGIN URL_SERVER_BACKEND "/api/v1/admin/login"
#define URL_ADMIN_LOGOUT URL_SERVER_BACKEND "/api/v1/admin/logout"
#define URL_ADMIN_REGISTER URL_SERVER_BACKEND "/api/v1/admin/register"
#define URL_ADMIN_USERS URL_SERVER_BACKEND "/api/v1/admin/users"
#define URL_ADMIN_CANCEL URL_SERVER_BACKEND "/api/v1/admin/cancelBooking"
#define URL_ROOMS_BULK_CREATE URL_SERVER_BACKEND "/api/v1/rooms/bulk-create"

// Đổi URL
#define URL_GET_USER_BY_DEVICEID URL_SERVER_BACKEND "/api/v1/users/getbydeviceid"

// Path file DeviceId.txt (đặt trong qrc)
#define PATH_DEVICE_ID ":/Device/DeviceId.txt"

#define URL_GET_ALL_IMAGES URL_SERVER_BACKEND "/api/v1/users/getimage/"

inline QString getFaceDBPath() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/FaceDB";
    QDir().mkpath(path);
    return path;
}
#define PATH_FACE_DB getFaceDBPath().toStdString()
#define PATH_FOLDER_DB "/home/vboxuser/Downloads/HotelSystem/SystemHotel/DB"
#define PATH_TO_FILE_STARTUP "./startup.txt"

#define CAMERA_INDEX 0
#define MAX_QUEUE_SIZE 10
#define FACE_CONFIDENCE_THRESHOLD 0.6

#define APP_NAME "MuongThanhFaceCheckin"
#define ORG_NAME "HCMUS-FIT"

#endif // CONSTANTS_H