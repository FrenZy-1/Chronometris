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
        width: parent.width; spacing: 24

        // Stats Header
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 25; Layout.topMargin: 20; Layout.alignment: Qt.AlignHCenter
            Text { text: "Today's Stats:"; font.bold: true; font.pixelSize: 18; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Total Focus: 4h 20m"; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
        }

        // SCROLLING HEATMAP
        ColumnLayout {
            Layout.fillWidth: true; spacing: 5
            Text { text: "Activity History"; font.bold: true; font.pixelSize: 18; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            Item {
                Layout.fillWidth: true; Layout.preferredHeight: 160

                // Centered Container with max width for desktop
                Item {
                    width: Math.min(parent.width, 400)
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: true // Clean edges

                    ListView {
                        anchors.fill: parent
                        anchors.leftMargin: 10; anchors.rightMargin: 10
                        orientation: ListView.Horizontal; layoutDirection: Qt.RightToLeft
                        spacing: 4
                        model: 52

                        delegate: Column {
                            spacing: 4
                            // Fixed Label Container
                            Item {
                                width: 14; height: 15
                                Text {
                                    text: index % 4 === 0 ? "JAN" : ""
                                    font.pixelSize: 9; color: theme.textSecondary
                                    anchors.centerIn: parent
                                }
                            }
                            // Grid
                            Repeater {
                                model: 7
                                Rectangle {
                                    width: 14; height: 14; radius: 2
                                    property int intensity: Math.floor(Math.random() * 5)
                                    color: accentColor
                                    opacity: intensity===0?0.1:(intensity*0.25)
                                }
                            }
                        }
                    }
                }
            }
        }

        // BAR CHART
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Weekly Hours:"; font.bold: true; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: 160 // Taller
                RowLayout {
                    anchors.centerIn: parent; spacing: 15
                    Repeater {
                        model: engine.chartData
                        Column { spacing: 5
                            Item { width: 30; height: 120
                                Rectangle { width: 8; radius: 2; color: theme.workFill; height: Math.min(modelData.work * 30, parent.height); anchors.bottom: parent.bottom; anchors.left: parent.left }
                                Rectangle { width: 8; radius: 2; color: theme.shortBreakFill; height: Math.min(modelData.short * 30, parent.height); anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter }
                                Rectangle { width: 8; radius: 2; color: theme.longBreakFill; height: Math.min(modelData.long * 30, parent.height); anchors.bottom: parent.bottom; anchors.right: parent.right }
                            }
                            Text { text: ["M","T","W","T","F","S","S"][index]; font.pixelSize: 8; color: theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }
                }
            }
        }

        // PIE CHART (Canvas)
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Distribution:"; font.bold: true; font.pixelSize: 18; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            Canvas {
                width: 200; height: 200; Layout.alignment: Qt.AlignHCenter
                onPaint: {
                    var ctx = getContext("2d"); ctx.reset();
                    var cx = width/2; var cy = height/2; var r = 80;

                    ctx.beginPath(); ctx.arc(cx, cy, r, 0, 4, false); // Blue slice
                    ctx.strokeStyle = theme.workFill; ctx.lineWidth = 20; ctx.stroke();

                    ctx.beginPath(); ctx.arc(cx, cy, r, 4, 5.5, false); // Pink slice
                    ctx.strokeStyle = theme.shortBreakFill; ctx.lineWidth = 20; ctx.stroke();

                    ctx.beginPath(); ctx.arc(cx, cy, r, 5.5, 6.28, false); // Purple slice
                    ctx.strokeStyle = theme.longBreakFill; ctx.lineWidth = 20; ctx.stroke();
                }
                Component.onCompleted: requestPaint()
            }
        }

        // LINE CHART (Canvas)
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Focus Trend:"; font.bold: true; font.pixelSize: 18; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            Canvas {
                width: 280; height: 120; Layout.alignment: Qt.AlignHCenter
                onPaint: {
                    var ctx = getContext("2d"); ctx.reset(); ctx.lineWidth = 2;
                    function drawLine(pts, color) {
                        ctx.strokeStyle = color; ctx.beginPath(); ctx.moveTo(pts[0][0], pts[0][1]);
                        for(var i=1;i<pts.length;i++) ctx.lineTo(pts[i][0], pts[i][1]);
                        ctx.stroke();
                    }
                    drawLine([[0,80],[40,50],[80,40],[120,60],[160,30],[200,40],[240,20],[280,30]], theme.workFill);
                    drawLine([[0,100],[40,90],[80,85],[120,95],[160,80],[200,85],[240,75],[280,80]], theme.shortBreakFill);
                    drawLine([[0,110],[40,110],[80,110],[120,105],[160,110],[200,105],[240,110],[280,110]], theme.longBreakFill);
                }
                Component.onCompleted: requestPaint()
            }
        }

        Item { Layout.preferredHeight: 80 }
    }
}
