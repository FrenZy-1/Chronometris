import QtQuick 2.15
import QtQuick.Controls 2.15

// This version uses a Button to render the icon because
// Qt 6 Button has built-in coloring support without Shaders.
Button {
    id: root

    property string source: ""
    property color color: "black"

    // Make it non-interactive (just visual)
    enabled: false
    flat: true

    // Icon properties
    icon.source: root.source
    icon.color: root.color
    icon.width: width
    icon.height: height

    // Ensure it consumes no input
    focus: false
}
