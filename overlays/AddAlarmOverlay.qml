import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Popup {
    id: popup
    width: 360; height: 650
    anchors.centerIn: parent
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {}

    property var theme
    property color accentColor
    property string repeatMode: "daily"
    property var selectedDays: []

    // Toggle Day Logic
    function toggleDay(day) {
        var idx = selectedDays.indexOf(day);
        if (idx >= 0) selectedDays.splice(idx, 1);
        else selectedDays.push(day);
        daysRepeater.model = selectedDays; // Force refresh logic if needed
    }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 12

            Text { Layout.alignment: Qt.AlignHCenter; text: "ADD ALARM"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            ColumnLayout {
                Layout.fillWidth: true; spacing: 8
                RowLayout { Text { text: "Name:"; color: "white"; font.bold: true; Layout.preferredWidth: 80 } TextField { id: aName; Layout.fillWidth: true; placeholderText: "Alarm name"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }
                RowLayout { Text { text: "Desc:"; color: "white"; font.bold: true; Layout.preferredWidth: 80 } TextField { Layout.fillWidth: true; placeholderText: "Description"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }
                RowLayout {
                    Layout.fillWidth: true
                    TextField { Layout.fillWidth: true; placeholderText: "Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                    Button { text: "📂"; onClicked: fileDialog.open() } // Use FileDialog logic
                }
            }

            // TIME PICKER (AM/PM)
            TimePicker { theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }

            // Repeat Toggle
            RowLayout {
                Text { text: "Repeat?"; color: "white"; font.bold: true }
                Item { Layout.fillWidth: true }
                Row {
                    Rectangle { width: 70; height: 30; color: repeatMode==="daily"?"white":"transparent"; radius: 4; border.color:"white"
                        Text { anchors.centerIn: parent; text: "Daily"; color: repeatMode==="daily"?accentColor:"white"; font.bold: true }
                        MouseArea { anchors.fill: parent; onClicked: repeatMode="daily" }
                    }
                    Rectangle { width: 70; height: 30; color: repeatMode==="custom"?"white":"transparent"; radius: 4; border.color:"white"
                        Text { anchors.centerIn: parent; text: "Custom"; color: repeatMode==="custom"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: repeatMode="custom" }
                    }
                }
            }

            // Days (Hidden if Daily)
            RowLayout {
                visible: repeatMode === "custom"
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    id: daysRepeater
                    model: ["M","T","W","T","F","S","S"]
                    Rectangle {
                        width: 30; height: 30; radius: 15
                        // Check if day is selected (simple mock logic for visual)
                        property bool isSelected: false
                        color: isSelected ? "white" : "transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: modelData; color: parent.isSelected ? accentColor : "white" }
                        MouseArea { anchors.fill: parent; onClicked: parent.isSelected = !parent.isSelected }
                    }
                }
            }

            // DELETE CHECKBOX
            RowLayout {
                CheckBox { text: "Delete after ringing?"; contentItem: Text { text: "Delete after ringing?"; color: "white"; leftPadding: 25 } }
            }

            // Buttons (Delete + Cancel + Check)
            Item { Layout.fillHeight: true }
            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillHeight: true }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 40

                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✕" } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✓"; color: accentColor } MouseArea { anchors.fill: parent; onClicked: { engine.addAlarm({}); popup.close() } } }
                }
            }
            Item { height: 10 }
        }
    }
}
