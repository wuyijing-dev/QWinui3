import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// FontIcon — FluentIcons glyph as Text.
//
//   FontIcon {
//       id: icon
//       symbol: FluentIcons.Home
//       fontSize: 20
//   }
//   // --- API ---
//   // icon.symbol / iconGlyph / fontSize
//   // microMotionEnabled / hoverScale / pressScale (1.49)
//
// @notes
//   FluentIcons symbol / glyph text; fontSize for px size.
//   Accessible: set accessibleName or toolTipText — never use the raw PUA glyph (1.29).
//   Hover/press micro-motion honors Theme.reducedMotion (1.49).

Item {
    id: root

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Icon glyph or source
    property var icon: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Font size in px
    property real fontSize: 16
    // Icon color
    property color iconColor: Theme.textPrimary
    // Mirror glyph for RTL
    property bool mirrorGlyph: false
    // Font weight
    property int fontWeight: Theme.fontWeightRegular
    // Tooltip text
    property string toolTipText: ""
    // Accessible name override
    property string accessibleName: ""
    // WinUI-style hover/press micro-motion (1.49)
    property bool microMotionEnabled: true
    // Hover glyph scale when microMotionEnabled
    property real hoverScale: 1.06
    // Pressed glyph scale when microMotionEnabled
    property real pressScale: 0.92

    // Resolved glyph string
    readonly property string effectiveGlyph: {
        var fromSymbol = IconSource.resolve(root.symbol, "")
        if (fromSymbol.length)
            return fromSymbol
        var fromIcon = IconSource.resolve(root.icon, "")
        if (fromIcon.length)
            return fromIcon
        return IconSource.resolve(root.glyph, FluentIcons.Placeholder)
    }

    readonly property real effectiveIconScale: {
        if (!root.microMotionEnabled || Theme.reducedMotion || !root.enabled)
            return 1
        if (press.pressed)
            return root.pressScale
        if (hover.hovered)
            return root.hoverScale
        return 1
    }

    implicitWidth: Math.ceil(fontSize * 1.25)
    implicitHeight: Math.ceil(fontSize * 1.25)
    width: implicitWidth
    height: implicitHeight
    Accessible.role: Accessible.Graphic
    Accessible.name: {
        if (root.accessibleName.length)
            return root.accessibleName
        if (root.toolTipText.length)
            return root.toolTipText
        return ""
    }
    Accessible.ignored: root.accessibleName.length === 0 && root.toolTipText.length === 0

    HoverHandler {
        id: hover
        enabled: root.microMotionEnabled || root.toolTipText.length > 0
    }
    TapHandler {
        id: press
        enabled: root.microMotionEnabled
        acceptedButtons: Qt.LeftButton
        gesturePolicy: TapHandler.WithinBounds
    }
    ToolTip.visible: hover.hovered && root.toolTipText.length > 0
    ToolTip.text: root.toolTipText
    ToolTip.delay: 400

    Text {
        id: glyphText
        anchors.centerIn: parent
        text: root.effectiveGlyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: root.fontSize
        font.weight: root.fontWeight
        color: root.enabled ? root.iconColor : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        scale: root.effectiveIconScale
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
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }
}
