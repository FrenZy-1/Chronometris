import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

    // TOP HEADER
    Rectangle {
        id: topHeader
        anchors.top: parent.top
        width: parent.width
        height: 80
        color: appTheme.idleColor
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

        // Settings/Menu Icon
        Rectangle {
            width: 36; height: 36
            radius: 10
            color: "transparent"
            border.color: "white"
            border.width: 1
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 10

            Text {
                anchors.centerIn: parent
                text: ":"
                color: "white"
                font.bold: true
                font.pixelSize: 20
                anchors.verticalCenterOffset: -2
            }
            MouseArea { anchors.fill: parent; onClicked: aboutOverlay.open() }
        }
    }

    // MAIN CONTENT
    SwipeView {
        id: viewPager
        anchors.top: topHeader.bottom
        anchors.bottom: bottomNav.top
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        interactive: true // Swipe Enabled

        DashboardPage {
            property string title: "DASHBOARD"
            theme: window.appTheme
        }
        TimerPage {
            property string title: "TIMERS"
            theme: window.appTheme
        }
        AlarmsPage {
            property string title: "ALARMS"
            theme: window.appTheme
        }
        AnalyticsPage {
            property string title: "ANALYTICS"
            theme: window.appTheme
        }
    }

    // BOTTOM NAVIGATION BAR
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        width: parent.width
        height: 90
        color: appTheme.mainBackgroundColor
        z: 100

        RowLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10
            width: parent.width * 0.9
            spacing: 0

            Repeater {
                model: [
                    { name: "Dashboard", icon: "dashboard", pageIndex: 0 },
                    { name: "Timer", icon: "timer", pageIndex: 1 },
                    { name: "Alarms", icon: "alarm", pageIndex: 2 },
                    { name: "Analytics", icon: "analytics", pageIndex: 3 }
                ]

                delegate: Item {
                    Layout.fillWidth: true
                    height: 50

                    property bool isActive: viewPager.currentIndex === modelData.pageIndex

                    // Active Background Pill
                    Rectangle {
                        anchors.centerIn: parent
                        width: 60; height: 50; radius: 25
                        color: appTheme.idleColor
                        opacity: isActive ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        // REPLACED: Use ColoredIcon to fix black icons
                        ColoredIcon {
                            source: "assets/icons/" + modelData.icon + ".svg"
                            width: 24
                            height: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                            // White if active, Green if inactive
                            color: isActive ? "white" : appTheme.idleColor
                        }

                        Text {
                            text: modelData.name
                            font.family: "Montserrat"
                            font.pixelSize: 10
                            color: isActive ? "white" : appTheme.idleColor
                            font.weight: isActive ? Font.Bold : Font.Normal
                            opacity: isActive ? 1.0 : 0.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: viewPager.currentIndex = modelData.pageIndex
                    }
                }
            }
        }
    }

    AboutOverlay { id: aboutOverlay; theme: window.appTheme }
}
