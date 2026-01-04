#pragma once

#include <QObject>
#include <QVariantList>

class PlacesController : public QObject
{
    Q_OBJECT

    static PlacesController *instance;

public:
    static PlacesController *getInstance() {
        if (instance == nullptr)
            instance = new PlacesController();
        return instance;
    }

    explicit PlacesController(QObject *parent = nullptr);

    Q_INVOKABLE void getNearbyPlaces();

Q_SIGNALS:
    void placesFetched(const QVariantList &places);
    void placesFetchFailed(const QString &errorMsg);
};