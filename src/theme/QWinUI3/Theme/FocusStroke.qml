import QtQuick

// FocusStroke — Dual-ring keyboard focus chrome (WinUI / Fluent).
//
//   FocusStroke { anchors.fill: parent; show: control.visualFocus }
//
// @notes
//   Shared by Style + Extras. Uses Theme.strokeFocus* / focusOuter/Inner and reducedMotion.

Item {
    id: root
    // Show the control
    property bool show: false
    // Frame corner radius
    property real frameRadius: Theme.cornerControl
    // Outer ring width (thicker in high contrast — 2px double per accessibility.md)
    property real outerSize: Theme.highContrast ? 2 : Theme.strokeFocusOuter
    // Inner ring width
    property real innerSize: Theme.highContrast ? 2 : Theme.strokeFocusInner
    visible: opacity > 0.01
    opacity: show ? 1 : 0
    scale: show ? 1 : (Theme.reducedMotion ? 1 : 0.96)
    z: 100

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingOutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -root.outerSize
        radius: root.frameRadius + root.outerSize
        color: "transparent"
        border.width: Theme.highContrast ? root.outerSize
                     : (Theme.dark ? root.outerSize : Math.max(1, root.outerSize - root.innerSize))
        border.color: Theme.focusOuter
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -root.innerSize
        radius: root.frameRadius + root.innerSize
        color: "transparent"
        border.width: root.innerSize
        border.color: Theme.focusInner
        visible: Theme.highContrast || root.innerSize > 0
    }
}
