import QtQuick 2.0
import QtQuick.Controls 2.1

import "../Utils/constants.js" as Constants

Item {
    property string q_username: "18520651"
    property string q_password: "18520651"

    Connections {
        target: AuthService
    }

    Rectangle {
        id: div_main
        x: 0
        y: 0
        width: Constants.WIDTH
        height: Constants.HEIGHT
        color: "#ffffff"

        Text {
            id: label_Title_app
            x: 397
            y: 109
            width: 230
            height: 60
            color: "#1e88e5"
            text: qsTr("Virtual Class - Teacher APP")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 48
        }

        Rectangle {
            id: div_username
            x: 133
            y: 222
            width: 348
            height: 40
            color: "#ffffff"
            radius: 5
            border.color: "#1e88e5"

            TextEdit {
                id: txtUsername
                x: 8
                y: 0
                width: 340
                height: 40
                text: qsTr("18520651")
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
            }
        }

        Rectangle {
            id: div_password
            x: 133
            y: 300
            width: 348
            height: 40
            color: "#ffffff"
            radius: 5
            border.color: "#1e88e5"
            TextInput {
                id: txtPassword
                x: 8
                y: 0
                width: 340
                height: 40
                text: qsTr("18520651")
                echoMode: TextInput.Password
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            id: btnRegister
            x: 364
            y: 368
            text: qsTr("Register")
            onClicked: {
                main_stackview.push("qrc:/Pkg/Views/Pages/RegisterView.qml")
                // console.log("Register is clicked")
            }
        }

        Button {
            id: btnLogin
            x: 176
            y: 368
            text: qsTr("Login")
            onClicked: {
                q_username = txtUsername.text
                q_password = txtPassword.text
                if(AuthService.loginToServer({  "username": q_username,
                                                 "password": q_password,
                                             })){
                    // go to dashboard
                    UserService.getUserInfo();
                    CamThreadService.stopConsumerByID(1);
                    CamThreadService.stopProducer();
                    mainSV.replace("qrc:/Pkg/Views/Pages/Dashboard.qml")
                }else{
                    NotiController.emitNoti("Please check your username or password or schedule again");
                }
            }
        }

        Connections {
            target: FaceCheckService
        }

        Image {
            property bool counter: false
            id: avatarImgProvider
            x: 621
            y: 195
            width: 224
            height: 224
            source: "image://live/image"
            fillMode: Image.PreserveAspectFit
//            visible: false
            asynchronous: false
            cache: false
            function reload() {
                counter = !counter
                source = "image://live/confacecheck?id=" + counter
            }
        }

        Connections {
            target: UserService
        }

        Connections {
            target: CamThreadService
        }

        Connections {
            target: NotiController
        }

        Connections {
                target: liveImageProvider

                onImageChanged: {
                    avatarImgProvider.reload()
                }
        }

        Connections {
            target: VideoStreamer

            onLoginSuccess: {
                CamThreadService.stopConsumerByID(1);
                CamThreadService.stopProducer();
                UserService.getUserInfo();
                mainSV.replace("qrc:/Pkg/Views/Pages/Dashboard.qml")
            }
        }

        Component.onCompleted: {
            CamThreadService.startConsumerByID(1);
        }
    }
}