#pragma once

#include <QObject>
#include <QVariantList>
#include "Http/inc/httpclientimpl.h"
#include "../../Models/inc/RoomModel.h"
#include "SocketIO/inc/socketioclient.h"
#include "Common/matrix.h"
class RoomController : public QObject {
    Q_OBJECT
    static RoomController *instance;

public:
    static RoomController *getInstance() {
        if (instance == nullptr)
            instance = new RoomController();
        return instance;
    }
    explicit RoomController(QObject *parent = nullptr);
    QString downloadImage(const QString& urlString);
    Q_INVOKABLE void getRooms();
    Q_INVOKABLE void selectRoom(const QString &roomId);
    Q_INVOKABLE void bookRoom(const QString &roomId, const QString &checkInDate, const QString &checkOutDate);
    void setRoomList(const QVariantList& roomList )
    {
        m_roomList=roomList;
        Q_EMIT roomsFetched(m_roomList);

    }
    QVariantList getRoomList(){return m_roomList;};
    void setRoomStatus(const QString &roomId);
Q_SIGNALS:
    void roomsFetched(const QVariantList &rooms);
    void roomSelected(const QVariantMap &room);
    void roomFetchFailed(const QString &errorMsg);
    void roomBooked();
    void roomBookingFailed(const QString &errorMsg);

private:
    bool isSubscribeSocket = false;
    HttpClientImpl *m_httpClient;
    RoomModel *m_selectedRoom;
    QVariantList m_roomList;
};