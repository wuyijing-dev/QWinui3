import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// IconicButton — Base icon + label button used by AppBar*.
//
//   IconicButton { text: qsTr("Action"); symbol: FluentIcons.Add }

T.AbstractButton {
    id: control

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Icon size in px
    property real iconSize: 16
    // Tooltip text
    property string toolTipText: ""
    // Show avatar badge
    property bool badgeVisible: false
    // Numeric badge value (-1 hides count)
    property int badgeValue: 0
    // Badge caption
    property string badgeText: ""
    // Badge max before +
    property int badgeMaxValue: 99
    // Emphasized / selected chrome
    property bool highlighted: false
    // Flat chrome without fill
    property bool flat: true

    // Resolved glyph string
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
