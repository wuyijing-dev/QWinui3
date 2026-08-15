import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Non-interactive section header inside a MenuFlyout.
MenuItem {
    id: control

    property var symbol: ""
    property string iconGlyph: ""

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    enabled: false
    checkable: false
    implicitHeight: 28
    leftPadding: 12
    rightPadding: 12

    background: Item {}
    indicator: Item {}
    arrow: Item {}

    contentItem: RowLayout {
        spacing: 6
        FontIcon {
            visible: control.effectiveIconGlyph.length > 0
            glyph: control.effectiveIconGlyph
            fontSize: 12
            iconColor: Theme.textSecondary
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            Layout.fillWidth: true
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
