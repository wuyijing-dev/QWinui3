import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ToolButton — Fluent styled ToolButton.
//
//   ToolButton { id: tool; text: qsTr("Edit"); onClicked: edit() }

T.ToolButton {
    id: control

    implicitWidth: Math.max(32, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(32, implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    flat: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.checked)
                return Theme.accent
            return Theme.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        scale: control.down && !Theme.reducedMotion ? 0.94 : 1
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: {
            if (!control.enabled || control.flat && !control.hovered && !control.down && !control.checked)
                return control.checked ? Theme.fillSubtle : "transparent"
            if (control.down || control.checked)
                return Theme.fillSubtle
            if (control.hovered)
                return Theme.fillSubtleSecondary
            return "transparent"
        }
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
        }
    }
}
