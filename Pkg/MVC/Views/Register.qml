import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: registerPage
    objectName: "Register"
    width: 1280
    height: 720

    Component.onCompleted: {
        Qt.callLater(() => {
            console.log("Register.qml: Starting camera preview only")
            UserController.setIsLoginMode(false)  // Quan trọng: Tắt mode nhận diện → không gọi face login
            CamThreadService.startConsumerByID(0)
            CamThreadService.startConsumerByID(1)
        })
    }

    onVisibleChanged: {
        if (!visible) {
            console.log("Register.qml: Stopping camera")
            UserController.setIsLoginMode(false)
            CamThreadService.stopConsumerByID(0)
            CamThreadService.stopConsumerByID(1)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"
    }

    Image {
        anchors.fill: parent
        source: "qrc:/Pkg/MVC/Views/images/outside_look.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.2
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 40

        // === BÊN TRÁI: CAMERA PREVIEW ===
        Column {
            spacing: 20
            width: 560

            Text {
                text: "ĐĂNG KÝ TÀI KHOẢN"
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
                    anchors.fill: parent
                    source: "image://live/ui"
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    asynchronous: false
                    property bool counter: false
                    function reload() {
                        counter = !counter
                        source = "image://live/ui?id=" + counter
                    }

                    Connections {
                        target: liveImageProvider
                        function onImageChanged() { avatarImgProvider.reload() }
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
                text: "Vui lòng nhìn vào camera để chuẩn bị khuôn mặt"
                font.pixelSize: 20
                color: "#3498db"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // === BÊN PHẢI: FORM ĐĂNG KÝ ===
        Rectangle {
            width: 460
            height: 520
            radius: 16
            color: "white"
            border.color: "#cccccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Đăng ký"
                        font.pixelSize: 22
                        font.bold: true
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "✕"
                        color: "#b71c1c"
                        font.pixelSize: 24
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.pop()  // Quay về MainIntro
                        }
                    }
                }

                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    TextField { id: firstNameInput; placeholderText: "Tên"; Layout.fillWidth: true; font.pixelSize: 16 }
                    TextField { id: lastNameInput; placeholderText: "Họ"; Layout.fillWidth: true; font.pixelSize: 16 }
                }

                TextField { id: phoneInput; placeholderText: "Số điện thoại"; Layout.fillWidth: true; font.pixelSize: 16 }
                TextField { id: emailInput; placeholderText: "Email"; Layout.fillWidth: true; font.pixelSize: 16 }
                TextField { id: passwordInput; placeholderText: "Mật khẩu"; echoMode: TextInput.Password; Layout.fillWidth: true; font.pixelSize: 16 }

                Button {
                    text: "Đăng ký"
                    Layout.fillWidth: true
                    height: 50
                    background: Rectangle { color: "#b71c1c"; radius: 8 }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        if (firstNameInput.text === "" || lastNameInput.text === "" ||
                            phoneInput.text === "" || emailInput.text === "" || passwordInput.text === "") {
                            notifyDialog.title = "Lỗi"
                            notifyDialog.message = "Vui lòng nhập đầy đủ thông tin!"
                            notifyDialog.open()
                        } else {
                            notifyDialog.title = "Thành công"
                            notifyDialog.message = "Đăng ký thành công với DeviceId: 123"
                            notifyDialog.open()
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#cccccc" }

                Text {
                    text: "© Hotel Management Team - OOP 2025"
                    font.pixelSize: 12
                    opacity: 0.6
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // === DIALOG THÔNG BÁO ===
    Dialog {
        id: notifyDialog
        modal: true
        focus: true
        property string message: ""
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 400

        contentItem: Rectangle {
            color: "#ffffff"
            radius: 12
            border.color: "#cccccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                Text {
                    text: notifyDialog.title
                    font.pixelSize: 20
                    font.bold: true
                    color: notifyDialog.title === "Thành công" ? "#2e7d32" : "#c62828"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: notifyDialog.message
                    font.pixelSize: 16
                    color: "#333333"
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Button {
                    text: "OK"
                    Layout.alignment: Qt.AlignHCenter
                    background: Rectangle {
                        color: notifyDialog.title === "Thành công" ? "#4caf50" : "#f44336"
                        radius: 8
                    }
                    contentItem: Text { text: parent.text; color: "white"; font.bold: true }
                    onClicked: notifyDialog.close()
                }
            }
        }
    }
}