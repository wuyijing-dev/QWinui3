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
    // When true, mirror directional glyphs under LayoutMirroring (2.67 — I9)
    property bool autoMirror: true
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
    // Manual optical offset (px); NaN → Theme.iconOpticalOffset(fontSize)
    property real iconOffsetX: NaN
    property real iconOffsetY: NaN
    // Size band hint: caption | chrome | nav | appbar | "" (auto from fontSize)
    property string iconContext: ""
    // Chevron expand rotation (deg); use with FluentIcons.Chevron* (2.66 — I4)
    property real chevronRotation: 0
    // Selected / emphasized glyph (accent + motion — 2.66 — I3)
    property bool selected: false

    readonly property var _optical: Theme.iconOpticalOffset(fontSize)
    readonly property real effectiveOffsetX: !isNaN(iconOffsetX) ? iconOffsetX : _optical.x
    readonly property real effectiveOffsetY: !isNaN(iconOffsetY) ? iconOffsetY : _optical.y
    readonly property color effectiveIconColor: Theme.iconColor(
        iconColor, selected, hover.hovered, enabled)
    readonly property real effectiveDisabledOpacity: enabled ? 1 : Theme.iconDisabledOpacity
    readonly property string effectiveGlyph: {
        var fromSymbol = IconSource.resolve(root.symbol, "")
        if (fromSymbol.length)
            return fromSymbol
        var fromIcon = IconSource.resolve(root.icon, "")
        if (fromIcon.length)
            return fromIcon
        return IconSource.resolve(root.glyph, FluentIcons.Placeholder)
    }

    readonly property bool effectiveMirror: {
        if (mirrorGlyph)
            return true
        if (!autoMirror)
            return false
        var rtl = LayoutMirroring.enabled
                || (typeof Qt !== "undefined" && Qt.application
                    && Qt.application.layoutDirection === Qt.RightToLeft)
        return rtl && Theme.iconShouldMirror(effectiveGlyph)
    }

    readonly property bool _compactChrome: root.fontSize <= 18
                || root.iconContext === "chrome"
                || root.iconContext === "caption"

    readonly property real effectiveIconScale: {
        if (!root.microMotionEnabled || Theme.reducedMotion || !root.enabled || _compactChrome)
            return 1
        if (press.pressed)
            return root.pressScale
        if (hover.hovered)
            return root.hoverScale
        return 1
    }

    readonly property real _motionOpacity: {
        if (!_compactChrome || !root.microMotionEnabled || Theme.reducedMotion || !root.enabled)
            return 1
        if (press.pressed)
            return 0.72
        if (hover.hovered)
            return 0.88
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
        x: root.effectiveOffsetX
        y: root.effectiveOffsetY
        text: root.effectiveGlyph
        font: Theme.iconFontFor(Math.round(root.fontSize), root.fontWeight)
        color: root.effectiveIconColor
        opacity: root.effectiveDisabledOpacity * root._motionOpacity
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        scale: root.effectiveIconScale
        rotation: root.chevronRotation
        transform: Scale {
            origin.x: glyphText.width / 2
            origin.y: glyphText.height / 2
            xScale: root.effectiveMirror ? -1 : 1
        }

        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
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
        Behavior on rotation {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
    }
}
