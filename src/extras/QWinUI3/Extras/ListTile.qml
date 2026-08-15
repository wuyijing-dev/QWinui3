import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI ListViewItem-style row: glyph / leading, title, subtitle, and trailing slot.
T.ItemDelegate {
    id: control

    property string title: text
    property string subtitle: ""
    property alias description: control.subtitle
    property string glyph: ""
    property alias trailing: trailingSlot.data
    property alias leading: leadingSlot.data
    property bool showChevron: false
    property bool isSelected: false

    hoverEnabled: true
    padding: 12
    leftPadding: 16
    rightPadding: 12
    spacing: Theme.spacingLoose
    implicitWidth: 320
    implicitHeight: Math.max(Theme.navItemHeight + 8,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

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
            visible: control.glyph.length > 0 && leadingSlot.children.length === 0
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignVCenter
            radius: Theme.cornerControl
            color: Theme.fillSubtle

            Text {
                anchors.centerIn: parent
                text: control.glyph
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
            text: "\uE76C"
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
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
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
