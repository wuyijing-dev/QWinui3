import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ItemsWrapGrid — model-driven variable-size wrap layout (2.24).
//
//   ItemsWrapGrid {
//       model: tags
//       minItemSize: Theme.controlHeight
//       delegate: Chip {
//           required property int index
//           required property var modelData
//           text: modelData.title
//       }
//   }
//
//   // --- API ---
//   // properties: model, delegate, filterText, itemSpacing, horizontalSpacing,
//   //             verticalSpacing, orientation, layoutDirection, itemWidth,
//   //             itemHeight, minItemSize
//   // signals: itemClicked, itemActivated
//   // readonly: count
//
// @notes
//   WinUI-style wrap grid over WrapPanel + Repeater — variable item sizes, not
//   million-item virtualized. Prefer ItemsRepeater for long single-column lists.
//   Touch: keep delegates ≥ minItemSize (default Theme.controlHeight).
//   Optional filterText filters plain JS arrays (debounced). See docs/items-wrap-grid.md.

T.Control {
    id: root

    property string accessibleName: qsTr("Wrap grid")
    property bool announceChanges: true

    Accessible.role: Accessible.List
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Wrap grid")
    Accessible.description: qsTr("%1 items").arg(repeater.count)

    property var model: []
    property Component delegate: null
    property string filterText: ""
    property var filterRoles: ["title", "name", "label"]
    property int filterDebounceMs: 120

    property real itemSpacing: Theme.spacing
    property real horizontalSpacing: -1
    property real verticalSpacing: -1
    property int orientation: Qt.Horizontal
    property int layoutDirection: Qt.LeftToRight
    property real itemWidth: -1
    property real itemHeight: -1
    // Documented touch floor — delegates should honor via implicit sizes.
    property real minItemSize: Theme.controlHeight

    signal itemClicked(int index)
    signal itemActivated(int index, var itemData)

    readonly property int count: repeater.count
    readonly property bool _filterActive: Array.isArray(model)
                                          && (filterText || "").trim().length > 0
    readonly property var _displayModel: _filterActive ? _filteredModel : model

    property var _filteredModel: []
    property string _lastFilterKey: ""
    property var _lastModelRef: null
    property string _lastAnnouncedFilterSummary: ""

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

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
        var summary = q.length
                ? qsTr("%1 items match filter").arg(out.length)
                : qsTr("%1 items").arg(m.length)
        if (summary !== _lastAnnouncedFilterSummary) {
            _lastAnnouncedFilterSummary = summary
            _announce(summary)
        }
    }

    function _itemAt(index) {
        var m = _displayModel
        if (Array.isArray(m))
            return index >= 0 && index < m.length ? m[index] : null
        return null
    }

    implicitWidth: 320
    implicitHeight: 200
    padding: 0
    clip: true

    contentItem: ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        background: null

        WrapPanel {
            id: wrap
            width: scroll.availableWidth
            spacing: root.itemSpacing
            horizontalSpacing: root.horizontalSpacing
            verticalSpacing: root.verticalSpacing
            orientation: root.orientation
            layoutDirection: root.layoutDirection
            itemWidth: root.itemWidth
            itemHeight: root.itemHeight

            Repeater {
                id: repeater
                model: root._displayModel
                delegate: root.delegate
            }
        }
    }

    background: Item {}
}
