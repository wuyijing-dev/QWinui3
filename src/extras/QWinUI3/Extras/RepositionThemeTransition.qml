import QtQuick
import QWinUI3.Theme

// RepositionThemeTransition — Animate this item when its layout x/y change.
//
//   Flow {
//       Repeater {
//           model: 6
//           RepositionThemeTransition {
//               width: 72; height: 72
//               Rectangle { anchors.fill: parent; radius: 8; color: Theme.accent }
//           }
//       }
//   }
//
//   // --- API ---
//   // properties: animatePosition
//
// @notes
//   Wrap Flow/Grid children. Honors Theme.reducedMotion.

Item {
    id: root

    default property alias content: host.data

    // Animate when this item's x/y change (e.g. Flow / Grid reflow)
    property bool animatePosition: true

    Behavior on x {
        enabled: root.animatePosition && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on y {
        enabled: root.animatePosition && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }

    Item {
        id: host
        anchors.fill: parent
    }
}
