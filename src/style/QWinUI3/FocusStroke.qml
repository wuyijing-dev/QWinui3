import QtQuick
import QWinUI3.Theme

Item {
    id: root
    property bool show: false
    property real frameRadius: Theme.cornerControl
    property real outerSize: 2
    property real innerSize: 1
    visible: opacity > 0.01
    opacity: show ? 1 : 0
    z: 100

    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -root.outerSize
        radius: root.frameRadius + root.outerSize
        color: "transparent"
        border.width: Theme.dark ? root.outerSize : root.outerSize - root.innerSize
        border.color: Theme.focusOuter
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -root.innerSize
        radius: root.frameRadius + root.innerSize
        color: "transparent"
        border.width: root.innerSize
        border.color: Theme.focusInner
    }
}
