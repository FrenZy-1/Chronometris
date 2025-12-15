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
    property color accentColor // <--- ADDED THIS PROPERTY

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 10

        // Timer Status
        Column {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            spacing: 5

            Text { text: "Running Timer:"; font.pixelSize: 14; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Work Session"; font.pixelSize: 28; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.ExtraBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Paused"; font.pixelSize: 24; font.family: "Montserrat"; color: theme.textPrimary; font.weight: Font.Normal; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "Working..."; font.pixelSize: 16; font.family: "Montserrat"; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
        }

        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15
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
                onClicked: engine.skip() // Mapped to skip for now
            }
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

        // Paused
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            // Upcoming Header
            Rectangle {
                Layout.fillWidth: true; height: 40; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Paused"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
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

        // Completed
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            // Upcoming Header
            Rectangle {
                Layout.fillWidth: true; height: 40; color: accentColor; radius: 5
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10
                    Text { text: "Completed"; font.family: "Montserrat"; font.bold: true; color: "white"; Layout.fillWidth: true }
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
