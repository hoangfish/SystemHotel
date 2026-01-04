import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root
    objectName: "Places"  // Đổi objectName để handling ở main.qml
    property StackView stackViewRef

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"
    }

    // == DỮ LIỆU PLACES ==
    ListModel {
        id: placesModel
    }

    Component.onCompleted: {
        PlacesController.getNearbyPlaces();
    }

    Connections {
        target: PlacesController
        function onPlacesFetched(places) {
            console.log("Places fetched, length: " + places.length);
            placesModel.clear();
            for (var i = 0; i < places.length; i++) {
                placesModel.append(places[i]);
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 0

        /* ================= HEADER (THAY ĐỔI: Thêm click handlers) ================= */
        Rectangle {
            id: header
            width: parent.width
            height: 60
            color: "#d32f2f"
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                Row {
                    spacing: 40
                    Layout.alignment: Qt.AlignVCenter
                    Text {
                        text: "Room"
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                stackViewRef.replace("qrc:/Pkg/MVC/Views/Booking.qml", {stackViewRef: stackViewRef});
                            }
                        }
                    }
                    Text {
                        text: "Others"
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // Ở Others rồi, không làm gì hoặc reload
                                console.log("Already in Others");
                                PlacesController.getNearbyPlaces();  // Reload nếu cần
                            }
                        }
                    }
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: "Muong Thanh Luxury HCM"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                }
                // Avatar giống hệt Booking.qml (nếu cần dùng sau này)
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
                        text: "NA" // Placeholder, có thể thay bằng UserController sau
                        color: "#880e4f"
                        font.bold: true
                        font.pixelSize: 14
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        // onClicked: profileDialog.open() // Có thể thêm dialog sau
                    }
                }
            }
        }

        /* ================= CONTENT ================= */
        Flickable {
            width: parent.width
            height: parent.height - header.height
            contentWidth: width
            contentHeight: contentCol.height
            clip: true
            Column {
                id: contentCol
                width: parent.width
                spacing: 30
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 40
                leftPadding: 40
                rightPadding: 40
                Text {
                    text: "Nearby Places"
                    font.pixelSize: 40
                    font.bold: true
                    color: "#333"
                }
                /* ================= CARD TEMPLATE (THAY HARDCODE BẰNG DYNAMIC) ================= */
                Repeater {
                    model: placesModel
                    Rectangle {
                        width: parent.width - 80
                        height: 180
                        radius: 12
                        color: "#ffffff"
                        border.color: "#e8e2e2"
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 20
                            /* ===== IMAGE ===== */
                            Rectangle {
                                width: 140
                                height: 140
                                radius: 8
                                clip: true
                                color: "#f0f0f0"
                                Image {
                                    anchors.fill: parent
                                    source: img  // Từ API
                                    fillMode: Image.PreserveAspectCrop
                                }
                            }
                            /* ===== TEXT ===== */
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Text {
                                    text: name  // Từ API
                                    font.pixelSize: 24
                                    font.bold: true
                                    color: "#333"
                                }
                                Text {
                                    text: desc || "No description available"  // Nếu API có desc, иначе default
                                    font.pixelSize: 16
                                    color: "#555"
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: addr  // Từ API
                                    font.pixelSize: 15
                                    color: "#777"
                                }
                                Text {
                                    text: dist + " từ khách sạn"  // Từ API (tính approx)
                                    font.pixelSize: 14
                                    color: "#999"
                                }
                            }
                            /* ===== BUTTON - GIỐNG HỆT BOOKING.QML ===== */
                            Button {
                                text: "SELECT"
                                width: 100
                                height: 36
                                enabled: true
                                background: Rectangle {
                                    color: "#7f2f2f"
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    // onClicked: xử lý sau khi có backend (ví dụ open map)
                                }
                            }
                        }
                    }
                }
                Item { height: 60 } // Khoảng trống cuối
            }
        }
    }
}