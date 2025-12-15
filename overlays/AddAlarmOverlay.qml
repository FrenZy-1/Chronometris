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
            }

            // Time Picker
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 10
                Rectangle { width: 80; height: 90; radius: 8; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "AM"; font.pixelSize: 32 } }
                Rectangle { width: 80; height: 90; radius: 8; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "07"; font.pixelSize: 48 } }
                Rectangle { width: 80; height: 90; radius: 8; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "30"; font.pixelSize: 48 } }
            }

            // Repeat Toggle (Double Button)
            RowLayout {
                Text { text: "Repeat?"; color: "white"; font.bold: true }
                Item { Layout.fillWidth: true }
                Row {
                    Rectangle { width: 70; height: 30; color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Daily"; color: accentColor; font.bold: true } }
                    Rectangle { width: 70; height: 30; color: "transparent"; border.color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Custom"; color: "white" } }
                }
            }

            // Days
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 5
                Repeater {
                    model: ["M","T","W","T","F","S","S"]
                    Rectangle { width: 35; height: 35; radius: 5; color: index<5?"#E9E9E9":accentColor; border.color: "white"; border.width: index<5?0:1; Text { anchors.centerIn: parent; text: modelData; color: index<5?accentColor:"white"; font.bold: true } }
                }
            }

            // Action Buttons (Delete added)
            Item { Layout.fillHeight: true }
            RowLayout {
                Layout.fillWidth: true
                // DELETE BUTTON
                Rectangle { width: 40; height: 40; radius: 20; color: "#FF6B6B"; Text { anchors.centerIn: parent; text: "🗑"; color: "white" } MouseArea { anchors.fill: parent; onClicked: popup.close() } }

                Item { Layout.fillWidth: true }

                Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#797979" } MouseArea { anchors.fill: parent; onClicked: popup.close() } }
                Rectangle { width: 50; height: 50; radius: 25; color: "#E9E9E9"; Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 24; color: accentColor; font.bold: true }
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            engine.addAlarm({name: aName.text, time: "07:30", days: "Daily"});
                            popup.close();
                        }
                    }
                }
            }
            Item { height: 10 }
        }
    }
}
