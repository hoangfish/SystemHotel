import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: loginPage
    objectName: "Login"
    width: 1280
    height: 720

    signal loginSuccess()

    property bool isEmailMode: true

    Component.onCompleted: {
        Qt.callLater(() => loginPage.width += 1)
        Qt.callLater(() => loginPage.width -= 1)
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

    // === LOGIN FORM ===
    Rectangle {
        id: loginForm
        visible: true
        width: 420
        height: 480
        radius: 16
        color: "white"
        anchors.centerIn: parent
        border.color: "#cccccc"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            Text {
                text: "Đăng nhập tài khoản cá nhân"
                font.pixelSize: 22
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    color: isEmailMode ? "#fce8e6" : "white"
                    border.color: "#b71c1c"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Email"
                        color: "#b71c1c"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: isEmailMode = true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    color: !isEmailMode ? "#fce8e6" : "white"
                    border.color: "#b71c1c"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Số điện thoại"
                        color: "#b71c1c"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: isEmailMode = false
                    }
                }
            }

            TextField {
                id: usernameInput
                placeholderText: isEmailMode ? "Email" : "Số điện thoại"
                Layout.fillWidth: true
                font.pixelSize: 16
            }

            TextField {
                id: passwordInput
                placeholderText: "Mật khẩu"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                font.pixelSize: 16
            }

            Button {
                text: "Đăng nhập"
                Layout.fillWidth: true
                height: 40
                font.pixelSize: 16
                background: Rectangle {
                    color: "#b71c1c"
                    radius: 8
                }
                contentItem: Text {
                    text: "Đăng nhập"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }
                onClicked: {
                    console.log("Logging in with:", usernameInput.text, passwordInput.text)
                    loginSuccess()
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Đăng ký"
                    color: "#b71c1c"
                    font.pixelSize: 14
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            loginForm.visible = false
                            registerForm.visible = true
                        }
                    }
                }

                Item { Layout.fillWidth: true }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#cccccc"
            }

            Text {
                text: "© Hotel Management Team - OOP 2025"
                font.pixelSize: 12
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // === REGISTER FORM ===
    Rectangle {
        id: registerForm
        visible: false
        width: 460
        height: 520
        radius: 16
        color: "white"
        anchors.centerIn: parent
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
                    Layout.alignment: Qt.AlignLeft
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "✕"
                    color: "#b71c1c"
                    font.pixelSize: 24
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            registerForm.visible = false
                            loginForm.visible = true
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                TextField {
                    placeholderText: "Tên"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                TextField {
                    placeholderText: "Họ"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }
            }

            TextField {
                placeholderText: "Số điện thoại"
                Layout.fillWidth: true
                font.pixelSize: 16
            }

            TextField {
                placeholderText: "Email"
                Layout.fillWidth: true
                font.pixelSize: 16
            }

            TextField {
                placeholderText: "Mật khẩu"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                font.pixelSize: 16
            }

            Button {
                text: "Đăng ký"
                Layout.fillWidth: true
                height: 40
                background: Rectangle {
                    color: "#b71c1c"
                    radius: 8
                }
                contentItem: Text {
                    text: "Đăng ký"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }
                onClicked: {
                    console.log("Register button clicked")
                    loginSuccess()  // 👉 Gọi signal này để main.qml chuyển sang Booking.qml
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#cccccc"
            }

            Text {
                text: "© Hotel Management Team - OOP 2025"
                font.pixelSize: 12
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
