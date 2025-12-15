import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: timerPage
    contentHeight: content.height + 120; contentWidth: width; boundsBehavior: Flickable.StopAtBounds
    property var theme
    property color accentColor
    signal editRequested(string type, string name, var config, int id)

    ColumnLayout {
        id: content; width: parent.width; spacing: 15

        // --- 1. RUNNING HEADER ---
        ColumnLayout {
            visible: engine.currentState !== "stopped"
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 20
            Text { text: engine.currentType==="work"?"WORK SESSION":"BREAK"; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH2; font.weight: theme.fontWeightExtraBold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.currentState; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH3; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter; font.capitalization: Font.Capitalize }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 10
                RoundButton { icon: engine.currentState==="running"?"pause":"play_arrow"; color: accentColor; onClicked: engine.currentState==="running"?engine.pause():engine.start() }
                RoundButton { icon: "stop"; color: accentColor; onClicked: engine.stop() }
            }
        }

        // --- 2. SAVED TIMERS ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: engine.currentState === "stopped" ? 20 : 0

            Rectangle { Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout { anchors.fill: parent; anchors.margins: 10; Text{text:"Saved Timers";font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody; color:"white";Layout.fillWidth:true} Text{text:engine.timersList.length;font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody;color:"white"} }
            }

            Repeater {
                model: engine.timersList
                Rectangle {
                    // INCREASED HEIGHT FOR BREATHING ROOM
                    Layout.fillWidth: true; height: 60;
                    color: theme.isDarkMode?"#2A2A2A":"white"; radius: 5; border.color: theme.borderColor

                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 15

                        Column {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            Text {
                                text: modelData.name
                                font.family: theme.mainFont; font.weight: theme.fontWeightBold; color: theme.textPrimary; font.pixelSize: theme.fontSizeBody
                                // PREVENT OVERFLOW
                                width: parent.width
                                elide: Text.ElideRight
                            }
                            Text {
                                text: modelData.config.mode==="pomodoro"?"Pomodoro":"Custom";
                                font.family: theme.mainFont; font.pixelSize: theme.fontSizeSmall; color: theme.textSecondary
                            }
                        }

                        // FIXED SIZE PLAY BUTTON
                        RoundButton {
                            Layout.preferredWidth: 36; Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                            icon: "play_arrow"; color: accentColor
                            onClicked: engine.loadAndStartSession(modelData.config)
                        }
                    }
                    MouseArea { anchors.fill: parent; onDoubleClicked: timerPage.editRequested("timer", modelData.name, modelData.config, modelData.id) }
                }
            }
        }

        // --- 3. RECENT HISTORY (Completed) ---
        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10

            Rectangle { Layout.fillWidth: true; height: 35; color: "#797979"; radius: 5
                RowLayout { anchors.fill: parent; anchors.margins: 10; Text{text:"Recent History";font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody; color:"white";Layout.fillWidth:true} }
            }

            Repeater {
                model: engine.historyList
                Rectangle {
                    Layout.fillWidth: true; height: 60;
                    color: "transparent"; border.color: theme.borderColor; radius: 5

                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 15

                        Column {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            Text {
                                text: modelData.name
                                font.family: theme.mainFont; color: theme.textPrimary; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody
                                width: parent.width; elide: Text.ElideRight
                            }
                            Text {
                                text: modelData.date + " • " + modelData.time;
                                font.family: theme.mainFont; color: theme.textSecondary; font.pixelSize: theme.fontSizeSmall
                            }
                        }

                        // FIXED SIZE RE-RUN BUTTON
                        RoundButton {
                            Layout.preferredWidth: 36; Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                            icon: "play_arrow"; color: "transparent"; iconColor: theme.textSecondary
                            onClicked: engine.loadAndStartSession(modelData.config)
                        }
                    }
                    MouseArea { anchors.fill: parent; onDoubleClicked: timerPage.editRequested("timer", modelData.name, modelData.config, -1) }
                }
            }
        }
    }
}
