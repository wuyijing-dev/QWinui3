import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// WinUI MenuFlyout: elevated Menu with showAt placement helper and isOpen.
Menu {
    id: root

    property int placement: Qt.AlignBottom
    property alias preferredPlacement: root.placement
    property bool isLightDismissEnabled: true
    property bool isOpen: false

    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    closePolicy: isLightDismissEnabled
                 ? (Popup.CloseOnEscape | Popup.CloseOnPressOutside)
                 : Popup.CloseOnEscape

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: isOpen = true
    onClosed: isOpen = false

    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }

    function showAt(targetItem, offsetX, offsetY) {
        if (!targetItem) {
            isOpen = true
            return
        }
        var ox = offsetX === undefined ? 0 : offsetX
        var oy = offsetY === undefined ? 0 : offsetY
        var px = ox
        var py = oy
        switch (placement) {
        case Qt.AlignTop:
            py = -implicitHeight + oy
            break
        case Qt.AlignRight:
            px = targetItem.width + 4 + ox
            py = oy
            break
        case Qt.AlignLeft:
            px = -implicitWidth - 4 + ox
            py = oy
            break
        default:
            py = targetItem.height + 4 + oy
            break
        }
        popup(targetItem, px, py)
        isOpen = true
    }

    function hide() {
        isOpen = false
    }

    background: ElevatedChrome {
        implicitWidth: 180
        implicitHeight: 40
        color: Theme.bgCardElevated
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.28 : 0.14
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
            from: 0.96; to: 1
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
        NumberAnimation {
            property: "scale"
            from: 1; to: 0.96
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
