#include "../inc/UserModel.h"

UserModel::UserModel(QObject *parent) : QObject(parent) {}

QString UserModel::firstName() const {
    return m_firstName;
}

void UserModel::setFirstName(const QString &firstName) {
    if (m_firstName != firstName) {
        m_firstName = firstName;
        Q_EMIT firstNameChanged();
    }
}

QString UserModel::lastName() const {
    return m_lastName;
}

void UserModel::setLastName(const QString &lastName) {
    if (m_lastName != lastName) {
        m_lastName = lastName;
        Q_EMIT lastNameChanged();
    }
}