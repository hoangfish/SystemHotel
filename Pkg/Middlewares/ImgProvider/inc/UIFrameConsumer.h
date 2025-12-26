#pragma once
#include "Camera/interfaces/IConsumer.h"
#include "Middlewares/ImgProvider/inc/ImageStreamObserver.h"

class UIFrameConsumer : public Consumer<cv::Mat> {
public:
    UIFrameConsumer() {}

    void processElement(cv::Mat &frame) override {
        // Đẩy frame mới nhất lên QML
        QImage img = QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();
        Q_EMIT VideoStreamer::getInstance().newImage(img, "ui");
    }
};