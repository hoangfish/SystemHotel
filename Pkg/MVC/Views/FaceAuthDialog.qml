import QtQuick 2.15
import QtQuick.Controls 2.15

Dialog {
    id: faceAuthDialog
    modal: true
    focus: true
    width: 960
    height: 640
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    closePolicy: Popup.NoAutoClose

    property string actionType: "" // "checkIn" hoặc "checkOut"
    property string bookingCode: ""
    property string roomId: ""

    // Các kết nối cần thiết
    Connections { target: AuthService }
    Connections { target: FaceCheckService }
    Connections { target: CamThreadService }

    // Reload camera khi có frame mới
    Connections {
        target: liveImageProvider
        function onImageChanged() { avatarImgProvider.reload() }
    }

    // Trigger check-in/check-out trực tiếp khi nhận diện thành công
    Connections {
        target: FaceCheckService
        function onLivenessScore(score) {
            livenessText.text = "Liveness: " + (score * 100).toFixed(1) + "%"
        }
        function onCosineScore(score, matched) {
            cosineText.text = "Face Check: " + (score * 100).toFixed(1) + "%"
            cosineText.color = matched ? "#2ecc71" : "#e74c3c"

            if (matched) {
                statusText.text = "Nhận diện thành công!"
                statusText.color = "green"

                if (actionType === "checkIn")
                    UserController.cancelBooking(bookingCode, roomId, "checkIn")
                else if (actionType === "checkOut")
                    UserController.cancelBooking(bookingCode, roomId, "checkOut")

                CamThreadService.stopConsumerByID(1)
                CamThreadService.stopProducer()
                successTimer.start()
            } else {
                statusText.text = "Không khớp khuôn mặt. Vui lòng thử lại..."
                statusText.color = "#e74c3c"
            }
        }
    }

    // ================== UI ==================
    Row {
        anchors.centerIn: parent
        spacing: 30

        // Bên trái: Camera + nút
        Column {
            spacing: 20
            width: 560

            Text {
                text: actionType === "checkIn" ? "XÁC THỰC CHECK-IN" : "XÁC THỰC CHECK-OUT"
                font.pixelSize: 28
                font.bold: true
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 560
                height: 420
                color: "black"
                radius: 12
                clip: true

                Image {
                    id: avatarImgProvider
                    property bool counter: false
                    anchors.fill: parent
                    source: "image://live/confacecheck"
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    asynchronous: false
                    function reload() {
                        counter = !counter
                        source = "image://live/confacecheck?id=" + counter
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Đang mở camera..."
                    color: "white"
                    font.pixelSize: 22
                    visible: avatarImgProvider.status !== Image.Ready
                }
            }

            Text {
                id: statusText
                text: "Vui lòng nhìn vào camera..."
                font.pixelSize: 22
                color: "#3498db"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: "Hủy bỏ"
                width: 200
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: faceAuthDialog.close()
            }
        }

        // Bên phải: Panel % realtime
        Column {
            width: 300
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                width: 300
                height: 420
                color: "#f8f9fa"
                radius: 12
                border.color: "#dee2e6"
                border.width: 2

                Column {
                    anchors.centerIn: parent
                    spacing: 50

                    Column {
                        spacing: 8
                        Text {
                            text: "Liveness"
                            font.pixelSize: 18
                            color: "#495057"
                        }
                        Text {
                            id: livenessText
                            text: "Liveness: 0.0%"
                            font.pixelSize: 24
                            font.bold: true
                            color: "#2ecc71"
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Face Check"
                            font.pixelSize: 18
                            color: "#495057"
                        }
                        Text {
                            id: cosineText
                            text: "Face Check: 0.0%"
                            font.pixelSize: 24
                            font.bold: true
                            color: "#e74c3c"
                        }
                    }
                }
            }
        }
    }

    onOpened: {
        statusText.text = "Đang khởi động camera..."
        statusText.color = "orange"
        CamThreadService.startProducer()
        CamThreadService.startConsumerByID(1)
        statusText.text = "Vui lòng nhìn vào camera..."
        statusText.color = "#3498db"
    }

    onClosed: {
        CamThreadService.stopConsumerByID(1)
        CamThreadService.stopProducer()
    }

    Timer {
        id: successTimer
        interval: 4000
        onTriggered: {
            faceAuthDialog.close()
            UserController.getBookingHistory()
        }
    }
}