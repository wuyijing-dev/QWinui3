import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Flyout — Light-dismiss popup anchored to a target.
//
//   Flyout {
//       id: flyout
//       target: button
//       Label { text: qsTr("Details") }
//   }
//
//   // --- API ---
//   // methods: showAt(item, place), show(), hide(), reposition()
//   // flyout.showAt(item, place)
//   // flyout.show()
//   // flyout.hide()
//   // flyout.reposition()
//   // inherits Popup (+ Qt Quick Controls base API)

T.Popup {
    id: root

    // Popup / flyout placement
    property int placement: Qt.AlignBottom
    // Preferred flyout placement
    property alias preferredPlacement: root.placement
    // Anchor item for placement
    property Item target: null
    // Close on outside click / Esc
    property bool isLightDismissEnabled: true
    // Open / visible state
    property bool isOpen: false
    // Primary title text
    property string title: ""
    // Default children / content slot
    default property alias contentData: body.data

    padding: 12
    modal: false
    dim: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.PopupMenu
    Accessible.name: title.length ? title : qsTr("Flyout")

    implicitWidth: Math.max(180, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: {
        isOpen = true
        reposition()
    }
    onClosed: isOpen = false

    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }

    // Show anchored at the given point or item
    function showAt(item, place) {
        if (item) {
            root.target = item
            // Prefer window overlay so we can clamp to the full window, not just the target.
            var win = item.Window.window
            root.parent = (win && win.Overlay && win.Overlay.overlay) ? win.Overlay.overlay : item
        }
        if (place !== undefined && place !== null)
            root.placement = place
        root.isOpen = true
        Qt.callLater(root.reposition)
    }

    // Show the control
    function show() { isOpen = true; Qt.callLater(reposition) }
    // Hide the control
    function hide() { isOpen = false }

    // Reposition the popup / flyout
    function reposition() {
        if (!target || !parent)
            return
        var p = target.mapToItem(parent, 0, 0)
        var gap = 8
        var w = implicitWidth
        var h = implicitHeight
        switch (placement) {
        case Qt.AlignRight:
            x = p.x + target.width + gap
            y = p.y + (target.height - h) / 2
            break
        case Qt.AlignLeft:
            x = p.x - w - gap
            y = p.y + (target.height - h) / 2
            break
        case Qt.AlignTop:
            x = p.x + (target.width - w) / 2
            y = p.y - h - gap
            break
        default:
            x = p.x + (target.width - w) / 2
            y = p.y + target.height + gap
            break
        }
        var margin = 8
        x = Math.max(margin, Math.min(x, parent.width - w - margin))
        y = Math.max(margin, Math.min(y, parent.height - h - margin))
    }

    contentItem: ColumnLayout {
        id: body
        spacing: Theme.spacing

        Text {
            visible: root.title.length > 0
            Layout.fillWidth: true
            text: root.title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            wrapMode: Text.Wrap
        }
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.28 : 0.16
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
