import QtQuick 2.15

QtObject {
    id: theme

    // Toggle this to switch themes
    property bool isDarkMode: false

    // Colors derived from your tokens
    readonly property color mainBackgroundColor: isDarkMode ? "#3E3E42" : "#E9E9E9"

    // Timer State Colors
    readonly property color idleColor: isDarkMode ? "#396745" : "#709775" // Sage Green

    // Cycle Specific Colors
    readonly property color workFill: isDarkMode ? "#3E6183" : "#6282A1"
    readonly property color workStroke: isDarkMode ? "#3F628F" : "#2C4B69"

    readonly property color shortBreakFill: isDarkMode ? "#864569" : "#AD5887"
    readonly property color shortBreakStroke: isDarkMode ? "#8E5875" : "#7B345B"

    readonly property color longBreakFill: isDarkMode ? "#5E4A82" : "#745D9C"
    readonly property color longBreakStroke: isDarkMode ? "#6A56A0" : "#4B3374"

    // Text & Borders
    readonly property color textPrimary: isDarkMode ? "#E9E9E9" : "#191716"
    readonly property color textSecondary: isDarkMode ? "#BEBEBE" : "#4A4A4A"
    readonly property color borderColor: isDarkMode ? "#4E4E4E" : "#797979"

    // Font Configuration
    readonly property string mainFont: "Montserrat"

    // Helper: Get color based on timer state
    function getTimerColor(type, isStroke) {
        switch(type) {
            case "work": return isStroke ? workStroke : workFill
            case "shortBreak": return isStroke ? shortBreakStroke : shortBreakFill
            case "longBreak": return isStroke ? longBreakStroke : longBreakFill
            default: return idleColor
        }
    }
}
