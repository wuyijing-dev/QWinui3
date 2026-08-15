import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ScrollBar — Fluent styled ScrollBar.
//
//   Flickable {
//       ScrollBar.vertical: ScrollBar { }
//   }

T.ScrollBar {
    id: control

    implicitWidth: control.interactive
                   ? (hovered || pressed || active ? 12 : 8)
                   : 6
    implicitHeight: control.interactive
                    ? (hovered || pressed || active ? 12 : 8)
                    : 6
    padding: 2

    Behavior on implicitWidth {
        enabled: !Theme.reducedMotion && control.orientation === Qt.Vertical
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion && control.orientation === Qt.Horizontal
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: Rectangle {
        implicitWidth: control.interactive ? 6 : 3
        implicitHeight: control.interactive ? 6 : 3
        radius: Math.min(width, height) / 2
        color: control.pressed ? Theme.textSecondary
             : (control.hovered ? Theme.textSecondary : Theme.strokeControlStrong)
        opacity: control.policy === T.ScrollBar.AlwaysOn
              || (control.active && control.size < 1.0)
              || control.hovered || control.pressed ? 0.75 : 0
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Rectangle {
        radius: Math.min(width, height) / 2
        color: Theme.fillSubtle
        opacity: control.hovered || control.pressed ? 1 : 0
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
            }
        }
    }
}
