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

    // --- STATE VARIABLES ---
    property bool isEditMode: false
    property int editId: -1 // CRITICAL FOR UPDATES

    property string mode: "" // "pomodoro" or "custom"
    property bool isScheduled: false
    property string preset: "standard" // "standard" or "presets"
    property int selectedPresetIndex: 0

    property string mainRingtone: ""
    property string schedRingtone: ""

    property bool isRepeat: false
    property string repeatMode: "daily"
    property var selectedDays: []

    // Custom Durations
    property string activeCycleType: "work"
    property var durationMap: ({ "work": 1500, "break": 300, "long": 900 })

    // --- RESET LOGIC ---
    function reset() {
        if (!isEditMode) {
            tName.text = ""; tDesc.text = "";
            mainRingtone = ""; schedRingtone = "";
            mode = ""; preset = "standard"; selectedPresetIndex = 0;
            isScheduled = false; isRepeat = false; repeatMode = "daily";
            selectedDays = [];
            durationMap = ({ "work": 1500, "break": 300, "long": 900 });
            editId = -1;
        }
    }

    // --- EDIT LOADING ---
    function openForEdit(data) {
        isEditMode = true;
        editId = data.id; // Capture ID
        tName.text = data.name || "";
        tDesc.text = data.config.desc || ""; // Read from config
        // In a full implementation, you would parse data.config to fill the rest
        // For now, we open in custom mode to allow modification
        mode = "custom";
        open();
    }

    onClosed: { isEditMode = false; reset(); }

    // --- HELPERS ---
    function updateDurationFromPicker() {
        var secs = (customPicker.hours * 3600) + (customPicker.minutes * 60) + customPicker.seconds
        var map = durationMap; map[activeCycleType] = secs; durationMap = map;
    }

    function loadPickerFromMap(type) {
        activeCycleType = type
        var secs = durationMap[type]
        customPicker.hours = Math.floor(secs / 3600)
        customPicker.minutes = Math.floor((secs % 3600) / 60)
        customPicker.seconds = secs % 60
    }

    FileDialog {
        id: fileDialog; title: "Select Ringtone"; nameFilters: ["Audio files (*.mp3 *.wav *.ogg)"]
        property int target: 0
        onAccepted: { if (target === 0) mainRingtone = selectedFile; else schedRingtone = selectedFile; }
    }

    function toggleDay(index) {
        var i = selectedDays.indexOf(index);
        if (i !== -1) selectedDays.splice(i, 1); else selectedDays.push(index);
        daysRepeater.model = 7; daysRepeater.model = ["M","T","W","T","F","S","S"];
    }
    function isDaySelected(index) { return selectedDays.indexOf(index) !== -1; }

    // --- UI CONTENT ---
    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        Flickable {
            anchors.fill: parent; anchors.margins: 20; contentHeight: contentCol.height; clip: true

            ColumnLayout {
                id: contentCol
                width: parent.width; spacing: 12

                Text {
                    Layout.alignment: Qt.AlignHCenter;
                    text: isEditMode ? "EDIT TIMER" : "ADD TIMER";
                    font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white"
                }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                // --- 1. MODE TOGGLE ---
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 10
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="pomodoro"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Pomodoro"; font.bold: true; color: mode==="pomodoro"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: mode="pomodoro" }
                    }
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="custom"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Custom"; font.bold: true; color: mode==="custom"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: { mode="custom"; loadPickerFromMap("work"); } }
                    }
                }

                // --- 2. MAIN INPUTS ---
                ColumnLayout {
                    visible: mode !== ""
                    Layout.fillWidth: true; spacing: 8

                    TextField { id: tName; Layout.fillWidth: true; placeholderText: "Timer Name"; selectByMouse: true; color: "black"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                    TextField { id: tDesc; Layout.fillWidth: true; placeholderText: "Description"; selectByMouse: true; color: "black"; background: Rectangle { radius: 5; color: "#E9E9E9" } }

                    RowLayout {
                        Layout.fillWidth: true
                        TextField { Layout.fillWidth: true; readOnly: true; text: mainRingtone; placeholderText: "Timer Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                        Button { text: "📂"; onClicked: { fileDialog.target=0; fileDialog.open(); } }
                    }
                }

                // --- 3. POMODORO UI (Here are your missing buttons!) ---
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

                    // Presets List
                    ColumnLayout {
                        visible: preset === "presets"
                        Repeater {
                            model: ["15 / 3 / 5", "30 / 5 / 10", "50 / 10 / 20"]
                            RowLayout {
                                spacing: 10
                                Rectangle { width: 16; height: 16; radius: 8; border.color: "white"; color: "transparent"
                                    Rectangle { anchors.centerIn: parent; width: 10; height: 10; radius: 5; color: "white"; visible: selectedPresetIndex === index }
                                    MouseArea { anchors.fill: parent; onClicked: selectedPresetIndex = index }
                                }
                                Text { text: modelData; color: "white" }
                            }
                        }
                    }

                    Text { visible: preset==="standard"; text: "Standard Cycle (25/5/15)"; color: "white" }
                }

                // --- 4. CUSTOM UI ---
                ColumnLayout {
                    visible: mode === "custom"
                    Layout.fillWidth: true

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["Work", "Break", "Long"]
                            Rectangle {
                                width: 70; height: 30; radius: 5;
                                color: (index===0 && activeCycleType==="work") || (index===1 && activeCycleType==="break") || (index===2 && activeCycleType==="long") ? "#E9E9E9" : "transparent";
                                border.color: "white"
                                Text { anchors.centerIn: parent; text: modelData; color: parent.color==="#E9E9E9" ? accentColor : "white"; font.bold: true }
                                MouseArea {
                                    anchors.fill: parent;
                                    onClicked: { updateDurationFromPicker(); var t=["work","break","long"]; loadPickerFromMap(t[index]); }
                                }
                            }
                        }
                    }

                    CheckBox { id: showHoursCheck; text: "Show Hours"; checked: true; contentItem: Text { text: "Show Hours"; color: "white"; leftPadding: 25 } }

                    TimePicker {
                        id: customPicker; theme: popup.theme; isDuration: true; showHours: showHoursCheck.checked; Layout.alignment: Qt.AlignHCenter
                        onHoursChanged: updateDurationFromPicker()
                        onMinutesChanged: updateDurationFromPicker()
                        onSecondsChanged: updateDurationFromPicker()
                    }
                }

                // --- 5. SCHEDULE ---
                RowLayout {
                    visible: mode !== ""; CheckBox { id: scheduleCheck; checked: isScheduled; onCheckedChanged: isScheduled = checked }
                    Text { text: "Schedule (Alarm)"; color: "white"; font.bold: true }
                }

                ColumnLayout {
                    visible: isScheduled && mode !== ""
                    Layout.fillWidth: true

                    TimePicker { id: alarmPicker; theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }

                    RowLayout {
                        Layout.fillWidth: true
                        TextField { Layout.fillWidth: true; readOnly: true; text: schedRingtone; placeholderText: "Alarm Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                        Button { text: "📂"; onClicked: { fileDialog.target=1; fileDialog.open(); } }
                    }

                    RowLayout { Text { text: "Date:"; color: "white" } TextField { Layout.fillWidth: true; placeholderText: "Today"; background: Rectangle { radius: 5; color: "#E9E9E9" } } }

                    RowLayout { CheckBox { id: repeatCheck; checked: isRepeat; onCheckedChanged: isRepeat = checked } Text { text: "Repeat"; color: "white"; font.bold: true } }

                    ColumnLayout {
                        visible: isRepeat
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Rectangle { width: 60; height: 25; color: repeatMode==="daily"?"white":"transparent"; radius: 4; border.color:"white"; Text{anchors.centerIn:parent;text:"Daily";color:parent.color=="white"?accentColor:"white"} MouseArea{anchors.fill:parent;onClicked:repeatMode="daily"} }
                            Rectangle { width: 60; height: 25; color: repeatMode==="custom"?"white":"transparent"; radius: 4; border.color:"white"; Text{anchors.centerIn:parent;text:"Custom";color:parent.color=="white"?accentColor:"white"} MouseArea{anchors.fill:parent;onClicked:repeatMode="custom"} }
                        }
                        RowLayout {
                            visible: repeatMode === "custom"
                            Layout.alignment: Qt.AlignHCenter
                            Repeater {
                                id: daysRepeater; model: ["M","T","W","T","F","S","S"]
                                Rectangle {
                                    width: 30; height: 30; radius: 15
                                    color: isDaySelected(index) ? "white" : "transparent"; border.color: "white"
                                    Text { anchors.centerIn: parent; text: modelData; color: isDaySelected(index) ? accentColor : "white"; font.bold: true }
                                    MouseArea { anchors.fill: parent; onClicked: toggleDay(index) }
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // --- 6. ACTION BUTTONS ---
                RowLayout {
                    visible: mode !== ""
                    Layout.alignment: Qt.AlignHCenter; spacing: 30
                    Rectangle {
                        width: 50; height: 50; radius: 25; color: "#E9E9E9"
                        Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#797979" }
                        MouseArea { anchors.fill: parent; onClicked: popup.close() }
                    }
                    Rectangle {
                        width: 50; height: 50; radius: 25; color: "#E9E9E9"
                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 24; color: accentColor; font.bold: true }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                updateDurationFromPicker();
                                // CONSTRUCT FULL DATA
                                var data = {
                                    "id": editId, // -1 for New, >0 for Update
                                    "name": tName.text, "desc": tDesc.text, "mode": mode,
                                    "durations": durationMap, "isScheduled": isScheduled,
                                    "mainRingtone": mainRingtone, "schedRingtone": schedRingtone
                                };
                                engine.addTimer(data);

                                if(!isScheduled) engine.loadAndStartSession(data);
                                popup.close()
                            }
                        }
                    }
                }
                Item { height: 10 }
            }
        }
    }
}
