import QtQuick 2.15

Item {
    id: root
    property string source
    property color color: "black"

    implicitWidth: 24
    implicitHeight: 24

    Image {
        id: img
        source: root.source
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: false // Hide the original black image
        mipmap: true   // Smooth scaling
    }

    ShaderEffect {
        anchors.fill: parent
        property variant src: img
        property color clr: root.color

        // Simple fragment shader to colorize the non-transparent pixels
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
}
