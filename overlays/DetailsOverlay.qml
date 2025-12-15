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

    // Data Properties
    property string itemType: "alarm"
    property string itemName: ""
    property string itemDesc: ""
    property var itemConfig: ({}) // Store the full config object
    property int itemId: -1       // Store the Database ID

    // --- OPEN FUNCTION (MATCHING MAIN.QML SIGNAL) ---
    function openWithData(type, name, config, id) {
        itemType = type;
        itemName = name;
        itemConfig = config; // Save config for editing later
        itemId = id;         // Save ID for editing/deleting

        // Extract description safely
        if (config && config.desc) itemDesc = config.desc;
        else itemDesc = "";

        open();
    }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 15

            Text {
                text: "DETAILS";
                font.family: "Montserrat"; font.weight: Font.ExtraBold; font.pixelSize: 24;
                color: "white"; Layout.alignment: Qt.AlignHCenter
            }
            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            Column {
                Layout.alignment: Qt.AlignHCenter; spacing: 5

                Text {
                    text: itemName;
                    font.family: "Montserrat"; font.bold: true; font.pixelSize: 20;
                    color: "white"; anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: itemDesc;
                    font.family: "Montserrat"; font.pixelSize: 14;
                    color: "white"; opacity: 0.8; anchors.horizontalCenter: parent.horizontalCenter;
                    wrapMode: Text.Wrap; width: 250; horizontalAlignment: Text.AlignHCenter
                }

                // Show Ringtones if present
                Text {
                    visible: itemConfig.mainRingtone !== undefined && itemConfig.mainRingtone !== ""
                    text: "🎵 " + (itemConfig.mainRingtone ? itemConfig.mainRingtone.split("/").pop() : "")
                    font.pixelSize: 10; color: "white"; anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item { Layout.fillHeight: true }

            // --- ACTION BUTTONS ---
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 20

                // DELETE BUTTON
                RoundButton {
                    width: 50; icon: "delete"; color: "#FF6B6B"; iconColor: "white";
                    onClicked: {
                        if(itemType === "alarm") engine.deleteAlarm(itemId);
                        else engine.deleteTimer(itemId);
                        popup.close();
                    }
                }

                // EDIT BUTTON
                RoundButton {
                    width: 50; icon: "edit"; color: "#E9E9E9"; iconColor: accentColor;
                    onClicked: {
                        popup.close();
                        // Construct the full data object needed by the Edit Overlay
                        var data = {
                            id: itemId,
                            name: itemName,
                            config: itemConfig // Pass the full config back
                        };

                        if(itemType === "alarm") addAlarmOverlay.openForEdit(data);
                        else addTimerOverlay.openForEdit(data);
                    }
                }
            }
        }
    }
}
