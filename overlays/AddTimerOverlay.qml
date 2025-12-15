import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Popup {
    id: popup
    width: parent ? parent.width * 0.9 : 340
    height: 600 // Taller for content
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Transparent background for the popup itself so we can draw custom rounded rect
    background: Item {}

    property var theme

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: theme.idleColor
        border.width: 4
        border.color: "white"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Header
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ADD TIMER"
                font.family: "Montserrat"
                font.pixelSize: 28
                font.weight: Font.ExtraBold
                color: "white"
            }

            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            // Mode Toggle
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                Rectangle {
                    width: 100; height: 30; radius: 5; color: "white"
                    Text { anchors.centerIn: parent; text: "Pomodoro"; font.family: "Montserrat"; font.bold: true; color: theme.idleColor }
                }
                Text { text: "Custom"; font.family: "Montserrat"; font.bold: true; color: "white"; opacity: 0.7 }
            }

            // Inputs
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                // Helper for styled fields
                Component {
                    id: inputField
                    Rectangle {
                        Layout.fillWidth: true; height: 35; radius: 5; color: "#E9E9E9"
                        property alias text: txt.text
                        property string placeholder: ""
                        TextInput {
                            id: txt; anchors.fill: parent; anchors.leftMargin: 10; verticalAlignment: TextInput.AlignVCenter
                            font.family: "Montserrat"; text: placeholder; color: "#4A4A4A"; clip: true
                        }
                    }
                }

                RowLayout {
                    Text { text: "Name:"; color: "white"; font.family: "Montserrat"; font.bold: true; Layout.preferredWidth: 80 }
                    Loader { sourceComponent: inputField; property string placeholder: "Enter timer name"; Layout.fillWidth: true }
                }
                RowLayout {
                    Text { text: "Desc:"; color: "white"; font.family: "Montserrat"; font.bold: true; Layout.preferredWidth: 80 }
                    Loader { sourceComponent: inputField; property string placeholder: "Enter description"; Layout.fillWidth: true }
                }
                RowLayout {
                    Text { text: "Sound:"; color: "white"; font.family: "Montserrat"; font.bold: true; Layout.preferredWidth: 80 }
                    Loader { sourceComponent: inputField; property string placeholder: "Ringtone"; Layout.fillWidth: true }
                }
            }

            // Cycle Format Presets
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Cycle Format:"; color: "white"; font.family: "Montserrat"; font.bold: true }
                Item { Layout.fillWidth: true }
                Rectangle { width: 80; height: 25; color: theme.idleColor; border.color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Standard"; color: "white" } }
                Rectangle { width: 80; height: 25; color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Presets"; color: theme.idleColor; font.bold: true } }
            }

            // Duration Pickers (Big Numbers)
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 5
                // Tab Switcher
                Rectangle { width: 60; height: 25; color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Work"; color: theme.idleColor; font.bold: true } }
                Text { text: "Break"; color: "white"; font.bold: true; opacity: 0.7 }
                Text { text: "Long Break"; color: "white"; font.bold: true; opacity: 0.7 }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                // Hours
                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "00"; font.pixelSize: 40; font.family: "Montserrat" }
                }
                // Minutes
                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "25"; font.pixelSize: 40; font.family: "Montserrat" }
                }
                // Seconds
                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "00"; font.pixelSize: 40; font.family: "Montserrat" }
                }
            }

            // Buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                spacing: 30

                // Cancel (X)
                Rectangle {
                    width: 50; height: 50; radius: 25; color: "#E9E9E9"
                    Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#797979" }
                    MouseArea { anchors.fill: parent; onClicked: popup.close() }
                }

                // Confirm (Check)
                Rectangle {
                    width: 50; height: 50; radius: 25; color: "#E9E9E9"
                    Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 24; color: theme.idleColor; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: popup.close() }
                }
            }
        }
    }
}
