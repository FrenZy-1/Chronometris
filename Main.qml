import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "pages"
import "overlays"

ApplicationWindow {
    id: window
    visible: true
    width: 440
    height: 1000
    title: "Chronométris"
    color: theme.mainBackgroundColor

    ThemeManager { id: theme }

    // TOP HEADER (Page Title)
    Rectangle {
        id: topHeader
        anchors.top: parent.top
        width: parent.width
        height: 80 // Space for status bar + title
        color: theme.idleColor
        z: 100

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            text: viewPager.currentItem.title || "CHRONOMÉTRIS"
            color: "white"
            font.family: "Montserrat"
            font.pixelSize: 24
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
        }

        // Settings/Menu Icon (Right)
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
        interactive: false // Disable swipe gesture if you want strict tab navigation

        // 1. Dashboard
        DashboardPage {
            property string title: "DASHBOARD"
            theme: window.theme
        }

        // 2. Timer
        TimerPage {
            property string title: "TIMERS"
            theme: window.theme
        }

        // 3. Alarms
        AlarmsPage {
            property string title: "ALARMS"
            theme: window.theme
        }

        // 4. Analytics
        AnalyticsPage {
            property string title: "ANALYTICS"
            theme: window.theme
        }
    }

    // BOTTOM NAVIGATION BAR
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        width: parent.width
        height: 100 // Taller for bottom padding
        color: "transparent" // Floating look, or set theme.mainBackgroundColor
        z: 100

        // Green Pill Container background (Optional, based on your screenshot it looks like individual pills)
        // But for structure, we use a RowLayout

        Rectangle {
            anchors.fill: parent
            color: theme.idleColor // The green bar at the bottom

            // Curve the top corners if desired
            radius: 30
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 30; color: theme.idleColor } // Fill bottom corners
        }

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

                    // Active Circle Indicator
                    Rectangle {
                        anchors.centerIn: parent
                        width: 50; height: 50; radius: 25
                        color: "white"
                        opacity: isActive ? 0.2 : 0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Image {
                            source: "assets/icons/" + modelData.icon + ".svg"
                            width: 24
                            height: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                            opacity: isActive ? 1.0 : 0.6
                        }

                        Text {
                            text: modelData.name
                            font.family: "Montserrat"
                            font.pixelSize: 10
                            color: "white"
                            font.weight: isActive ? Font.Bold : Font.Normal
                            opacity: isActive ? 1.0 : 0.6
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

    AboutOverlay { id: aboutOverlay; theme: window.theme }
}
