import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.AbstractButton {
    id: control

    property bool closable: false
    property alias isCloseButtonVisible: control.closable
    property bool highlighted: false
    property bool flat: false
    property string iconGlyph: ""
    // small | medium
    property string chipSize: "medium"
    signal closeClicked()

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
        FontIcon {
            visible: control.iconGlyph.length > 0
            glyph: control.iconGlyph
            fontSize: 12
            iconColor: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control.checked || control.highlighted)
                    return Theme.textOnAccent
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
                if (control.checked || control.highlighted)
                    return Theme.textOnAccent
                return Theme.textPrimary
            }
            verticalAlignment: Text.AlignVCenter
        }
        ToolButton {
            visible: control.closable
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            text: "\uE711"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 9
            onClicked: control.closeClicked()
        }
    }

    background: Rectangle {
        radius: height / 2
        color: {
            if (control.checked || control.highlighted)
                return Theme.accent
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.fillControl
        }
        border.width: (control.checked || control.highlighted) ? 0 : 1
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
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
