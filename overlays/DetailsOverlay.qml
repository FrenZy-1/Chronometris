import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Popup {
    id: popup
    width: 320; height: 350
    anchors.centerIn: parent
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {}

    property var theme
    property color accentColor

    // Data passed from Double Click
    property string itemType: "alarm"
    property string itemName: ""
    property string itemTime: ""

    function openWithData(type, name, time) {
        itemType = type; itemName = name; itemTime = time;
        open();
    }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 15

            Text { text: "DETAILS"; font.bold: true; font.pixelSize: 24; color: "white"; Layout.alignment: Qt.AlignHCenter }
            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            Column {
                Layout.alignment: Qt.AlignHCenter; spacing: 5
                Text { text: itemName; font.bold: true; font.pixelSize: 20; color: "white"; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: itemDesc; font.pixelSize: 14; color: "white"; opacity: 0.8; anchors.horizontalCenter: parent.horizontalCenter }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 20
                RoundButton { width: 50; icon: "delete"; color: "#FF6B6B"; iconColor: "white"; onClicked: popup.close() }

                RoundButton {
                    width: 50; icon: "edit"; color: "#E9E9E9"; iconColor: accentColor;
                    onClicked: {
                        popup.close();
                        if(itemType === "alarm") {
                            // Open Alarm Overlay with data
                            // addAlarmOverlay.openForEdit(...)
                            addAlarmOverlay.open();
                        } else {
                            // OPEN TIMER OVERLAY IN EDIT MODE
                            addTimerOverlay.openForEdit({name: itemName, desc: "Edited Timer"});
                        }
                    }
                }
            }
        }
    }
}
