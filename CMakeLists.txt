cmake_minimum_required(VERSION 3.16)

project(AppTeacher VERSION 0.1 LANGUAGES CXX)

# --- Compiler setup ---
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_C99_STDIO=1 -U_FORTIFY_SOURCE")

# --- Qt5 Packages ---
find_package(Qt5 REQUIRED COMPONENTS
    Core
    Quick
    Qml
    QuickControls2
    Sql
    Multimedia
    Network
)

# --- Paths ---
set(PKG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Pkg)
set(LIB_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libs)
set(PATH_LIB_SOCKET ${LIB_PATH}/SocketIO_bin/libsioclient.a)

# --- Extra dependencies ---
find_package(OpenCV REQUIRED)
find_package(OpenSSL REQUIRED)
set(ncnn_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/ncnn_bin/lib/cmake/ncnn)
find_package(ncnn REQUIRED)

# --- Source files ---
file(GLOB CPP_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp"
    "${PKG_PATH}/*/*/src/*.cpp"
    "${PKG_PATH}/*/src/*.cpp"
)

file(GLOB HEADERS
    "${PKG_PATH}/*/*/inc/*.h"
    "${PKG_PATH}/*/inc/*.h"
)

# --- Include directories ---
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/Pkg
    ${OpenCV_INCLUDE_DIRS}
    ${LIB_PATH}/ncnn_bin/include
    ${LIB_PATH}/ncnn_bin/install/include
    ${LIB_PATH}/SocketIO_bin/src
    ${OPENSSL_INCLUDE_DIR}
    ${PKG_PATH}/Protocols
    ${PKG_PATH}/MVC
    ${PKG_PATH}/Auth
    ${PKG_PATH}/ComputingServ
    ${PKG_PATH}/Devices
    ${PKG_PATH}/Middlewares
    ${PKG_PATH}/Utils
    ${PKG_PATH}/Booting
    ${PKG_PATH}/Common
)

# --- QML Resources (nếu có) ---
set(QML_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Pkg/MVC/Views/resources.qrc)

# --- Executable ---
add_executable(${PROJECT_NAME}
    ${CPP_SOURCES}
    ${HEADERS}
    ${QML_RESOURCES}
)

# --- Compile definitions ---
add_definitions(-DQT_NO_KEYWORDS)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_DEPRECATED_WARNINGS
)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall
    -Wno-deprecated-declarations
    -pthread
    -fopenmp
)

# --- Link Libraries ---
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
    Qt5::Sql
    Qt5::Multimedia
    Qt5::Network
    ncnn
    ${OpenCV_LIBS}
    ${PATH_LIB_SOCKET}
    ${OPENSSL_LIBRARIES}
)

# --- Register resources for Qt5 ---
qt5_add_resources(QML_RESOURCES_ADDED ${QML_RESOURCES})
target_sources(${PROJECT_NAME} PRIVATE ${QML_RESOURCES_ADDED})

# --- Install rule ---
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG_MODE)
    install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/bin)
endif()

# --- Optional build flags ---
if(BUILD_VIRTUAL)
    add_definitions(-DBUILD_VIRTUAL)
endif()