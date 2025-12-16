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
        initialItem: "qrc:/Pkg/MVC/Views/MainIntro.qml"

        onCurrentItemChanged: {
            if (stackView.currentItem && stackView.currentItem.objectName === "MainIntro") {
                let intro = stackView.currentItem
                intro.openLogin.connect(() => {
                    stackView.push("qrc:/Pkg/MVC/Views/Login.qml")
                })
            }
            if (stackView.currentItem && stackView.currentItem.objectName === "Login") {
                let login = stackView.currentItem
                login.loginSuccess.connect(() => {
                    // ✅ FIX CUỐI: Clear hết stack cũ (xóa sạch Login + MainIntro) → push Booking mới
                    delayTimer.start()
                })
                login.adminLoginSuccess.connect(() => {
                    stackView.clear()
                    Qt.callLater(() => {
                        stackView.push("qrc:/Pkg/MVC/Views/CustomerList.qml", {stackViewRef: stackView})
                    })
                })
            }
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

    // Timer delay push Booking sau khi clear stack
    Timer {
        id: delayTimer
        interval: 300
        repeat: false
        onTriggered: {
            stackView.clear()  // Xóa sạch stack cũ
            stackView.push("qrc:/Pkg/MVC/Views/Booking.qml", {stackViewRef: stackView})
        }
    }

    // Connections logout khi ở Booking (an toàn với currentItem)
    Connections {
        target: stackView.currentItem
        ignoreUnknownSignals: true
        function onLogoutSuccess() {
            if (stackView.currentItem && stackView.currentItem.objectName === "Booking") {
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
    }
}