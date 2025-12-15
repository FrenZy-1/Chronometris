import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: analyticsPage
    contentHeight: content.height + 100
    contentWidth: width

    property var theme
    property color accentColor

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 24

        // Today's Stats
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 25;
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignHCenter

            Text { text: "Today's Stats:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Total Time: 4h 20m"; font.family: "Montserrat"; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Sessions: 8"; font.family: "Montserrat"; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Current Streak: 5 Days"; font.family: "Montserrat"; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Heatmap
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10

            Text { text: "Heatmap:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter
                columns: 14
                columnSpacing: 4; rowSpacing: 4

                Repeater {
                    model: 70
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: 25
                        height: Math.random() * 80 + 20
                        radius: 4

                        // FIXED COLORS: Cycle through Work(Blue), Break(Pink), LongBreak(Purple)
                        color: {
                            var type = index % 3
                            if (type === 0) return theme.workFill // Blue
                            if (type === 1) return theme.shortBreakFill // Pink
                            return theme.longBreakFill // Purple
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Chart
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10

            Text { text: "Total Hours:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            RowLayout {
                Layout.fillWidth: true; height: 120; spacing: 8
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: 7
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: 25
                        height: Math.random() * 80 + 20
                        color: index % 2 == 0 ? accentColor : Qt.darker(accentColor, 1.2)
                        radius: 4
                        Text {
                            anchors.top: parent.bottom; anchors.topMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: ["M","T","W","T","F","S","S"][index]
                            font.pixelSize: 8; color: theme.textSecondary
                        }
                    }
                }
            }
        }
        Item { Layout.preferredHeight: 80 }
    }
}
