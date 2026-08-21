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
    property var itemConfig: ({})
    property int itemId: -1

    function openWithData(type, name, config, id) {
        itemType = type; itemName = name; itemConfig = config; itemId = id;
        itemDesc = (config && config.desc) ? config.desc : "";
        open();
    }

    Rectangle {
        anchors.fill: parent; radius: 20; color: accentColor; border.width: 4; border.color: "white"

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 15

            // HEADER
            Text {
                text: "DETAILS";
                font.family: theme.mainFont; font.weight: theme.fontWeightExtraBold; font.pixelSize: theme.fontSizeH3;
                color: "white"; Layout.alignment: Qt.AlignHCenter
            }
            Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

            // --- CONTENT (Directly in Layout now) ---

            // 1. TITLE
            Text {
                text: itemName;
                color: "white"
                font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeH3;

                Layout.fillWidth: true          // Fill space
                horizontalAlignment: Text.AlignHCenter // Center text
                elide: Text.ElideRight          // Handle "Very Long Title..."
            }

            // 2. DESCRIPTION
            Text {
                visible: itemDesc !== ""
                text: itemDesc;
                color: "white"; opacity: 0.8;
                font.family: theme.mainFont; font.pixelSize: theme.fontSizeSmall

                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap             // Wrap long descriptions
                maximumLineCount: 3             // Limit height
                elide: Text.ElideRight
            }

            // 3. RINGTONE
            Text {
                visible: itemConfig && itemConfig.mainRingtone !== undefined && itemConfig.mainRingtone !== ""
                text: "🎵 " + (itemConfig.mainRingtone ? itemConfig.mainRingtone.split("/").pop() : "")
                font.family: theme.mainFont; font.pixelSize: theme.fontSizeSmall; color: "white";

                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle         // "song...name.mp3"
            }

            Item { Layout.fillHeight: true }

            // --- ACTION BUTTONS ---
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 20

                RoundButton {
                    width: 50; icon: "delete"; color: "#FF6B6B"; iconColor: "white";
                    onClicked: {
                        if(itemType === "alarm") engine.deleteAlarm(itemId);
                        else engine.deleteTimer(itemId);
                        popup.close();
                    }
                }

                RoundButton {
                    width: 50; icon: "edit"; color: "#E9E9E9"; iconColor: accentColor;
                    onClicked: {
                        popup.close();
                        var data = { id: itemId, name: itemName, config: itemConfig };
                        if(itemType === "alarm") addAlarmOverlay.openForEdit(data);
                        else addTimerOverlay.openForEdit(data);
                    }
                }
            }
        }
    }
}
