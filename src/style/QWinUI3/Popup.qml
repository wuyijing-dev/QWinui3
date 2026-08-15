import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Popup {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 8
    transformOrigin: Item.Top

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        radius: Theme.cornerOverlay
        color: Theme.bgCardElevated
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.28 : 0.14
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            blurMax: 28
            autoPaddingEnabled: true
        }
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
