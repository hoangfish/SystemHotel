import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Item {
    width: 1280
    height: 720
    objectName: "Booking"

    // == DỮ LIỆU PHÒNG ==
    ListModel {
        id: roomModel
        ListElement {
            name: "Muong Thanh Lite Queen"
            image: "qrc:/Pkg/MVC/Views/images/room1.png"
            price: "972.000₫"
            originalPrice: "1.080.000₫"
            desc: "Giường Queen size • Không hút thuốc • Smart TV • Wifi tốc độ cao • Mini Bar"
            guests: "2 khách"
            area: "20 m²"
        }
        ListElement {
            name: "Muong Thanh Lite+ Queen"
            image: "qrc:/Pkg/MVC/Views/images/room2.png"
            price: "1.350.000₫"
            originalPrice: "1.500.000₫"
            desc: "Giường Queen size • Thú cưng ok • Máy sấy tóc • Không hút thuốc"
            guests: "2 khách"
            area: "20 m²"
        }
        ListElement {
            name: "Muong Thanh Family Room"
            image: "qrc:/Pkg/MVC/Views/images/room3.png"
            price: "1.980.000₫"
            originalPrice: "2.200.000₫"
            desc: "2 Giường đôi • Bếp nhỏ • Cửa sổ lớn • View thành phố"
            guests: "4 khách"
            area: "35 m²"
        }
        ListElement {
            name: "Muong Thanh Premium"
            image: "qrc:/Pkg/MVC/Views/images/room4.png"
            price: "2.400.000₫"
            originalPrice: "2.650.000₫"
            desc: "Giường King • Máy pha cà phê • Ban công riêng • Bồn tắm"
            guests: "2 khách"
            area: "40 m²"
        }
        ListElement {
            name: "Muong Thanh Suite"
            image: "qrc:/Pkg/MVC/Views/images/room5.png"
            price: "3.200.000₫"
            originalPrice: "3.500.000₫"
            desc: "Phòng suite rộng rãi • Phòng khách riêng • View biển • Bếp nhỏ"
            guests: "3 khách"
            area: "55 m²"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // == HEADER ==
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#d32f2f"
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                Text {
                    text: "Muong Thanh Luxury HCM"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    id: avatar
                    width: 40
                    height: 40
                    radius: 20
                    color: "#ffebee"
                    border.color: "#880e4f"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "HN"
                        color: "#880e4f"
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: profileDialog.open()
                    }
                }
            }
        }

        // == BODY + FOOTER ==
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: bodyWrapper.implicitHeight
            clip: true

            Column {
                id: bodyWrapper
                width: parent.width
                spacing: 0

                // == BODY CONTENT ==
                Item {
                    width: parent.width
                    height: 720

                    // Nội dung chính
                    Item {
                        id: contentArea
                        anchors.fill: parent

                        // == DANH SÁCH PHÒNG ==
                        Flickable {
                            id: scrollArea
                            anchors {
                                top: parent.top
                                left: parent.left
                                bottom: parent.bottom
                                right: bookingSummary.left
                                margins: 24
                            }
                            contentWidth: contentWrapper.width
                            contentHeight: contentWrapper.implicitHeight
                            clip: true

                            Column {
                                id: contentWrapper
                                width: scrollArea.width
                                spacing: 32

                                ColumnLayout {
                                    id: roomList
                                    width: scrollArea.width - 32
                                    spacing: 32

                                    Text {
                                        text: "Chọn phòng"
                                        font.pixelSize: 28
                                        font.bold: true
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    // BỘ LỌC
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 90
                                        color: "#f3f4f6"
                                        radius: 8
                                        border.color: "#ccc"
                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 16
                                            ComboBox {
                                                id: roomTypeFilter
                                                Layout.preferredWidth: 180
                                                model: ["Tùy chọn phòng", "Phòng đơn", "Phòng đôi"]
                                            }
                                            ComboBox {
                                                id: viewFilter
                                                Layout.preferredWidth: 220
                                                model: ["Hướng cửa sổ", "Quang cảnh thành phố", "Hướng nhìn ra biển"]
                                            }
                                            Item { Layout.fillWidth: true }
                                        }
                                    }

                                    // DANH SÁCH PHÒNG
                                    Repeater {
                                        model: roomModel
                                        delegate: Rectangle {
                                            width: roomList.width
                                            height: 220
                                            radius: 12
                                            color: "#fff"
                                            border.color: "#e0e0e0"
                                            border.width: 1

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 16
                                                spacing: 16

                                                Rectangle {
                                                    Layout.preferredWidth: roomList.width * 0.3
                                                    Layout.fillHeight: true
                                                    radius: 8
                                                    clip: true
                                                    color: "#f0f0f0"

                                                    Image {
                                                        anchors.fill: parent
                                                        source: image
                                                        fillMode: Image.PreserveAspectCrop
                                                    }
                                                }

                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 6

                                                    Text {
                                                        text: name
                                                        font.pixelSize: 20
                                                        font.bold: true
                                                    }

                                                    Text {
                                                        text: desc
                                                        font.pixelSize: 14
                                                        color: "#444"
                                                        wrapMode: Text.WordWrap
                                                    }

                                                    RowLayout {
                                                        spacing: 16
                                                        Text { text: "👥 " + guests; font.pixelSize: 14 }
                                                        Text { text: "📐 " + area; font.pixelSize: 14 }
                                                    }

                                                    RowLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 16

                                                        ColumnLayout {
                                                            spacing: 2
                                                            Text {
                                                                text: originalPrice
                                                                font.pixelSize: 14
                                                                color: "#999"
                                                                font.strikeout: true
                                                            }
                                                            Text {
                                                                text: price
                                                                font.pixelSize: 18
                                                                font.bold: true
                                                                color: "#d32f2f"
                                                            }
                                                        }

                                                        Item { Layout.fillWidth: true }

                                                        Button {
                                                            text: "Chọn"
                                                            width: 100
                                                            height: 36
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // == ĐƠN ĐẶT PHÒNG ==
                        Rectangle {
                            id: bookingSummary
                            width: 300
                            height: 180
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: 80
                            anchors.rightMargin: 24
                            radius: 12
                            color: "#fafafa"
                            border.color: "#ddd"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 0

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 50
                                    color: "#fafafa"
                                    radius: 12

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Đơn đặt phòng của tôi"
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#333"
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 32
                                    color: "#fff3f3"
                                    Text {
                                        anchors.centerIn: parent
                                        text: "1 đêm"
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "#333"
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"

                                    Item {
                                        anchors.fill: parent
                                        anchors.margins: 12

                                        GridLayout {
                                            columns: 2
                                            anchors.fill: parent
                                            rowSpacing: 4
                                            columnSpacing: 16

                                            ColumnLayout {
                                                Text {
                                                    text: "7 tháng 8"
                                                    font.pixelSize: 16
                                                    font.bold: true
                                                    color: "#333"
                                                }
                                                Text {
                                                    text: "Thứ Năm"
                                                    font.pixelSize: 12
                                                    color: "#555"
                                                }
                                                Text {
                                                    text: "từ lúc 14:00"
                                                    font.pixelSize: 12
                                                    color: "#555"
                                                }
                                            }

                                            ColumnLayout {
                                                Text {
                                                    text: "8 tháng 8"
                                                    font.pixelSize: 16
                                                    font.bold: true
                                                    color: "#333"
                                                }
                                                Text {
                                                    text: "Thứ Sáu"
                                                    font.pixelSize: 12
                                                    color: "#555"
                                                }
                                                Text {
                                                    text: "đến 12:00"
                                                    font.pixelSize: 12
                                                    color: "#555"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // == FOOTER ==
                Rectangle {
                    width: parent.width
                    height: 220
                    color: "#001f3f"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 48

                        ColumnLayout {
                            spacing: 8
                            Label {
                                text: "fit@hcmus"
                                color: "#00cc99"
                                font.pixelSize: 20
                                font.bold: true
                            }
                            Label {
                                text: "Faculty of Information Technology,\nVNUHCM - University of Science"
                                color: "#ffffff"
                                wrapMode: Text.WordWrap
                            }
                        }

                        ColumnLayout {
                            spacing: 8
                            Label {
                                text: "Members"
                                color: "#00cc99"
                                font.pixelSize: 18
                                font.bold: true
                            }
                            Label { text: "• Phạm Hoàng Phúc"; color: "#ffffff" }
                            Label { text: "• Nguyễn Trực Phúc"; color: "#ffffff" }
                            Label { text: "• Nguyễn Khang Hy"; color: "#ffffff" }
                            Label { text: "• Lê Đinh Nguyên Phong"; color: "#ffffff" }
                        }

                        ColumnLayout {
                            spacing: 8
                            Label {
                                text: "Contact Us"
                                color: "#00cc99"
                                font.pixelSize: 18
                                font.bold: true
                            }
                            Label { text: "📞 0915 895 157"; color: "#ffffff" }
                            MouseArea {
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally("mailto:nkhy2414@clc.fitus.edu.vn")

                                Label {
                                    text: "✉ nkhy2414@clc.fitus.edu.vn"
                                    color: "#00ccff"
                                    font.underline: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // PROFILE DIALOG
    Dialog {
        id: profileDialog
        modal: true
        focus: true
        x: parent.width - width - 40
        y: 70
        width: 340
        contentItem: Rectangle {
            width: parent.width
            color: "#ffffff"
            radius: 8
            border.color: "#ccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: "Hy Nguyễn"
                    font.bold: true
                    font.pixelSize: 16
                }

                Text {
                    text: "+84915895157"
                    color: "#666"
                    font.pixelSize: 14
                }

                Rectangle {
                    color: "#fce4ec"
                    radius: 4
                    Layout.fillWidth: true
                    height: 32
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 6
                        Text {
                            text: "\u2714"
                            font.pixelSize: 14
                            color: "#c2185b"
                        }
                        Text {
                            text: "Bạn đã nhận được khuyến mãi 10%"
                            font.pixelSize: 12
                            color: "#c2185b"
                        }
                    }
                }

                Button {
                    text: "Đăng xuất"
                    Layout.fillWidth: true
                    onClicked: profileDialog.close()
                }
            }
        }
    }
}
