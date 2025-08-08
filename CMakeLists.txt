cmake_minimum_required(VERSION 3.16)

project(HotelQMLTest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Tìm Qt
find_package(Qt6 REQUIRED COMPONENTS Quick QuickLayouts)

# Tạo executable
qt_add_executable(app_viewer
    main.cpp
    Pkg/MVC/Views/resources.qrc
)

qt_add_qml_module(app_viewer
    URI HotelUI
    VERSION 1.0
    RESOURCE_PREFIX /Pkg/MVC/Views
    QML_FILES
        Pkg/MVC/Views/ImageSlider.qml
        Pkg/MVC/Views/MainIntro.qml
        Pkg/MVC/Views/Login.qml
        Pkg/MVC/Views/Booking.qml
        Pkg/MVC/Views/BookingHistory.qml
        Pkg/MVC/Views/CustomerList.qml
        Pkg/MVC/Views/Payment.qml
        Pkg/MVC/Views/main.qml
)

target_link_libraries(app_viewer
    PRIVATE
        Qt6::Quick
        Qt6::QuickLayouts
)