import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"

Flickable {
    id: dashboard
    contentHeight: content.height + 100; contentWidth: width; boundsBehavior: Flickable.StopAtBounds
    property var theme
    property color accentColor
    signal editRequested(string type, string name, var config, int id)

    ColumnLayout {
        id: content; width: parent.width; spacing: 10

        // --- 1. HEADER ---
        Column {
            visible: engine.currentState === "stopped" && !engine.isAlarmSoon
            Layout.alignment: Qt.AlignHCenter; Layout.margins: 20; Layout.topMargin: 40; spacing: 5
            ColoredIcon { source: "../assets/icons/timer.svg"; width: 80; height: 80; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "NO ACTIVE TIMER"; font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeH3; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
        }

        ColumnLayout {
            visible: engine.currentState !== "stopped"
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter
            Text { text: "Running Timer:"; font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.currentType === "work" ? "WORK SESSION" : (engine.currentType === "longBreak" ? "LONG BREAK" : "SHORT BREAK"); font.family: theme.mainFont; font.pixelSize: theme.fontSizeH2; font.weight: theme.fontWeightExtraBold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Item { width: 260; height: 260; Layout.alignment: Qt.AlignHCenter
                TimerProgressCircle { anchors.centerIn: parent; circleSize: 240; progress: engine.progress; progressColor: accentColor }
                Column { anchors.centerIn: parent
                    Text { text: engine.timeRemainingString; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH1; font.weight: theme.fontWeightBold; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: engine.currentState; font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter; font.capitalization: Font.Capitalize }
                }
            }

            // --- FIXED BUTTON LABELS ---
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15

                // Play / Pause
                RoundButton {
                    text: engine.currentState==="running" ? "Pause" : "Resume" // Explicit Label
                    icon: engine.currentState==="running" ? "pause" : "play_arrow"
                    color: accentColor
                    onClicked: engine.currentState==="running" ? engine.pause() : engine.start()
                }

                // Stop
                RoundButton {
                    text: "Stop" // Explicit Label
                    icon: "stop"
                    color: accentColor
                    onClicked: engine.stop()
                }

                // Skip Cycle
                RoundButton {
                    text: "Skip" // Explicit Label
                    icon: "fast_forward"
                    color: accentColor
                    onClicked: engine.skip()
                }

                // Next Timer
                RoundButton {
                    text: "End" // Explicit Label
                    icon: "skip_next"
                    color: accentColor
                    onClicked: engine.stop()
                }
            }
        }

        // --- 2. STATS ---
        Column {
            Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 10; spacing: 5
            Text { text: "Today's Stats:"; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH3; font.weight: theme.fontWeightBold; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Total Focus: " + engine.todayFocusString; font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Sessions: " + engine.todaySessionCount; font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 5
                Text { text: "Current Streak:"; font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody; color: theme.textPrimary }
                Text { text: engine.currentStreak + " Days"; font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody; font.bold: true; color: accentColor }
            }
        }

        // --- 3. HEATMAP ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Weekly Activity"; font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 12
                Repeater {
                    model: ["M", "T", "W", "T", "F", "S", "S"]
                    Column {
                        spacing: 6
                        Rectangle { width: 30; height: 30; radius: 6; color: accentColor; opacity: 0.2 + (Math.random() * 0.8) }
                        Text { text: modelData; font.family: theme.mainFont; anchors.horizontalCenter: parent.horizontalCenter; font.pixelSize: theme.fontSizeSmall; color: theme.textSecondary }
                    }
                }
            }
        }
        Item { Layout.preferredHeight: 100 }
    }
}
