import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    implicitWidth: 60
    implicitHeight: width + (text !== "" ? 25 : 0) // Adjust height if label exists

    property string icon: "play_arrow"
    property string text: "Start"
    property color color: "#709775"
    property color iconColor: "white"

    signal clicked()

    // The Button Circle
    Rectangle {
        id: buttonBg
        width: root.width
        height: root.width
        radius: width / 2
        color: root.color
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        layer.enabled: true
        Material.elevation: 6

        // FIXED SIZE: Increased to 50% of button size
        ColoredIcon {
            anchors.centerIn: parent
            source: "../assets/icons/" + root.icon + ".svg"
            width: parent.width * 0.8
            height: parent.height * 0.8
            color: root.iconColor
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: root.clicked()
            onPressed: {
                if (root.text !== "") {
                    label.opacity = 1
                    label.y = buttonBg.height + 5
                }
            }
            onReleased: hideTimer.restart()
        }
    }

    // Floating Label
    Text {
        id: label
        text: root.text
        font.family: "Montserrat"
        font.pixelSize: 12
        font.weight: Font.Bold
        color: root.color

        anchors.horizontalCenter: parent.horizontalCenter
        y: buttonBg.height / 2
        opacity: 0; z: -1

        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: { label.opacity = 0; label.y = buttonBg.height / 2 }
    }
}
