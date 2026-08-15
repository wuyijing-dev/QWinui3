import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ProgressBar — Fluent styled ProgressBar.
//
//   ProgressBar { value: 0.4; from: 0; to: 1 }

T.ProgressBar {
    id: control

    implicitWidth: 200
    implicitHeight: Theme.sliderThickness
    padding: 0

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: Theme.sliderThickness
        clip: control.indeterminate

        Rectangle {
            visible: !control.indeterminate
            width: Math.max(0, control.position * parent.width)
            height: parent.height
            radius: height / 2
            color: control.enabled ? Theme.accent : Theme.textDisabled

            Behavior on width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: Math.min(parent.width, 24)
                height: parent.height
                radius: height / 2
                visible: parent.width > 8
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "transparent" }
                    GradientStop {
                        position: 1
                        color: Qt.rgba(1, 1, 1, Theme.dark ? 0.22 : 0.35)
                    }
                }
            }
        }

        Rectangle {
            id: indeterminateBar
            visible: control.indeterminate
            width: Math.max(48, parent.width * 0.32)
            height: parent.height
            radius: height / 2
            color: Theme.accent
            opacity: Theme.reducedMotion ? 0.85 : 1

            SequentialAnimation on x {
                loops: Animation.Infinite
                running: control.indeterminate && control.visible && !Theme.reducedMotion
                NumberAnimation {
                    from: -indeterminateBar.width
                    to: control.width
                    duration: Math.max(900, control.width * 8)
                    easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    from: -indeterminateBar.width * 0.5
                    to: control.width
                    duration: Math.max(600, control.width * 5)
                    easing.type: Easing.InOutCubic
                }
            }

            Binding {
                when: Theme.reducedMotion && control.indeterminate
                target: indeterminateBar
                property: "x"
                value: (control.width - indeterminateBar.width) / 2
            }
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: Theme.sliderThickness
        radius: height / 2
        color: Theme.dark ? "#15FFFFFF" : "#0F000000"
    }
}
