import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Chip — Compact selectable tag; optional close affordance.
//
//   Chip {
//       text: qsTr("Tag")
//       closable: true
//       onCloseClicked: remove()
//   }

T.AbstractButton {
    id: control

    // Shows a trailing close affordance
    property bool closable: false
    property alias isCloseButtonVisible: control.closable
    // Emphasized / selected chrome
    property bool highlighted: false
    // Flat chrome without fill
    property bool flat: false
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Initials / short avatar text instead of an icon
    property string avatarText: ""
    // filled | outline
    property string appearance: "filled"
    // small | medium
    property string chipSize: "medium"
    // Fired when the close glyph is clicked (does not uncheck)
    signal closeClicked()

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    checkable: true
    hoverEnabled: true
    implicitHeight: chipSize === "small" ? Theme.controlHeight - 10 : Theme.controlHeight - 4
    implicitWidth: Math.max(chipSize === "small" ? 36 : 48,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    leftPadding: chipSize === "small" ? 8 : 12
    rightPadding: closable ? 4 : (chipSize === "small" ? 8 : 12)
    topPadding: chipSize === "small" ? 2 : 4
    bottomPadding: topPadding
    font.family: Theme.fontFamily
    font.pixelSize: chipSize === "small" ? 11 : Theme.fontCaption
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.checkable: true
    Accessible.checked: control.checked

    readonly property bool _outline: appearance === "outline"
    readonly property bool _selected: checked || highlighted

    scale: down && !Theme.reducedMotion ? 0.97 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: RowLayout {
        spacing: 4
        Rectangle {
            visible: control.avatarText.length > 0
            Layout.preferredWidth: control.chipSize === "small" ? 18 : 22
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignVCenter
            radius: width / 2
            color: control._selected && !control._outline ? Theme.textOnAccent : Theme.accent
            Text {
                anchors.centerIn: parent
                text: control.avatarText.charAt(0).toUpperCase()
                font.family: Theme.fontFamily
                font.pixelSize: control.chipSize === "small" ? 9 : 11
                font.weight: Theme.fontWeightSemiBold
                color: control._selected && !control._outline ? Theme.accent : Theme.textOnAccent
            }
        }
        FontIcon {
            visible: control.effectiveIconGlyph.length > 0 && control.avatarText.length === 0
            glyph: control.effectiveIconGlyph
            fontSize: 12
            iconColor: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control._selected && !control._outline)
                    return Theme.textOnAccent
                if (control._outline && control._selected)
                    return Theme.accent
                return Theme.textSecondary
            }
            Layout.alignment: Qt.AlignVCenter
        }
        Text {
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.weight: control.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control._selected && !control._outline)
                    return Theme.textOnAccent
                if (control._outline && control._selected)
                    return Theme.accent
                return Theme.textPrimary
            }
            verticalAlignment: Text.AlignVCenter
        }
        AbstractButton {
            visible: control.closable
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Accessible.name: qsTr("Remove")
            onClicked: control.closeClicked()
            contentItem: Text {
                text: FluentIcons.ChromeClose
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 9
                color: {
                    if (!control.enabled)
                        return Theme.textDisabled
                    if (control._selected && !control._outline)
                        return Theme.textOnAccent
                    return Theme.textSecondary
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: width / 2
                color: parent.down ? Theme.fillSubtleTertiary
                     : (parent.hovered ? Theme.fillSubtle : "transparent")
            }
        }
    }

    background: Rectangle {
        radius: height / 2
        color: {
            if (control._outline) {
                if (control.down)
                    return Theme.fillSubtle
                if (control.hovered)
                    return Theme.fillSubtle
                return "transparent"
            }
            if (control._selected)
                return Theme.accent
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.fillControl
        }
        border.width: control._outline ? (control._selected ? 2 : 1) : ((control._selected) ? 0 : 1)
        border.color: control._outline && control._selected ? Theme.accent : Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on border.color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: parent.radius + 2
            color: "transparent"
            border.width: control.visualFocus ? Theme.strokeFocusOuter : 0
            border.color: Theme.accent
            visible: control.visualFocus
        }
    }
}
