import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: timerPage
    contentHeight: content.height + 100
    contentWidth: width
    boundsBehavior: Flickable.StopAtBounds // Helps with swipe feel

    property var theme

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10 // Reduced spacing

        // Running Timer Section
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5
            Layout.topMargin: 10 // Adjust this if you want it closer to header
        }

        // Running Timer Section
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text { text: "Running Timer:"; font.pixelSize: 14; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "TIMER NAME"; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Paused"; font.pixelSize: 24; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Working..."; font.pixelSize: 16; font.family: "Montserrat"; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
        }

        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15
            RoundButton { icon: "pause"; text: "Pause"; color: theme.idleColor }
            RoundButton { icon: "stop"; text: "Stop"; color: theme.idleColor }
            RoundButton { icon: "skip_next"; text: "Skip"; color: theme.idleColor }
            RoundButton { icon: "fast_forward"; text: "Next"; color: theme.idleColor }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20 }

        // Generic List Section Builder
        Component {
            id: sectionHeader
            RowLayout {
                width: parent ? parent.width : 0
                Text {
                    text: sectionName
                    font.family: "Montserrat"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: theme.textPrimary
                    Layout.fillWidth: true
                }
                Rectangle {
                    color: "transparent"; border.color: theme.borderColor; radius: 4
                    width: 60; height: 24
                    Text { text: "Rows: --"; anchors.centerIn: parent; font.pixelSize: 10; color: theme.textSecondary }
                }
            }
        }

        // Upcoming
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 20;
            spacing: 10

            // Upcoming Header
            RowLayout {
                width: parent.width
                Text { text: "Upcoming:"; font.family: "Montserrat"; font.pixelSize: 20; font.weight: Font.Bold; color: theme.textPrimary; Layout.fillWidth: true }
                Rectangle { color: "transparent"; border.color: theme.borderColor; radius: 4; width: 60; height: 24; Text { text: "Rows: --"; anchors.centerIn: parent; font.pixelSize: 10 } }
            }

            // Mock List
            Repeater {
                model: 8
                Rectangle {
                    Layout.fillWidth: true; height: 25; color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.fillWidth: true }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.preferredWidth: 60 }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold }
                    }
                }
            }
        }

        // Paused
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 20;
            spacing: 10

            // Upcoming Header
            RowLayout {
                width: parent.width
                Text { text: "Paused:"; font.family: "Montserrat"; font.pixelSize: 20; font.weight: Font.Bold; color: theme.textPrimary; Layout.fillWidth: true }
                Rectangle { color: "transparent"; border.color: theme.borderColor; radius: 4; width: 60; height: 24; Text { text: "Rows: --"; anchors.centerIn: parent; font.pixelSize: 10 } }
            }

            // Mock List
            Repeater {
                model: 8
                Rectangle {
                    Layout.fillWidth: true; height: 25; color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.fillWidth: true }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.preferredWidth: 60 }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold }
                    }
                }
            }
        }

        // Completed
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 20;
            spacing: 10

            // Upcoming Header
            RowLayout {
                width: parent.width
                Text { text: "Completed:"; font.family: "Montserrat"; font.pixelSize: 20; font.weight: Font.Bold; color: theme.textPrimary; Layout.fillWidth: true }
                Rectangle { color: "transparent"; border.color: theme.borderColor; radius: 4; width: 60; height: 24; Text { text: "Rows: --"; anchors.centerIn: parent; font.pixelSize: 10 } }
            }

            // Mock List
            Repeater {
                model: 8
                Rectangle {
                    Layout.fillWidth: true; height: 25; color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.fillWidth: true }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; Layout.preferredWidth: 60 }
                        Text { text: "Default"; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold }
                    }
                }
            }
        }
    }
}
