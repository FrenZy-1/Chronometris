import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"

Flickable {
    id: dashboard
    contentHeight: content.height + 40
    contentWidth: width
    boundsBehavior: Flickable.StopAtBounds

    property var theme

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10 // Tightened global spacing

        // --- TIMER SECTION ---
        Column {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            spacing: 0 // Minimal space between "Running Timer" and "Name"

            Text {
                text: "Running Timer:"
                font.family: "Montserrat"; font.pixelSize: 14; font.weight: Font.Bold
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: engine.currentType === "work" ? "WORK SESSION" : "BREAK"
                font.family: "Montserrat"; font.pixelSize: 26; font.weight: Font.ExtraBold
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Progress Circle (Functioning)
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 260; height: 260

            TimerProgressCircle {
                anchors.centerIn: parent
                circleSize: 240
                progress: engine.progress
                strokeWidth: 20
                backgroundColor: theme.isDarkMode ? "#454545" : "#E0E0E0"
                progressColor: theme.getTimerColor(engine.currentType, false)
            }

            Column {
                anchors.centerIn: parent
                Text {
                    // Time Formatter
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
                color: theme.idleColor
                onClicked: engine.currentState === "running" ? engine.pause() : engine.start()
            }
            RoundButton {
                icon: "stop"; text: "Stop"; color: theme.idleColor
                onClicked: engine.stop()
            }
            RoundButton {
                icon: "skip_next"; text: "Skip"; color: theme.idleColor
                onClicked: engine.skip()
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 25; height: 1
            color: theme.borderColor; opacity: 0.3
        }

        // --- UPCOMING ALARM SECTION (Centered) ---
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter // Center the block
            spacing: 5

            Text {
                text: "Upcoming Alarm:"
                font.family: "Montserrat"; font.pixelSize: 16; font.weight: Font.Bold
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter // Center text
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
                RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: theme.idleColor }
                RoundButton { icon: "close"; text: "Dismiss"; color: theme.idleColor }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; Layout.margins: 25; height: 1
            color: theme.borderColor; opacity: 0.3
        }

        // --- HEATMAP SECTION (Visual Only) ---
        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: 25
            spacing: 10
            Layout.alignment: Qt.AlignHCenter

            Text { text: "Activity Heatmap"; font.family: "Montserrat"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter
                columns: 14
                columnSpacing: 4; rowSpacing: 4

                Repeater {
                    model: 56 // 4 rows * 14 cols
                    Rectangle {
                        width: 15; height: 15; radius: 2
                        property int rand: Math.floor(Math.random() * 4)
                        color: {
                            // Using Figma token colors manually for simplicity
                            if (rand === 0) return "#B2B2B2"
                            if (rand === 1) return "#CFCFCF"
                            if (rand === 2) return "#DDDDDD"
                            return "#E4E4E4"
                        }
                    }
                }
            }
        }

        // Spacer
        Item { Layout.preferredHeight: 40 }
    }
}
