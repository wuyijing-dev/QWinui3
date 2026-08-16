import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SettingsGroup — Section header + card stack for settings pages.
//
//   SettingsGroup {
//       title: qsTr("Appearance")
//       description: qsTr("Theme and motion preferences.")
//       SettingsCard { title: qsTr("Dark mode"); toggle: true; checked: … }
//       SettingsCard { title: qsTr("Density"); action: ComboBox {} }
//   }
//
// @notes
//   Groups SettingsCard / SettingsExpander rows under a Fluent section title.
//   Cards declare Layout.fillWidth themselves — no parent walk needed.
//   Prefer nesting inside SettingsView for page padding/title.

T.Control {
    id: root

    Layout.fillWidth: true

    // Section title
    property string title: ""
    // Toolkit Header alias
    property alias header: root.title
    // Supporting description under the title
    property string description: ""
    // Optional Fluent symbol before the title
    property var symbol: ""
    // Raw glyph fallback
    property string iconGlyph: ""
    // Spacing between child cards
    property real contentSpacing: Theme.spacing
    // Default children / card stack
    default property alias contentData: stack.data

    readonly property string effectiveSymbol: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: Math.max(320, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    Accessible.role: Accessible.Grouping
    Accessible.name: title
    Accessible.description: description

    contentItem: ColumnLayout {
        spacing: Theme.spacingLoose

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            visible: root.title.length > 0 || root.description.length > 0
                    || root.effectiveSymbol.length > 0

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                visible: root.title.length > 0 || root.effectiveSymbol.length > 0

                Text {
                    visible: root.effectiveSymbol.length > 0
                    text: root.effectiveSymbol
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 16
                    color: Theme.accent
                }
                Text {
                    Layout.fillWidth: true
                    visible: root.title.length > 0
                    text: root.title
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBodyLarge
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
            }

            Text {
                Layout.fillWidth: true
                visible: root.description.length > 0
                text: root.description
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
            }
        }

        ColumnLayout {
            id: stack
            Layout.fillWidth: true
            spacing: root.contentSpacing
        }
    }
}
