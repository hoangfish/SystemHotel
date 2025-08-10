#ifndef NOTIFICATIONMODEL_H
#define NOTIFICATIONMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>
#include <QString>
#include <QVariant>

class Notification
{
public:
    Notification(QString content)
        : m_content(content) {}
    void setContent(QString pContent)
    {
        m_content = pContent;
    }
    QString content() const {
        return m_content;
    }

private:
    QString m_content;
};

class NotificationModel : public QAbstractListModel
{
    Q_OBJECT;

public:
    enum NotificationRoles
    {
        ContentRole = (Qt::UserRole + 1)
    };

    explicit NotificationModel(QObject *parent = nullptr);

    void addNotification(const Notification notification, const QList<Notification> &notificationList);

    QList<Notification> getNotiModel()
    {
        return m_notificationList;
    }
    void       clear();
    void setNotiModelList(const QJsonArray &jsonArray);
    
    QJsonArray getNotiModelList() const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant   data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;


private:
    QList<Notification> m_notificationList;
};

#endif // NOTIFICATIONMODEL_H