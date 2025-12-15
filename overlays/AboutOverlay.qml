import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: popup
    width: 320
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
        border.color: "white" // Thick outer border

        // Thin inner border
        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            color: "transparent"
            border.color: "white"
            border.width: 1
            radius: 14
        }
    }

    contentItem: ColumnLayout {
        spacing: 10

        // Logo
        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 35
            source: "../assets/logo/Logo.png" // Using your uploaded logo
            width: 80
            height: 80
            fillMode: Image.PreserveAspectFit
        }

        // Text Content
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            Text {
                text: "ABOUT:"
                font.family: "Montserrat"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "CHRONOMÉTRIS"
                font.family: "Montserrat"
                font.pixelSize: 28
                font.weight: Font.ExtraBold
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "VERSION: 1.1"
                font.family: "Montserrat"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Gear Icon Decoration (Flower shape)
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            width: 50; height: 50
            radius: 25
            color: "#E9E9E9" // Light gray/white

            // Flower edge effect (simulated with border or clip)
            // Using a simple gear character for now to keep it native
            Text {
                anchors.centerIn: parent
                text: "⚙"
                font.pixelSize: 28
                color: theme.idleColor
            }
        }

        Item { Layout.fillHeight: true } // Spacer

        // Bottom Settings Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.bottomMargin: 20
            height: 45
            color: "transparent"
            border.color: "white"
            border.width: 2
            radius: 8

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // 12 Hours (Active)
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: theme.idleColor; radius: 6
                    Text { anchors.centerIn: parent; text: "12 Hours"; color: "white"; font.family: "Montserrat"; font.bold: true; font.pixelSize: 12 }
                }

                Rectangle { width: 1; height: 30; color: "white" }

                // 24 Hours
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: "transparent"
                    Text { anchors.centerIn: parent; text: "24 Hours"; color: "white"; font.family: "Montserrat"; font.bold: true; font.pixelSize: 12; opacity: 0.7 }
                }

                Rectangle { width: 1; height: 30; color: "white" }

                // Light
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: "transparent"
                    Text { anchors.centerIn: parent; text: "Light"; color: "white"; font.family: "Montserrat"; font.bold: true; font.pixelSize: 12; opacity: 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = false }
                }

                Rectangle { width: 1; height: 30; color: "white" }

                // Dark
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: "#E9E9E9"; radius: 6
                    Text { anchors.centerIn: parent; text: "Dark"; color: theme.idleColor; font.family: "Montserrat"; font.bold: true; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = true }
                }
            }
        }
    }
}
