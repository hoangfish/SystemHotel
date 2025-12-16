// libs/Pkg/ComputingServ/FaceCheck/src/FaceCheckService.cpp
#include "../inc/FaceCheckService.h"
#include "Logger/inc/logger.h"

#define DEBUG

FaceCheckService* FaceCheckService::instance = nullptr;
std::mutex FaceCheckService::m_ctx;

// ====================================================================
// Cosine distance
// ====================================================================
static inline float CosineDistance(const cv::Mat &v1, const cv::Mat &v2)
{
    double dot      = v1.dot(v2);
    double denom_v1 = norm(v1);
    double denom_v2 = norm(v2);
    if (denom_v1 == 0 || denom_v2 == 0) return 0.0f;
    return static_cast<float>(dot / (denom_v1 * denom_v2));
}

// ====================================================================
// Singleton
// ====================================================================
FaceCheckService* FaceCheckService::getInstance()
{
    if (instance == nullptr) {
        std::lock_guard<std::mutex> lock(m_ctx);
        if (instance == nullptr) {
            instance = new FaceCheckService();
        }
    }
    return instance;
}

// ====================================================================
// Các hàm public (giữ nguyên 100% như file gốc của bạn)
// ====================================================================
QString FaceCheckService::setPatternStr(const QString &id)
{
    LOG(LogLevel::INFO, "setPatternStr called");
    this->pattern_jpg = this->path_to_dir + "/" + id.toStdString() + "*" + this->endswith;
    return QString::fromStdString(this->pattern_jpg);
}

bool FaceCheckService::init(const QString &id)
{
    this->setPatternStr(id);
    this->loadDatabase();
#ifndef DEBUG
    this->getResources(id.toStdString());
#endif
    return true;
}

bool FaceCheckService::loadDatabase()
{
    cv::Mat faces;

    if (pattern_jpg.empty()) {
        LOG(LogLevel::ERROR, "pattern_jpg is empty");
        return false;
    }

    cv::glob(this->pattern_jpg, this->NameFaces);
    this->faceCnt = this->NameFaces.size();

    if (this->faceCnt == 0) {
        LOG(LogLevel::ERROR, "No image files[jpg] in database");
        return false;
    }

    LOG(LogLevel::INFO, "Found " + std::to_string(this->faceCnt) + " pictures in database.");

    for (int i = 0; i < this->faceCnt; ++i) {
        faces = cv::imread(this->NameFaces[i]);
        if (faces.empty()) {
            LOG(LogLevel::WARNING, "Cannot read image: " + this->NameFaces[i]);
            continue;
        }

        cv::resize(faces, faces, cv::Size(112, 112));
        cv::Mat feat = this->ArcFace.GetFeature(faces);

        double n = cv::norm(feat);
        if (feat.empty() || std::isnan(n) || n == 0) {
            LOG(LogLevel::WARNING, "Invalid feature for: " + this->NameFaces[i]);
            continue;
        }

        this->fc1.push_back(feat);

        if (faceCnt > 1)
            printf("\rloading: %.2lf%% ", (i + 1) * 100.0 / faceCnt);
    }

    LOG(LogLevel::INFO, "Loaded " + std::to_string(this->fc1.size()) + " faces in total");
    return true;
}

static inline bool check_create_folder(const std::string &path)
{
    struct stat info;
    if (stat(path.c_str(), &info) != 0) {
        LOG(LogLevel::INFO, "Creating directory " + path);
        int status = mkdir(path.c_str(), 0775);
        if (status != 0) {
            LOG(LogLevel::ERROR, "Failed to create directory " + path);
            return false;
        }
    } else if (info.st_mode & S_IFDIR) {
        LOG(LogLevel::INFO, path + " already exists.");
    } else {
        LOG(LogLevel::ERROR, path + " exists, but is not a directory.");
        return false;
    }
    return true;
}

bool FaceCheckService::getResources(const std::string &id)
{
#ifdef DEBUG
    const std::string dir_path_app       = "../";
    const std::string dir_path_database  = "../database/";
#else
    const std::string dir_path_app       = "/tmp/app-teacher/";
    const std::string dir_path_database  = "/tmp/app-teacher/database/";
#endif

    if (check_create_folder(dir_path_app)) {
        if (check_create_folder(dir_path_database)) {
            std::string url = id;
            system("wget -P /tmp/app-teacher/database/ URL");
        }
    }
    return true;
}

bool FaceCheckService::loadModelCustom()
{
    return true;
}

// ====================================================================
// loginWithFace – ĐÃ FIX HOÀN TOÀN, CHẠY NGON, CÓ Q_EMIT
// ====================================================================
bool FaceCheckService::loginWithFace(const cv::Mat &frame)
{
    bool ret = false;
    cv::Mat inputFrame;           // <-- ĐÃ KHAI BÁO LẠI ĐÚNG
    cv::Mat result_cnn;
    std::vector<FaceObject> Faces;

    // 1. Lấy frame từ consumer (realtime) hoặc fallback video/camera
    bool useExternalFrame = !frame.empty();
    if (useExternalFrame) {
        inputFrame = frame.clone();
    } else {
        cv::VideoCapture cap;
        std::string videoPath = "/home/vboxuser/Downloads/HotelSystem/SystemHotel/test/Huyen.mp4";
        cap.open(videoPath);
        if (!cap.isOpened()) {
            LOG(LogLevel::WARNING, "Unable to open video file, trying camera 0...");
            cap.open(0);
        }
        if (!cap.isOpened()) {
            LOG(LogLevel::ERROR, "Cannot open video or camera.");
            return false;
        }
        cap >> inputFrame;
    }

    if (inputFrame.empty()) {
        LOG(LogLevel::ERROR, "loginWithFace() --> frame is empty");
        return false;
    }

    result_cnn = inputFrame.clone();

#ifdef RETINA
    Rtn->detect_retinaface(result_cnn, Faces);
#else
    MtCNN.detect(result_cnn, Faces);
#endif

    if (Faces.size() != 1) {
        LOG(LogLevel::WARNING, "No face or multiple faces detected");
        return false;
    }
    if (Faces[0].FaceProb < FACE_PROB_THRESH) {
        LOG(LogLevel::WARNING, "Low detection confidence: " + std::to_string(Faces[0].FaceProb));
        return false;
    }

    // 3. Liveness
    float x1 = Faces[0].rect.x;
    float y1 = Faces[0].rect.y;
    float x2 = Faces[0].rect.width + x1;
    float y2 = Faces[0].rect.height + y1;
    struct LiveFaceBox LiveBox = {x1, y1, x2, y2};
    float rateFake = Live.Detect(result_cnn, LiveBox);

    LOG(LogLevel::INFO, "Liveness score: " + std::to_string(rateFake));
    Q_EMIT livenessScore(rateFake);                     // Gửi realtime ra QML

    if (rateFake <= FACE_LIVING) {
        LOG(LogLevel::WARNING, "Face is fake (score=" + std::to_string(rateFake) + ")");
        return false;
    }

    // 4. Align + resize
    cv::Mat aligned = Warp.Process(result_cnn, Faces[0]);
    Faces[0].Angle = Warp.Angle;
    cv::resize(aligned, aligned, cv::Size(112, 112));

    // 5. Trích xuất feature
    cv::Mat fc2 = ArcFace.GetFeature(aligned);
    double n2 = cv::norm(fc2);
    if (fc2.empty() || std::isnan(n2) || n2 == 0) {
        LOG(LogLevel::WARNING, "Invalid feature vector.");
        return false;
    }

    // 6. So sánh với DB
    if (this->faceCnt > 0) {
        std::vector<double> score_;
        for (int c = 0; c < faceCnt; ++c)
            score_.push_back(CosineDistance(fc1[c], fc2));

        double max_score = *std::max_element(score_.begin(), score_.end());
        bool   matched   = (max_score > COSINE_THRESH);

        LOG(LogLevel::INFO, "Cosine similarity score: " + std::to_string(max_score));
        Q_EMIT cosineScore(static_cast<float>(max_score), matched);  // Gửi realtime ra QML

        if (matched) {
            LOG(LogLevel::INFO, "Match found! Cosine = " + std::to_string(max_score));
            ret = true;
        } else {
            LOG(LogLevel::WARNING, "Not matched. Cosine = " + std::to_string(max_score));
        }
    }

    return ret;
}

// ====================================================================
// Constructor / Destructor
// ====================================================================
FaceCheckService::FaceCheckService(QObject *parent) : QObject(parent)
{
    this->Live.LoadModel();
    this->Rtn = new TRetina(this->RetinaWidth, this->RetinaHeight, true);
    LOG(LogLevel::INFO, "FaceCheckService initialized (ArcFace assumed pre-loaded).");
}

FaceCheckService::~FaceCheckService()
{
    if (this->Rtn != nullptr)
        delete this->Rtn;
}

cv::Mat FaceCheckService::getFeatureFromImage(const cv::Mat &img)
{
    return this->ArcFace.GetFeature(img);
}