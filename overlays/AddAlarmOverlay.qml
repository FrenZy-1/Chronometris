import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
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
    property string selectedRingtone: ""

    // Native File Picker
    FileDialog {
        id: fileDialog
        title: "Select Ringtone"
        nameFilters: ["Audio files (*.mp3 *.wav *.ogg)"]
        onAccepted: { selectedRingtone = fileDialog.selectedFile; }
    }

    // Toggle Day Logic
    function toggleDay(day) {
        var idx = selectedDays.indexOf(day);
        if (idx >= 0) selectedDays.splice(idx, 1);
        else selectedDays.push(day);
        daysRepeater.model = 7; // reset
        daysRepeater.model = ["M","T","W","T","F","S","S"]; // refresh
    }

    function isDaySelected(index) { return selectedDays.indexOf(index) !== -1; }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        Flickable {
            anchors.fill: parent; anchors.margins: 20; contentHeight: contentCol.height; clip: true

            ColumnLayout {
                id: contentCol
                width: parent.width; spacing: 12

                Text { Layout.alignment: Qt.AlignHCenter; text: "ADD ALARM"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                ColumnLayout {
                    Layout.fillWidth: true; spacing: 8
                    // INPUTS FIXED
                    TextField {
                        id: aName; Layout.fillWidth: true; placeholderText: "Alarm name";
                        selectByMouse: true; color: "black"; background: Rectangle { radius: 5; color: "#E9E9E9" }
                    }
                    TextField {
                        Layout.fillWidth: true; placeholderText: "Description";
                        selectByMouse: true; color: "black"; background: Rectangle { radius: 5; color: "#E9E9E9" }
                    }
                    // Ringtone Row
                    RowLayout {
                        Layout.fillWidth: true
                        TextField {
                            Layout.fillWidth: true; readOnly: true
                            text: selectedRingtone !== "" ? selectedRingtone : ""
                            placeholderText: "Ringtone"
                            background: Rectangle { radius: 5; color: "#E9E9E9" }
                        }
                        Button {
                            text: "📂"
                            background: Rectangle { color: "#E9E9E9"; radius: 5 }
                            onClicked: fileDialog.open()
                        }
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
                            color: isDaySelected(index) ? "white" : "transparent"; border.color: "white"
                            Text { anchors.centerIn: parent; text: modelData; color: isDaySelected(index) ? accentColor : "white"; font.bold: true }
                            MouseArea { anchors.fill: parent; onClicked: toggleDay(index) }
                        }
                    }
                }

                // DELETE CHECKBOX (Replaces Trashcan Icon)
                RowLayout {
                    CheckBox {
                        text: "Delete after ringing?"
                        contentItem: Text { text: "Delete after ringing?"; color: "white"; leftPadding: 10; font.pixelSize: 14 }
                    }
                }

                // Buttons (Cancel + Check)
                Item { Layout.fillHeight: true }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 40
                    Rectangle {
                        width: 50; height: 50; radius: 25; color: "#E9E9E9";
                        Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#797979" }
                        MouseArea { anchors.fill: parent; onClicked: popup.close() }
                    }
                    Rectangle {
                        width: 50; height: 50; radius: 25; color: "#E9E9E9";
                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 24; color: accentColor; font.bold: true }
                        MouseArea { anchors.fill: parent; onClicked: { engine.addAlarm({name: aName.text}); popup.close() } }
                    }
                }
                Item { height: 10 }
            }
        }
    }
}
