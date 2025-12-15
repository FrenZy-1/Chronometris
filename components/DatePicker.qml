import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    width: 280; height: 180
    property var selectedDate: new Date()

    ColumnLayout {
        anchors.fill: parent
        // Month Header
        Text {
            text: selectedDate.toLocaleString(Qt.locale(), "MMMM yyyy")
            font.bold: true; color: "white"; Layout.alignment: Qt.AlignHCenter
        }

        // Days Grid
        GridLayout {
            columns: 7; Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: 31 // Simple 1-31 loop for prototype
                Rectangle {
                    width: 30; height: 30; radius: 15
                    color: (index + 1) === selectedDate.getDate() ? "white" : "transparent"
                    Text {
                        anchors.centerIn: parent; text: index + 1
                        color: parent.color === "white" ? "black" : "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var d = new Date(selectedDate);
                            d.setDate(index + 1);
                            selectedDate = d;
                        }
                    }
                }
            }
        }
    }
}
