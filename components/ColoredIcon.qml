import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root

    // API matching your usage
    property string source: ""
    property color color: "black"

    // Disable interaction (it's just an icon)
    enabled: false
    flat: true

    // Map properties to the Button's icon group
    icon.source: root.source
    icon.color: root.color
    icon.width: width
    icon.height: height

    // Remove all background/borders
    background: Item {}

    // Ensure no text padding affects the size
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    // Force the icon to fill the item
    contentItem: Item {
        // The Button renders the icon internally, we just hide the label
    }
}
