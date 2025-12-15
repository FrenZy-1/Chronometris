import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: alarmPage
    contentHeight: content.height + 100
    contentWidth: width

    property var theme
    property color accentColor

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10

        // Active Alarm
        Column {
            Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 30; spacing: 5
            Text { text: "Upcoming Alarm:"; font.pixelSize: 14; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "DAILY STANDUP"; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; anchors.horizontalCenter: parent.horizontalCenter }

            // DYNAMIC TIME FORMAT
            Text {
                // Hardcoded 12:15 example, but using the formatter logic
                text: theme.formatTime(12, 15)
                font.pixelSize: 32; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15
            RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: accentColor }
            RoundButton { icon: "close"; text: "Turn Off"; color: accentColor }
            RoundButton { icon: "skip_next"; text: "Skip"; color: accentColor }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20 }

        // Upcoming
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            // Upcoming Header
            Rectangle {
                Layout.fillWidth: true; height: 40; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Upcoming"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Text { text: "(3)"; color: "white"; font.pixelSize: 12 }
                }
            }

            // Mock List Items
            Repeater {
                model: 3
                Rectangle {
                    Layout.fillWidth: true; height: 40; color: "white"; radius: 5; border.color: "#E0E0E0"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Text { text: "Work Session"; font.family: "Montserrat"; Layout.fillWidth: true }
                        Text { text: "25:00"; font.family: "Montserrat"; color: theme.textSecondary }
                    }
                }
            }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20 }

        // Snoozed
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            // Upcoming Header
            Rectangle {
                Layout.fillWidth: true; height: 40; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Snoozed"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Text { text: "(3)"; color: "white"; font.pixelSize: 12 }
                }
            }

            // Mock List Items
            Repeater {
                model: 3
                Rectangle {
                    Layout.fillWidth: true; height: 40; color: "white"; radius: 5; border.color: "#E0E0E0"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Text { text: "Work Session"; font.family: "Montserrat"; Layout.fillWidth: true }
                        Text { text: "25:00"; font.family: "Montserrat"; color: theme.textSecondary }
                    }
                }
            }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20 }

        // Turned off
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            // Upcoming Header
            Rectangle {
                Layout.fillWidth: true; height: 40; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Turned Off"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Text { text: "(3)"; color: "white"; font.pixelSize: 12 }
                }
            }

            // Mock List Items
            Repeater {
                model: 3
                Rectangle {
                    Layout.fillWidth: true; height: 40; color: "white"; radius: 5; border.color: "#E0E0E0"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Text { text: "Work Session"; font.family: "Montserrat"; Layout.fillWidth: true }
                        Text { text: "25:00"; font.family: "Montserrat"; color: theme.textSecondary }
                    }
                }
            }
        }
    }
}
