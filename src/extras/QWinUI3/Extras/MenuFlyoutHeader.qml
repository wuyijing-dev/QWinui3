import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// MenuFlyoutHeader — Non-interactive MenuFlyout section header.
//
//   MenuFlyout {
//       MenuFlyoutHeader { text: qsTr("Actions") }
//       MenuFlyoutItem { text: qsTr("Edit") }
//   }
//
// @notes
//   Non-interactive section header inside MenuFlyout.

MenuItem {
    id: control

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""

    // Resolved glyph string
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
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
