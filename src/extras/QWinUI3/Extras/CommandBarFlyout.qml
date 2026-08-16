import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Window
import QWinUI3.Theme

// CommandBarFlyout — Popup CommandBar with primary + secondary commands.
//
//   CommandBarFlyout {
//       id: commandBarFlyout
//       AppBarButton { text: qsTr("Share") }
//   }
//
//   // --- API ---
//   // methods: showAt(item, preferredPlacement), show(), hide(), openFlyout(), closeFlyout(), reposition()
//   // commandBarFlyout.showAt(item, preferredPlacement)
//   // commandBarFlyout.show()
//   // commandBarFlyout.hide()
//   // commandBarFlyout.openFlyout()
//   // inherits Popup (+ Qt Quick Controls base API)
//
// @notes
//   Popup CommandBar; open at a target like Flyout.
//   showAt() opens then repositions after layout — first open must not use 0×0 size
//   (that clamped ShouldConstrainToRootBounds to the top-left).

T.Popup {
    id: root

    // Primary command host
    readonly property alias primaryCommands: primaryRow
    // Secondary command host
    readonly property alias secondaryCommands: secondaryCol
    // Primary commands slot
    default property alias primaryData: primaryRow.data
    // Secondary commands slot
    property alias secondaryData: secondaryCol.data

    // Open / visible state
    property bool isOpen: false
    // Close on outside click / Esc
    property bool isLightDismissEnabled: true
    // Anchor item for placement
    property Item target: null
    // Popup / flyout placement
    property int placement: Qt.AlignBottom
    // Preferred flyout placement
    property alias preferredPlacement: root.placement
    // WinUI ShouldConstrainToRootBounds — clamp into overlay when true
    property bool shouldConstrainToRootBounds: true

    // Show secondary command list
    readonly property bool showSecondary: secondaryCol.children.length > 0

    // Show anchored at the given point or item
    function showAt(item, preferredPlacement) {
        if (preferredPlacement !== undefined && preferredPlacement !== null)
            root.placement = preferredPlacement
        if (item) {
            root.target = item
            var win = item.Window.window
            var host = (win && win.Overlay && win.Overlay.overlay) ? win.Overlay.overlay : item
            root.parent = host
        }
        root.isOpen = true
        // Layout (and real width/height) exists only after open — reposition then.
        Qt.callLater(root.reposition)
    }

    // Show the control
    function show() {
        isOpen = true
        Qt.callLater(reposition)
    }
    // Hide the control
    function hide() { isOpen = false }
    // Open the flyout
    function openFlyout() { show() }
    // Dismiss the flyout
    function closeFlyout() { hide() }

    // Reposition against target using current laid-out size
    function reposition() {
        if (!target || !parent)
            return
        var host = parent
        var p = target.mapToItem(host, 0, 0)
        var gap = 8
        var w = Math.max(root.width, root.implicitWidth, 200)
        var h = Math.max(root.height, root.implicitHeight, 40)
        // Guard: unlaid-out popups report 0 — clamping with w/h=0 pins to (8,8).
        if (!(w > 1) || !(h > 1))
            return

        switch (root.placement) {
        case Qt.AlignTop:
            root.x = p.x + Math.max(0, (target.width - w) / 2)
            root.y = p.y - h - gap
            break
        case Qt.AlignRight:
            root.x = p.x + target.width + gap
            root.y = p.y
            break
        case Qt.AlignLeft:
            root.x = p.x - w - gap
            root.y = p.y
            break
        default:
            root.x = p.x + Math.max(0, (target.width - w) / 2)
            root.y = p.y + target.height + gap
            break
        }

        if (root.shouldConstrainToRootBounds && host.width > 0 && host.height > 0) {
            var margin = 8
            var maxX = host.width - w - margin
            var maxY = host.height - h - margin
            if (maxX >= margin)
                root.x = Math.max(margin, Math.min(root.x, maxX))
            if (maxY >= margin)
                root.y = Math.max(margin, Math.min(root.y, maxY))
        }
    }

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: {
        isOpen = true
        reposition()
        Qt.callLater(reposition)
    }
    onClosed: isOpen = false

    padding: 6
    modal: false
    dim: false
    closePolicy: isLightDismissEnabled
                 ? (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)
                 : T.Popup.CloseOnEscape
    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(200, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    contentItem: ColumnLayout {
        spacing: 4
        Accessible.role: Accessible.PopupMenu
        Accessible.name: qsTr("Command bar flyout")

        RowLayout {
            id: primaryRow
            spacing: 2
            Layout.fillWidth: true
        }

        Rectangle {
            visible: root.showSecondary
            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            height: 1
            color: Theme.strokeDivider
            opacity: 0.9
        }

        ColumnLayout {
            id: secondaryCol
            visible: root.showSecondary
            spacing: 2
            Layout.fillWidth: true
        }
    }

    background: ElevatedChrome {
        color: Theme.bgCardElevated
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 6
        shadowOpacity: Theme.dark ? 0.32 : 0.18
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
    }
}
