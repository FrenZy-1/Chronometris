import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
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

    property string mode: "" // "pomodoro", "custom"
    property bool isScheduled: false
    property string preset: "standard"

    Rectangle {
        anchors.fill: parent; radius: 20
        color: accentColor; border.width: 4; border.color: "white"

        Flickable {
            anchors.fill: parent; anchors.margins: 20
            contentHeight: contentCol.height; clip: true

            ColumnLayout {
                id: contentCol
                width: parent.width; spacing: 12

                Text { Layout.alignment: Qt.AlignHCenter; text: "ADD TIMER"; font.family: "Montserrat"; font.pixelSize: 28; font.weight: Font.ExtraBold; color: "white" }
                Rectangle { Layout.fillWidth: true; height: 2; color: "white" }

                // Mode Toggle
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Rectangle {
                        width: 100; height: 35; radius: 5; color: mode==="pomodoro"?"#E9E9E9":"transparent"; border.color: "white"
                        Text { anchors.centerIn: parent; text: "Pomodoro"; font.bold: true; color: mode==="pomodoro"?accentColor:"white" }
                        MouseArea { anchors.fill: parent; onClicked: mode="pomodoro" }
                    }
                    Rectangle {
                        width: 100; height: 35; radius: 5; color: mode==="custom"?"#E9E9E9":"transparent"; border.color: "white"
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
                    TextField { Layout.fillWidth: true; placeholderText: "Ringtone"; background: Rectangle { radius: 5; color: "#E9E9E9" } }
                }

                // Pomodoro Presets
                ColumnLayout {
                    visible: mode === "pomodoro"
                    Layout.fillWidth: true
                    RowLayout {
                        Text { text: "Format:"; color: "white"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 70; height: 25; color: preset==="standard"?"white":"transparent"; border.color: "white"; radius: 4
                            Text { anchors.centerIn: parent; text: "Standard"; color: preset==="standard"?accentColor:"white"; font.bold: true; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: preset="standard" }
                        }
                        Rectangle { width: 70; height: 25; color: preset==="presets"?"white":"transparent"; border.color: "white"; radius: 4
                            Text { anchors.centerIn: parent; text: "Presets"; color: preset==="presets"?accentColor:"white"; font.bold: true; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: preset="presets" }
                        }
                    }
                    // Presets List
                    ColumnLayout {
                        visible: preset === "presets"; spacing: 5
                        Repeater {
                            model: ["15/3/5", "30/5/10", "50/10/20"]
                            RowLayout {
                                Rectangle { width: 16; height: 16; radius: 8; border.color: "white"; color: "transparent"; Rectangle { anchors.centerIn: parent; width: 10; height: 10; radius: 5; color: "white"; visible: index===0 } }
                                Text { text: modelData; color: "white" }
                            }
                        }
                    }
                }

                // Custom Timer Picker
                ColumnLayout {
                    visible: mode === "custom"
                    Layout.fillWidth: true
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["Work", "Break", "L. Break"]
                            Rectangle {
                                width: 70; height: 30; radius: 5; color: index===0?"#E9E9E9":"transparent"; border.color: "white"
                                Text { anchors.centerIn: parent; text: modelData; color: index===0?accentColor:"white"; font.bold: true }
                            }
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter; spacing: 5
                        CheckBox { text: "Hrs"; contentItem: Text { text: "Hrs"; color: "white"; leftPadding: 25 } }
                        Rectangle { width: 50; height: 40; color: "white"; radius: 5; Text { anchors.centerIn: parent; text: "00"; font.pixelSize: 20 } }
                        Text { text: ":"; color: "white" }
                        Rectangle { width: 50; height: 40; color: "white"; radius: 5; Text { anchors.centerIn: parent; text: "25"; font.pixelSize: 20 } }
                        Text { text: ":"; color: "white" }
                        Rectangle { width: 50; height: 40; color: "white"; radius: 5; Text { anchors.centerIn: parent; text: "00"; font.pixelSize: 20 } }
                    }
                }

                // Schedule Toggle
                RowLayout {
                    visible: mode !== ""
                    CheckBox {
                        id: scheduleCheck
                        checked: isScheduled; onCheckedChanged: isScheduled = checked
                        indicator: Rectangle { width: 20; height: 20; radius: 3; color: scheduleCheck.checked?"white":"transparent"; border.color: "white" }
                    }
                    Text { text: "Schedule (Alarm)"; color: "white"; font.bold: true }
                }

                // Alarm Settings (Reusable)
                ColumnLayout {
                    visible: isScheduled && mode !== ""
                    Layout.fillWidth: true; spacing: 10
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Rectangle { width: 50; height: 50; color: "#E9E9E9"; radius: 5; Text { anchors.centerIn: parent; text: "AM"; font.pixelSize: 18 } }
                        Rectangle { width: 50; height: 50; color: "#E9E9E9"; radius: 5; Text { anchors.centerIn: parent; text: "08"; font.pixelSize: 24 } }
                        Rectangle { width: 50; height: 50; color: "#E9E9E9"; radius: 5; Text { anchors.centerIn: parent; text: "30"; font.pixelSize: 24 } }
                    }

                    // Repeat Toggle (Double Button)
                    RowLayout {
                        Text { text: "Repeat:"; color: "white"; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Row {
                            Rectangle { width: 60; height: 25; color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Daily"; color: accentColor; font.bold: true } }
                            Rectangle { width: 60; height: 25; color: "transparent"; border.color: "white"; radius: 4; Text { anchors.centerIn: parent; text: "Custom"; color: "white" } }
                        }
                    }

                    // Days
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["M","T","W","T","F","S","S"]
                            Rectangle { width: 25; height: 25; radius: 12.5; color: index<5?"white":"transparent"; border.color: "white"
                                Text { anchors.centerIn: parent; text: modelData; color: index<5?accentColor:"white"; font.pixelSize: 10; font.bold: true }
                            }
                        }
                    }
                }

                // Actions
                Item { Layout.fillHeight: true }
                RowLayout {
                    visible: mode !== ""
                    Layout.alignment: Qt.AlignHCenter; spacing: 40
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
                                // Call C++ to save
                                engine.addTimer({name: tName.text, desc: "Custom Timer"});
                                popup.close();
                            }
                        }
                    }
                }
                Item { height: 10 }
            }
        }
    }
}
