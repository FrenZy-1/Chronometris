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

    // State
    property bool isEditMode: false
    property int editId: -1
    property string mode: ""
    property bool isScheduled: false
    property string preset: "standard"
    property int selectedPresetIndex: 0
    property string mainRingtone: ""
    property string schedRingtone: ""
    property bool isRepeat: false
    property string repeatMode: "daily"
    property var selectedDays: []

    // Custom Durations
    property string activeCycleType: "work"
    property var durationMap: ({ "work": 1500, "break": 300, "long": 900 })
    property string selectedDateString: "Today" // Date Picker Text

    // --- LOGIC ---
    function reset() {
        if (!isEditMode) {
            tName.text = ""; tDesc.text = ""; mainRingtone = ""; schedRingtone = "";
            mode = ""; preset = "standard"; selectedPresetIndex = 0;
            isScheduled = false; isRepeat = false; repeatMode = "daily"; selectedDays = [];
            durationMap = ({ "work": 1500, "break": 300, "long": 900 });
            editId = -1; selectedDateString = "Today";
            // RESET PICKER TO 0 so it doesn't default to 12h
            customPicker.hours = 0; customPicker.minutes = 25; customPicker.seconds = 0;
        }
    }

    function openForEdit(data) {
        isEditMode = true;
        editId = data.id;
        tName.text = data.name || "";
        tDesc.text = data.config.desc || "";
        // Read mode from config to open correct tab
        mode = data.config.mode || "custom";
        if (mode === "custom" && data.config.durations) durationMap = data.config.durations;
        open();
    }
    onClosed: { isEditMode = false; reset(); }

    function applyPomodoroPreset(index) {
        selectedPresetIndex = index;
        if (index === 0) durationMap = ({ "work": 900, "break": 180, "long": 300 }); // 15/3/5
        else if (index === 1) durationMap = ({ "work": 1800, "break": 300, "long": 600 }); // 30/5/10
        else durationMap = ({ "work": 3000, "break": 600, "long": 1200 }); // 50/10/20
    }

    function updateDurationFromPicker() {
        if (mode === "custom") {
            var secs = (customPicker.hours * 3600) + (customPicker.minutes * 60) + customPicker.seconds;
            var map = durationMap; map[activeCycleType] = secs; durationMap = map;
        }
    }

    // --- UI ---
    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"
        Flickable {
            anchors.fill: parent; anchors.margins: 20; contentHeight: contentCol.height; clip: true
            ColumnLayout {
                id: contentCol; width: parent.width; spacing: 12
                Text { Layout.alignment: Qt.AlignHCenter; text: isEditMode ? "EDIT TIMER" : "ADD TIMER"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                // Mode Toggle
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 10
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="pomodoro"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Pomodoro"; font.bold: true; color: mode==="pomodoro"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: { mode="pomodoro"; durationMap=({ "work": 1500, "break": 300, "long": 900 }); } }
                    }
                    Rectangle { width: 100; height: 35; radius: 5; color: mode==="custom"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Custom"; font.bold: true; color: mode==="custom"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: mode="custom" }
                    }
                }

                // Inputs
                ColumnLayout {
                    visible: mode !== ""; Layout.fillWidth: true; spacing: 8
                    TextField { id: tName; Layout.fillWidth: true; placeholderText: "Timer Name"; selectByMouse: true; color: "black"; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    TextField { id: tDesc; Layout.fillWidth: true; placeholderText: "Description"; selectByMouse: true; color: "black"; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    RowLayout { TextField { Layout.fillWidth: true; readOnly: true; text: mainRingtone; placeholderText: "Timer Ringtone"; background: Rectangle{radius:5;color:"#E9E9E9"} } Button { text: "📂"; onClicked: {fileDialog.target=0;fileDialog.open()} } }
                }

                // Pomodoro
                ColumnLayout {
                    visible: mode === "pomodoro"; Layout.fillWidth: true
                    RowLayout {
                        Rectangle { width: 70; height: 25; color: preset==="standard"?"white":"transparent"; radius: 4; border.color:"white"; Text{anchors.centerIn:parent;text:"Standard";color:preset==="standard"?accentColor:"white"} MouseArea{anchors.fill:parent;onClicked:{preset="standard"; durationMap=({ "work": 1500, "break": 300, "long": 900 }); }} }
                        Rectangle { width: 70; height: 25; color: preset==="presets"?"white":"transparent"; radius: 4; border.color:"white"; Text{anchors.centerIn:parent;text:"Presets";color:preset==="presets"?accentColor:"white"} MouseArea{anchors.fill:parent;onClicked:preset="presets"} }
                    }
                    ColumnLayout {
                        visible: preset === "presets"
                        Repeater {
                            model: ["15 / 3 / 5", "30 / 5 / 10", "50 / 10 / 20"]
                            RowLayout { spacing: 10
                                Rectangle { width: 16; height: 16; radius: 8; border.color: "white"; color: "transparent"; Rectangle{anchors.centerIn:parent;width:10;height:10;radius:5;color:"white";visible:selectedPresetIndex===index} MouseArea{anchors.fill:parent;onClicked:applyPomodoroPreset(index)} }
                                Text { text: modelData; color: "white" }
                            }
                        }
                    }
                }

                // Custom
                ColumnLayout {
                    visible: mode === "custom"; Layout.fillWidth: true
                    RowLayout { Layout.alignment: Qt.AlignHCenter
                        Repeater { model: ["Work", "Break", "Long"]; Rectangle { width: 70; height: 30; radius: 5; color: (index===0&&activeCycleType==="work"||index===1&&activeCycleType==="break"||index===2&&activeCycleType==="long")?"#E9E9E9":"transparent"; border.color:"white"; Text{anchors.centerIn:parent;text:modelData;color:parent.color=="#E9E9E9"?accentColor:"white"} MouseArea{anchors.fill:parent;onClicked:{updateDurationFromPicker(); var t=["work","break","long"]; activeCycleType=t[index];}} } }
                    }
                    CheckBox { id: showHoursCheck; text: "Show Hours"; checked: true }
                    TimePicker { id: customPicker; theme: popup.theme; isDuration: true; showHours: showHoursCheck.checked; Layout.alignment: Qt.AlignHCenter; onHoursChanged: updateDurationFromPicker(); onMinutesChanged: updateDurationFromPicker(); onSecondsChanged: updateDurationFromPicker() }
                }

                // Schedule
                RowLayout { visible: mode!==""; CheckBox { id: scheduleCheck; checked: isScheduled; onCheckedChanged: isScheduled=checked } Text { text: "Schedule (Alarm)"; color: "white"; font.bold: true } }
                ColumnLayout {
                    visible: isScheduled && mode!==""; Layout.fillWidth: true
                    TimePicker { id: alarmPicker; theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }
                    RowLayout { TextField { Layout.fillWidth: true; readOnly: true; text: schedRingtone; placeholderText: "Alarm Ringtone"; background: Rectangle{radius:5;color:"#E9E9E9"} } Button { text: "📂"; onClicked: {fileDialog.target=1;fileDialog.open()} } }

                    // DATE PICKER BUTTON
                    RowLayout {
                        Text { text: "Date:"; color: "white" }
                        Button {
                            text: selectedDateString; Layout.fillWidth: true
                            onClicked: datePopup.open()
                        }
                    }

                    RowLayout { CheckBox { id: repeatCheck; checked: isRepeat; onCheckedChanged: isRepeat=checked } Text { text: "Repeat"; color: "white"; font.bold: true } }

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
                // Save
                RowLayout {
                    visible: mode !== ""; Layout.alignment: Qt.AlignHCenter; spacing: 30
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✕" } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✓"; color: accentColor }
                        MouseArea { anchors.fill: parent; onClicked: {
                            updateDurationFromPicker();
                            var data = { "id":editId, "name":tName.text, "desc":tDesc.text, "mode":mode, "durations":durationMap, "isScheduled":isScheduled, "mainRingtone":mainRingtone, "schedRingtone":schedRingtone };
                            engine.addTimer(data);
                            if(!isScheduled) engine.loadAndStartSession(data);
                            popup.close();
                        } }
                    }
                }
                Item { height: 10 }
            }
        }
    }

    // DATE POPUP
    Popup {
        id: datePopup; width: 300; height: 300; anchors.centerIn: parent; modal: true
        background: Rectangle { radius: 10; color: accentColor; border.color: "white" }
        contentItem: DatePicker {
            onSelectedDateChanged: { selectedDateString = selectedDate.toLocaleDateString(); datePopup.close() }
        }
    }
    FileDialog { id: fileDialog; title: "Select Ringtone"; nameFilters: ["*.mp3, *.wav"]; property int target: 0; onAccepted: target===0?mainRingtone=selectedFile:schedRingtone=selectedFile }
}
