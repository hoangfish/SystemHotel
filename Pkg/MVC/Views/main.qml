import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import HotelUI 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: "Quản lý khách sạn"

    StackView {
        id: stackView
        anchors.fill: parent

        // ✅ Đã bỏ Qt.resolvedUrl để tránh silent error
        initialItem: "qrc:/Pkg/MVC/Views/MainIntro.qml"

        onCurrentItemChanged: {
            if (stackView.currentItem && stackView.currentItem.objectName === "Dashboard") {
                let dash = stackView.currentItem
                dash.navigateToBooking.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Booking.qml"))
                dash.navigateToPayment.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Payment.qml"))
                dash.navigateToReservation.connect(() => stackView.push("qrc:/Pkg/MVC/Views/BookingHistory.qml"))
                dash.navigateToCustomer.connect(() => stackView.push("qrc:/Pkg/MVC/Views/CustomerList.qml"))
                dash.logout.connect(() => stackView.pop())
            }

            if (stackView.currentItem && stackView.currentItem.objectName === "MainIntro") {
                let intro = stackView.currentItem
                intro.openLogin.connect(() => {
                    // ✅ Đã sửa prefix đúng như .qrc
                    stackView.push("qrc:/Pkg/MVC/Views/Login.qml")
                })
            }

            if (stackView.currentItem && stackView.currentItem.objectName === "Login") {
                let login = stackView.currentItem
                login.loginSuccess.connect(() => {
                    // ✅ Sửa đúng prefix
                    stackView.replace("qrc:/Pkg/MVC/Views/Booking.qml")
                })
            }
        }
    }
}
