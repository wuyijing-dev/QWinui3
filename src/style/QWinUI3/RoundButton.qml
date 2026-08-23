import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RoundButton — Fluent styled RoundButton.
//
//   RoundButton {
//       id: round
//       text: "+"
//       enabled: true
//       onClicked: add()
//   }
//   // --- API ---
//   // inherits AbstractButton: text, enabled, clicked()
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls RoundButton.
//   Public API is the Qt Quick Controls RoundButton type; this file supplies visuals/metrics only.

T.RoundButton {
    id: control


    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.onPressAction: if (control.enabled) control.clicked()
    implicitWidth: Math.max(Theme.dp(40), 36, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.dp(40), 36, implicitContentHeight + topPadding + bottomPadding)

    radius: Math.min(width, height) / 2
    padding: 8
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.highlighted
             ? (control.enabled ? Theme.textOnAccent : Theme.textDisabled)
             : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        scale: control.down && !Theme.reducedMotion ? 0.94 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Rectangle {
        implicitWidth: Theme.dp(40)
        implicitHeight: Theme.dp(40)
        radius: control.radius
        scale: control.down && !Theme.reducedMotion ? 0.94 : 1
        color: {
            if (control.highlighted) {
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0,0,0,0.2) : Qt.rgba(1,1,1,0.2))
                if (control.hovered)
                    return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0,0,0,0.1) : Qt.rgba(1,1,1,0.1))
                return Theme.accent
            }
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.bgControlRest
        }
        border.width: control.highlighted ? 0 : 1
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.motionMs("normal")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: control.radius
        }
    }
}
