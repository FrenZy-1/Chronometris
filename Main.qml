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

    // --- HEADER ---
    Rectangle {
        id: topHeader
        anchors.top: parent.top; width: parent.width; height: 80
        color: window.currentAccentColor; z: 100
        Text {
            anchors.centerIn: parent; anchors.verticalCenterOffset: 10
            text: (viewPager.currentItem && viewPager.currentItem.title) ? viewPager.currentItem.title : "CHRONOMÉTRIS"
            color: "white"
            // THEME FONTS
            font.family: themeManager.mainFont
            font.pixelSize: themeManager.fontSizeH3
            font.weight: themeManager.fontWeightBold
            font.capitalization: Font.AllUppercase
        }
        Rectangle {
            width: 36; height: 36; radius: 10; color: "transparent"; border.color: "white"; border.width: 1
            anchors.right: parent.right; anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: 10
            Text {
                anchors.centerIn: parent; text: ":"; color: "white";
                font.family: themeManager.mainFont
                font.bold: true; font.pixelSize: themeManager.fontSizeH3;
                anchors.verticalCenterOffset: -2
            }
            MouseArea { anchors.fill: parent; onClicked: aboutOverlay.open() }
        }
    }

    // --- CONTENT ---
    SwipeView {
        id: viewPager
        anchors.top: topHeader.bottom; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
        clip: true; interactive: true

        DashboardPage {
            property string title: "DASHBOARD"
            theme: window.appTheme; accentColor: window.currentAccentColor
            onEditRequested: (type, name, config, id) => detailsOverlay.openWithData(type, name, config, id)
        }
        TimerPage {
            property string title: "TIMERS"
            theme: window.appTheme; accentColor: window.currentAccentColor
            onEditRequested: (type, name, config, id) => detailsOverlay.openWithData(type, name, config, id)
        }
        AlarmsPage {
            property string title: "ALARMS"
            theme: window.appTheme; accentColor: window.currentAccentColor
            onEditRequested: (type, name, config, id) => detailsOverlay.openWithData(type, name, config, id)
        }
        AnalyticsPage {
            property string title: "ANALYTICS"
            theme: window.appTheme; accentColor: window.currentAccentColor
        }
    }

    // --- FOOTER (FIXED VISUALS) ---
    Item {
        id: bottomContainer
        width: parent.width * 0.9; height: 70
        anchors.bottom: parent.bottom; anchors.bottomMargin: 30; anchors.horizontalCenter: parent.horizontalCenter; z: 100

        Rectangle {
            anchors.fill: parent; radius: height / 2; color: window.currentAccentColor
            layer.enabled: true; Material.elevation: 10

            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 20; spacing: 0

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

                        // 1. CIRCLE INDICATOR (Centered, slightly shifted up)
                        Rectangle {
                            id: indicator
                            width: 45; height: 45; radius: 22.5
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -6 // Push up to make room for text
                            color: "white"
                            opacity: isActive ? 0.2 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        // 2. ICON (Locked to the Center of the Circle)
                        ColoredIcon {
                            id: navIcon
                            source: "assets/icons/" + modelData.icon + ".svg"
                            width: 55; height: 55
                            anchors.centerIn: indicator // <--- KEY FIX: Align to circle, not parent
                            color: isActive ? "white" : Qt.rgba(1,1,1,0.6)
                        }

                        // 3. TEXT (Anchored below the Circle)
                        Text {
                            text: modelData.name
                            color: isActive ? "white" : Qt.rgba(1,1,1,0.6)
                            font.family: themeManager.mainFont
                            font.pixelSize: 10 // Keep small for footer
                            font.weight: isActive ? Font.Bold : Font.Normal

                            anchors.top: indicator.bottom
                            anchors.topMargin: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        MouseArea { anchors.fill: parent; onClicked: viewPager.currentIndex = modelData.pageIndex }
                    }
                }
            }
        }

        RoundButton {
            id: fab
            width: 50; height: 50
            anchors.right: parent.right; anchors.rightMargin: 10
            anchors.verticalCenter: parent.top; anchors.verticalCenterOffset: -10
            visible: viewPager.currentIndex === 1 || viewPager.currentIndex === 2
            scale: visible ? 1.0 : 0.0
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
            color: "white"; iconColor: window.currentAccentColor; icon: "add"; text: ""
            onClicked: {
                if (viewPager.currentIndex === 1) addTimerOverlay.open()
                else if (viewPager.currentIndex === 2) addAlarmOverlay.open()
            }
        }
    }

    // --- OVERLAYS ---
    AboutOverlay { id: aboutOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    AddTimerOverlay { id: addTimerOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    AddAlarmOverlay { id: addAlarmOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
    DetailsOverlay { id: detailsOverlay; theme: window.appTheme; accentColor: window.currentAccentColor }
}
