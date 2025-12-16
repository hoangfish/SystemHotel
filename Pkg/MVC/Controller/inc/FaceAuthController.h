#pragma once

#include <QObject>
#include <QImage>
#include <memory>

class ConFaceCheckIpml;

class FaceAuthController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isChecking READ isChecking NOTIFY isCheckingChanged)
    Q_PROPERTY(QString currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)

private:
    explicit FaceAuthController(QObject* parent = nullptr);
    static FaceAuthController* m_instance;

    bool m_isChecking = false;
    QString m_currentUserId;
    std::unique_ptr<ConFaceCheckIpml> m_faceConsumer;

public:
    static FaceAuthController* getInstance();
    ~FaceAuthController() override;

    bool isChecking() const { return m_isChecking; }
    QString currentUserId() const { return m_currentUserId; }

    Q_INVOKABLE void startFaceCheck(const QString& userId = QString());
    Q_INVOKABLE void stopFaceCheck();

public Q_SLOTS:
    void setCurrentUserId(const QString& id);

Q_SIGNALS:
    void faceCheckSuccess();        // Mặt đúng → cho Check-In/Check-Out
    void faceCheckFailed();         // Mặt sai
    void faceCheckError(const QString& msg);
    void newCameraFrame(const QImage& image);  // Để QML hiển thị camera realtime
    void isCheckingChanged();
    void currentUserIdChanged();
};