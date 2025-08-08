import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 700
    height: 600
    title: "Khách hàng"
    color: "#f9f9f9"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Text {
            text: "Danh sách khách hàng"
            font.pixelSize: 28
            font.bold: true
        }

        // Ô tìm kiếm
        RowLayout {
            spacing: 8
            TextField {
                id: searchField
                placeholderText: "Tìm theo tên hoặc số điện thoại"
                Layout.fillWidth: true
            }
            Button {
                text: "Tìm"
                onClicked: {
                    console.log("Tìm kiếm:", searchField.text)
                }
            }
        }

        // Danh sách khách hàng
        ListView {
            id: customerList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            clip: true

            model: ListModel {
                ListElement { name: "Nguyễn Văn A"; phone: "0901234567" }
                ListElement { name: "Trần Thị B"; phone: "0939876543" }
                ListElement { name: "Lê Văn C"; phone: "0965554433" }
            }

            delegate: Rectangle {
                width: parent.width
                height: 60
                radius: 6
                color: "#ffffff"
                border.color: "#cccccc"
                border.width: 1

                Item {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text {
                        text: name
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                    }

                    Text {
                        text: phone
                        font.pixelSize: 14
                        color: "#666"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                    }
                }
            }
        }
    }
}
