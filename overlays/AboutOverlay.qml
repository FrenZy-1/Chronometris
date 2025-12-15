import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: popup
    width: 300; height: 380
    anchors.centerIn: parent
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var theme
    property color accentColor

    background: Rectangle {
        radius: 20
        color: accentColor
        border.width: 5; border.color: "white"
        Rectangle { anchors.fill: parent; anchors.margins: 8; color: "transparent"; border.color: "white"; border.width: 1; radius: 14 }
    }

    contentItem: ColumnLayout {
        spacing: 10
        // Logo
        Image {
            Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 30
            source: "../assets/logo/Logo.png"; sourceSize: Qt.size(60, 60)
            width: 60; height: 60; fillMode: Image.PreserveAspectFit
        }
        // Text
        Column {
            Layout.alignment: Qt.AlignHCenter; spacing: 4
            Text { text: "ABOUT:"; font.family: "Montserrat"; font.pixelSize: 12; font.weight: Font.Bold; color: "white"; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "CHRONOMÉTRIS"; font.family: "Montserrat"; font.pixelSize: 24; font.weight: Font.ExtraBold; color: "white"; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "VERSION: 1.1"; font.family: "Montserrat"; font.pixelSize: 12; font.weight: Font.Bold; color: "white"; anchors.horizontalCenter: parent.horizontalCenter }
        }

        Item { Layout.fillHeight: true }

        // Settings Bar (FUNCTIONAL)
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 20; Layout.bottomMargin: 20; height: 40
            color: "transparent"; border.color: "white"; border.width: 2; radius: 8
            RowLayout {
                anchors.fill: parent; spacing: 0

                // 12 Hours Button
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: !theme.is24HourFormat ? "white" : "transparent"
                    radius: !theme.is24HourFormat ? 6 : 0
                    Text { anchors.centerIn: parent; text: "12 Hours"; color: !theme.is24HourFormat ? accentColor : "white"; font.bold: true; font.pixelSize: 11; opacity: !theme.is24HourFormat ? 1.0 : 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.is24HourFormat = false }
                }

                Rectangle { width: 1; height: 25; color: "white" }

                // 24 Hours Button
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: theme.is24HourFormat ? "white" : "transparent"
                    radius: theme.is24HourFormat ? 6 : 0
                    Text { anchors.centerIn: parent; text: "24 Hours"; color: theme.is24HourFormat ? accentColor : "white"; font.bold: true; font.pixelSize: 11; opacity: theme.is24HourFormat ? 1.0 : 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.is24HourFormat = true }
                }

                Rectangle { width: 1; height: 25; color: "white" }

                // Light Mode Button
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: !theme.isDarkMode ? "white" : "transparent"
                    radius: !theme.isDarkMode ? 6 : 0
                    Text { anchors.centerIn: parent; text: "Light"; color: !theme.isDarkMode ? accentColor : "white"; font.bold: true; font.pixelSize: 11; opacity: !theme.isDarkMode ? 1.0 : 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = false }
                }

                Rectangle { width: 1; height: 25; color: "white" }

                // Dark Mode Button
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: theme.isDarkMode ? "white" : "transparent"
                    radius: theme.isDarkMode ? 6 : 0
                    Text { anchors.centerIn: parent; text: "Dark"; color: theme.isDarkMode ? accentColor : "white"; font.bold: true; font.pixelSize: 11; opacity: theme.isDarkMode ? 1.0 : 0.7 }
                    MouseArea { anchors.fill: parent; onClicked: theme.isDarkMode = true }
                }
            }
        }
    }
}
