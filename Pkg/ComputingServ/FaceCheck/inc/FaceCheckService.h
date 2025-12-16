#ifndef FACECHECKSERVICE_H
#define FACECHECKSERVICE_H

#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include "TArcface.h"
#include "TBlur.h"
#include "TLive.h"
#include "TMtCNN.h"
#include "TRetina.h"
#include "TWarp.h"
#include <QObject>
#include <algorithm>
#include <mutex>
#include <sys/stat.h>
#include <sys/types.h>
#include <vector>
#include "config.h"

using namespace cv;

class FaceCheckService : public QObject
{
    Q_OBJECT

private:
    static FaceCheckService *instance;
    static std::mutex m_ctx;

    FaceCheckService(const FaceCheckService &) = delete;
    FaceCheckService &operator=(const FaceCheckService &) = delete;

    explicit FaceCheckService(QObject *parent = nullptr);
    ~FaceCheckService();

    int RetinaWidth  = 320;
    int RetinaHeight = 240;

    // Neural network modules
    TLive    Live;
    TWarp    Warp;
    TMtCNN   MtCNN;
    TArcFace ArcFace;
    TRetina *Rtn = nullptr;

    std::vector<cv::String> NameFaces;
    std::vector<cv::Mat>    fc1;
    int                     faceCnt = 0;

    // Đường dẫn DB ảnh của user
    std::string path_to_dir = "/home/vboxuser/Downloads/HotelSystem/SystemHotel/DB";
    std::string endswith    = ".jpg";
    std::string pattern_jpg = "";

public:
    static FaceCheckService *getInstance();

    bool   init(const QString &id);
    bool   getResources(const std::string &id);
    bool   loadModelCustom();

    Q_INVOKABLE bool   loginWithFace(const Mat &frame);
    Q_INVOKABLE bool   loadDatabase();
    Q_INVOKABLE QString setPatternStr(const QString &id);
    cv::Mat getFeatureFromImage(const cv::Mat &img);

Q_SIGNALS:
    // Gửi realtime ra QML
    void livenessScore(float score);           // 0.0 ~ 1.0
    void cosineScore(float score, bool matched); // score 0.0~1.0 + true/false
};

#endif // FACECHECKSERVICE_H