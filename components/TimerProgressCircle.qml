import QtQuick 2.15

Item {
    id: root
    width: 280
    height: 280

    property int circleSize: 260
    property real progress: 0.5 // 0.0 to 1.0
    property int strokeWidth: 20
    property color backgroundColor: "#E0E0E0"
    property color progressColor: "#709775"

    // Unused properties kept for compatibility with Dashboard code
    property string timeText: ""
    property string statusText: ""
    property string typeText: ""
    property bool showProgressText: false

    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: root.circleSize
        height: root.circleSize

        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2
            var centerY = height / 2
            var radius = (width - root.strokeWidth) / 2

            ctx.clearRect(0, 0, width, height)

            // Background Circle
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.strokeStyle = root.backgroundColor
            ctx.lineWidth = root.strokeWidth
            ctx.stroke()

            // Progress Arc
            // Start from -90 degrees (12 o'clock)
            var startAngle = -Math.PI / 2
            var endAngle = startAngle + (root.progress * 2 * Math.PI)

            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle, false)
            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    onProgressChanged: canvas.requestPaint()
    onProgressColorChanged: canvas.requestPaint()
    onBackgroundColorChanged: canvas.requestPaint()
}
