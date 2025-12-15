import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"

Flickable {
    id: dashboard
    contentHeight: content.height + 100; contentWidth: width; boundsBehavior: Flickable.StopAtBounds
    property var theme
    property color accentColor
    signal editRequested(string type, string name, string time)

    ColumnLayout {
        id: content; width: parent.width; spacing: 10

        // --- 1. HEADER ---
        // IDLE
        Column {
            visible: engine.currentState === "stopped" && !engine.isAlarmSoon
            Layout.alignment: Qt.AlignHCenter; Layout.margins: 20; Layout.topMargin: 40; spacing: 5
            ColoredIcon { source: "../assets/icons/timer.svg"; width: 80; height: 80; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "NO ACTIVE TIMER"; font.family: "Montserrat"; font.bold: true; font.pixelSize: 22; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
        }

        // ACTIVE
        ColumnLayout {
            visible: engine.currentState !== "stopped"
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter
            Text { text: "Running Timer:"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.currentType === "work" ? "WORK SESSION" : "BREAK"; font.pixelSize: 26; font.weight: Font.ExtraBold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Item { width: 260; height: 260; Layout.alignment: Qt.AlignHCenter
                TimerProgressCircle { anchors.centerIn: parent; circleSize: 240; progress: engine.progress; progressColor: accentColor }
                Column { anchors.centerIn: parent
                    Text { text: engine.timeRemainingString; font.pixelSize: 48; font.bold: true; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: engine.currentState; font.pixelSize: 18; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                }
            }
            // 4 BUTTONS RESTORED
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 20
                RoundButton { icon: engine.currentState==="running"?"pause":"play_arrow"; color: accentColor; onClicked: engine.currentState==="running"?engine.pause():engine.start() }
                RoundButton { icon: "stop"; color: accentColor; onClicked: engine.stop() }
                RoundButton { icon: "skip_next"; color: accentColor; onClicked: engine.skip() }
                RoundButton { icon: "fast_forward"; color: accentColor; onClicked: engine.skip() } // Next Button
            }
        }

        // ALARM
        ColumnLayout {
            visible: engine.isAlarmSoon && engine.currentState === "stopped"
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 5
            Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }
            Text { text: "Upcoming Alarm:"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmName; font.pixelSize: 24; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmTime; font.pixelSize: 32; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15
                RoundButton { icon: "hourglass_bottom"; color: accentColor; onClicked: console.log("Snoozed") }
                RoundButton { icon: "close"; color: accentColor; onClicked: console.log("Dismissed") }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // --- 2. STATS ---
        Column {
            Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 10; spacing: 5
            Text { text: "Today's Stats:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Total Focus: 4h 20m"; font.family: "Montserrat"; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Sessions: 8"; font.family: "Montserrat"; color: theme.textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
        }

        // --- 3. HEATMAP ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Weekly Activity"; font.family: "Montserrat"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 12
                Repeater {
                    model: ["M", "T", "W", "T", "F", "S", "S"]
                    Column {
                        spacing: 6
                        Rectangle { width: 30; height: 30; radius: 6; color: accentColor; opacity: 0.2 + (Math.random() * 0.8) }
                        Text { text: modelData; anchors.horizontalCenter: parent.horizontalCenter; font.pixelSize: 10; color: theme.textSecondary }
                    }
                }
            }
        }
        Item { Layout.preferredHeight: 100 }
    }
}
