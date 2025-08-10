#include "../inc/NotiModel.h"
#include <QAbstractListModel>
#include <QDateTime>
#include <QDebug>
#include <QString>

NotificationModel::NotificationModel(QObject *parent) : QAbstractListModel(parent) {}

void NotificationModel::addNotification(const Notification notification,
                                        const QList<Notification> &notificationList)
{

    const int oldCount = rowCount();
    beginInsertRows(QModelIndex(), oldCount, oldCount + notificationList.count() - 1);

    m_notificationList.append(notification);

    endInsertRows();
}
void NotificationModel::setNotiModelList(const QJsonArray &jsonArray)
{
    beginResetModel();
    m_notificationList.clear();  // Xóa dữ liệu cũ trước khi thêm mới

    for (int i = 0; i < jsonArray.size(); i++)
    {
        QJsonObject json = jsonArray[i].toObject();

        QString content = json["content"].toString();
        Notification noti(content);
        m_notificationList.append(noti);
    }
    endResetModel();
}

void NotificationModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, rowCount() - 1);
    m_notificationList.clear();
    endRemoveRows();
}

QJsonArray NotificationModel::getNotiModelList() const
{
    QJsonArray jsonArray;
    for (const auto &noti : m_notificationList)
    {
        QJsonObject jsonObject;
        jsonObject["content"] = noti.content();
        jsonArray.append(jsonObject);
    }
    return jsonArray;
}
int NotificationModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    return m_notificationList.count();
}

QVariant NotificationModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_notificationList.count())
        return QVariant();

    const Notification &notification = m_notificationList[index.row()];
    switch (role) {
        case ContentRole:
            return notification.content();
        default:
            return QVariant();
    }
}
QHash<int, QByteArray> NotificationModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ContentRole]  = "content";
    return roles;
}