import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 300; height: 340
    color: "transparent"

    property var selectedDate: new Date()
    property var viewDate: new Date()

    function daysInMonth(month, year) { return new Date(year, month + 1, 0).getDate(); }
    function firstDayOfMonth(month, year) { return new Date(year, month, 1).getDay(); }

    function changeMonth(delta) {
        var d = new Date(viewDate); d.setMonth(d.getMonth() + delta); viewDate = d;
    }
    function changeYear(delta) {
        var d = new Date(viewDate); d.setFullYear(d.getFullYear() + delta); viewDate = d;
    }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 20
        spacing: 15 // Nicer vertical spacing

        // --- 1. HEADER (Month & Year) ---
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            // Month
            RowLayout {
                spacing: 0
                RoundButton {
                    flat: true; width: 30; height: 30
                    contentItem: Text { text: "◄"; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    background: Item {}
                    onClicked: changeMonth(-1)
                }
                Text {
                    text: viewDate.toLocaleDateString(Qt.locale(), "MMMM")
                    font.bold: true; font.pixelSize: 16; color: "white"
                    horizontalAlignment: Text.AlignHCenter; width: 80
                }
                RoundButton {
                    flat: true; width: 30; height: 30
                    contentItem: Text { text: "►"; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    background: Item {}
                    onClicked: changeMonth(1)
                }
            }

            // Year
            RowLayout {
                spacing: 0
                RoundButton {
                    flat: true; width: 30; height: 30
                    contentItem: Text { text: "◄"; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    background: Item {}
                    onClicked: changeYear(-1)
                }
                Text {
                    text: viewDate.getFullYear()
                    font.bold: true; font.pixelSize: 16; color: "white"
                    horizontalAlignment: Text.AlignHCenter; width: 40
                }
                RoundButton {
                    flat: true; width: 30; height: 30
                    contentItem: Text { text: "►"; color: "white"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    background: Item {}
                    onClicked: changeYear(1)
                }
            }
        }

        // Divider
        Rectangle { Layout.fillWidth: true; height: 1; color: "white"; opacity: 0.3 }

        // --- 2. DAY NAMES ---
        // Using RowLayout with fillWidth items ensures perfectly equal spacing matching the grid
        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: ["S", "M", "T", "W", "T", "F", "S"]
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 20
                    Text { anchors.centerIn: parent; text: modelData; color: "white"; font.pixelSize: 11; font.bold: true; opacity: 0.7 }
                }
            }
        }

        // --- 3. CALENDAR GRID ---
        GridLayout {
            columns: 7; rowSpacing: 2; columnSpacing: 0
            Layout.fillWidth: true // Stretch to full width

            Repeater {
                model: 42
                Item {
                    // Each cell takes equal width
                    Layout.fillWidth: true; Layout.preferredHeight: 34

                    property int dayOffset: index - firstDayOfMonth(viewDate.getMonth(), viewDate.getFullYear())
                    property int currentDay: dayOffset + 1
                    property bool isValid: currentDay > 0 && currentDay <= daysInMonth(viewDate.getMonth(), viewDate.getFullYear())
                    property bool isSelected: isValid &&
                                              selectedDate.getDate() === currentDay &&
                                              selectedDate.getMonth() === viewDate.getMonth() &&
                                              selectedDate.getFullYear() === viewDate.getFullYear()

                    // The Circle (Centered in the cell)
                    Rectangle {
                        anchors.centerIn: parent
                        width: 30; height: 30; radius: 15
                        color: parent.isSelected ? "white" : "transparent"
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.isValid ? parent.currentDay : ""
                        color: parent.isSelected ? "#333333" : "white"
                        font.bold: parent.isSelected
                        opacity: parent.isValid ? 1.0 : 0.0
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: parent.isValid
                        onClicked: {
                            var newDate = new Date(viewDate.getFullYear(), viewDate.getMonth(), parent.currentDay)
                            root.selectedDate = newDate
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
