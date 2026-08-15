import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// FontIcon — FluentIcons glyph as Text.
//
//   FontIcon { symbol: FluentIcons.Home; font.pixelSize: 16 }

Item {
    id: root

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Icon glyph or source
    property var icon: ""
    property string glyph: ""
    property real fontSize: 16
    property color iconColor: Theme.textPrimary
    property bool mirrorGlyph: false
    property int fontWeight: Theme.fontWeightRegular
    property string toolTipText: ""
    property string accessibleName: ""

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
