#ifndef ROOMCONTROLLER_H
#define ROOMCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include "../../Models/inc/RoomModel.h"
#include "Http/inc/httpclientimpl.h"
#include "SocketIO/inc/socketioclient.h"

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
    void setRoomStatus(const QString& roomId, const QString& newStatus);

    Q_INVOKABLE void getRooms();
    Q_INVOKABLE void selectRoom(const QString &roomId);
    Q_INVOKABLE void bookRoom(const QString &roomId, const QString &checkInDate, const QString &checkOutDate);

    QVariantList getRoomList() const { return m_roomList; }
    void setRoomList(const QVariantList &roomList) {
        m_roomList = roomList;
        Q_EMIT roomListChanged();
    }

Q_SIGNALS:
    void roomsFetched(const QVariantList &rooms);
    void roomFetchFailed(const QString &errorMsg);
    void roomSelected(const QVariantMap &room);
    void roomBooked();
    void roomBookingFailed(const QString &errorMsg);
    void roomListChanged();

private:
    HttpClientImpl *m_httpClient;
    RoomModel *m_selectedRoom;
    QVariantList m_roomList;
    bool isSubscribeSocket;
};

#endif // ROOMCONTROLLER_H