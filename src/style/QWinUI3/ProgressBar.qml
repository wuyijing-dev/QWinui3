import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ProgressBar — Fluent styled ProgressBar (WinUI ShowError / ShowPaused).
//
//   ProgressBar {
//       id: bar
//       value: 0.6
//       showError: false
//       showPaused: false
//   }
//
// @notes
//   Fluent ProgressBar with WinUI ShowError (critical fill) and ShowPaused (caution fill;
//   pauses indeterminate animation). Base API is Qt Quick Controls ProgressBar.

T.ProgressBar {
    id: control

    // WinUI ShowError — paint the bar in the error/critical color
    property bool showError: false
    // WinUI ShowPaused — caution color; stops indeterminate motion
    property bool showPaused: false

    Accessible.role: Accessible.ProgressBar
    Accessible.name: qsTr("Progress")
    Accessible.description: {
        if (control.indeterminate)
            return qsTr("In progress")
        if (control.showError)
            return qsTr("Error")
        if (control.showPaused)
            return qsTr("Paused")
        return qsTr("%1 percent").arg(Math.round(control.position * 100))
    }

    implicitWidth: 200
    implicitHeight: Theme.sliderThickness
    padding: 0

    readonly property color _fillColor: {
        if (!control.enabled)
            return Theme.textDisabled
        if (control.showError)
            return Theme.systemCritical
        if (control.showPaused)
            return Theme.systemCaution
        return Theme.accent
    }

    property bool _wasComplete: false

    onPositionChanged: {
        if (control.indeterminate)
            return
        if (control.position >= 1 && !_wasComplete) {
            _wasComplete = true
            if (!Theme.reducedMotion)
                completeFlash.restart()
        } else if (control.position < 0.995) {
            _wasComplete = false
        }
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: Theme.sliderThickness

        Rectangle {
            id: determinateFill
            visible: !control.indeterminate
            width: Math.max(0, control.position * parent.width)
            height: parent.height
            radius: height / 2
            color: control._fillColor
            opacity: 1

            Behavior on width {
                enabled: !Theme.reducedMotion && control.visible
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
            Behavior on opacity {
                enabled: !Theme.reducedMotion && !completeFlash.running
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            SequentialAnimation {
                id: completeFlash
                NumberAnimation {
                    target: determinateFill
                    property: "opacity"
                    to: 0.55
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
                NumberAnimation {
                    target: determinateFill
                    property: "opacity"
                    to: 1
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: Math.min(parent.width, 24)
                height: parent.height
                radius: height / 2
                visible: parent.width > 8 && !control.showError
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
            color: control._fillColor
            opacity: Theme.reducedMotion || control.showPaused ? 0.85 : 1

            // Stay inside the pill track — no clip:true (would square the ends).
            SequentialAnimation on x {
                loops: Animation.Infinite
                running: control.indeterminate && control.visible
                         && !Theme.reducedMotion && !control.showPaused
                NumberAnimation {
                    from: 0
                    to: Math.max(0, control.width - indeterminateBar.width)
                    duration: Math.max(900, control.width * 8)
                    easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    from: Math.max(0, control.width - indeterminateBar.width)
                    to: 0
                    duration: Math.max(600, control.width * 5)
                    easing.type: Easing.InOutCubic
                }
            }

            Binding {
                when: (Theme.reducedMotion || control.showPaused) && control.indeterminate
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
