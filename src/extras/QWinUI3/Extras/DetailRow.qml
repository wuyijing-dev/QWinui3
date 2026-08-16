import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// DetailRow — Compact label / value row for forms and settings summaries.
//
//   DetailRow {
//       label: qsTr("Account")
//       value: qsTr("alex@example.com")
//       symbol: FluentIcons.Contact
//   }
//
// @notes
//   Left label (+ optional symbol), right value or custom trailing slot.
//   Use inside SettingsGroup, ContentCard, or FormLayout footnotes.

T.Control {
    id: root

    Layout.fillWidth: true

    // Leading label
    property string label: ""
    // Trailing value text (ignored when trailing has children)
    property string value: ""
    // Optional Fluent symbol
    property var symbol: ""
    property string iconGlyph: ""
    // Custom trailing content
    property alias trailing: trailingSlot.data
    // Preferred label column width
    property real labelWidth: 140

    readonly property string effectiveSymbol: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: 320
    implicitHeight: Math.max(Theme.controlHeight,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 8
    leftPadding: 12
    rightPadding: 12
    Accessible.role: Accessible.StaticText
    Accessible.name: label
    Accessible.description: value

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtleSecondary
        border.width: Theme.highContrast ? 1 : 0
        border.color: Theme.strokeCard
    }

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Text {
            visible: root.effectiveSymbol.length > 0
            text: root.effectiveSymbol
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            Layout.preferredWidth: root.labelWidth
            Layout.maximumWidth: root.labelWidth
            Layout.alignment: Qt.AlignVCenter
            text: root.label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textSecondary
            elide: Text.ElideRight
        }

        Item {
            id: trailingSlot
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            implicitHeight: Math.max(Theme.fontBody + 4, childrenRect.height)
            implicitWidth: children.length ? childrenRect.width : valueLabel.implicitWidth
            visible: children.length > 0 || root.value.length > 0

            Text {
                id: valueLabel
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                visible: trailingSlot.children.length === 0
                horizontalAlignment: Text.AlignRight
                text: root.value
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
        }
    }
}
