import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MenuBarItem — Fluent styled MenuBarItem.
//
//   MenuBarItem { text: qsTr("File") }

T.MenuBarItem {
    id: control

    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 48)
    implicitHeight: 32

    padding: 8
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        scale: control.down && !Theme.reducedMotion ? 0.97 : 1
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
            if (control.highlighted || control.down)
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
    }
}
