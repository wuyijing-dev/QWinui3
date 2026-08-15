import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Popup {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 8
    transformOrigin: Item.Top

    background: ElevatedChrome {
        implicitWidth: 200
        implicitHeight: 40
        radius: Theme.cornerOverlay
        color: Theme.bgCardElevated
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.32 : 0.16
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "scale"
            from: 0.98; to: 1
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
