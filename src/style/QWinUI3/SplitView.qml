import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.SplitView {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    handle: Item {
        implicitWidth: control.orientation === Qt.Horizontal ? 8 : 24
        implicitHeight: control.orientation === Qt.Horizontal ? 24 : 8

        Rectangle {
            anchors.centerIn: parent
            width: control.orientation === Qt.Horizontal ? (T.SplitHandle.hovered || T.SplitHandle.pressed ? 3 : 1) : 24
            height: control.orientation === Qt.Horizontal ? 24 : (T.SplitHandle.hovered || T.SplitHandle.pressed ? 3 : 1)
            radius: 1.5
            color: T.SplitHandle.pressed ? Theme.accent
                 : (T.SplitHandle.hovered ? Theme.strokeControlStrong : Theme.strokeDivider)

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on width {
                enabled: !Theme.reducedMotion && control.orientation === Qt.Horizontal
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on height {
                enabled: !Theme.reducedMotion && control.orientation === Qt.Vertical
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }
}
