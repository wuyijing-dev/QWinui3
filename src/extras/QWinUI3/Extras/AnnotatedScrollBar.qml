import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// AnnotatedScrollBar — Scroll area with a value label on the vertical scrollbar.
//
//   AnnotatedScrollBar {
//       id: scroll
//       anchors.fill: parent
//       // labels: sampled by scrollPosition (0..1). Empty → labelFormat with percent.
//       labels: ["Intro", "Body", "End"]
//       labelFormat: "%1%"
//       alwaysShowLabel: false
//       Column {
//           width: scroll.flickable.width
//           Repeater {
//               model: 40
//               Label { text: "Row " + (index + 1); height: 36 }
//           }
//       }
//   }
//
//   // --- API ---
//   // read:  scroll.scrollPosition (0..1), scroll.currentLabel
//   // write: scroll.contentY = …  or  scroll.flickable.contentY = …
//   // size:  scroll.contentWidth / contentHeight / flickable
//   // inherits Control: padding, font, contentItem
//
// @notes
//   Place tall content as children (default property → Flickable).
//   Vertical ScrollBar shows a floating label (ElevatedChrome) while scrolling
//   unless alwaysShowLabel is true.
//   labels is a string[]; index = round(scrollPosition * (length-1)).
//   When labels is empty, currentLabel = labelFormat.arg(percent).

T.Control {
    id: root

    // Default children / content slot (hosted in the inner Flickable)
    default property alias contentData: flick.data
    // Flickable content width
    property alias contentWidth: flick.contentWidth
    // Flickable content height
    property alias contentHeight: flick.contentHeight
    // Flickable content X
    property alias contentX: flick.contentX
    // Flickable content Y — set this (or flickable.contentY) to scroll programmatically
    property alias contentY: flick.contentY
    // Inner Flickable (bounds, contentItem, ScrollBar.vertical, …)
    property alias flickable: flick

    // Optional string[] sampled by scrollPosition; empty → percentage via labelFormat
    property var labels: []
    // Percent format when labels is empty (Qt arg: "%1%")
    property string labelFormat: "%1%"
    // Keep the floating scrollbar label visible even when idle
    property bool alwaysShowLabel: false

    implicitWidth: 200
    implicitHeight: 200
    clip: true

    // Normalized vertical scroll position 0..1
    readonly property real scrollPosition: {
        if (flick.contentHeight <= flick.height)
            return 0
        return flick.contentY / Math.max(1, flick.contentHeight - flick.height)
    }

    // Label for the current scroll position (from labels[] or labelFormat)
    readonly property string currentLabel: {
        if (labels && labels.length > 0) {
            var idx = Math.min(labels.length - 1,
                               Math.max(0, Math.round(scrollPosition * (labels.length - 1))))
            return "" + labels[idx]
        }
        return labelFormat.arg(Math.round(scrollPosition * 100))
    }

    contentItem: Item {
        Flickable {
            id: flick
            anchors.fill: parent
            anchors.rightMargin: vbar.visible ? vbar.width : 0
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                id: vbar
                policy: flick.contentHeight > flick.height
                        ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }
        }

        ElevatedChrome {
            id: bubble
            z: 2
            width: labelText.implicitWidth + 16
            height: 28
            radius: Theme.cornerControl
            color: Theme.bgCardElevated
            borderWidth: 1
            borderColor: Theme.strokeCard
            elevation: 4
            shadowOpacity: Theme.dark ? 0.28 : 0.14
            opacity: (root.alwaysShowLabel || vbar.pressed || vbar.hovered) && vbar.size < 1.0 ? 1 : 0
            visible: opacity > 0.01
            scale: opacity > 0.5 ? 1 : 0.94

            x: Math.max(0, flick.width - width - 4)
            y: {
                var track = Math.max(0, flick.height - height)
                var handleCenter = vbar.position * flick.height + (vbar.size * flick.height) / 2
                return Math.min(track, Math.max(0, handleCenter - height / 2))
            }

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
                    easing.type: Theme.easingEnter
                }
            }
            Behavior on y {
                enabled: !Theme.reducedMotion && (vbar.pressed || vbar.hovered)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Text {
                id: labelText
                anchors.centerIn: parent
                text: root.currentLabel
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                z: 1
            }
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard
        radius: Theme.cornerControl
    }
}
