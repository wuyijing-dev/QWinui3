import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

// Scroll view with a vertical scrollbar that shows a value label while dragging / hovering the handle.
T.Control {
    id: root

    default property alias contentData: flick.data
    property alias contentWidth: flick.contentWidth
    property alias contentHeight: flick.contentHeight
    property alias contentX: flick.contentX
    property alias contentY: flick.contentY
    property alias flickable: flick

    // Optional map from scroll position (0..1) → label. Empty → percentage.
    property var labels: []
    property string labelFormat: "%1%"
    property bool alwaysShowLabel: false

    implicitWidth: 200
    implicitHeight: 200
    clip: true

    readonly property real scrollPosition: {
        if (flick.contentHeight <= flick.height)
            return 0
        return flick.contentY / Math.max(1, flick.contentHeight - flick.height)
    }

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

        // Annotation bubble beside the handle
        Rectangle {
            id: bubble
            z: 2
            width: labelText.implicitWidth + 16
            height: 28
            radius: Theme.cornerControl
            color: Theme.bgCardElevated
            border.width: 1
            border.color: Theme.strokeCard
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

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowOpacity: Theme.dark ? 0.28 : 0.14
                shadowColor: "#000000"
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 4
                blurMax: 16
                autoPaddingEnabled: true
            }

            Text {
                id: labelText
                anchors.centerIn: parent
                text: root.currentLabel
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
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
