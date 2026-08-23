import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ChartCard — Title/subtitle chrome around a chart child.
//
//   ChartCard {
//       title: qsTr("Revenue")
//       LineChart { values: series }
//   }
//
// @notes
//   Title/subtitle chrome around a chart child; put the chart as content.
//   Layout.fillWidth defaults to true. Omit a chart child (or bind empty series)
//   for an empty card — charts own their empty states / units / click callbacks.

T.Control {
    id: root

    Layout.fillWidth: true

    // Primary title text
    property string title: ""
    // Secondary subtitle text
    property string subtitle: ""
    // Footer text
    property string footer: ""
    // Show an Export action in the footer strip (2.65)
    property bool showExportAction: false
    // Export action label
    property string exportActionText: qsTr("Export")
    // Trailing footer actions slot (buttons, links)
    property alias footerActions: footerActionsRow.data
    // Emitted when the built-in Export action is clicked
    signal exportRequested()

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Play enter / reveal animation
    property bool animated: true
    // Stronger elevation / card tint
    property bool elevated: false
    // Draw a border when true
    property bool bordered: true
    // Trailing header actions slot
    property alias headerActions: actionsRow.data
    // Content slot / children host
    default property alias content: body.data

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: 320
    implicitHeight: 240
    padding: 12
    opacity: animated && !Theme.reducedMotion ? 0 : 1
    scale: animated && !Theme.reducedMotion ? 0.97 : 1
    Accessible.role: Accessible.Grouping
    Accessible.name: title
    Accessible.description: subtitle

    Component.onCompleted: {
        opacity = 1
        scale = 1
    }

    Behavior on opacity {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    Behavior on scale {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: root.title.length > 0 || root.subtitle.length > 0
                     || root.effectiveIconGlyph.length > 0 || actionsRow.children.length > 0

            FontIcon {
                visible: root.effectiveIconGlyph.length > 0
                Layout.alignment: Qt.AlignTop
                glyph: root.effectiveIconGlyph
                fontSize: 18
                iconColor: Theme.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    visible: root.title.length > 0
                    Layout.fillWidth: true
                    text: root.title
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
                Text {
                    visible: root.subtitle.length > 0
                    Layout.fillWidth: true
                    text: root.subtitle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    elide: Text.ElideRight
                }
            }

            Row {
                id: actionsRow
                spacing: 4
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        Item {
            id: body
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            visible: root.footer.length > 0
            Layout.fillWidth: true
            text: root.footer
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            elide: Text.ElideRight
        }

        RowLayout {
            Layout.fillWidth: true
            visible: root.showExportAction || footerActionsRow.children.length > 0
            spacing: 8

            Item { Layout.fillWidth: true }

            Row {
                id: footerActionsRow
                spacing: 4
                Layout.alignment: Qt.AlignVCenter
            }

            Button {
                visible: root.showExportAction
                text: root.exportActionText
                flat: true
                onClicked: root.exportRequested()
            }
        }
    }

    background: ElevatedChrome {
        color: root.elevated ? Theme.bgCardElevated : Theme.bgCard
        radius: Theme.cornerCard
        borderWidth: root.bordered ? 1 : 0
        borderColor: Theme.strokeCard
        elevation: root.elevated ? 5 : 2
        shadowOpacity: Theme.dark ? 0.22 : 0.1
        elevated: true
    }
}
