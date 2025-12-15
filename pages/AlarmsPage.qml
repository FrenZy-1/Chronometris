import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: alarmPage
    contentHeight: content.height + 120
    contentWidth: width
    boundsBehavior: Flickable.StopAtBounds

    property var theme
    property color accentColor

    // --- SIGNAL IS REQUIRED ---
    signal editRequested(string type, string name, string time)

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 15

        // ACTIVE ALARM (Hidden if false)
        ColumnLayout {
            visible: engine.isAlarmSoon
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            spacing: 5

            Text { text: "Upcoming Alarm:"; font.pixelSize: 14; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmName; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmTime; font.pixelSize: 32; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; Layout.alignment: Qt.AlignHCenter }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 10
                RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: accentColor }
                RoundButton { icon: "close"; text: "Turn Off"; color: accentColor }
                RoundButton { icon: "skip_next"; text: "Skip"; color: accentColor }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20; Layout.topMargin: 15 }
        }

        // ALARM LIST
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: !engine.isAlarmSoon ? 40 : 0

            Rectangle {
                Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Upcoming"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Rectangle { width: 60; height: 20; color: "transparent"; border.color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Rows: 5"; color: "white"; font.pixelSize: 10 } }
                }
            }

            Repeater {
                model: 5
                Rectangle {
                    Layout.fillWidth: true; height: 40; color: theme.isDarkMode ? "#2A2A2A" : "white"; radius: 5; border.color: theme.borderColor; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Text { text: "Daily Standup"; color: theme.textPrimary; Layout.fillWidth: true }
                        Text { text: "10:00 AM"; color: theme.textSecondary }
                    }

                    // DOUBLE CLICK - EMIT SIGNAL INSTEAD OF CALLING OVERLAY DIRECTLY
                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: alarmPage.editRequested("alarm", "Daily Standup", "10:00 AM")
                    }
                }
            }
        }
    }
}
