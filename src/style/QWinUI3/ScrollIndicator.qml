import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.ScrollIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2

    contentItem: Rectangle {
        implicitWidth: control.horizontal ? 100 : 3
        implicitHeight: control.horizontal ? 3 : 100
        radius: width / 2
        color: Theme.strokeControlStrong
        visible: control.size < 1.0
        opacity: 0.0

        states: State {
            name: "active"
            when: control.active
            PropertyChanges { control.contentItem.opacity: 0.6 }
        }

        transitions: [
            Transition {
                from: "active"
                SequentialAnimation {
                    PauseAnimation { duration: 450 }
                    NumberAnimation {
                        target: control.contentItem
                        duration: Theme.duration(Theme.motionNormal)
                        property: "opacity"
                        to: 0.0
                    }
                }
            },
            Transition {
                to: "active"
                NumberAnimation {
                    target: control.contentItem
                    duration: Theme.duration(Theme.motionFast)
                    property: "opacity"
                    to: 0.6
                }
            }
        ]
    }
}
