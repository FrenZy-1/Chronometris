import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: timerPage
    contentHeight: content.height + 120
    contentWidth: width
    boundsBehavior: Flickable.StopAtBounds

    property var theme
    property color accentColor

    // --- ADD THIS LINE ---
    signal editRequested(string type, string name, string time)

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10

        // ... (The rest of your TimerPage code) ...
        // Ensure you paste the full content from previous steps here
        // If you need the full file again, let me know, but adding the signal line fixes the specific Main.qml error.

        // --- 1. RUNNING TIMER (Hidden if Stopped) ---
        ColumnLayout {
            visible: engine.currentState !== "stopped"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            // ... (Timer Text & Controls) ...
            Text { text: engine.currentType === "work" ? "WORK SESSION" : "BREAK"; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.currentState; font.pixelSize: 24; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; font.capitalization: Font.Capitalize; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Working..."; font.pixelSize: 16; font.family: "Montserrat"; color: theme.textSecondary; Layout.alignment: Qt.AlignHCenter }

            // Controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 10
                RoundButton {
                    icon: engine.currentState === "running" ? "pause" : "play_arrow"
                    text: engine.currentState === "running" ? "Pause" : "Resume"
                    color: accentColor
                    onClicked: engine.currentState === "running" ? engine.pause() : engine.start()
                }
                RoundButton { icon: "stop"; text: "Stop"; color: accentColor; onClicked: engine.stop() }
                RoundButton { icon: "skip_next"; text: "Skip"; color: accentColor; onClicked: engine.skip() }
                RoundButton { icon: "fast_forward"; text: "Next"; color: accentColor; onClicked: engine.skip() }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20; Layout.topMargin: 15 }
        }

        // --- 2. LISTS (Always Visible) ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: engine.currentState === "stopped" ? 40 : 0

            // Header
            Rectangle {
                Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Upcoming"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Rectangle { width: 60; height: 20; color: "transparent"; border.color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Rows: 3"; color: "white"; font.pixelSize: 10 } }
                }
            }

            // List Items
            Repeater {
                model: 3
                Rectangle {
                    Layout.fillWidth: true; height: 40; color: theme.isDarkMode ? "#2A2A2A" : "white"; radius: 5; border.color: theme.borderColor; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10
                        Text { text: "Work Session"; font.family: "Montserrat"; color: theme.textPrimary; Layout.fillWidth: true }
                        Text { text: "25:00"; font.family: "Montserrat"; color: theme.textSecondary }
                    }

                    // EDIT TRIGGER
                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: timerPage.editRequested("timer", "Work Session", "25:00")
                    }
                }
            }
        }
    }
}
