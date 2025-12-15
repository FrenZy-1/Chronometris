import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"

Flickable {
    id: dashboard
    contentHeight: content.height + 100 // Extra space for footer
    contentWidth: width
    boundsBehavior: Flickable.StopAtBounds

    property var theme
    property color accentColor

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10

        // --- TIMER SECTION ---
        Column {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            spacing: 0

            Text {
                text: "Running Timer:"
                font.family: "Montserrat"; font.pixelSize: 14; font.weight: Font.Bold
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: engine.currentType === "work" ? "WORK SESSION" : (engine.currentType === "shortBreak" ? "SHORT BREAK" : "LONG BREAK")
                font.family: "Montserrat"; font.pixelSize: 26; font.weight: Font.ExtraBold
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Progress Circle
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 260; height: 260

            TimerProgressCircle {
                anchors.centerIn: parent
                circleSize: 240
                progress: engine.progress
                strokeWidth: 20
                backgroundColor: theme.isDarkMode ? "#454545" : "#E0E0E0"
                progressColor: accentColor
            }

            Column {
                anchors.centerIn: parent
                Text {
                    function fmt(s) {
                        var m = Math.floor(s / 60)
                        var sec = s % 60
                        return (m < 10 ? "0"+m : m) + ":" + (sec < 10 ? "0"+sec : sec)
                    }
                    text: fmt(engine.timeRemaining)
                    font.family: "Montserrat"; font.pixelSize: 48; font.weight: Font.Bold
                    color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: engine.currentState
                    font.family: "Montserrat"; font.pixelSize: 18; color: theme.textSecondary
                    font.capitalization: Font.Capitalize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Timer Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            RoundButton {
                icon: engine.currentState === "running" ? "pause" : "play_arrow"
                text: engine.currentState === "running" ? "Pause" : "Resume"
                color: accentColor
                onClicked: engine.currentState === "running" ? engine.pause() : engine.start()
            }
            RoundButton {
                icon: "stop"; text: "Stop"; color: accentColor
                onClicked: engine.stop()
            }
            RoundButton {
                icon: "skip_next"; text: "Skip"; color: accentColor
                onClicked: engine.skip()
            }
            RoundButton {
                icon: "fast_forward"; text: "Next"; color: accentColor
                onClicked: engine.skip()
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 25; height: 1
            color: theme.borderColor; opacity: 0.3
        }

        // --- UPCOMING ALARM SECTION ---
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                text: "Upcoming Alarm:"
                font.family: "Montserrat"; font.pixelSize: 16; font.weight: Font.Bold
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "DAILY STANDUP"
                font.family: "Montserrat"; font.pixelSize: 24; font.weight: Font.Bold
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "10:00 AM"
                font.family: "Montserrat"; font.pixelSize: 32; font.weight: Font.Normal
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 5
                RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: accentColor }
                RoundButton { icon: "close"; text: "Dismiss"; color: accentColor }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 25; height: 1
            color: theme.borderColor; opacity: 0.3
        }

        // --- IDLE STATE MESSAGE ---
        Column {
            visible: engine.currentState === "stopped"
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 20
            spacing: 5

            Text {
                text: "NO UPCOMING ALARM OR TIMER"
                font.family: "Montserrat"; font.bold: true; font.pixelSize: 16
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Set a timer or alarm for it to appear here."
                font.family: "Montserrat"; font.pixelSize: 12
                color: theme.textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 25; height: 1
            color: theme.borderColor; opacity: 0.3
        }

        // --- WEEKLY HEATMAP ---
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 25;
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            // --- TODAY'S STATS (Centered) ---
            Column {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                spacing: 5

                Text {
                    text: "Today's Stats:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "Total Time: 4h 20m"; font.family: "Montserrat"; color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "Sessions: 8"; font.family: "Montserrat"; color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "Current Streak: 5 Days"; font.family: "Montserrat"; color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Text { text: "Weekly Activity"; font.family: "Montserrat"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 12

                Repeater {
                    model: ["M", "T", "W", "T", "F", "S", "S"]
                    Column {
                        spacing: 6
                        Rectangle {
                            width: 30; height: 30; radius: 6
                            color: accentColor
                            opacity: 0.2 + (Math.random() * 0.8) // Mock data
                        }
                        Text {
                            text: modelData
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 10; color: theme.textSecondary
                        }
                    }
                }
            }
        }

        Item { Layout.preferredHeight: 80 } // Footer spacer
    }
}
