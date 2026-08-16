import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ListTile — List row: leading, title, subtitle, trailing.
//
//   ListTile {
//       title: qsTr("Item")
//       subtitle: qsTr("Detail")
//       symbol: FluentIcons.Document
//   }
//
// @notes
//   List row tile with leading symbol and trailing slot.

T.ItemDelegate {
    id: control

    Layout.fillWidth: true

    // Primary title text
    property string title: text
    // Secondary subtitle text
    property string subtitle: ""
    // Supporting description text
    property alias description: control.subtitle
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Leading content slot
    property alias leading: leadingSlot.data
    // Trailing slot
    default property alias trailing: trailingSlot.data
    // Show trailing chevron
    property bool showChevron: false
    // Selected state
    property bool isSelected: false

    // Resolved glyph string
    readonly property string effectiveGlyph: IconSource.resolve(symbol, glyph)

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 12
    leftPadding: 16
    rightPadding: 12
    spacing: Theme.spacingLoose
    implicitWidth: 320
    implicitHeight: Math.max(Theme.navItemHeight + 8,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ListItem
    Accessible.name: title.length ? title : qsTr("List item")
    Accessible.description: subtitle
    Accessible.selectable: true
    Accessible.selected: isSelected || checked
    Accessible.checkable: checkable
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) clicked()

    scale: down && !Theme.reducedMotion ? 0.995 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: RowLayout {
        spacing: control.spacing

        Item {
            id: leadingSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        Rectangle {
            visible: control.effectiveGlyph.length > 0 && leadingSlot.children.length === 0
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignVCenter
            radius: Theme.cornerControl
            color: Theme.fillSubtle

            Text {
                anchors.centerIn: parent
                text: control.effectiveGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 16
                color: control.enabled ? Theme.accent : Theme.textDisabled
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: control.title
                font.family: control.font.family
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
            }
            Text {
                visible: control.subtitle.length > 0
                Layout.fillWidth: true
                text: control.subtitle
                font.family: control.font.family
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 3
            }
        }

        Item {
            id: trailingSlot
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        Text {
            visible: control.showChevron
            Layout.alignment: Qt.AlignVCenter
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return "transparent"
                if (control.isSelected || control.checked)
                    return Theme.fillSubtle
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered || control.highlighted)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            border.width: 0
            border.color: "transparent"

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
        Rectangle {
            visible: control.isSelected || control.checked
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: Math.min(parent.height - 16, 24)
            radius: 1.5
            color: Theme.accent
        }
    }
}
