import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: isDuration ? 260 : 200
    height: 80

    property var theme
    property bool isDuration: false

    property int hours: 12
    property int minutes: 0
    property int seconds: 0
    property bool isAm: true
    property bool showHours: true

    function pad(n) { return n < 10 ? "0" + n : n }

    RowLayout {
        anchors.centerIn: parent
        spacing: 5

        // AM/PM
        Rectangle {
            visible: !isDuration && !theme.is24HourFormat && showHours
            width: 50; height: 60; color: "#E9E9E9"; radius: 5
            Text { anchors.centerIn: parent; text: root.isAm ? "AM" : "PM"; font.bold: true; font.pixelSize: 18 }
            MouseArea { anchors.fill: parent; onClicked: root.isAm = !root.isAm }
        }

        // HOURS
        Column {
            visible: showHours
            Button { text: "▲"; flat: true; height: 20; width: 50; onClicked: root.hours++ }
            Rectangle {
                width: 50; height: 50; color: "#E9E9E9"; radius: 5
                TextInput {
                    anchors.fill: parent; text: pad(root.hours); font.pixelSize: 24; font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter; verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true; color: "black" // FORCE INTERACTION
                    validator: IntValidator { bottom: 0; top: 99 }
                    onEditingFinished: root.hours = parseInt(text)
                }
            }
            Button { text: "▼"; flat: true; height: 20; width: 50; onClicked: root.hours = Math.max(0, root.hours - 1) }
        }

        Text { visible: showHours; text: ":"; font.pixelSize: 24; color: "white" }

        // MINUTES
        Column {
            Button { text: "▲"; flat: true; height: 20; width: 50; onClicked: root.minutes = (root.minutes + 1) % 60 }
            Rectangle {
                width: 50; height: 50; color: "#E9E9E9"; radius: 5
                TextInput {
                    anchors.fill: parent; text: pad(root.minutes); font.pixelSize: 24; font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter; verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true; color: "black"
                    validator: IntValidator { bottom: 0; top: 59 }
                    onEditingFinished: root.minutes = parseInt(text)
                }
            }
            Button { text: "▼"; flat: true; height: 20; width: 50; onClicked: root.minutes = (root.minutes - 1 < 0 ? 59 : root.minutes - 1) }
        }

        // SECONDS
        Text { visible: isDuration; text: ":"; font.pixelSize: 24; color: "white" }
        Column {
            visible: isDuration
            Button { text: "▲"; flat: true; height: 20; width: 50; onClicked: root.seconds = (root.seconds + 1) % 60 }
            Rectangle {
                width: 50; height: 50; color: "#E9E9E9"; radius: 5
                TextInput {
                    anchors.fill: parent; text: pad(root.seconds); font.pixelSize: 24; font.bold: true
                    horizontalAlignment: TextInput.AlignHCenter; verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true; color: "black"
                    validator: IntValidator { bottom: 0; top: 59 }
                    onEditingFinished: root.seconds = parseInt(text)
                }
            }
            Button { text: "▼"; flat: true; height: 20; width: 50; onClicked: root.seconds = (root.seconds - 1 < 0 ? 59 : root.seconds - 1) }
        }
    }
}
