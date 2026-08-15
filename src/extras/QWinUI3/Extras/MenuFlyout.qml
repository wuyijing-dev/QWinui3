import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// MenuFlyout — Elevated Menu with showAt / isOpen helpers.
//
//   MenuFlyout {
//       MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }
//   }

Menu {
    id: root

    // Popup / flyout placement
    property int placement: Qt.AlignBottom
    // Preferred flyout placement
    property alias preferredPlacement: root.placement
    // Close on outside click / Esc
    property bool isLightDismissEnabled: true
    // Open / visible state
    property bool isOpen: false
    // Primary title text
    property string title: ""

    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.PopupMenu
    Accessible.name: title.length ? title : qsTr("Menu")

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

    // Open Menu
    function openMenu() { isOpen = true }
    // Close Menu
    function closeMenu() { isOpen = false }

    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }

    // Show At
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

    // Hide
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
        elevation: 8
        shadowOpacity: Theme.dark ? 0.34 : 0.18
        shadowBlur: 1.0
        blurMax: 32
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
