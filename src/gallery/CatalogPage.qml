import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// CatalogPage — Gallery scroll host (PageHeader + padded column).
//
//   CatalogPage {
//       title: qsTr("Button")
//       subtitle: qsTr("…")
//       ControlExample { headerText: qsTr("Basic"); … }
//   }
//
// Root is Item (not Page): Qt 6.8 Page.title / Page.footer / Pane.contentData are FINAL
// and cannot be redeclared or aliased.

Item {
    id: root

    property string title: ""
    property alias subtitle: header.subtitle
    // Gallery page component id for favorites (set by Main on open — 1.20)
    property alias componentId: header.componentId
    property real pagePadding: Theme.spacingSection
    property real sectionSpacing: Theme.spacingSection
    // True while the page Flickable is dragged or coasting
    readonly property bool viewMoving: Math.abs(_wheelRemain) > 0.35
                                       || (scroll.contentItem
                                           && (scroll.contentItem.moving || scroll.contentItem.flicking))
    property real _wheelRemain: 0
    // Optional footer outside the scroll (e.g. StatusBar)
    property alias footer: footerSlot.data
    // Floating overlays (ToastHost, dialogs) — not scrolled
    property alias overlay: overlaySlot.data
    default property alias contentData: stack.data

    function _findNamed(item, name) {
        if (!item || !name)
            return null
        if (item.objectName === name)
            return item
        var kids = item.children || []
        for (var i = 0; i < kids.length; ++i) {
            var hit = _findNamed(kids[i], name)
            if (hit)
                return hit
        }
        return null
    }

    function _flickableAncestor(start) {
        var p = start
        while (p) {
            if (p.contentItem !== undefined && p.contentItem
                    && p.contentItem.contentY !== undefined)
                return p.contentItem
            if (p.contentY !== undefined && p.contentItem !== undefined
                    && p.flickableDirection !== undefined)
                return p
            p = p.parent
        }
        return null
    }

    function scrollToItem(item) {
        if (!item)
            return false
        var flick = null
        var p = item
        while (p) {
            flick = _flickableAncestor(p)
            if (flick)
                break
            p = p.parent
        }
        if (!flick)
            return false
        var itemTop = item.mapToGlobal(0, 0).y
        var viewTop = flick.mapToGlobal(0, 0).y
        var localY = itemTop - viewTop + flick.contentY
        var maxY = Math.max(0, flick.contentHeight - flick.height)
        flick.contentY = Math.max(0, Math.min(localY - 12, maxY))
        return true
    }

    function scrollToName(name) {
        var hit = _findNamed(root, String(name || ""))
        if (!hit)
            return false
        var ok = scrollToItem(hit)
        if (!ok)
            Qt.callLater(function () { root.scrollToItem(hit) })
        return true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ScrollView {
            id: scroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true
            background: null
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            Component.onCompleted: {
                var f = contentItem
                if (!f)
                    return
                f.flickDeceleration = 2800
                f.maximumFlickVelocity = 4500
                f.boundsBehavior = Flickable.StopAtBounds
            }

            WheelHandler {
                target: scroll
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: function (event) {
                    var flick = scroll.contentItem
                    if (!flick || flick.contentHeight === undefined
                            || flick.contentHeight <= flick.height)
                        return
                    if (event.pixelDelta.y !== 0) {
                        root._wheelRemain = 0
                        wheelCoast.stop()
                        var maxY = Math.max(0, flick.contentHeight - flick.height)
                        flick.contentY = Math.max(0, Math.min(maxY, flick.contentY - event.pixelDelta.y))
                        event.accepted = true
                        return
                    }
                    if (event.angleDelta.y === 0)
                        return
                    root._wheelRemain += event.angleDelta.y / Theme.scrollWheelAngleDivisor
                    if (!wheelCoast.running)
                        wheelCoast.start()
                    event.accepted = true
                }
            }

            ColumnLayout {
                width: scroll.availableWidth
                spacing: root.sectionSpacing

                PageHeader {
                    id: header
                    Layout.fillWidth: true
                    Layout.leftMargin: root.pagePadding
                    Layout.rightMargin: root.pagePadding
                    Layout.topMargin: root.pagePadding
                    title: root.title
                    visible: root.title.length > 0 || root.subtitle.length > 0
                }

                ColumnLayout {
                    id: stack
                    Layout.fillWidth: true
                    Layout.leftMargin: root.pagePadding
                    Layout.rightMargin: root.pagePadding
                    Layout.bottomMargin: root.pagePadding
                    spacing: root.sectionSpacing
                }
            }
        }

        Item {
            id: footerSlot
            Layout.fillWidth: true
            Layout.preferredHeight: children.length ? childrenRect.height : 0
            visible: children.length > 0

            Binding {
                target: footerSlot.children.length === 1 ? footerSlot.children[0] : null
                property: "width"
                value: footerSlot.width
                when: footerSlot.children.length === 1
            }
        }
    }

    Item {
        id: overlaySlot
        anchors.fill: parent
        z: 100
    }

    Timer {
        id: wheelCoast
        interval: 8
        repeat: true
        onTriggered: {
            var flick = scroll.contentItem
            if (!flick || Math.abs(root._wheelRemain) < 0.35) {
                root._wheelRemain = 0
                stop()
                return
            }
            var step = root._wheelRemain * 0.22
            root._wheelRemain -= step
            var maxY = Math.max(0, flick.contentHeight - flick.height)
            flick.contentY = Math.max(0, Math.min(maxY, flick.contentY - step))
        }
    }
}
