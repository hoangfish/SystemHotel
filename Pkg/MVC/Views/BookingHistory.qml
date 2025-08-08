import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 700
    height: 600
    title: qsTr("Lịch sử đặt phòng")
    color: "#f4f4f4"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Text {
            text: "Lịch sử đặt phòng"
            font.pixelSize: 28
            font.bold: true
        }

        ListView {
            id: historyList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true
            model: ListModel {
                ListElement {
                    name: "Nguyễn Văn A"
                    room: "Phòng đôi"
                    checkIn: "2025-07-10"
                    checkOut: "2025-07-12"
                }
                ListElement {
                    name: "Trần Thị B"
                    room: "Phòng VIP"
                    checkIn: "2025-07-15"
                    checkOut: "2025-07-17"
                }
                ListElement {
                    name: "Lê Văn C"
                    room: "Phòng đơn"
                    checkIn: "2025-07-18"
                    checkOut: "2025-07-19"
                }
            }

            delegate: Rectangle {
                width: parent.width
                height: 100
                color: "white"
                radius: 8
                border.color: "#cccccc"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    Text { text: "Khách: " + name; font.pixelSize: 16; font.bold: true }
                    Text { text: "Phòng: " + room; font.pixelSize: 14 }
                    Text { text: "Từ: " + checkIn + "  Đến: " + checkOut; font.pixelSize: 14 }
                }
            }
        }

        Button {
            text: "Quay lại"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                console.log("Quay lại dashboard")
            }
        }
    }
}
