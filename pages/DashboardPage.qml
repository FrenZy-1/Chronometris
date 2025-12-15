import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: dashboard
    contentHeight: content.height + 40
    contentWidth: width

    property var theme

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 24

        // Header
        Text {
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignHCenter
            text: "Running Timer:"
            font.family: "Montserrat"
            font.pixelSize: 16
            color: theme.textPrimary
            font.weight: Font.Bold
        }

        // Timer Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "TIMER NAME" // Dynamic binding later
            font.family: "Montserrat"
            font.pixelSize: 28
            color: theme.textPrimary
            font.weight: Font.ExtraBold
        }

        // Big Progress Circle
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 280
            height: 280

            TimerProgressCircle {
                anchors.centerIn: parent
                circleSize: 260
                progress: 0.5 // 50%
                strokeWidth: 15
                // Colors from Figma tokens
                backgroundColor: theme.isDarkMode ? "#454545" : "#E0E0E0"
                progressColor: theme.idleColor
                timeText: "50%" // Matches screenshot text
                statusText: ""
                typeText: ""
                showProgressText: false // We use custom text center
            }

            // Custom Center Text per Figma design
            Column {
                anchors.centerIn: parent
                Text {
                    text: "50%"
                    font.family: "Montserrat"
                    font.pixelSize: 48
                    font.weight: Font.Bold
                    color: theme.textPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Timer State Text
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                text: "15:15 Paused"
                font.family: "Montserrat"
                font.pixelSize: 24
                font.weight: Font.Bold
                color: theme.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Working..."
                font.family: "Montserrat"
                font.pixelSize: 16
                color: theme.textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Control Buttons Row
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            RoundButton { icon: "pause"; text: "Pause"; color: theme.idleColor }
            RoundButton { icon: "stop"; text: "Stop"; color: theme.idleColor }
            RoundButton { icon: "skip_next"; text: "Skip"; color: theme.idleColor }
            RoundButton { icon: "fast_forward"; text: "Next"; color: theme.idleColor }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 25 // pageSidePadding
            height: 1
            color: theme.borderColor
            opacity: 0.3
        }

        // Upcoming Alarm Section
        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 25
            Layout.rightMargin: 25
            spacing: 10

            Text {
                text: "Upcoming Alarm:"
                font.family: "Montserrat"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: theme.textPrimary
            }

            Text {
                text: "ALARM NAME"
                font.family: "Montserrat"
                font.pixelSize: 26
                font.weight: Font.Bold
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "12:15 PM"
                font.family: "Montserrat"
                font.pixelSize: 32
                font.weight: Font.Normal
                color: theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            // Alarm Controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 15
                Layout.topMargin: 10

                RoundButton { icon: "pause"; text: "Snooze"; color: theme.idleColor } // Placeholder icon
                RoundButton { icon: "skip_next"; text: "Dismiss"; color: theme.idleColor }
            }
        }

        // Spacer at bottom
        Item { Layout.preferredHeight: 40 }
    }
}
