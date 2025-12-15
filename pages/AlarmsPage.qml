import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Flickable {
    id: alarmPage
    contentHeight: content.height + 120; contentWidth: width; boundsBehavior: Flickable.StopAtBounds
    property var theme
    property color accentColor
    signal editRequested(string type, string name, var config, int id)

    ColumnLayout {
        id: content; width: parent.width; spacing: 15; Layout.topMargin: 20

        ColumnLayout {
            visible: engine.isAlarmSoon
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 30; spacing: 5
            Text { text: "Upcoming Alarm:"; font.family: theme.mainFont; font.pixelSize: theme.fontSizeSmall; font.weight: theme.fontWeightBold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmName; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH2; font.weight: theme.fontWeightExtraBold; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Text { text: engine.nextAlarmTime; font.family: theme.mainFont; font.pixelSize: theme.fontSizeH2; font.weight: theme.fontWeightNormal; color: theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 15; Layout.topMargin: 10
                RoundButton { icon: "hourglass_bottom"; text: "Snooze"; color: accentColor; onClicked: console.log("Snooze") }
                RoundButton { icon: "close"; text: "Turn Off"; color: accentColor; onClicked: console.log("Stop") }
                RoundButton { icon: "skip_next"; text: "Skip"; color: accentColor; onClicked: console.log("Skip") }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderColor; opacity: 0.3; Layout.margins: 20; Layout.topMargin: 15 }
        }

        ColumnLayout {
            Layout.fillWidth: true; Layout.margins: 20; spacing: 10
            Layout.topMargin: !engine.isAlarmSoon ? 40 : 0
            Rectangle { Layout.fillWidth: true; height: 35; color: accentColor; radius: 5
                RowLayout { anchors.fill: parent; anchors.margins: 10; Text{text:"Active Alarms";font.family: theme.mainFont; font.weight: theme.fontWeightBold; font.pixelSize: theme.fontSizeBody; color:"white";Layout.fillWidth:true} Text{text:engine.alarmsList.length;font.family: theme.mainFont; font.pixelSize: theme.fontSizeBody;color:"white"} }
            }
            Repeater {
                model: engine.alarmsList
                Rectangle {
                    Layout.fillWidth: true; height: 50; color: theme.isDarkMode?"#2A2A2A":"white"; radius: 5; border.color: theme.borderColor; border.width: 1
                    RowLayout { anchors.fill: parent; anchors.margins: 10
                        Column { Layout.fillWidth: true; Text{text:modelData.name;font.family: theme.mainFont; font.weight: theme.fontWeightBold; color:theme.textPrimary; font.pixelSize: theme.fontSizeBody} Text{text:modelData.config.time||"00:00";font.family: theme.mainFont; color:theme.textSecondary;font.pixelSize:theme.fontSizeSmall} }
                        Rectangle { width: 36; height: 20; radius: 10; color: accentColor; Rectangle{x:18;width:16;height:16;radius:8;color:"white";anchors.verticalCenter:parent.verticalCenter} }
                    }
                    MouseArea { anchors.fill: parent; onDoubleClicked: alarmPage.editRequested("alarm", modelData.name, modelData.config, modelData.id) }
                }
            }
        }
    }
}
