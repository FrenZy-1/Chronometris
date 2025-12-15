import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: analyticsPage
    contentHeight: content.height + 40
    contentWidth: width

    property var theme

    // Colors from tokens (Light Mode)
    readonly property color heatHigh: "#B2B2B2"
    readonly property color heatMid:  "#CFCFCF"
    readonly property color heatLow:  "#DDDDDD"
    readonly property color heatNone: "#E4E4E4"

    ColumnLayout {
        id: content
        width: parent.width
        spacing: 24

        // Today's Stats
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25
            Layout.topMargin: 20

            Text { text: "Today's Stats:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary }
            Text { text: "Total Time: -- H -- M"; font.family: "Montserrat"; color: theme.textPrimary }
            Text { text: "Sessions: --"; font.family: "Montserrat"; color: theme.textPrimary }
            Text { text: "Current Streak: -- Days"; font.family: "Montserrat"; color: theme.textPrimary }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Heatmap
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25
            Text { text: "Heatmap:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary }

            // Grid
            GridLayout {
                columns: 14 // Weeks approx
                columnSpacing: 4; rowSpacing: 4

                Repeater {
                    model: 70 // 5 rows * 14 cols
                    Rectangle {
                        width: 18; height: 18; radius: 2
                        // Randomly assign colors based on token values
                        property int rand: Math.floor(Math.random() * 4)
                        color: {
                            if (rand === 0) return heatHigh
                            if (rand === 1) return heatMid
                            if (rand === 2) return heatLow
                            return heatNone
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Total Hours Chart
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25
            Text { text: "Total Hours:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary }

            RowLayout {
                Layout.fillWidth: true; height: 120; spacing: 8
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: 7
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: 25
                        height: Math.random() * 80 + 20
                        // Alternating colors from your tokens
                        color: index % 2 == 0 ? "#6282A1" : "#AD5887"
                        radius: 4
                    }
                }
            }
        }
    }
}
