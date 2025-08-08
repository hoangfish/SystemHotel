import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "Thanh toán"
    color: "#fafafa"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        Text {
            text: "Thanh toán hóa đơn"
            font.pixelSize: 28
            font.bold: true
        }

        // Tổng tiền
        RowLayout {
            spacing: 12
            Text {
                text: "Tổng tiền:"
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                text: "2,500,000 VND"
                font.pixelSize: 18
                color: "#d32f2f"
            }
        }

        // Hình thức thanh toán
        GroupBox {
            title: "Chọn hình thức thanh toán"
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 8
                RadioButton { text: "Tiền mặt"; checked: true }
                RadioButton { text: "Chuyển khoản" }
                RadioButton { text: "Thẻ tín dụng" }
            }
        }

        // Xác nhận
        Button {
            text: "Xác nhận và xuất hóa đơn"
            Layout.fillWidth: true
            height: 48
            font.pixelSize: 16
            background: Rectangle {
                color: "#388E3C"
                radius: 8
            }
            onClicked: {
                console.log("Đã thanh toán và xuất hóa đơn")
                // Gọi logic xử lý thanh toán sau này
            }
        }
    }
}
