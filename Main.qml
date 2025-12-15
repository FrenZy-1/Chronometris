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
    color: appTheme.mainBackgroundColor

    property alias appTheme: themeManager
    ThemeManager { id: themeManager }

    // DYNAMIC COLOR LOGIC
    // If stopped, use Sage Green (Idle). If running/paused, use the specific Cycle Color.
    property color currentAccentColor: {
        if (engine.currentState === "stopped") return appTheme.idleColor
        return appTheme.getTimerColor(engine.currentType, false)
    }

    // TOP HEADER
    Rectangle {
        id: topHeader
        anchors.top: parent.top
        width: parent.width
        height: 80
        color: window.currentAccentColor // BINDING
        z: 100

        Behavior on color { ColorAnimation { duration: 300 } } // Smooth transition

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            text: viewPager.currentItem ? viewPager.currentItem.title : "CHRONOMÉTRIS"
            color: "white"
            font.family: "Montserrat"; font.pixelSize: 24; font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
        }

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
        anchors.bottom: bottomNav.top
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        interactive: true

        DashboardPage { property string title: "DASHBOARD"; theme: window.appTheme }
        TimerPage { property string title: "TIMERS"; theme: window.appTheme }
        AlarmsPage { property string title: "ALARMS"; theme: window.appTheme }
        AnalyticsPage { property string title: "ANALYTICS"; theme: window.appTheme }
    }

    // BOTTOM NAVIGATION BAR
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        width: parent.width
        height: 50
        color: window.currentAccentColor // BINDING
        z: 100

        Behavior on color { ColorAnimation { duration: 300 } }

        // Curved Top corners
        radius: 30
        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 30; color: parent.color }

        RowLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -5
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
                    Layout.fillWidth: true; height: 50
                    property bool isActive: viewPager.currentIndex === modelData.pageIndex

                    // Active Pill
                    Rectangle {
                        anchors.centerIn: parent
                        width: 60; height: 50; radius: 25
                        color: "white"
                        opacity: isActive ? 0.2 : 0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        // NEW COLORED ICON COMPONENT (White if active, Light White if inactive)
                        ColoredIcon {
                            source: "assets/icons/" + modelData.icon + ".svg"
                            width: 24; height: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: isActive ? "white" : "#CCFFFFFF" // High opacity white vs Medium opacity
                        }

                        Text {
                            text: modelData.name
                            font.family: "Montserrat"; font.pixelSize: 10
                            color: "white"
                            font.weight: isActive ? Font.Bold : Font.Normal
                            opacity: isActive ? 1.0 : 0.7
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: viewPager.currentIndex = modelData.pageIndex }
                }
            }
        }
    }

    AboutOverlay { id: aboutOverlay; theme: window.appTheme }
}
