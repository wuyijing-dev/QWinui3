import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// CatalogPage — Gallery scroll host (PageHeader + padded column).
//
// Standalone pages: Flickable + ScrollBar (content lives inside the Flickable).
// hubEmbed: same tree but Flickable expands to content height (non-interactive) so
// the parent hub page receives wheel / drag.

Item {
    id: root

    property string title: ""
    property alias subtitle: header.subtitle
    property bool hubEmbed: false
    property alias componentId: header.componentId
    property real pagePadding: hubEmbed ? 0 : Theme.spacingSection
    property real sectionSpacing: Theme.spacingSection
    readonly property bool viewMoving: !hubEmbed && (flick.moving || flick.flicking)
    property alias footer: footerSlot.data
    property alias overlay: overlaySlot.data
    default property alias contentData: stack.data

    // StackView animates this item's x/y/scale — do not anchors.fill the page root.
    width: parent ? parent.width : 0
    height: hubEmbed ? implicitHeight : (parent ? parent.height : 0)
    implicitHeight: hubEmbed ? bodyCol.implicitHeight : 0
    Layout.fillWidth: true
    Layout.preferredHeight: hubEmbed ? implicitHeight : -1

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
            if (p.contentY !== undefined && p.contentHeight !== undefined
                    && p.flickableDirection !== undefined)
                return p
            if (p.contentItem !== undefined && p.contentItem
                    && p.contentItem.contentY !== undefined)
                return p.contentItem
            p = p.parent
        }
        return null
    }

    function scrollToItem(item) {
        if (!item)
            return false
        var flickTarget = null
        var p = item
        while (p) {
            flickTarget = _flickableAncestor(p)
            if (flickTarget)
                break
            p = p.parent
        }
        if (!flickTarget)
            return false
        var itemTop = item.mapToGlobal(0, 0).y
        var viewTop = flickTarget.mapToGlobal(0, 0).y
        var localY = itemTop - viewTop + flickTarget.contentY
        var maxY = Math.max(0, flickTarget.contentHeight - flickTarget.height)
        flickTarget.contentY = Math.max(0, Math.min(localY - 12, maxY))
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

    function _liftOverlays() {
        if (!root.hubEmbed)
            return
        var target = Overlay.overlay
        if (!target)
            return
        var kids = overlaySlot.children
        for (var i = 0; i < kids.length; ++i) {
            var c = kids[i]
            if (!c || c.parent !== overlaySlot)
                continue
            if (c.parent === target)
                continue
            c.parent = target
        }
    }

    onHubEmbedChanged: {
        if (hubEmbed)
            Qt.callLater(_liftOverlays)
    }

    Component.onCompleted: {
        if (hubEmbed)
            Qt.callLater(_liftOverlays)
    }

    ColumnLayout {
        id: bodyCol
        anchors.fill: hubEmbed ? undefined : parent
        anchors.left: hubEmbed ? parent.left : undefined
        anchors.right: hubEmbed ? parent.right : undefined
        width: hubEmbed && parent ? parent.width : undefined
        spacing: 0

        Flickable {
            id: flick
            Layout.fillWidth: true
            Layout.fillHeight: !root.hubEmbed
            Layout.preferredHeight: root.hubEmbed ? pageColumn.implicitHeight : -1
            clip: !root.hubEmbed
            interactive: !root.hubEmbed
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            flickDeceleration: 1200
            maximumFlickVelocity: 7000
            pressDelay: 0
            contentWidth: width
            contentHeight: pageColumn.implicitHeight

            ScrollBar.vertical: ScrollBar {
                policy: root.hubEmbed ? ScrollBar.AlwaysOff : ScrollBar.AsNeeded
            }

            ColumnLayout {
                id: pageColumn
                width: flick.width
                spacing: root.sectionSpacing

                PageHeader {
                    id: header
                    Layout.fillWidth: true
                    Layout.leftMargin: root.pagePadding
                    Layout.rightMargin: root.pagePadding
                    Layout.topMargin: root.pagePadding
                    title: root.title
                    visible: !root.hubEmbed && (root.title.length > 0 || root.subtitle.length > 0)
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
        enabled: false

        onChildrenChanged: {
            if (root.hubEmbed)
                Qt.callLater(root._liftOverlays)
        }
    }
}
