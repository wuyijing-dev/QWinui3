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
//
// @notes
//   FluentIcons symbol / glyph text; fontSize for px size.

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

    implicitWidth: Math.ceil(fontSize * 1.25)
    implicitHeight: Math.ceil(fontSize * 1.25)
    width: implicitWidth
    height: implicitHeight
    Accessible.role: Accessible.Graphic
    Accessible.name: accessibleName.length ? accessibleName : effectiveGlyph

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
        text: root.effectiveGlyph
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
