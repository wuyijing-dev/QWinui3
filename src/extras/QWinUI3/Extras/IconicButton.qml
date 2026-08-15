import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Shared parent for icon buttons — accept FluentIcons / names / raw glyphs.
// Subclasses override contentItem / background; use effectiveIconGlyph for painting.
T.AbstractButton {
    id: control

    // Preferred: icon: FluentIcons.Save  or  icon: "Save"
    property var icon: ""
    // Legacy / explicit glyph escape still supported
    property string iconGlyph: ""
    property real iconSize: 16
    property string toolTipText: ""
    property bool badgeVisible: false
    property int badgeValue: 0
    property string badgeText: ""
    property int badgeMaxValue: 99
    property bool highlighted: false
    property bool flat: true

    readonly property string effectiveIconGlyph: {
        var fromIcon = IconSource.resolve(control.icon, "")
        if (fromIcon.length)
            return fromIcon
        var fromGlyph = IconSource.resolve(control.iconGlyph, "")
        if (fromGlyph.length)
            return fromGlyph
        return FluentIcons.Placeholder
    }

    readonly property string _badgeLabel: {
        if (badgeText.length)
            return badgeText
        if (badgeValue <= 0)
            return ""
        if (badgeValue > badgeMaxValue)
            return badgeMaxValue + "+"
        return String(badgeValue)
    }

    hoverEnabled: true
    font.family: Theme.fontFamilyIcon
    font.pixelSize: iconSize
    ToolTip.visible: hovered && toolTipText.length > 0
    ToolTip.text: toolTipText
    Accessible.role: Accessible.Button
}
