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
            height: 100
            color: appTheme.idleColor // 1. Restore Footer Green Color

            // Top corners rounded
            radius: 30
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 30; color: appTheme.idleColor }

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
                        Layout.fillWidth: true
                        height: 50

                        property bool isActive: viewPager.currentIndex === modelData.pageIndex

                        // Active Pill (White when active)
                        Rectangle {
                            anchors.centerIn: parent
                            width: 60; height: 50; radius: 25
                            color: "white"
                            opacity: isActive ? 0.2 : 0 // Subtle highlight
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            // ICON FIX: Use native Image, colorize via a simple property change if possible
                            // Since SVGs are black, we can't easily make them white without a shader.
                            // We will use the 'ColoredIcon' again but simpler.

                            Image {
                                source: "assets/icons/" + modelData.icon + ".svg"
                                width: 24; height: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: false // Hidden source
                                id: srcIcon
                            }

                            // The Colorize Effect
                            ShaderEffect {
                                width: 24; height: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                                property variant src: srcIcon
                                property color clr: isActive ? "white" : Qt.rgba(1,1,1,0.6) // White vs Dim White

                                fragmentShader: "
                                    varying highp vec2 qt_TexCoord0;
                                    uniform sampler2D src;
                                    uniform lowp vec4 clr;
                                    uniform lowp float qt_Opacity;
                                    void main() {
                                        lowp vec4 tex = texture2D(src, qt_TexCoord0);
                                        gl_FragColor = vec4(clr.rgb, tex.a * qt_Opacity);
                                    }"
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

    AboutOverlay { id: aboutOverlay; theme: window.appTheme }
}
