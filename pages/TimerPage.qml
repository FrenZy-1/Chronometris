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

    // Signal: Type, Name, ConfigObject, ID
    signal editRequested(string type, string name, var config, int id)

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10

        // --- 1. RUNNING TIMER (Hidden if Stopped) ---
        ColumnLayout {
            visible: engine.currentState !== "stopped"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            spacing: 5

            Text {
                text: engine.currentType === "work" ? "WORK SESSION" : "BREAK";
                font.pixelSize: 28; font.family: "Montserrat";
                color: theme.textPrimary; font.weight: Font.ExtraBold;
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: engine.currentState;
                font.pixelSize: 24; font.family: "Montserrat";
                color: theme.textPrimary; font.weight: Font.Normal;
                font.capitalization: Font.Capitalize; Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "Working...";
                font.pixelSize: 16; font.family: "Montserrat";
                color: theme.textSecondary; Layout.alignment: Qt.AlignHCenter
            }

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

            Rectangle {
                Layout.fillWidth: true; height: 1;
                color: theme.borderColor; opacity: 0.3;
                Layout.margins: 20; Layout.topMargin: 15
            }
        }

        // --- 2. SAVED TIMER LIST ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: engine.currentState === "stopped" ? 40 : 0

            // Header
            Rectangle {
                Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Saved Timers"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
                    Text { text: engine.timersList.length; font.family: "Montserrat"; color: "white" }
                }
            }

            // The List
            Repeater {
                model: engine.timersList // Live Data

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
                                text: (modelData.config.mode === "pomodoro") ? "Pomodoro" : "Custom Cycle";
                                font.family: "Montserrat"; font.pixelSize: 10; color: theme.textSecondary
                            }
                        }

                        // Play Button (Starts THIS timer)
                        RoundButton {
                            width: 30; height: 30; icon: "play_arrow"; color: accentColor;
                            onClicked: engine.loadAndStartSession(modelData.config)
                        }
                    }

                    // Interaction
                    MouseArea {
                        anchors.fill: parent
                        // PASS DATA + CONFIG + ID
                        onDoubleClicked: timerPage.editRequested("timer", modelData.name, modelData.config, modelData.id)
                    }
                }
            }
        }
    }
}
