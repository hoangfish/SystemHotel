import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 1280
    height: 800
    title: "Quản lý khách sạn"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qrc:/Pkg/MVC/Views/MainIntro.qml"  // Giữ nguyên nếu bạn có intro riêng, hoặc thay bằng Login nếu không cần

        onCurrentItemChanged: {
            // ==================== MainIntro ====================
            if (stackView.currentItem && stackView.currentItem.objectName === "MainIntro") {
                let intro = stackView.currentItem
                intro.openLogin.connect(() => {
                    stackView.push("qrc:/Pkg/MVC/Views/Login.qml")
                })
                // THÊM: Xử lý nút Đăng ký → mở Register.qml
                intro.openRegister.connect(() => {
                    stackView.push("qrc:/Pkg/MVC/Views/Register.qml")
                })
            }
            // ==================== Login ====================
            if (stackView.currentItem && stackView.currentItem.objectName === "Login") {
                let login = stackView.currentItem
                login.loginSuccess.connect(() => {
                    delayTimer.start() // Clear stack rồi vào Booking
                })
                login.adminLoginSuccess.connect(() => {
                    stackView.clear()
                    Qt.callLater(() => {
                        stackView.push("qrc:/Pkg/MVC/Views/CustomerList.qml", {stackViewRef: stackView})
                    })
                })
            }
            // ==================== Booking ====================
            if (stackView.currentItem && stackView.currentItem.objectName === "Booking") {
                let booking = stackView.currentItem
                // Thêm nếu cần signals khác
            }
            // ==================== Places (Others) ====================
            if (stackView.currentItem && stackView.currentItem.objectName === "Places") {
                let places = stackView.currentItem
                // Thêm nếu cần signals khác
            }
            // ==================== Dashboard (nếu có) ====================
            if (stackView.currentItem && stackView.currentItem.objectName === "Dashboard") {
                let dash = stackView.currentItem
                dash.navigateToBooking.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Booking.qml"))
                dash.navigateToPayment.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Payment.qml"))
                dash.navigateToReservation.connect(() => stackView.push("qrc:/Pkg/MVC/Views/BookingHistory.qml"))
                dash.navigateToCustomer.connect(() => stackView.push("qrc:/Pkg/MVC/Views/CustomerList.qml"))
                dash.logout.connect(() => stackView.pop())
            }
        }
    }

    // Timer để delay một chút trước khi clear stack và push Booking (tránh lỗi QML)
    Timer {
        id: delayTimer
        interval: 300
        repeat: false
        onTriggered: {
            stackView.clear()
            stackView.push("qrc:/Pkg/MVC/Views/Booking.qml", {stackViewRef: stackView})
        }
    }

    // Xử lý logout từ Booking (an toàn với currentItem thay đổi)
    Connections {
        target: stackView.currentItem
        ignoreUnknownSignals: true
        function onLogoutSuccess() {
            if (stackView.currentItem && (stackView.currentItem.objectName === "Booking" || stackView.currentItem.objectName === "Places")) {
                stackView.clear()
                stackView.push("qrc:/Pkg/MVC/Views/Login.qml")
            }
        }
    }

    Component.onCompleted: {
        UserController = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; UserController {}', this);
        UserModel = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; UserModel {}', this);
        AdminController = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; AdminController {}', this);
        AdminModel = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; AdminModel {}', this);
        // Thêm: Tạo PlacesController
        PlacesController = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; PlacesController {}', this);
    }
}