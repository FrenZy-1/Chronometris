import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Popup {
    id: popup
    width: parent ? parent.width * 0.85 : 320
    height: 350
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {}

    property var theme

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: theme.idleColor
        border.width: 4
        border.color: "white"

        // Inner Border Line styling
        Rectangle {
            anchors.fill: parent
            anchors.margins: 10
            color: "transparent"
            border.color: "white"
            border.width: 2
            radius: 15
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 10

            // Header
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: theme.idleColor // blends in
                Text {
                    anchors.centerIn: parent
                    text: "DETAILS"
                    font.family: "Montserrat"
                    font.pixelSize: 28
                    font.weight: Font.ExtraBold
                    color: "white"
                }
            }

            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            Item { Layout.fillHeight: true } // Spacer

            // Content
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ALARM NAME"
                font.family: "Montserrat"
                font.pixelSize: 22
                font.weight: Font.Bold
                color: "white"
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ALARM DESCRIPTION"
                font.family: "Montserrat"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "white"
                opacity: 0.9
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "RINGTONE"
                font.family: "Montserrat"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "white"
                opacity: 0.9
            }

            Item { Layout.fillHeight: true } // Spacer

            // Buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Rectangle {
                    width: 100; height: 40; radius: 5; color: "#E9E9E9"
                    Row {
                        anchors.centerIn: parent; spacing: 5
                        Text { text: "Edit"; font.family: "Montserrat"; font.bold: true; color: theme.idleColor; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "✎"; color: theme.idleColor; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                }

                Rectangle {
                    width: 100; height: 40; radius: 5; color: "#E9E9E9"
                    Row {
                        anchors.centerIn: parent; spacing: 5
                        Text { text: "Delete"; font.family: "Montserrat"; font.bold: true; color: theme.idleColor; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "✎"; color: theme.idleColor; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                }
            }

            Item { Layout.fillHeight: true } // Spacer
        }
    }
}
