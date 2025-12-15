import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Popup {
    id: popup
    width: 360; height: 720
    anchors.centerIn: parent
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {} // Transparent

    property var theme
    property color accentColor

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: accentColor
        border.width: 4; border.color: "white"

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 10

            Text { Layout.alignment: Qt.AlignHCenter; text: "ADD TIMER"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            // Toggle
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Rectangle { width: 100; height: 30; radius: 5; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "Pomodoro"; font.family: "Montserrat"; color: theme.idleColor; font.bold: true } }
                Text { text: "Custom"; color: "white"; font.family: "Montserrat"; font.bold: true; opacity: 0.7 }
            }

            // Fields
            ColumnLayout {
                spacing: 8; Layout.fillWidth: true
                property real lblW: 90
                RowLayout { Text { width: parent.lblW; text: "Name:"; color: "white"; font.bold: true } TextField { Layout.fillWidth: true; placeholderText: "Enter timer name"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }
                RowLayout { Text { width: parent.lblW; text: "Description:"; color: "white"; font.bold: true } TextField { Layout.fillWidth: true; placeholderText: "Enter description"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }
                RowLayout { Text { width: parent.lblW; text: "Ringtone:"; color: "white"; font.bold: true } TextField { Layout.fillWidth: true; placeholderText: "Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }
            }

            // Durations
            Text { text: "Time Settings"; color: "white"; font.family: "Montserrat"; font.pixelSize: 16; font.bold: true }

            GridLayout {
                columns: 2; columnSpacing: 10; rowSpacing: 10
                Layout.fillWidth: true

                Text { text: "Work Duration"; color: "white" }
                Rectangle { width: 120; height: 35; color: "white"; radius: 5; Row { anchors.centerIn: parent; spacing: 15; Text { text: "-"; font.pixelSize: 20 } Text { text: "25"; font.bold: true } Text { text: "+"; font.pixelSize: 20 } } }

                Text { text: "Short Break"; color: "white" }
                Rectangle { width: 120; height: 35; color: "white"; radius: 5; Row { anchors.centerIn: parent; spacing: 15; Text { text: "-"; font.pixelSize: 20 } Text { text: "5"; font.bold: true } Text { text: "+"; font.pixelSize: 20 } } }

                Text { text: "Long Break"; color: "white" }
                Rectangle { width: 120; height: 35; color: "white"; radius: 5; Row { anchors.centerIn: parent; spacing: 15; Text { text: "-"; font.pixelSize: 20 } Text { text: "15"; font.bold: true } Text { text: "+"; font.pixelSize: 20 } } }
            }

            // Save Buttons
            Item { Layout.fillHeight: true }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 40
                Text { text: "Cancel"; color: "white"; font.bold: true; MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                Rectangle { width: 120; height: 40; radius: 20; color: "#4CAF50"; Text { anchors.centerIn: parent; text: "Save Timer"; color: "white"; font.bold: true } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
            }
        }
    }
}
