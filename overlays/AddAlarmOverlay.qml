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

    property int editId: -1 // CRITICAL
    property bool isEditMode: false
    property bool isRepeat: false
    property string repeatMode: "daily"
    property var selectedDays: []
    property string selectedRingtone: ""
    property string selectedDateString: "Today"

    function reset() {
        if (!isEditMode) {
            aName.text = ""; aDesc.text = ""; selectedRingtone = "";
            isRepeat = false; repeatMode = "daily"; selectedDays = [];
            editId = -1;
        }
    }

    // EDIT LOADING
    function openForEdit(data) {
        isEditMode = true;
        editId = data.id; // Capture ID
        aName.text = data.name || "";
        aDesc.text = data.config.desc || ""; // Read JSON
        selectedRingtone = data.config.ringtone || "";
        open();
    }

    onClosed: { isEditMode = false; reset(); }

    FileDialog {
        id: fileDialog; title: "Select Ringtone"; nameFilters: ["*.mp3","*.wav"]
        onAccepted: selectedRingtone = fileDialog.selectedFile
    }

    function toggleDay(idx) {
        var i = selectedDays.indexOf(idx);
        if (i!==-1) selectedDays.splice(i,1); else selectedDays.push(idx);
        daysRepeater.model = 7; daysRepeater.model = ["M","T","W","T","F","S","S"];
    }
    function isDaySelected(i) { return selectedDays.indexOf(i) !== -1; }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        Flickable {
            anchors.fill: parent; anchors.margins: 20; contentHeight: contentCol.height; clip: true

            ColumnLayout {
                id: contentCol
                width: parent.width; spacing: 12

                Text {
                    Layout.alignment: Qt.AlignHCenter;
                    text: isEditMode ? "EDIT ALARM" : "ADD ALARM"
                    font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white"
                }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                ColumnLayout {
                    Layout.fillWidth: true; spacing: 8
                    TextField { id: aName; Layout.fillWidth: true; placeholderText: "Alarm name"; selectByMouse: true; color: "black"; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    TextField { id: aDesc; Layout.fillWidth: true; placeholderText: "Description"; selectByMouse: true; color: "black"; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    RowLayout {
                        TextField { Layout.fillWidth: true; readOnly: true; text: selectedRingtone; placeholderText: "Ringtone"; background: Rectangle{radius:5;color:"#E9E9E9"} }
                        Button { text: "📂"; onClicked: fileDialog.open() }
                    }
                }

                TimePicker { id: aTime; theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }

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

                // // DATE PICKER BUTTON (New)
                // RowLayout {
                //     Text { text: "Date:"; color: "white" }
                //     Button { text: selectedDateString; Layout.fillWidth: true; onClicked: datePopup.open() }
                // }

                RowLayout { CheckBox { text: "Delete after ringing?"; contentItem: Text { text: "Delete after ringing?"; color: "white"; leftPadding: 10 } } }

                Item { Layout.fillHeight: true }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 40
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✕" } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✓"; color: accentColor }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                engine.addAlarm({
                                    "id": editId, // Pass ID for update
                                    "name": aName.text, "desc": aDesc.text, "ringtone": selectedRingtone,
                                    "time": aTime.hours+":"+aTime.minutes,
                                    "days": isRepeat ? (repeatMode==="daily"?"Daily":JSON.stringify(selectedDays)) : "Once"
                                });
                                popup.close();
                            }
                        }
                    }
                }
                Item { height: 10 }

            }
        }
    }

    // DATE POPUP (Add at bottom)
    Popup {
        id: datePopup; width: 300; height: 300; anchors.centerIn: parent; modal: true
        background: Rectangle { radius: 10; color: accentColor; border.color: "white" }
        contentItem: DatePicker {
            onSelectedDateChanged: { selectedDateString = selectedDate.toLocaleDateString(); datePopup.close() }
        }
    }
}
