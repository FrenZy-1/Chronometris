import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    width: 60
    height: 85

    property string icon: "play_arrow"
    property string text: "Start"
    property color color: "#709775"
    signal clicked()

    // The Button Circle
    Rectangle {
        id: buttonBg
        width: 60
        height: 60
        radius: 30
        color: root.color
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        // THIS FIXES THE ERROR: Use Material elevation instead of DropShadow
        layer.enabled: true
        layer.effect: null // Clear any previous effects
        Material.elevation: 6

        Image {
            anchors.centerIn: parent
            source: "../assets/icons/" + root.icon + ".svg"
            width: 24
            height: 24
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: root.clicked()
            onPressed: {
                label.opacity = 1
                label.y = 65
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
        font.weight: Font.Bold // Bold as requested
        color: root.color      // Matches button color (e.g., Sage Green)

        anchors.horizontalCenter: parent.horizontalCenter
        y: 45; opacity: 0; z: -1

        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: { label.opacity = 0; label.y = 45 }
    }
}
