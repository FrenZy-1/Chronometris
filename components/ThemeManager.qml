import QtQuick 2.15

QtObject {
    id: theme

    property bool isDarkMode: false
    property bool is24HourFormat: false // Toggled by AboutOverlay

    property color mainBackgroundColor: isDarkMode ? "#363F45" : "#E5E5E5"
    property color idleColor: "#709775"

    property color workFill: isDarkMode ? "#3E6183" : "#6282A1"
    property color shortBreakFill: isDarkMode ? "#864569" : "#AD5887"
    property color longBreakFill: isDarkMode ? "#5E4A82" : "#745D9C"

    property color workStroke: isDarkMode ? "#2A4663" : "#4A6E8C"
    property color shortBreakStroke: isDarkMode ? "#66304D" : "#8F456D"
    property color longBreakStroke: isDarkMode ? "#453663" : "#5E4A82"

    property color textPrimary: isDarkMode ? "#E0E0E0" : "#4A4A4A"
    property color textSecondary: isDarkMode ? "#B0B0B0" : "#797979"
    property color borderColor: isDarkMode ? "#505050" : "#D1D1D1"

    property string mainFont: "Montserrat"

    function getTimerColor(type, isStroke) {
        if (type === "work") return isStroke ? workStroke : workFill
        if (type === "shortBreak") return isStroke ? shortBreakStroke : shortBreakFill
        if (type === "longBreak") return isStroke ? longBreakStroke : longBreakFill
        return idleColor
    }

    // Global Time Formatter
    function formatTime(hour, minute) {
        if (is24HourFormat) {
            return (hour < 10 ? "0"+hour : hour) + ":" + (minute < 10 ? "0"+minute : minute)
        } else {
            var ampm = hour >= 12 ? "PM" : "AM"
            var h = hour % 12
            h = h ? h : 12
            return h + ":" + (minute < 10 ? "0"+minute : minute) + " " + ampm
        }
    }
}
