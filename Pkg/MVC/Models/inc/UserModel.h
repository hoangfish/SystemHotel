#ifndef USERMODEL_H
#define USERMODEL_H

#include <QObject>
#include <QString>

class UserModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)

public:
    explicit UserModel(QObject *parent = nullptr);

    QString firstName() const;
    void setFirstName(const QString &firstName);

    QString lastName() const;
    void setLastName(const QString &lastName);

Q_SIGNALS:
    void firstNameChanged();
    void lastNameChanged();

private:
    QString m_firstName;
    QString m_lastName;
};

#endif // USERMODEL_H