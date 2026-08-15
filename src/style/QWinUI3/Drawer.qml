import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Drawer {
    id: control

    parent: T.Overlay.overlay
    modal: true
    dim: true
    interactive: true
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    padding: Theme.spacingSection
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge ? "x" : "y"
            duration: Theme.duration(Theme.motionNormal)
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

    background: Rectangle {
        color: Theme.bgAcrylic
        border.width: 1
        border.color: Theme.strokeDivider

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.35 : 0.18
            shadowColor: "#000000"
            shadowHorizontalOffset: control.edge === Qt.LeftEdge ? 6
                                   : (control.edge === Qt.RightEdge ? -6 : 0)
            shadowVerticalOffset: control.edge === Qt.TopEdge ? 6
                                 : (control.edge === Qt.BottomEdge ? -6 : 0)
            blurMax: 28
            autoPaddingEnabled: true
        }
    }

    T.Overlay.modal: Rectangle {
        color: Theme.bgSmoke
        Behavior on opacity {
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
