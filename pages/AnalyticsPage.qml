import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: analyticsPage
    contentHeight: content.height + 40
    contentWidth: width

    property var theme

    // Colors from tokens
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
            Layout.fillWidth: true;
            Layout.margins: 25;
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignHCenter

            Text { text: "Today's Stats:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary }
            Text { text: "Total Time: 4h 20m"; font.family: "Montserrat"; color: theme.textPrimary }
            Text { text: "Sessions: 8"; font.family: "Montserrat"; color: theme.textPrimary }
            Text { text: "Current Streak: 5 Days"; font.family: "Montserrat"; color: theme.textPrimary }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Heatmap
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 25
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: "Heatmap:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary
                // Keep label left aligned, but grid centered? Or align block?
            }

            // Centered Grid
            GridLayout {
                Layout.alignment: Qt.AlignHCenter // CENTER THE GRID
                columns: 14
                columnSpacing: 4; rowSpacing: 4

                Repeater {
                    model: 70
                    Rectangle {
                        width: 18; height: 18; radius: 2
                        property int rand: Math.floor(Math.random() * 4)
                        color: rand === 0 ? heatHigh : (rand === 1 ? heatMid : (rand === 2 ? heatLow : heatNone))
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 25 }

        // Total Hours Chart
        ColumnLayout {
            Layout.fillWidth: true;
            Layout.margins: 25
            Layout.alignment: Qt.AlignHCenter

            Text { text: "Total Hours:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary }

            RowLayout {
                Layout.fillWidth: true; height: 120; spacing: 8
                Layout.alignment: Qt.AlignHCenter // CENTER THE CHART
                Repeater {
                    model: 7
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: 25
                        height: Math.random() * 80 + 20
                        color: index % 2 == 0 ? "#6282A1" : "#AD5887"
                        radius: 4

                        // Small label below bar
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
    }
}
