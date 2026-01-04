// Pkg/MVC/Controllers/src/PlacesController.cpp

#include "../inc/PlacesController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QBuffer>
#include <QUrl>
#include <cmath>  // cho sin, cos, atan2

const QString API_KEY = "AIzaSyAUv9WeCmgqGVVS-dG0RRBaFADHoBgM-S0";  // Key của bạn
const double HOTEL_LAT = 10.75991;
const double HOTEL_LNG = 106.68285;
const int RADIUS_METERS = 5000;  // 5km

// Hàm tính khoảng cách Haversine (km)
double haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0;  // Bán kính Trái Đất (km)
    double dLat = (lat2 - lat1) * M_PI / 180.0;
    double dLon = (lon2 - lon1) * M_PI / 180.0;
    double a = sin(dLat/2) * sin(dLat/2) +
               cos(lat1 * M_PI / 180.0) * cos(lat2 * M_PI / 180.0) *
               sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
}

// Static instance
PlacesController* PlacesController::instance = nullptr;

PlacesController::PlacesController(QObject *parent) : QObject(parent)
{
    // Không cần khởi tạo gì thêm
}

void PlacesController::getNearbyPlaces()
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    QString urlStr = "https://places.googleapis.com/v1/places:searchNearby";

    // Tạo body JSON
    QJsonObject circle;
    circle["center"] = QJsonObject{ {"latitude", HOTEL_LAT}, {"longitude", HOTEL_LNG} };
    circle["radius"] = RADIUS_METERS;

    QJsonObject locationRestriction;
    locationRestriction["circle"] = circle;

    QJsonArray includedTypes{"cafe", "amusement_park", "restaurant", "park"};

    QJsonObject body;
    body["includedTypes"] = includedTypes;
    body["maxResultCount"] = 20;
    body["locationRestriction"] = locationRestriction;

    QByteArray postData = QJsonDocument(body).toJson(QJsonDocument::Compact);

    // === FIX VEXING PARSE: Khai báo rõ ràng QUrl trước ===
    QUrl url(urlStr);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("X-Goog-Api-Key", API_KEY.toUtf8());
    request.setRawHeader("X-Goog-FieldMask",
                         "places.displayName,"
                         "places.formattedAddress,"
                         "places.location,"
                         "places.photos,"
                         "places.rating,"
                         "places.editorialSummary");

    // Dùng QBuffer để gửi body (Qt5 không hỗ trợ post trực tiếp QByteArray)
    QBuffer *buffer = new QBuffer(this);
    buffer->setData(postData);
    buffer->open(QIODevice::ReadOnly);

    QNetworkReply *reply = manager->post(request, buffer);
    buffer->setParent(reply);  // Đảm bảo buffer được delete khi reply xong

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            qDebug() << "Google Places API - Network error:" << reply->errorString();
            Q_EMIT placesFetchFailed("Lỗi mạng: " + reply->errorString());
            reply->deleteLater();
            return;
        }

        QByteArray data = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);

        if (doc.isNull() || !doc.object().contains("places")) {
            qDebug() << "Google Places API - Invalid JSON response:" << QString(data);
            Q_EMIT placesFetchFailed("Không nhận được dữ liệu từ Google Places");
            reply->deleteLater();
            return;
        }

        QJsonArray placesArray = doc.object()["places"].toArray();
        QVariantList resultList;

        for (const QJsonValue &val : placesArray) {
            QJsonObject p = val.toObject();

            QVariantMap map;

            // Tên địa điểm
            map["name"] = p["displayName"].toObject()["text"].toString();

            // Địa chỉ
            map["addr"] = p["formattedAddress"].toString();

            // Mô tả: dùng editorialSummary nếu có, fallback rating
            QString desc = p["editorialSummary"].toObject()["text"].toString();
            if (desc.isEmpty()) {
                double rating = p["rating"].toDouble();
                desc = rating > 0 ? QString("Đánh giá: %1 ★").arg(rating, 0, 'f', 1) : "Không có mô tả";
            }
            map["desc"] = desc;

            // Khoảng cách
            QJsonObject loc = p["location"].toObject();
            double lat = loc["latitude"].toDouble();
            double lng = loc["longitude"].toDouble();
            double distKm = haversine(HOTEL_LAT, HOTEL_LNG, lat, lng);
            map["dist"] = QString("%1 km").arg(distKm, 0, 'f', 1);

            // Ảnh đầu tiên (nếu có)
            QJsonArray photos = p["photos"].toArray();
            if (!photos.isEmpty()) {
                QString photoName = photos[0].toObject()["name"].toString();
                map["img"] = QString("https://places.googleapis.com/v1/%1/media?key=%2&maxHeightPx=400&maxWidthPx=400")
                             .arg(photoName, API_KEY);
            } else {
                map["img"] = "qrc:/Pkg/MVC/Views/images/default_place.png";
            }

            resultList.append(map);
        }

        Q_EMIT placesFetched(resultList);
        reply->deleteLater();
    });
}