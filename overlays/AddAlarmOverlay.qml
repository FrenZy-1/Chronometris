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

    property int editId: -1
    property bool isEditMode: false
    property bool isRepeat: false
    property string repeatMode: "daily"
    property var selectedDays: []
    property string selectedRingtone: ""
    property string selectedDateString: "Today"

    function reset() {
        if (!isEditMode) {
            aName.text=""; aDesc.text=""; selectedRingtone="";
            isRepeat=false; repeatMode="daily"; selectedDays=[];
            editId=-1; selectedDateString="Today";
        }
    }

    function openForEdit(data) {
        isEditMode = true; editId = data.id;
        aName.text = data.name || "";
        aDesc.text = data.config.desc || "";
        selectedRingtone = data.config.ringtone || "";
        open();
    }
    onClosed: { isEditMode = false; reset(); }

    FileDialog { id: fileDialog; title: "Select Ringtone"; nameFilters: ["*.mp3","*.wav"]; onAccepted: selectedRingtone = fileDialog.selectedFile }

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
                id: contentCol; width: parent.width; spacing: 15

                Text {
                    Layout.alignment: Qt.AlignHCenter; text: isEditMode?"EDIT ALARM":"ADD ALARM";
                    font.family: theme.mainFont; font.weight: theme.fontWeightExtraBold; font.pixelSize: theme.fontSizeH2; color: "white"
                }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                // Inputs
                ColumnLayout { Layout.fillWidth: true; spacing: 10
                    ColumnLayout {
                        spacing: 2; Layout.fillWidth: true
                        Text { text: "Alarm Name"; color: "white"; font.pixelSize: 12; font.bold: true }
                        TextField { id: aName; Layout.fillWidth: true; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    }

                    ColumnLayout {
                        spacing: 2; Layout.fillWidth: true
                        Text { text: "Description"; color: "white"; font.pixelSize: 12; font.bold: true }
                        TextField { id: aDesc; Layout.fillWidth: true; background: Rectangle{radius:5;color:"#E9E9E9"} }
                    }

                    ColumnLayout {
                        spacing: 2; Layout.fillWidth: true
                        Text { text: "Ringtone"; color: "white"; font.pixelSize: 12; font.bold: true }
                        RowLayout {
                            TextField { Layout.fillWidth: true; readOnly: true; text: selectedRingtone; placeholderText: "None selected"; font.pixelSize: theme.fontSizeSmall; background: Rectangle{radius:5;color:"#E9E9E9"} }
                            Button { text: "📂"; onClicked: fileDialog.open() }
                        }
                    }
                }

                TimePicker { id: aTime; theme: popup.theme; isDuration: false; Layout.alignment: Qt.AlignHCenter }

                RowLayout { Text { text: "Date:"; color: "white"; font.pixelSize: theme.fontSizeBody } Button { text: selectedDateString; Layout.fillWidth: true; onClicked: datePopup.open() } }

                RowLayout { CheckBox { id: repeatCheck; checked: isRepeat; onCheckedChanged: isRepeat=checked } Text { text: "Repeat"; color: "white"; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody } }

                ColumnLayout {
                    visible: isRepeat
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Rectangle {
                            width: 60; height: 25; radius: 4; border.color: "white"
                            color: repeatMode==="daily" ? "white" : "transparent"
                            Text { anchors.centerIn: parent; text: "Daily"; font.pixelSize: 12; color: repeatMode==="daily"?"#333333":"white" }
                            MouseArea { anchors.fill: parent; onClicked: repeatMode="daily" }
                        }
                        Rectangle {
                            width: 60; height: 25; radius: 4; border.color: "white"
                            color: repeatMode==="custom" ? "white" : "transparent"
                            Text { anchors.centerIn: parent; text: "Custom"; font.pixelSize: 12; color: repeatMode==="custom"?"#333333":"white" }
                            MouseArea { anchors.fill: parent; onClicked: repeatMode="custom" }
                        }
                    }
                    RowLayout {
                        visible: repeatMode === "custom"
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            id: daysRepeater; model: ["M","T","W","T","F","S","S"]
                            Rectangle {
                                width: 30; height: 30; radius: 15; border.color: "white"
                                color: popup.isDaySelected(index) ? "white" : "transparent"
                                Text {
                                    anchors.centerIn: parent; text: modelData; font.bold: true; font.pixelSize: theme.fontSizeSmall
                                    color: popup.isDaySelected(index) ? "#333333" : "white"
                                }
                                MouseArea { anchors.fill: parent; onClicked: toggleDay(index) }
                            }
                        }
                    }
                }

                RowLayout { CheckBox { text: "Delete after ringing?"; contentItem: Text { text: "Delete after ringing?"; color: "white"; font.pixelSize: theme.fontSizeSmall; leftPadding: 10 } } }

                Item { Layout.fillHeight: true }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 40
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✘"; font.pixelSize: theme.fontSizeH3 } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                    Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: theme.fontSizeH3; color: accentColor }
                        MouseArea { anchors.fill: parent; onClicked: {
                            engine.addAlarm({ "id": editId, "name": aName.text.trim()===""?"Alarm":aName.text, "desc": aDesc.text, "ringtone": selectedRingtone, "time": aTime.hours+":"+aTime.minutes, "days": isRepeat ? (repeatMode==="daily"?"Daily":JSON.stringify(selectedDays)) : "Once" });
                            popup.close();
                        } }
                    }
                }
                Item { height: 10 }
            }
        }
    }
    Popup { id: datePopup; width: 300; height: 360; anchors.centerIn: parent; modal: true
        background: Rectangle { radius: 10; color: accentColor; border.color: "white" }
        contentItem: DatePicker { onSelectedDateChanged: { selectedDateString = selectedDate.toLocaleDateString(); datePopup.close() } }
    }
}
