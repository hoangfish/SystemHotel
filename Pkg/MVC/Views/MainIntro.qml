import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: mainIntro
    objectName: "MainIntro"
    signal openLogin

    width: 900
    height: 720

    // ===== TASKBAR =====
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#ffffffcc"
        border.color: "#cccccc"
        anchors.top: parent.top
        z: 2

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Repeater {
                model: [
                    { label: "Tổng quan", target: overviewSection },
                    { label: "Vị trí", target: locationSection },
                    { label: "Phòng nghỉ", target: roomSection },
                    { label: "Dịch vụ", target: serviceSection }
                ]
                delegate: MouseArea {
                    Layout.fillWidth: true
                    height: parent.height
                    property color defaultColor: "#333333"
                    property color hoverColor: "#ff9900"
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: flickableContent.contentY = modelData.target.y
                    onEntered: navText.color = hoverColor
                    onExited: navText.color = defaultColor

                    Text {
                        id: navText
                        text: modelData.label
                        font.bold: true
                        font.pixelSize: 16
                        color: defaultColor
                        anchors.centerIn: parent
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Đăng nhập"
                font.bold: true
                background: Rectangle { color: "#FF5722"; radius: 6 }
                onClicked: openLogin()
            }
        }
    }

    // ===== SCROLLABLE CONTENT =====
    Flickable {
        id: flickableContent
        clip: true
        contentWidth: columnContent.width
        contentHeight: columnContent.height
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: columnContent
            width: mainIntro.width
            spacing: 32
            anchors.margins: 24

            // ẢNH BANNER
            Rectangle {
                width: parent.width
                height: 420
                Image {
                    anchors.fill: parent
                    source: "qrc:/Pkg/MVC/Views/images/banner_background.png"
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.4
                }
            }

            // NGĂN CÁCH GIỮA ẢNH VÀ NỘI DUNG
            Rectangle {
                width: parent.width
                height: 200
                color: "#eeeeee"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 6
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    // Tiêu đề - lớn, in đậm
                    Label {
                        text: "Mường Thanh Luxury TP.HCM"
                        font.family: "Helvetica"
                        font.pixelSize: 20
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Mô tả - nhỏ hơn, nhẹ nhàng hơn
                    Label {
                        text: "Mường Thanh nổi bật với phong cách thiết kế độc đáo, kết hợp hài hoà"
                        font.family: "Helvetica"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        maximumLineCount: 3
                    }
                    Label {
                        text: "giữa tính hiện đại và giá trị truyền thống Việt Nam, mang đến"
                        font.family: "Helvetica"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        maximumLineCount: 3
                    }
                    Label {
                        text: "trải nghiệm mới mẻ cho du khách."
                        font.family: "Helvetica"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        maximumLineCount: 3
                    }
                }
            }

            // LOBBY + THÔNG TIN
            RowLayout {
                Layout.fillWidth: true
                spacing: 24

                Rectangle {
                    width: 480
                    height: 260
                    color: "transparent"
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/Pkg/MVC/Views/images/lobby.png"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Label { text: "Mường Thanh Luxury Sài Gòn"; font.pixelSize: 26; font.bold: true }
                    Label { text: "Địa chỉ: 123 Nguyễn Văn Linh, Quận 7, TP.HCM"; wrapMode: Text.WordWrap }
                    Label { text: "Giá phòng từ: 1.200.000đ/đêm"; font.pixelSize: 18 }
                    Label { text: "Dịch vụ: Hồ bơi, Nhà hàng, Wifi miễn phí" }
                    Label { text: "Liên hệ: 028 1234 5678" }

                    Button {
                        text: "Đặt phòng"
                        width: 140
                        onClicked: openLogin()
                    }
                }
            }

            // 1. TỔNG QUAN - Ảnh bên phải, thông tin bên trái
            RowLayout {
                id: overviewSection
                Layout.fillWidth: true
                spacing: 24

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420

                    Label {
                        text: "1. TỔNG QUAN"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "-Không gian sang trọng, thiết kế hài hòa giữa hiện đại và truyền thống."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Phù hợp cho cả khách du lịch và công tác."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                    Label {
                        text: "-Vị trí thuận tiện cùng đa dạng các loại hình dịch vụ."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                Rectangle {
                    width: 400
                    height: 260
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Pkg/MVC/Views/images/outside_look.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }
            }

            // 2. VỊ TRÍ - Ảnh bên trái, thông tin bên phải
            RowLayout {
                id: locationSection
                Layout.fillWidth: true
                spacing: 24

                Rectangle {
                    width: 400
                    height: 260
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Pkg/MVC/Views/images/pool.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420

                    Label {
                        text: "2. VỊ TRÍ VÀ KẾT NỐI"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "-Nằm tại trung tâm Quận 7, dễ kết nối đến các trung tâm\n thương mại, sân bay và khu giải trí."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Tiết kiệm thời gian di chuyển, tận hưởng kỳ nghỉ trọn vẹn."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }
            }

            // 3. PHÒNG NGHỈ - Ảnh bên phải, thông tin bên trái
            RowLayout {
                id: roomSection
                Layout.fillWidth: true
                spacing: 24

                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420

                    Label {
                        text: "3. HỆ THỐNG PHÒNG NGHỈ"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "-Đa dạng loại phòng từ tiêu chuẩn đến cao cấp,\n phù hợp cả nhu cầu nghỉ dưỡng và công tác."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Phòng ốc trang bị tiện nghi hiện đại, thoáng đãng, tầm nhìn đẹp."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                ColumnLayout {
                    spacing: 12
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/room4.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/room9.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // 4. ẨM THỰC & NHÀ HÀNG
            RowLayout {
                id: foodSection
                Layout.fillWidth: true
                spacing: 24

                // 2 ảnh bên trái
                ColumnLayout {
                    spacing: 12
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/buffet.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/freshseafood.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }

                // Thông tin bên phải
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420

                    Label {
                        text: "4. ẨM THỰC & NHÀ HÀNG"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "-Thưởng thức buffet đa dạng món Á – Âu, nguyên liệu tươi ngon."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Đặc biệt các món hải sản tươi sống chế biến ngay tại quầy."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Không gian nhà hàng sang trọng, phục vụ tận tâm."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }
            }

            // 5. HOẠT ĐỘNG & GIẢI TRÍ
            RowLayout {
                id: activitySection
                Layout.fillWidth: true
                spacing: 24

                // Thông tin bên trái
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420

                    Label {
                        text: "5. HOẠT ĐỘNG & GIẢI TRÍ"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "-Phòng gym hiện đại, trang thiết bị tân tiến đầy đủ."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Quầy bar ngoài trời với các loại cocktail độc đáo."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "-Các hoạt động giải trí phù hợp cho mọi lứa tuổi."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                // 2 ảnh bên phải
                ColumnLayout {
                    spacing: 12
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/gym.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 400
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/outdoorbar.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // 6. DỊCH VỤ - giữ lại cấu trúc 2 ảnh trên 2 ảnh dưới, căn đều và gọn
            ColumnLayout {
                id: serviceSection
                spacing: 10

                Label {
                    text: "4. DỊCH VỤ TIỆN ÍCH"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Segoe UI"
                    color: "#333333"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "  -Hồ bơi, nhà hàng sang trọng, wifi miễn phí và dịch vụ spa cao cấp – tất cả nhằm mang đến trải nghiệm tốt nhất."
                    wrapMode: Text.WordWrap
                    font.pixelSize: 16
                    font.family: "Segoe UI"
                    color: "#444444"
                    width: 600
                    horizontalAlignment: Text.AlignHCenter
                }

                // Ảnh hàng trên
                RowLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        width: 300
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/pool.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 300
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/wifi.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }

                // Ảnh hàng dưới
                RowLayout {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        width: 300
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/restaurant.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 300
                        height: 180
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/spa.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // FOOTER
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