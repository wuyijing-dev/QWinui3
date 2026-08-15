import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

T.AbstractButton {
    id: control

    property string iconGlyph: "\uE8A7"
    property bool highlighted: false
    property bool flat: true
    property real iconSize: 16
    property string toolTipText: ""
    property bool badgeVisible: false
    property int badgeValue: 0
    property string badgeText: ""
    property int badgeMaxValue: 99

    implicitWidth: Theme.controlHeight
    implicitHeight: Theme.controlHeight
    hoverEnabled: true
    padding: 0
    font.family: Theme.fontFamilyIcon
    font.pixelSize: iconSize
    scale: down && !Theme.reducedMotion ? 0.94 : 1
    ToolTip.visible: hovered && toolTipText.length > 0
    ToolTip.text: toolTipText

    readonly property string _badgeLabel: {
        if (badgeText.length)
            return badgeText
        if (badgeValue <= 0)
            return ""
        if (badgeValue > badgeMaxValue)
            return badgeMaxValue + "+"
        return String(badgeValue)
    }

    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: Text {
        text: control.iconGlyph
        font.family: Theme.fontFamilyIcon
        font.pixelSize: control.iconSize
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.highlighted || control.checked)
                return Theme.accent
            return Theme.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (control.flat && !control.hovered && !control.down && !control.checked
                    && !control.visualFocus)
                return "transparent"
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down || control.checked)
                return Theme.fillSubtleTertiary
            if (control.hovered)
                return Theme.fillSubtle
            return Theme.fillControl
        }
        border.width: control.flat ? 0 : 1
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
            radius: Theme.cornerControl + 1
            color: "transparent"
            border.width: control.visualFocus ? Theme.strokeFocusOuter : 0
            border.color: Theme.accent
            visible: control.visualFocus
        }

        Rectangle {
            visible: control.badgeVisible || control._badgeLabel.length > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: -2
            width: Math.max(16, badgeLabel.implicitWidth + 8)
            height: 16
            radius: 8
            color: Theme.systemCritical
            z: 2

            Text {
                id: badgeLabel
                anchors.centerIn: parent
                text: control._badgeLabel.length ? control._badgeLabel : ""
                font.family: Theme.fontFamily
                font.pixelSize: 10
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textOnAccent
                visible: text.length > 0
            }
        }
    }
}
