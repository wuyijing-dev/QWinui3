import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ItemsRepeater — Thin WinUI-style virtualizing repeater over ListView.
//
//   ItemsRepeater {
//       model: bigModel
//       orientation: Qt.Vertical
//       delegate: ListTile { title: model.title }
//   }
//
//   // --- API ---
//   // properties: model, delegate, orientation, itemSpacing, cacheBuffer
//   // aliases: contentX/Y, count, currentIndex
//
// @notes
//   Prefer this for large models; ItemsView adds selection / EmptyState recipe on top.
//   ListView uses reuseItems (1.25) — keep delegates binding-driven for pooling.
//   Optional filterText filters plain JS arrays (debounced, 1.88).

T.Control {
    id: root

    Accessible.role: Accessible.List
    Accessible.name: qsTr("Items")
    Accessible.description: qsTr("%1 items").arg(root.count)

    // List / array / QAbstractItemModel
    property var model: []
    // Filter plain JS arrays (debounced). C++ / ListModel: filter app-side.
    property string filterText: ""
    property var filterRoles: ["title", "name", "label"]
    property int filterDebounceMs: 120
    // Item delegate component
    property alias delegate: list.delegate
    // Qt.Vertical or Qt.Horizontal
    property alias orientation: list.orientation
    // Spacing between items (Control.spacing is FINAL — do not alias it)
    property alias itemSpacing: list.spacing
    // Extra cache outside the viewport
    property alias cacheBuffer: list.cacheBuffer
    // Current index
    property alias currentIndex: list.currentIndex
    // Item count
    readonly property alias count: list.count
    property alias contentX: list.contentX
    property alias contentY: list.contentY
    property alias contentWidth: list.contentWidth
    property alias contentHeight: list.contentHeight

    // Emitted when an item is clicked (if delegate forwards)
    signal itemClicked(int index)

    readonly property bool _filterActive: Array.isArray(model)
                                          && (filterText || "").trim().length > 0
    readonly property var _displayModel: _filterActive ? _filteredModel : model

    property var _filteredModel: []
    property string _lastFilterKey: ""
    property var _lastModelRef: null

    Timer {
        id: filterDebounce
        interval: root.filterDebounceMs
        onTriggered: root._rebuildFilter()
    }

    onFilterTextChanged: _scheduleFilter(false)
    onModelChanged: _scheduleFilter(true)
    onFilterRolesChanged: _scheduleFilter(true)
    Component.onCompleted: _rebuildFilter()

    function _scheduleFilter(immediate) {
        if (immediate) {
            filterDebounce.stop()
            _rebuildFilter()
        } else {
            filterDebounce.restart()
        }
    }

    function _rebuildFilter() {
        if (!_filterActive) {
            _filteredModel = []
            _lastFilterKey = ""
            _lastModelRef = null
            return
        }
        var m = model
        var q = (filterText || "").trim().toLowerCase()
        var key = q + "\0" + m.length
        if (key === _lastFilterKey && m === _lastModelRef)
            return
        _lastFilterKey = key
        _lastModelRef = m
        var roles = filterRoles && filterRoles.length ? filterRoles : ["title"]
        var out = []
        for (var i = 0; i < m.length; ++i) {
            var item = m[i]
            if (typeof item === "string") {
                if (item.toLowerCase().indexOf(q) >= 0)
                    out.push(item)
                continue
            }
            var hit = false
            for (var r = 0; r < roles.length; ++r) {
                var v = item && item[roles[r]]
                if (v !== undefined && v !== null
                        && String(v).toLowerCase().indexOf(q) >= 0) {
                    hit = true
                    break
                }
            }
            if (hit)
                out.push(item)
        }
        _filteredModel = out
    }

    implicitWidth: 280
    implicitHeight: 200
    padding: 0
    clip: true

    contentItem: ListView {
        id: list
        anchors.fill: parent
        clip: true
        reuseItems: true
        model: root._displayModel
        boundsBehavior: Flickable.StopAtBounds
        spacing: 0
        cacheBuffer: Theme.navItemHeight * 8
        ScrollBar.vertical: ScrollBar {
            policy: list.orientation === Qt.Vertical ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
        }
        ScrollBar.horizontal: ScrollBar {
            policy: list.orientation === Qt.Horizontal ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
        }
        highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionFast)
    }

    background: Item {}
}
