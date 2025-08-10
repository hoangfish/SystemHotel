import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
//import QUANLYKHACHSAN 1.0

Item {
    id: root
    width: 1280
    height: 800
    objectName: "Booking"
    signal continueBooking()
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

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

    // ========== HEADER ==========
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#d32f2f"
        z: 1

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
                    text: UserModel.firstName && UserModel.lastName ? 
                          UserModel.firstName[0].toUpperCase() + UserModel.lastName[0].toUpperCase() : "NA"
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

    // ========== TITLE ==========
    Rectangle {
        id: titleBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "transparent"
        z: 1

        Text {
            anchors.centerIn: parent
            text: "Chọn phòng"
            font.pixelSize: 28
            font.bold: true
            color: "#333"
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 6
            color: "#f5ecec"
        }
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: 4
            width: parent.width * 0.35
            anchors.margins: 0
            color: "#b45b5b"
        }
    }

    // ========== Booking summary ==========
    Rectangle {
        id: bookingSummary
        width: 320
        height: 280
        radius: 8
        color: "#fafafa"
        border.color: "#ddd"
        border.width: 1
        z: 3

        anchors.top: titleBar.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 24

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "transparent"
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
                height: 36
                color: "#fff3f3"
                Text {
                    anchors.centerIn: parent
                    text: "1 đêm"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333"
                }
            }

            Item { Layout.preferredHeight: 0 }

            ColumnLayout {
                spacing: 2
                RowLayout {
                    spacing: 8
                    Text { text: "9"; font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng 8"; font.pixelSize: 14; color: "#333" }
                    Text { text: "—"; font.pixelSize: 20; color: "#333" }
                    Text { text: "10"; font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng 8"; font.pixelSize: 14; color: "#333" }
                }
                RowLayout {
                    spacing: 12
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Thứ Bảy"; font.pixelSize: 12; color: "#555" }
                        Text { text: "từ lúc 13:00"; font.pixelSize: 12; color: "#555" }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Chủ Nhật"; font.pixelSize: 12; color: "#555" }
                        Text { text: "đến 12:30"; font.pixelSize: 12; color: "#555" }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "#fff3f3"
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: "Phòng:"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#333"
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        text: "Muong Thanh Family Room"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#7f2f2f"
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "transparent"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4

                    Text {
                        text: "2.632.500 ₫"
                        font.pixelSize: 24
                        font.bold: true
                        color: "#7f2f2f"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        text: "Tiếp tục  >"
                        font.pixelSize: 22
                        background: Rectangle {
                            color: "#7f2f2f"
                            radius: 4
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        onClicked: {
                            root.continueBooking()
                        }
                    }
                }
            }
        }
    }

    // ========== MAIN SCROLL ==========
    ScrollView {
        id: mainScroll
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 12
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        clip: true
        z: 0

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            anchors.right: parent.right
        }

        Column {
            id: mainContent
            width: mainScroll.width
            spacing: 24
            anchors.topMargin: 8

            Row {
                id: contentRow
                width: mainContent.width
                spacing: 0

                Column {
                    id: leftColumn
                    width: mainScroll.width - bookingSummary.width - 48
                    spacing: 20

                    Rectangle {
                        width: leftColumn.width
                        height: 60
                        color: "#fffaf0"
                        radius: 8
                        border.color: "#ccc"
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Layout.alignment: Qt.AlignVCenter
                            ComboBox {
                                id: roomTypeFilter
                                Layout.preferredWidth: 166
                                Layout.preferredHeight: 35
                                model: ["Tùy chọn phòng", "Phòng đơn", "Phòng đôi"]
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ComboBox {
                                id: viewFilter
                                Layout.preferredWidth: 160
                                Layout.preferredHeight: 35
                                model: ["View cửa sổ", "View thành phố", "View biển"]
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Item { Layout.fillWidth: true }
                        }
                    }

                    Repeater {
                        model: roomModel
                        delegate: Rectangle {
                            width: leftColumn.width
                            height: 220
                            radius: 12
                            color: "#fff"
                            border.color: "#e8e2e2"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16

                                Rectangle {
                                    Layout.preferredWidth: leftColumn.width * 0.32
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

                    Rectangle { width: leftColumn.width; height: 16; color: "transparent" }
                }

                Item {
                    width: bookingSummary.width + 48
                }
            }

            Rectangle {
                id: footer
                width: mainContent.width
                height: 220
                color: "#001f3f"
                radius: 0
                border.width: 0
                anchors.horizontalCenter: mainContent.horizontalCenter

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

    // ========== PROFILE DIALOG ==========
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
                    text: UserModel.firstName && UserModel.lastName ? 
                          UserModel.firstName + " " + UserModel.lastName : "Guest"
                    font.bold: true
                    font.pixelSize: 16
                }

                Text {
                    text: UserModel.firstName ? "+84915895157" : "No phone"
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
                    onClicked: {
                        UserController.logoutUser();
                    }
                }
            }
        }
    }

    Connections {
        target: UserController
        function onLogoutSuccess() {
            profileDialog.close();
            stackView.replace("Login.qml");
        }
        function onLogoutFailed(errorMsg) {
            console.log("Logout failed: " + errorMsg);
        }
    }
}