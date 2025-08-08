import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property var images: []
    property real slideWidth: width
    property real slideHeight: height

    implicitWidth: 300
    implicitHeight: 200

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    Flickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top   // ✅ thêm dòng này
        height: slideHeight       // ✅ đảm bảo chiều cao cố định

        contentWidth: slideWidth * images.length
        contentHeight: slideHeight
        interactive: false
        clip: true

        Row {
            width: contentWidth
            height: flick.height

            Repeater {
                model: images.length
                delegate: Image {
                    source: images[index]
                    fillMode: Image.PreserveAspectCrop
                    width: slideWidth
                    height: slideHeight
                }
            }
        }

        Timer {
            interval: 3000
            running: true
            repeat: true
            onTriggered: {
                var nextX = flick.contentX + slideWidth
                flick.contentX = (nextX >= flick.contentWidth) ? 0 : nextX
            }
        }
    }
}
