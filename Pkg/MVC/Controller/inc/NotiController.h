#ifndef NOTI_SERVICE_H
#define NOTI_SERVICE_H

#include "Http/inc/httpclientimpl.h"
#include "Logger/inc/logger.h"
#include <iostream>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QString>

#include "MVC/Models/inc/NotiModel.h"

class NotiController : public QObject {
    Q_OBJECT
    QJsonArray             m_QmlNotiIF;
    int                    Count;
    static NotiController *instance;
    Q_PROPERTY(QJsonArray qmlNotiIF READ getQmlNotiIF WRITE setQmlNotiIF NOTIFY qmlNotiIFChanged)

    // Private constructor
    NotiController(QObject *parent = nullptr)
        : QObject(parent), m_notiModel(new NotificationModel(parent)) {
        loaed = false;
    }

private:
    NotificationModel *m_notiModel;
    bool               loaed;

public:
    ~NotiController() {}

    static NotiController *getInstance() {
        if (instance == nullptr)
            instance = new NotiController();
        return instance;
    }

    Q_INVOKABLE QJsonArray getQmlNotiIF();

    void setQmlNotiIF(const QJsonArray &qmlNotiIF);
    void getIdTeacher(const QString &idTeacher);

    // Disable copy constructor and copy assignment operator
    NotiController(const NotiController &) = delete;
    NotiController &    operator=(const NotiController &) = delete;

    Q_INVOKABLE QString getNotiCount() const;
    Q_INVOKABLE bool    getNotiFromServer();
    Q_INVOKABLE void    addNotiRealTime(QString content);
    Q_INVOKABLE void    emitNoti(QString content) {
        //Q_EMIT notiChanged(content);
    }

Q_SIGNALS:
    void qmlNotiIFChanged(QJsonArray qmlNotiIF);
};

#endif // NOTI_SERVICE_H