import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// StackView — Fluent styled StackView.
//
//   StackView {
//       id: stack
//       anchors.fill: parent
//       initialItem: page1
//   }
//   stack.push(page2)
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls StackView.
//   Public API is the Qt Quick Controls StackView type; this file supplies visuals/metrics only.

T.StackView {
    id: control

    readonly property int __dur: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionNormal)
    readonly property int __durFast: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionFast)

    popEnter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: control.__dur
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "x"
            from: Theme.reducedMotion ? 0 : (control.mirrored ? -0.2 : 0.2) * -control.width
            to: 0
            duration: control.__dur
            easing.type: Theme.easingEnter
        }
    }
    popExit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: control.__durFast
            easing.type: Theme.easingExit
        }
    }
    pushEnter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: control.__dur
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "x"
            from: Theme.reducedMotion ? 0 : (control.mirrored ? -0.2 : 0.2) * control.width
            to: 0
            duration: control.__dur
            easing.type: Theme.easingEnter
        }
    }
    pushExit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: control.__durFast
            easing.type: Theme.easingExit
        }
    }
    replaceEnter: pushEnter
    replaceExit: popExit
}
