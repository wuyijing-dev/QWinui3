import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// PageIndicator — Fluent styled PageIndicator.
//
//   SwipeView {
//       id: pages
//       Item {}
//       Item {}
//       Item {}
//   }
//   PageIndicator {
//       id: dots
//       count: pages.count
//       currentIndex: pages.currentIndex
//       interactive: true
//       anchors.horizontalCenter: parent.horizontalCenter
//   }
//   // --- API ---
//   // dots.count / currentIndex / interactive

T.PageIndicator {
    id: control

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    spacing: 8
    padding: 4
    count: 3
    currentIndex: 0

    delegate: Rectangle {
        required property int index
        // Active state
        readonly property bool active: index === control.currentIndex
        implicitWidth: active ? 18 : 8
        implicitHeight: 8
        radius: height / 2
        color: active ? Theme.accent : Theme.strokeControlStrong
        opacity: active ? 1 : 0.4
        scale: active ? 1 : 0.92

        Behavior on implicitWidth {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
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

    contentItem: Row {
        spacing: control.spacing
        Repeater {
            model: control.count
            delegate: control.delegate
        }
    }
}
