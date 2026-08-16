import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// IconButton — Icon-only button helper.
//
//   IconButton {
//       id: btn
//       symbol: FluentIcons.Settings
//       onClicked: openSettings()
//   }
//   // --- API ---
//   // inherits Button: enabled, clicked()
//
// @notes
//   Icon-only Button helper; set symbol / iconGlyph; inherits clicked().

IconicButton {
    id: control

    // Icon-only: callers should set Accessible.name; fall back to text or a generic label.
    Accessible.name: control.text.length ? control.text : qsTr("Icon button")

    implicitWidth: Theme.controlHeight
    implicitHeight: Theme.controlHeight
    padding: 0
    scale: down && !Theme.reducedMotion ? 0.94 : 1

    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: Text {
        text: control.effectiveIconGlyph
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

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
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
