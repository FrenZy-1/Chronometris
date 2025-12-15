import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Popup {
    id: popup
    width: parent ? parent.width * 0.9 : 340
    height: 550
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

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ADD ALARM"
                font.family: "Montserrat"
                font.pixelSize: 28
                font.weight: Font.ExtraBold
                color: "white"
            }

            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            // Inputs
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

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
                    Loader { sourceComponent: inputField; property string placeholder: "Alarm name"; Layout.fillWidth: true }
                }
                RowLayout {
                    Text { text: "Desc:"; color: "white"; font.family: "Montserrat"; font.bold: true; Layout.preferredWidth: 80 }
                    Loader { sourceComponent: inputField; property string placeholder: "Description"; Layout.fillWidth: true }
                }
            }

            // Big Time Picker
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                spacing: 10

                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "AM"; font.pixelSize: 30; font.family: "Montserrat" }
                }
                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "07"; font.pixelSize: 40; font.family: "Montserrat" }
                }
                Rectangle {
                    width: 70; height: 80; radius: 8; color: "#D9D9D9"
                    Text { anchors.centerIn: parent; text: "30"; font.pixelSize: 40; font.family: "Montserrat" }
                }
            }

            // Days of Week
            ColumnLayout {
                spacing: 5
                Layout.fillWidth: true

                RowLayout {
                    Text { text: "Repeat?"; color: "white"; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Rectangle { width: 60; height: 25; color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Daily"; color: theme.idleColor; font.bold: true } }
                    Text { text: "Custom"; color: "white"; font.bold: true; opacity: 0.7 }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8
                    Repeater {
                        model: ["M", "T", "W", "T", "F", "S", "S"]
                        Rectangle {
                            width: 30; height: 30; radius: 5
                            color: index < 5 ? "#E9E9E9" : theme.idleColor // Weekdays active
                            border.color: "white"; border.width: index < 5 ? 0 : 1
                            Text {
                                anchors.centerIn: parent; text: modelData;
                                color: index < 5 ? theme.idleColor : "white"; font.bold: true
                            }
                        }
                    }
                }
            }

            // Confirm Buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                spacing: 30

                Rectangle {
                    width: 50; height: 50; radius: 25; color: "#E9E9E9"
                    Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#797979" }
                    MouseArea { anchors.fill: parent; onClicked: popup.close() }
                }
                Rectangle {
                    width: 50; height: 50; radius: 25; color: "#E9E9E9"
                    Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 24; color: theme.idleColor; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: popup.close() }
                }
            }
        }
    }
}
