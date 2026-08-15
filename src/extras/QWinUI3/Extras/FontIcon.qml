import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// Segoe Fluent Icons glyph with Theme-aware sizing and color.
// Use Item (not Control): Control/Item.mirrored is FINAL and must not be redeclared.
Item {
    id: root

    property string glyph: "\uE8A7"
    property alias symbol: root.glyph
    property real fontSize: 16
    property color iconColor: Theme.textPrimary
    property bool mirrorGlyph: false
    property int fontWeight: Theme.fontWeightRegular
    property string toolTipText: ""
    property string accessibleName: ""

    implicitWidth: Math.ceil(fontSize * 1.25)
    implicitHeight: Math.ceil(fontSize * 1.25)
    width: implicitWidth
    height: implicitHeight
    Accessible.role: Accessible.Graphic
    Accessible.name: accessibleName.length ? accessibleName : glyph

    HoverHandler {
        id: hover
        enabled: root.toolTipText.length > 0
    }
    ToolTip.visible: hover.hovered && root.toolTipText.length > 0
    ToolTip.text: root.toolTipText
    ToolTip.delay: 400

    Text {
        id: glyphText
        anchors.centerIn: parent
        text: root.glyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: root.fontSize
        font.weight: root.fontWeight
        color: root.enabled ? root.iconColor : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        scale: hover.hovered && root.toolTipText.length > 0 && !Theme.reducedMotion ? 1.06 : 1
        transform: Scale {
            origin.x: glyphText.width / 2
            origin.y: glyphText.height / 2
            xScale: root.mirrorGlyph ? -1 : 1
        }

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
