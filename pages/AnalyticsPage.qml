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

        // Heatmap (Connected to DB)
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Heatmap:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter
                columns: 14; columnSpacing: 4; rowSpacing: 4
                Repeater {
                    model: engine.heatmapData // FROM C++
                    Rectangle {
                        width: 18; height: 18; radius: 2
                        property int intensity: modelData
                        color: accentColor
                        opacity: intensity === 3 ? 1.0 : (intensity === 2 ? 0.6 : (intensity === 1 ? 0.3 : 0.1))
                    }
                }
            }
        }

        // Bar Chart (Connected to DB)
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Weekly Hours:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            RowLayout {
                Layout.fillWidth: true; height: 120; spacing: 8; Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: engine.chartData // FROM C++ (List of 7 ints)
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: 25
                        // Scale height: Max expected ~10 hours, so * 10
                        height: Math.min(modelData * 10 + 5, 120)
                        radius: 4
                        color: accentColor
                        Text { anchors.top: parent.bottom; anchors.topMargin: 2; anchors.horizontalCenter: parent.horizontalCenter; text: ["M","T","W","T","F","S","S"][index]; font.pixelSize: 8; color: theme.textSecondary }
                    }
                }
            }
        }

        // Pie Chart (Connected to DB)
        ColumnLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 10
            Text { text: "Distribution:"; font.family: "Montserrat"; font.pixelSize: 18; font.weight: Font.Bold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }

            Canvas {
                width: 200; height: 200; Layout.alignment: Qt.AlignHCenter
                property var data: engine.pieData // [Work, Break, Long]
                onDataChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d"); ctx.reset();
                    var cx = width/2; var cy = height/2; var radius = 70;
                    var total = data[0] + data[1] + data[2];
                    if(total === 0) total = 1; // Avoid divide by zero

                    var currentAngle = -Math.PI/2;

                    function drawSlice(value, color) {
                        if(value === 0) return;
                        var sliceAngle = (value / total) * 2 * Math.PI;
                        ctx.beginPath();
                        ctx.moveTo(cx, cy);
                        ctx.arc(cx, cy, radius, currentAngle, currentAngle + sliceAngle);
                        ctx.closePath();
                        ctx.fillStyle = color;
                        ctx.fill();
                        currentAngle += sliceAngle;
                    }

                    drawSlice(data[0], theme.workFill);
                    drawSlice(data[1], theme.shortBreakFill);
                    drawSlice(data[2], theme.longBreakFill);

                    // Donut
                    ctx.beginPath(); ctx.arc(cx, cy, 35, 0, 2*Math.PI); ctx.fillStyle = theme.mainBackgroundColor; ctx.fill();
                }
            }
        }

        // DEBUG BUTTON
        Button {
            text: "Generate Dummy Data"
            Layout.alignment: Qt.AlignHCenter
            onClicked: engine.generateDummyData()
        }

        Item { Layout.preferredHeight: 80 }
    }
}
