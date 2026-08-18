import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// SemanticZoom — Shared-selection dual view (grid ↔ index) for contacts / albums (2.62).
//
//   SemanticZoom {
//       id: zoom
//       model: contacts
//       groupRole: "letter"
//       GridView { /* zoomed-in grid */ }
//       zoomedOut: GridView { /* A–Z index */ }
//   }
//   zoom.selectGroup("M")
//   zoom.toggleZoom()
//
// @notes
//   Experimental — one model + selectedIndex across zoomed-in / zoomed-out hosts (FL-006).
//   Not generic pinch/map zoom. See docs/semantic-zoom-262.md.

T.Control {
    id: root

    property var model: []
    property string groupRole: "group"
    property int selectedIndex: -1
    property string selectedGroup: ""
    property bool isZoomedOut: false
    property bool canChangeViews: true
    property bool showZoomButton: true
    property string zoomInLabel: qsTr("Zoom in")
    property string zoomOutLabel: qsTr("Zoom out")
    property string accessibleName: qsTr("Semantic zoom")
    // Forward wheel to parent ScrollView when the inner grid cannot scroll further
    property bool nestedInScrollView: true

    default property alias zoomedIn: zoomedInHost.data
    property alias zoomedOut: zoomedOutHost.data

    signal zoomChanged(bool zoomedOut)
    signal selectionChanged(int index, var item)
    signal groupActivated(string group)

    readonly property var groupKeys: _computeGroupKeys()

    implicitWidth: 320
    implicitHeight: 280
    focusPolicy: Qt.StrongFocus

    Accessible.role: Accessible.Grouping
    Accessible.name: root.accessibleName

    function toggleZoom() {
        if (!root.canChangeViews)
            return
        root.isZoomedOut = !root.isZoomedOut
        root.zoomChanged(root.isZoomedOut)
        if (root.isZoomedOut)
            zoomedOutHost.forceActiveFocus()
        else
            zoomedInHost.forceActiveFocus()
    }

    function zoomIn() {
        if (root.isZoomedOut)
            root.toggleZoom()
    }

    function zoomOut() {
        if (!root.isZoomedOut)
            root.toggleZoom()
    }

    function itemAt(index) {
        var m = root.model
        if (!m || index < 0)
            return null
        if (Array.isArray(m)) {
            if (index >= m.length)
                return null
            return m[index]
        }
        if (m.count !== undefined && m.get && index < m.count)
            return m.get(index)
        return null
    }

    function selectIndex(index) {
        if (index < 0)
            return
        root.selectedIndex = index
        var it = root.itemAt(index)
        if (it && root.groupRole.length && it[root.groupRole] !== undefined)
            root.selectedGroup = String(it[root.groupRole])
        root.selectionChanged(index, it)
    }

    function indexForGroup(key) {
        var m = root.model
        if (!m || !root.groupRole.length || !key || !String(key).length)
            return -1
        var k = String(key)
        var walk = function(pred) {
            if (Array.isArray(m)) {
                for (var i = 0; i < m.length; ++i) {
                    var it = m[i]
                    if (it && pred(it))
                        return i
                }
            } else if (m.count !== undefined && m.get) {
                for (var j = 0; j < m.count; ++j) {
                    var row = m.get(j)
                    if (row && pred(row))
                        return j
                }
            }
            return -1
        }
        var exact = walk(function (it) {
            return String(it[root.groupRole]) === k
        })
        if (exact >= 0)
            return exact
        return walk(function (it) {
            var g = String(it[root.groupRole] || "")
            return g.length && g.toUpperCase().charAt(0) === k.toUpperCase().charAt(0)
        })
    }

    function selectGroup(key) {
        if (!key || !String(key).length)
            return
        root.selectedGroup = String(key)
        var idx = root.indexForGroup(key)
        if (idx >= 0)
            root.selectedIndex = idx
        root.groupActivated(root.selectedGroup)
        root.zoomIn()
        if (idx >= 0)
            root.selectionChanged(idx, root.itemAt(idx))
    }

    function _computeGroupKeys() {
        var seen = ({})
        var out = []
        var m = root.model
        if (!m || !root.groupRole.length)
            return out
        var add = function (g) {
            var s = String(g)
            if (!s.length || seen[s])
                return
            seen[s] = true
            out.push(s)
        }
        if (Array.isArray(m)) {
            for (var i = 0; i < m.length; ++i) {
                var it = m[i]
                if (it)
                    add(it[root.groupRole])
            }
        } else if (m.count !== undefined && m.get) {
            for (var j = 0; j < m.count; ++j) {
                var row = m.get(j)
                if (row)
                    add(row[root.groupRole])
            }
        }
        out.sort()
        return out
    }

    function _childGridView(host) {
        if (!host)
            return null
        var stack = [host]
        while (stack.length) {
            var n = stack.pop()
            if (n && n.cellWidth !== undefined && n.contentY !== undefined)
                return n
            var kids = n.children || []
            for (var i = 0; i < kids.length; ++i)
                stack.push(kids[i])
        }
        return null
    }

    function _activeGridView() {
        return root.isZoomedOut
                ? root._childGridView(zoomedOutHost)
                : root._childGridView(zoomedInHost)
    }

    function _parentPageFlickable() {
        var p = root.parent
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

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        enabled: root.nestedInScrollView
        onWheel: function (event) {
            var grid = root._activeGridView()
            var dy = event.angleDelta.y
            if (grid && grid.contentHeight > grid.height + 1) {
                var atTop = grid.contentY <= 0.5
                var atBottom = grid.contentY >= grid.contentHeight - grid.height - 0.5
                if ((dy > 0 && !atTop) || (dy < 0 && !atBottom))
                    return
            }
            var page = root._parentPageFlickable()
            if (!page)
                return
            var maxY = Math.max(0, page.contentHeight - page.height)
            page.contentY = Math.max(0, Math.min(maxY, page.contentY - dy / 8))
            event.accepted = true
        }
    }

    Keys.onPressed: function (event) {
        if (!root.canChangeViews)
            return
        if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_Minus) {
            root.zoomOut()
            event.accepted = true
        } else if ((event.modifiers & Qt.ControlModifier)
                   && (event.key === Qt.Key_Plus || event.key === Qt.Key_Equal)) {
            root.zoomIn()
            event.accepted = true
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacingSmall

        RowLayout {
            visible: root.showZoomButton && root.canChangeViews
            Layout.fillWidth: true
            spacing: Theme.spacingSmall
            Label {
                Layout.fillWidth: true
                text: root.isZoomedOut ? qsTr("Index view") : qsTr("Detail view")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontSizeCaption
            }
            IconButton {
                symbol: root.isZoomedOut ? FluentIcons.ZoomIn : FluentIcons.ZoomOut
                toolTipText: root.isZoomedOut ? root.zoomInLabel : root.zoomOutLabel
                onClicked: root.toggleZoom()
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.isZoomedOut ? 1 : 0

            Item {
                id: zoomedInHost
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                focus: !root.isZoomedOut
            }

            Item {
                id: zoomedOutHost
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                focus: root.isZoomedOut
            }
        }
    }
}
