import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../components"

Popup {
    id: popup
    width: 360; height: 720
    anchors.centerIn: parent
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {}

    property var theme
    property color accentColor
    property string mode: ""
    property bool isScheduled: false
    property string preset: "standard"
    property string selectedRingtone: ""
    property string repeatMode: "daily" // "daily" or "custom"
    property int selectedPresetIndex: -1
    property var selectedDays: [] // Array to store days

    FileDialog {
        id: fileDialog; title: "Select Ringtone"; nameFilters: ["Audio files (*.mp3 *.wav *.ogg)"]
        onAccepted: { selectedRingtone = fileDialog.selectedFile; }
    }

    // Day Toggle Logic
    function toggleDay(index) {
        var i = selectedDays.indexOf(index);
        if (i !== -1) selectedDays.splice(i, 1);
        else selectedDays.push(index);
        daysRepeater.model = 7; // Force refresh visual
        daysRepeater.model = ["M","T","W","T","F","S","S"];
    }

    function isDaySelected(index) { return selectedDays.indexOf(index) !== -1; }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        Flickable {
            anchors.fill: parent; anchors.margins: 20; contentHeight: contentCol.height; clip: true

            ColumnLayout {
                id: contentCol
                width: parent.width; spacing: 12

                Text { Layout.alignment: Qt.AlignHCenter; text: "ADD TIMER"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                // Mode Toggle
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="pomodoro"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Pomodoro"; font.bold: true; color: mode==="pomodoro"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: mode="pomodoro" }
                    }
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="custom"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Custom"; font.bold: true; color: mode==="custom"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: mode="custom" }
                    }
                }

                // Inputs
                ColumnLayout {
                    visible: mode !== ""
                    Layout.fillWidth: true; spacing: 8
                    TextField { id: tName; Layout.fillWidth: true; placeholderText: "Timer Name"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                    TextField { Layout.fillWidth: true; placeholderText: "Description"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                    TextField { Layout.fillWidth: true; placeholderText: "Alarm Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } }

                    // Ringtone
                    RowLayout {
                        Layout.fillWidth: true
                        TextField {
                            Layout.fillWidth: true; readOnly: true
                            text: selectedRingtone !== "" ? selectedRingtone : ""
                            placeholderText: "Select Ringtone"
                            background: Rectangle { radius: 5; color: "#E9E9E9" }
                        }
                        Button {
                            text: "📂" // Simple icon for file picker button
                            background: Rectangle { color: "#E9E9E9"; radius: 5 }
                            onClicked: fileDialog.open()
                        }
                    }
                }

                // POMODORO PRESETS (Restored)
                ColumnLayout {
                    visible: mode === "pomodoro"
                    Layout.fillWidth: true
                    RowLayout {
                        Rectangle { width: 70; height: 25; color: preset==="standard"?"white":"transparent"; radius: 4; border.color:"white"
                            Text { anchors.centerIn: parent; text: "Standard"; color: preset==="standard"?accentColor:"white"; font.bold: true; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: preset="standard" }
                        }
                        Rectangle { width: 70; height: 25; color: preset==="presets"?"white":"transparent"; radius: 4; border.color:"white"
                            Text { anchors.centerIn: parent; text: "Presets"; color: preset==="presets"?accentColor:"white"; font.bold: true; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: preset="presets" }
                        }
                    }

                    // FIXED PRESETS (Exclusive)
                    ColumnLayout {
                        visible: preset === "presets"
                        Repeater {
                            model: ["15 / 3 / 5", "30 / 5 / 10", "50 / 10 / 20"]
                            RowLayout {
                                spacing: 10
                                // Custom Checkbox Logic
                                Rectangle {
                                    width: 16; height: 16; radius: 8; border.color: "white"; color: "transparent"
                                    Rectangle { anchors.centerIn: parent; width: 10; height: 10; radius: 5; color: "white"; visible: selectedPresetIndex === index }
                                    MouseArea { anchors.fill: parent; onClicked: selectedPresetIndex = index }
                                }
                                Text { text: modelData; color: "white" }
                            }
                        }
                    }
                }

                // Custom Duration UI
                ColumnLayout {
                    visible: mode === "custom"
                    Layout.fillWidth: true

                    // Cycle Type
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["Work", "Break", "L. Break"]
                            Rectangle { width: 70; height: 30; radius: 5; color: "#E9E9E9"; border.color: "white"
                                Text { anchors.centerIn: parent; text: modelData; color: accentColor; font.bold: true }
                            }
                        }
                    }

                    // Hour Toggle
                    CheckBox {
                        id: showHoursCheck
                        text: "Show Hours"; checked: true
                        contentItem: Text { text: "Show Hours"; color: "white"; leftPadding: 25 }
                    }

                    // DURATION PICKER (HH:MM:SS)
                    TimePicker { theme: popup.theme; isDuration: true; Layout.alignment: Qt.AlignHCenter }
                }

                // Schedule
                RowLayout {
                    visible: mode !== ""; CheckBox { id: scheduleCheck; checked: isScheduled; onCheckedChanged: isScheduled = checked }
                    Text { text: "Schedule (Alarm)"; color: "white"; font.bold: true }
                }

                // Alarm Settings
                ColumnLayout {
                    visible: isScheduled && mode !== ""
                    Layout.fillWidth: true

                    // TIME PICKER (AM/PM)
                    TimePicker { theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }

                    RowLayout {
                        Text { text: "Date:"; color: "white" }
                        TextField { Layout.fillWidth: true; placeholderText: "Today"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                    }

                    // Repeat Toggle
                    RowLayout {
                        Text { text: "Repeat:"; color: "white"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Row {
                            Rectangle { width: 60; height: 25; color: repeatMode==="daily"?"white":"transparent"; radius: 4; border.color:"white"
                                Text { anchors.centerIn: parent; text: "Daily"; color: repeatMode==="daily"?accentColor:"white"; font.bold: true }
                                MouseArea { anchors.fill: parent; onClicked: repeatMode="daily" }
                            }
                            Rectangle { width: 60; height: 25; color: repeatMode==="custom"?"white":"transparent"; radius: 4; border.color:"white"
                                Text { anchors.centerIn: parent; text: "Custom"; color: repeatMode==="custom"?accentColor:"white" }
                                MouseArea { anchors.fill: parent; onClicked: repeatMode="custom" }
                            }
                        }
                    }

                    // Days (Visible only if Custom)
                    RowLayout {
                        visible: repeatMode === "custom"
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            id: daysRepeater
                            model: ["M","T","W","T","F","S","S"]
                            Rectangle {
                                width: 30; height: 30; radius: 15
                                // Visual State based on array
                                color: isDaySelected(index) ? "white" : "transparent"; border.color: "white"
                                Text { anchors.centerIn: parent; text: modelData; color: isDaySelected(index) ? accentColor : "white"; font.bold: true }
                                MouseArea { anchors.fill: parent; onClicked: toggleDay(index) }
                            }
                        }
                    }
                }

                // Buttons (Using SVGs)
                Item { Layout.fillHeight: true }
                RowLayout {
                    visible: mode !== ""
                    Layout.alignment: Qt.AlignHCenter; spacing: 30
                    RoundButton { icon: "close"; color: "#E9E9E9"; iconColor: "#797979"; onClicked: popup.close() }
                    RoundButton { icon: "check"; color: "#E9E9E9"; iconColor: accentColor;
                        onClicked: { engine.addTimer({name: tName.text}); popup.close() }
                    }
                }
                Item { height: 10 }
            }
        }
    }
}
