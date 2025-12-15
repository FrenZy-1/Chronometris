import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: alarmPage
    contentHeight: content.height + 100
    contentWidth: width

    property var theme

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 20

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: theme.idleColor
            Text {
                anchors.centerIn: parent; text: "ALARMS"; font.family: "Montserrat"; font.pixelSize: 24; font.weight: Font.Bold; color: "white"
            }
        }

        // Active Alarm
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5
            Text { text: "Upcoming Alarm:"; font.pixelSize: 14; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "ALARM NAME"; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Description..."; font.pixelSize: 16; font.family: "Montserrat"; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "12:15 PM"; font.pixelSize: 32; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
        }

        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15
            RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: theme.idleColor }
            RoundButton { icon: "close"; text: "Turn Off"; color: theme.idleColor }
            RoundButton { icon: "skip_next"; text: "Skip"; color: theme.idleColor }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20 }

        // Lists
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

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
    }
}
