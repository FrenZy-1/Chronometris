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

    // Signal: Type, Name, ConfigObject, ID
    signal editRequested(string type, string name, var config, int id)

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 15

        // --- 1. UPCOMING ALARM (Hidden unless alarm is < 15 mins) ---
        ColumnLayout {
            visible: engine.isAlarmSoon
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            spacing: 5

            Text {
                text: "Upcoming Alarm:";
                font.family: "Montserrat"; font.pixelSize: 14; font.bold: true;
                color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: engine.nextAlarmName;
                font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold;
                color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: engine.nextAlarmTime;
                font.family: "Montserrat"; font.pixelSize: 32; font.weight: Font.Normal;
                color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter
            }

            // Action Buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 10
                RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: accentColor; onClicked: console.log("Snooze") }
                RoundButton { icon: "close"; text: "Turn Off"; color: accentColor; onClicked: console.log("Stop") }
                RoundButton { icon: "skip_next"; text: "Skip"; color: accentColor; onClicked: console.log("Skip") }
            }

            Rectangle {
                Layout.fillWidth: true; height: 1;
                color: theme.borderColor; opacity: 0.3;
                Layout.margins: 20; Layout.topMargin: 15
            }
        }

        // --- 2. ALARM LIST ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: !engine.isAlarmSoon ? 40 : 0

            // List Header
            Rectangle {
                Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Active Alarms"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Text { text: engine.alarmsList.length; font.family: "Montserrat"; color: "white" }
                }
            }

            // The List
            Repeater {
                model: engine.alarmsList // Live Data from C++

                Rectangle {
                    Layout.fillWidth: true; height: 50
                    color: theme.isDarkMode ? "#2A2A2A" : "white"
                    radius: 5; border.color: theme.borderColor; border.width: 1

                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Column {
                            Layout.fillWidth: true
                            Text {
                                text: modelData.name;
                                font.family: "Montserrat"; font.bold: true; color: theme.textPrimary
                            }
                            Text {
                                // Parse JSON config safely for display
                                text: modelData.config.time || "00:00";
                                font.family: "Montserrat"; font.pixelSize: 12; color: theme.textSecondary
                            }
                        }

                        // Fake Toggle Switch
                        Rectangle {
                            width: 36; height: 20; radius: 10
                            color: accentColor
                            Rectangle { x: 18; width: 16; height: 16; radius: 8; color: "white"; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }

                    // Interaction
                    MouseArea {
                        anchors.fill: parent
                        // PASS DATA + CONFIG + ID
                        onDoubleClicked: alarmPage.editRequested("alarm", modelData.name, modelData.config, modelData.id)
                    }
                }
            }
        }
    }
}
