import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "components"
import "pages"
import "overlays"

ApplicationWindow {
    id: window
    visible: true
    width: 440
    height: 1000
    title: "Chronométris"
    color: appTheme.mainBackgroundColor

    property alias appTheme: themeManager
    ThemeManager { id: themeManager }

    property color currentAccentColor: {
        if (engine.currentState === "stopped") return appTheme.idleColor
        return appTheme.getTimerColor(engine.currentType, false)
    }
    Behavior on currentAccentColor { ColorAnimation { duration: 300 } }

    // TOP HEADER
    Rectangle {
        id: topHeader
        anchors.top: parent.top
        width: parent.width
        height: 80
        color: window.currentAccentColor
        z: 100

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            text: viewPager.currentItem ? viewPager.currentItem.title : "CHRONOMÉTRIS"
            color: "white"
            font.family: "Montserrat"
            font.pixelSize: 24
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
        }

        // Menu Icon
        Rectangle {
            width: 36; height: 36; radius: 10
            color: "transparent"; border.color: "white"; border.width: 1
            anchors.right: parent.right; anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: 10
            Text { anchors.centerIn: parent; text: ":"; color: "white"; font.bold: true; font.pixelSize: 20; anchors.verticalCenterOffset: -2 }
            MouseArea { anchors.fill: parent; onClicked: aboutOverlay.open() }
        }
    }

    // MAIN CONTENT
    SwipeView {
        id: viewPager
        anchors.top: topHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        interactive: true

        DashboardPage {
            property string title: "DASHBOARD"
            theme: window.appTheme; accentColor: window.currentAccentColor
            // Connect signal to overlay
            onEditRequested: (type, name, time) => detailsOverlay.openWithData(type, name, time)
        }
        TimerPage {
            property string title: "TIMERS"
            theme: window.appTheme; accentColor: window.currentAccentColor
            onEditRequested: (type, name, time) => detailsOverlay.openWithData(type, name, time)
        }
        AlarmsPage {
            property string title: "ALARMS"
            theme: window.appTheme; accentColor: window.currentAccentColor
            // THIS FIXES THE ERROR
            onEditRequested: (type, name, time) => detailsOverlay.openWithData(type, name, time)
        }
        AnalyticsPage {
            property string title: "ANALYTICS"
            theme: window.appTheme; accentColor: window.currentAccentColor
        }
    }

    // FLOATING FOOTER
    Item {
        id: bottomContainer
        width: parent.width * 0.9
        height: 70
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        z: 100

        // Navigation Pill
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: window.currentAccentColor

            // Shadow using Material
            layer.enabled: true
            Material.elevation: 10

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 0

                Repeater {
                    model: [
                        { name: "Dashboard", icon: "dashboard", pageIndex: 0 },
                        { name: "Timer", icon: "timer", pageIndex: 1 },
                        { name: "Alarms", icon: "alarm", pageIndex: 2 },
                        { name: "Analytics", icon: "analytics", pageIndex: 3 }
                    ]

                    delegate: Item {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        property bool isActive: viewPager.currentIndex === modelData.pageIndex

                        // White Circle Indicator
                        Rectangle {
                            anchors.centerIn: parent
                            width: 45; height: 45; radius: 22.5
                            color: "white"
                            opacity: isActive ? 0.2 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 2 // Tiny space between icon and text

                            ColoredIcon {
                                source: "assets/icons/" + modelData.icon + ".svg"
                                width: 24; height: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: isActive ? "white" : Qt.rgba(1,1,1,0.6)
                            }

                            // RESTORED LABELS
                            Text {
                                text: modelData.name
                                color: isActive ? "white" : Qt.rgba(1,1,1,0.6)
                                font.family: "Montserrat"
                                font.pixelSize: 9
                                font.weight: isActive ? Font.Bold : Font.Normal
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea { anchors.fill: parent; onClicked: viewPager.currentIndex = modelData.pageIndex }
                    }
                }
            }
        }

        // FAB (Add Button)
        RoundButton {
            id: fab
            width: 50  // Explicit size
            height: 50 // Explicit size ensures Item height doesn't drift

            // Position: Docked to the right of the footer
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: -10

            // Only show on Timer (1) and Alarm (2) pages
            visible: viewPager.currentIndex === 1 || viewPager.currentIndex === 2
            scale: visible ? 1.0 : 0.0
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

            // Visuals
            color: "white"                        // White Background
            iconColor: window.currentAccentColor // Green/Blue/Purple Icon
            icon: "add"
            text: ""                             // No label for FAB

            onClicked: {
                if (viewPager.currentIndex === 1) addTimerOverlay.open()
                else if (viewPager.currentIndex === 2) addAlarmOverlay.open()
            }
        }
    }

    // OVERLAYS (Define them here globally)
    AboutOverlay { id: aboutOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    AddTimerOverlay { id: addTimerOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    AddAlarmOverlay { id: addAlarmOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    DetailsOverlay { id: detailsOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
}
