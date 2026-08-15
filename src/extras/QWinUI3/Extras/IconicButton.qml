import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Shared parent for icon buttons — accept FluentIcons / names / raw glyphs.
// NOTE: do NOT declare `icon` — AbstractButton.icon is FINAL (QQuickIcon).
// Prefer: symbol: FluentIcons.Save  or  symbol: "Save"  or  iconGlyph: FluentIcons.Save
T.AbstractButton {
    id: control

    property var symbol: ""
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
        var fromSymbol = IconSource.resolve(control.symbol, "")
        if (fromSymbol.length)
            return fromSymbol
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
    Accessible.name: {
        if (toolTipText.length)
            return toolTipText
        if (control.text && control.text.length)
            return control.text
        return qsTr("Icon button")
    }
    Accessible.checkable: checkable
    Accessible.checked: checked
}
