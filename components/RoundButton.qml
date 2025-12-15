import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    // Default size, but allows overriding (e.g. width: 50 for FAB)
    implicitWidth: 60
    implicitHeight: width + 25

    property string icon: "play_arrow"
    property string text: "Start"
    property color color: "#709775"       // Background Color
    property color iconColor: "white"     // Icon Color (Default white)

    signal clicked()

    // The Button Circle
    Rectangle {
        id: buttonBg
        width: root.width
        height: root.width // Keep it circular
        radius: width / 2
        color: root.color
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        // Shadow
        layer.enabled: true
        Material.elevation: 6

        // Icon with Color Support
        ColoredIcon {
            anchors.centerIn: parent
            source: "../assets/icons/" + root.icon + ".svg"
            width: parent.width * 0.4
            height: parent.height * 0.4
            color: root.iconColor
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: root.clicked()
            onPressed: {
                if (root.text !== "") { // Only animate if text exists
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
        color: root.color // Text matches button background color usually

        anchors.horizontalCenter: parent.horizontalCenter
        y: buttonBg.height / 2 // Hidden start pos
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
