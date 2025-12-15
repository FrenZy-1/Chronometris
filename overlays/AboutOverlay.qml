import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: popup
    width: 300
    height: 380
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var theme

    background: Rectangle {
        radius: 20
        color: theme.idleColor
        border.width: 5
        border.color: "white"

        Rectangle {
            anchors.fill: parent; anchors.margins: 8
            color: "transparent"
            border.color: "white"; border.width: 1; radius: 14
        }
    }

    contentItem: ColumnLayout {
        spacing: 10

        // Logo - Reduced Size
        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            source: "../assets/logo/Logo.png"
            sourceSize: Qt.size(60, 60)
            width: 60; height: 60
            fillMode: Image.PreserveAspectFit
        }

        // Text Content
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Text {
                text: "ABOUT:"
                font.family: "Montserrat"; font.pixelSize: 12; font.weight: Font.Bold
                color: "#FFFFFF" // Explicit White
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "CHRONOMÉTRIS"
                font.family: "Montserrat"; font.pixelSize: 24; font.weight: Font.ExtraBold
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "VERSION: 1.1"
                font.family: "Montserrat"; font.pixelSize: 12; font.weight: Font.Bold
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Gear Icon (Simplified)
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            text: "⚙"
            font.pixelSize: 30
            color: "#E9E9E9"
        }

        Item { Layout.fillHeight: true }

        // Bottom Settings Bar
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 20; Layout.bottomMargin: 20
            height: 40
            color: "transparent"; border.color: "white"; border.width: 2; radius: 8

            RowLayout {
                anchors.fill: parent; spacing: 0
                Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: theme.idleColor; radius: 6
                    Text { anchors.centerIn: parent; text: "12 Hours"; color: "white"; font.family: "Montserrat"; font.bold: true; font.pixelSize: 11 }
                }
                Rectangle { width: 1; height: 25; color: "white" }
                Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "transparent"
                    Text { anchors.centerIn: parent; text: "24 Hours"; color: "white"; font.bold: true; font.pixelSize: 11; opacity: 0.7 }
                }
                Rectangle { width: 1; height: 25; color: "white" }
                Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "transparent"
                    Text { anchors.centerIn: parent; text: "Light"; color: "white"; font.bold: true; font.pixelSize: 11; opacity: 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = false }
                }
                Rectangle { width: 1; height: 25; color: "white" }
                Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#E9E9E9"; radius: 6
                    Text { anchors.centerIn: parent; text: "Dark"; color: theme.idleColor; font.bold: true; font.pixelSize: 11 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = true }
                }
            }
        }
    }
}
