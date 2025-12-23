import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    // Determine width based on whether seconds are visible
    width: isDuration ? 260 : 200
    height: 60 // Adjusted height since spinners are gone

    property var theme
    property bool isDuration: false
    property bool showHours: true

    // Internal Logic: Always 0-23
    property int hours: 0
    property int minutes: 0
    property int seconds: 0

    // LOGIC: Use 'is24HourFormat' from ThemeManager
    property bool use12Hour: !isDuration && !theme.is24HourFormat // Uses theme.is24HourFormat

    function getDisplayHour() {
        if (!use12Hour) return hours.toString().padStart(2, '0');
        var h = hours % 12;
        if (h === 0) h = 12;
        return h.toString().padStart(2, '0');
    }

    function setFromDisplayHour(val) {
        if (!use12Hour) {
            if (val > 23) val = 23;
            hours = val;
        } else {
            // 12-hour logic
            if (val > 12) val = 12;
            if (val < 1) val = 1;
            var isPm = hours >= 12;
            if (val === 12) { hours = isPm ? 12 : 0; }
            else { hours = isPm ? (val + 12) : val; }
        }
    }

    function toggleAmPm() {
        if (hours >= 12) hours -= 12;
        else hours += 12;
    }

    RowLayout {
        anchors.centerIn: parent; spacing: 5

        // --- HOURS ---
        Rectangle {
            visible: root.showHours
            width: 50; height: 50; radius: 5; color: "white"
            TextInput {
                id: hInput
                anchors.centerIn: parent
                text: root.getDisplayHour()
                font.pixelSize: 20; font.bold: true
                width: parent.width; horizontalAlignment: TextInput.AlignHCenter
                // FIX: Auto-select and format on exit
                onActiveFocusChanged: if(activeFocus) selectAll()
                onEditingFinished: {
                    var val = parseInt(text)||0;
                    root.setFromDisplayHour(val);
                    text = root.getDisplayHour();
                }
            }
        }

        Text { visible: root.showHours; text: ":"; font.pixelSize: 20; color: "white"; font.bold: true }

        // --- MINUTES ---
        Rectangle {
            width: 50; height: 50; radius: 5; color: "white"
            TextInput {
                anchors.centerIn: parent
                text: root.minutes.toString().padStart(2, '0')
                font.pixelSize: 20; font.bold: true
                width: parent.width; horizontalAlignment: TextInput.AlignHCenter
                // FIX: Auto-select and format on exit
                onActiveFocusChanged: if(activeFocus) selectAll()
                onEditingFinished: {
                    var val = parseInt(text)||0;
                    if(val>59)val=59;
                    root.minutes=val;
                    text=val.toString().padStart(2,'0');
                }
            }
        }

        // --- SECONDS (Duration Only) ---
        Text { visible: root.isDuration; text: ":"; font.pixelSize: 20; color: "white"; font.bold: true }
        Rectangle {
            visible: root.isDuration
            width: 50; height: 50; radius: 5; color: "white"
            TextInput {
                id: sInput
                anchors.centerIn: parent
                text: root.seconds.toString().padStart(2, '0')
                font.pixelSize: 20; font.bold: true
                width: parent.width; horizontalAlignment: TextInput.AlignHCenter
                // FIX: Auto-select and format on exit
                onActiveFocusChanged: if(activeFocus) selectAll()
                onEditingFinished: {
                    var val = parseInt(text)||0;
                    if(val>59)val=59;
                    root.seconds=val;
                    text=val.toString().padStart(2,'0');
                }
            }
        }

        // --- GLOBAL AM/PM TOGGLE ---
        Rectangle {
            visible: root.use12Hour
            width: 50; height: 50; radius: 5; color: "#333333"
            Text { anchors.centerIn: parent; text: root.hours >= 12 ? "PM" : "AM"; color: "white"; font.bold: true; font.pixelSize: 16 }
            MouseArea { anchors.fill: parent; onClicked: root.toggleAmPm() }
        }
    }
}
