import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// DataTable — Fluent virtualizing table with sort, filter, resize, and keyboard.
//
//   DataTable {
//       columns: [
//           { title: qsTr("Name"), role: "name", width: 160, sortable: true, pinned: true },
//           { title: qsTr("Role"), role: "role", width: 140, sortable: true },
//           { title: qsTr("Status"), role: "status", width: 120 }
//       ]
//       rows: [ { name: "Alex", role: "Design", status: "Active", team: "Alpha" }, … ]
//       groupRole: "team"
//       filterPlaceholder: qsTr("Filter rows")
//       // 2.66 D1
//       sortSpecs: [ { column: 1, order: Qt.AscendingOrder } ]
//       hiddenColumns: [ 4 ]
//       columnWidths: [ 160, 140, 120 ]  // bind to Settings
//   }
//
//   // --- API ---
//   // selectedRow / selectedIndex, sortColumn / sortOrder / sortSpecs, filterText, columnOrder
//   // hiddenColumns, columnWidths, setColumnVisible(), toggleSort(col, append?)
//   // methods: select(row), clearSelection(), refresh(), focusTable(), moveColumn(from, to)
//   // signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int),
//   //          columnLayoutChanged()
//
// @notes
//   ListView virtualizes rows (`reuseItems`) — fixed rowHeight fast path (2.66 C1).
//   Filter + sort rebuild `_viewRows` in JS — debounced on filter keystrokes (1.88);
//   skips rebuild when query/sort/rows unchanged (2.18). maxFilterResults caps filter walk.
//   Multi-column sort via sortSpecs / Shift+click header (2.66 D1).
//   Column visibility (hiddenColumns) + width persistence (columnWidths) — 2.66 D1.
//   Column pin + reorder (columnOrder / moveColumn) and row group headers (groupRole) — 2.64.
//   Selection tracks the row **object** across sort/filter.
//   See docs/data-collections.md for DataTable vs ItemsView vs ListDetailsView.

T.Control {
    id: root

    property var columns: []
    property var rows: []
    property string filterText: ""
    property string filterPlaceholder: qsTr("Filter")
    property bool filterVisible: true
    property int selectedIndex: -1
    // Primary sort column (compat); kept in sync with sortSpecs[0]
    property int sortColumn: -1
    property int sortOrder: Qt.AscendingOrder
    // Multi-column sort specs: [{ column, order }, …] — first entry is primary (2.66 D1)
    property var sortSpecs: []
    property real rowHeight: Theme.navItemHeight
    // Fixed row-height ListView path (always on — C1 contract)
    readonly property bool fixedRowHeight: true
    property real minColumnWidth: 64
    property real headerHeight: Theme.navItemHeight
    // Debounce filter keystrokes before rebuilding _viewRows (1.88).
    property int filterDebounceMs: 120
    // Cap filtered rows (0 = unlimited). Large JS arrays only (2.18).
    property int maxFilterResults: 0
    // Qt 6.8+ Accessible.announce for selection / sort / filter (2.07).
    property bool announceChanges: true
    // Row group header role — inserts sticky-style group rows (2.64).
    property string groupRole: ""
    property real groupHeaderHeight: Theme.navItemHeight
    // Persist column order — bind to Settings; empty = natural column index order (2.64).
    property var columnOrder: []
    // Hidden column indices — omitted from header/body (2.66 D1)
    property var hiddenColumns: []
    // Persistable widths — bind to Settings; empty = use columns[].width (2.66 D1)
    property var columnWidths: []
    // Row enter motion: none | fade | slide — 2.67 B2
    property string itemEnter: "none"
    // Row exit motion: none | fade | slide (prefer none at 10k+)
    property string itemExit: "none"

    readonly property var selectedRow: {
        if (selectedIndex < 0 || selectedIndex >= _viewRows.length)
            return null
        return _viewRows[selectedIndex]
    }
    readonly property int rowCount: _viewRows.length
    readonly property int columnCount: columns ? columns.length : 0
    readonly property bool _groupActive: groupRole.length > 0
    readonly property real _pinnedWidth: {
        var w = 0
        for (var i = 0; i < _pinnedColOrder.length; ++i)
            w += _columnWidths[_pinnedColOrder[i]] || 140
        return w
    }
    readonly property real _scrollContentWidth: {
        var w = 0
        for (var i = 0; i < _scrollColOrder.length; ++i)
            w += _columnWidths[_scrollColOrder[i]] || 140
        return w
    }
    readonly property int _listCurrentIndex: _listDisplayIndex(selectedIndex)

    signal rowActivated(int index, var row)
    signal selectionChanged(int index, var row)
    signal sortChanged(int column, int order)
    signal columnLayoutChanged()

    property var _viewRows: []
    property var _displayItems: []
    property var _columnWidths: []
    property var _pinnedColOrder: []
    property var _scrollColOrder: []
    property real _scrollX: 0
    property string _lastRefreshKey: ""
    property var _lastRowsRef: null
    property string _lastAnnouncedFilterSummary: ""
    property var _selectedRowRef: null
    property bool _syncingWidths: false
    property bool _syncingSort: false

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    function _announceSelection(index) {
        if (index < 0) {
            _announce(qsTr("Selection cleared"))
            return
        }
        var row = _viewRows[index]
        var name = _cellText(row, 0)
        if (!name.length)
            name = qsTr("Row %1").arg(index + 1)
        _announce(qsTr("%1, row %2 of %3").arg(name).arg(index + 1).arg(rowCount))
    }

    function _announceFilterResult() {
        var q = (filterText || "").trim()
        var summary = q.length
                ? qsTr("%1 rows match filter").arg(_viewRows.length)
                : qsTr("%1 rows").arg(_viewRows.length)
        if (summary === _lastAnnouncedFilterSummary)
            return
        _lastAnnouncedFilterSummary = summary
        _announce(summary)
    }

    Timer {
        id: filterDebounce
        interval: root.filterDebounceMs
        onTriggered: root.refresh()
    }

    implicitWidth: 640
    implicitHeight: 360
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    property string accessibleName: qsTr("Data table")
    Accessible.role: Accessible.Table
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Data table")
    Accessible.description: qsTr("%1 rows, %2 columns").arg(rowCount).arg(columnCount)

    onColumnsChanged: {
        _syncColumnWidths()
        _rebuildColumnLayout()
        _scheduleRefresh(true)
    }
    onColumnOrderChanged: _rebuildColumnLayout()
    onRowsChanged: _scheduleRefresh(true)
    onFilterTextChanged: _scheduleRefresh(false)
    onSortColumnChanged: _scheduleRefresh(true)
    onSortOrderChanged: _scheduleRefresh(true)
    onGroupRoleChanged: _scheduleRefresh(true)
    Component.onCompleted: {
        _syncColumnWidths()
        _rebuildColumnLayout()
        refresh()
    }

    function _scheduleRefresh(immediate) {
        if (immediate) {
            filterDebounce.stop()
            refresh()
        } else {
            filterDebounce.restart()
        }
    }

    function _isColumnHidden(index) {
        var hidden = hiddenColumns || []
        for (var i = 0; i < hidden.length; ++i) {
            if (Number(hidden[i]) === index)
                return true
        }
        return false
    }

    function setColumnVisible(column, visible) {
        var cols = columns || []
        if (column < 0 || column >= cols.length)
            return
        var hidden = (hiddenColumns || []).slice()
        var idx = -1
        for (var i = 0; i < hidden.length; ++i) {
            if (Number(hidden[i]) === column) {
                idx = i
                break
            }
        }
        if (visible) {
            if (idx >= 0)
                hidden.splice(idx, 1)
        } else if (idx < 0) {
            hidden.push(column)
        }
        hiddenColumns = hidden
        _rebuildColumnLayout()
    }

    function isColumnVisible(column) {
        return !_isColumnHidden(column)
    }

    function _displayColumnIndices() {
        var cols = columns || []
        var order = columnOrder
        var natural = []
        if (order && order.length === cols.length) {
            var seen = ({})
            var ok = true
            for (var i = 0; i < order.length; ++i) {
                var idx = order[i]
                if (typeof idx !== "number" || idx < 0 || idx >= cols.length || seen[idx]) {
                    ok = false
                    break
                }
                seen[idx] = true
                natural.push(idx)
            }
            if (!ok)
                natural = []
        }
        if (!natural.length) {
            for (var j = 0; j < cols.length; ++j)
                natural.push(j)
        }
        var visible = []
        for (var k = 0; k < natural.length; ++k) {
            if (!_isColumnHidden(natural[k]))
                visible.push(natural[k])
        }
        return visible
    }

    function _rebuildColumnLayout() {
        var order = _displayColumnIndices()
        var pinned = []
        var scroll = []
        var cols = columns || []
        for (var i = 0; i < order.length; ++i) {
            var ci = order[i]
            if (ci >= 0 && ci < cols.length && cols[ci].pinned === true)
                pinned.push(ci)
            else
                scroll.push(ci)
        }
        _pinnedColOrder = pinned
        _scrollColOrder = scroll
        columnLayoutChanged()
    }

    function _sortKeyString() {
        var specs = _effectiveSortSpecs()
        var parts = []
        for (var i = 0; i < specs.length; ++i)
            parts.push(String(specs[i].column) + ":" + String(specs[i].order))
        return parts.join(",")
    }

    function _effectiveSortSpecs() {
        var specs = sortSpecs || []
        if (specs.length)
            return specs
        if (sortColumn >= 0)
            return [{ column: sortColumn, order: sortOrder }]
        return []
    }

    function _syncPrimarySortFromSpecs() {
        if (_syncingSort)
            return
        _syncingSort = true
        var specs = sortSpecs || []
        if (specs.length) {
            sortColumn = Number(specs[0].column)
            sortOrder = Number(specs[0].order)
        }
        _syncingSort = false
    }

    onSortSpecsChanged: {
        _syncPrimarySortFromSpecs()
        _scheduleRefresh(true)
    }
    onHiddenColumnsChanged: _rebuildColumnLayout()
    onColumnWidthsChanged: {
        if (_syncingWidths)
            return
        var incoming = columnWidths || []
        if (!incoming.length)
            return
        var cols = columns || []
        if (incoming.length !== cols.length && _columnWidths.length === cols.length)
            return
        var next = _columnWidths.slice()
        while (next.length < cols.length)
            next.push(140)
        for (var i = 0; i < Math.min(incoming.length, cols.length); ++i) {
            var w = Number(incoming[i])
            if (isFinite(w) && w > 0)
                next[i] = Math.max(minColumnWidth, w)
        }
        _columnWidths = next
    }

    function moveColumn(fromDisplay, toDisplay) {
        var order = _displayColumnIndices().slice()
        if (fromDisplay < 0 || fromDisplay >= order.length
                || toDisplay < 0 || toDisplay >= order.length
                || fromDisplay === toDisplay)
            return
        var item = order.splice(fromDisplay, 1)[0]
        order.splice(toDisplay, 0, item)
        columnOrder = order
        _rebuildColumnLayout()
    }

    function focusTable() {
        forceActiveFocus()
    }

    function clearSelection() {
        select(-1)
    }

    function _listDisplayIndex(dataIndex) {
        if (dataIndex < 0)
            return -1
        if (!_groupActive)
            return dataIndex
        for (var i = 0; i < _displayItems.length; ++i) {
            var it = _displayItems[i]
            if (it.kind === "row" && it.rowIndex === dataIndex)
                return i
        }
        return -1
    }

    function _dataIndexFromDisplay(displayIndex) {
        if (!_groupActive)
            return displayIndex
        if (displayIndex < 0 || displayIndex >= _displayItems.length)
            return -1
        var it = _displayItems[displayIndex]
        return it && it.kind === "row" ? it.rowIndex : -1
    }

    function select(index) {
        if (index < -1 || index >= _viewRows.length)
            return
        selectedIndex = index
        _selectedRowRef = index >= 0 ? _viewRows[index] : null
        selectionChanged(index, selectedRow)
        _announceSelection(index)
        if (index >= 0) {
            var di = _listDisplayIndex(index)
            if (di >= 0)
                list.positionViewAtIndex(di, ListView.Contain)
        }
    }

    function _buildDisplayItems(rows) {
        if (!_groupActive) {
            _displayItems = []
            return
        }
        var items = []
        var lastGroup = null
        for (var i = 0; i < rows.length; ++i) {
            var row = rows[i]
            var g = row[groupRole]
            var gStr = g === undefined || g === null ? "" : String(g)
            if (gStr !== lastGroup) {
                items.push({
                    kind: "group",
                    label: gStr.length ? gStr : qsTr("Ungrouped")
                })
                lastGroup = gStr
            }
            items.push({ kind: "row", rowIndex: i, row: row })
        }
        _displayItems = items
    }

    function _compareValues(av, bv, asc) {
        if (av === bv)
            return 0
        if (av === undefined || av === null)
            return asc ? -1 : 1
        if (bv === undefined || bv === null)
            return asc ? 1 : -1
        if (typeof av === "number" && typeof bv === "number")
            return asc ? (av - bv) : (bv - av)
        var as = String(av).toLowerCase()
        var bs = String(bv).toLowerCase()
        if (as < bs)
            return asc ? -1 : 1
        if (as > bs)
            return asc ? 1 : -1
        return 0
    }

    function refresh() {
        var src = rows || []
        var cols = columns || []
        var q = (filterText || "").trim().toLowerCase()
        var refreshKey = q + "\0" + _sortKeyString() + "\0"
                + src.length + "\0" + groupRole + "\0" + String(maxFilterResults)
        if (refreshKey === _lastRefreshKey && src === _lastRowsRef)
            return
        _lastRefreshKey = refreshKey
        _lastRowsRef = src

        var filtered = []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            if (!q.length) {
                filtered.push(row)
                if (root.maxFilterResults > 0 && filtered.length >= root.maxFilterResults)
                    break
                continue
            }
            var hit = false
            for (var c = 0; c < cols.length; ++c) {
                if (_isColumnHidden(c))
                    continue
                var role = cols[c].role || ("c" + c)
                var v = row[role]
                if (v !== undefined && String(v).toLowerCase().indexOf(q) >= 0) {
                    hit = true
                    break
                }
            }
            if (hit)
                filtered.push(row)
            if (root.maxFilterResults > 0 && filtered.length >= root.maxFilterResults)
                break
        }

        var specs = _effectiveSortSpecs()
        var canSort = specs.length > 0 || root._groupActive
        if (canSort) {
            filtered = filtered.slice().sort(function (a, b) {
                if (root._groupActive) {
                    var ga = a[root.groupRole]
                    var gb = b[root.groupRole]
                    var gcmp = root._compareValues(ga, gb, true)
                    if (gcmp !== 0)
                        return gcmp
                }
                for (var s = 0; s < specs.length; ++s) {
                    var col = Number(specs[s].column)
                    if (col < 0 || col >= cols.length || cols[col].sortable === false)
                        continue
                    var roleSort = cols[col].role || ("c" + col)
                    var asc = Number(specs[s].order) === Qt.AscendingOrder
                    var cmp = root._compareValues(a[roleSort], b[roleSort], asc)
                    if (cmp !== 0)
                        return cmp
                }
                return 0
            })
        }

        var prev = _selectedRowRef
        _viewRows = filtered
        _buildDisplayItems(filtered)

        if (prev !== null && prev !== undefined) {
            var found = -1
            for (var j = 0; j < _viewRows.length; ++j) {
                if (_viewRows[j] === prev) {
                    found = j
                    break
                }
            }
            if (found >= 0) {
                if (selectedIndex !== found) {
                    selectedIndex = found
                    selectionChanged(found, prev)
                }
                var di = _listDisplayIndex(found)
                if (di >= 0)
                    list.positionViewAtIndex(di, ListView.Contain)
            } else {
                selectedIndex = -1
                _selectedRowRef = null
                selectionChanged(-1, null)
            }
        } else if (selectedIndex >= _viewRows.length) {
            select(_viewRows.length ? _viewRows.length - 1 : -1)
        }
        _announceFilterResult()
    }

    // Toggle sort. append=true (Shift+click) adds/updates a secondary sort key (2.66 D1).
    function toggleSort(column, append) {
        var cols = columns || []
        if (column < 0 || column >= cols.length)
            return
        if (cols[column].sortable === false)
            return
        var specs = (sortSpecs && sortSpecs.length) ? sortSpecs.slice()
                  : (sortColumn >= 0 ? [{ column: sortColumn, order: sortOrder }] : [])
        var found = -1
        for (var i = 0; i < specs.length; ++i) {
            if (Number(specs[i].column) === column) {
                found = i
                break
            }
        }
        if (append) {
            if (found >= 0) {
                var cur = Number(specs[found].order)
                specs[found] = {
                    column: column,
                    order: cur === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                }
            } else {
                specs.push({ column: column, order: Qt.AscendingOrder })
            }
        } else {
            if (found === 0 && specs.length === 1) {
                var only = Number(specs[0].order)
                specs = [{
                    column: column,
                    order: only === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                }]
            } else if (found === 0) {
                specs[0] = {
                    column: column,
                    order: Number(specs[0].order) === Qt.AscendingOrder
                           ? Qt.DescendingOrder : Qt.AscendingOrder
                }
            } else {
                specs = [{ column: column, order: Qt.AscendingOrder }]
            }
        }
        _syncingSort = true
        sortSpecs = specs
        sortColumn = Number(specs[0].column)
        sortOrder = Number(specs[0].order)
        _syncingSort = false
        sortChanged(sortColumn, sortOrder)
        if (announceChanges) {
            var colTitle = cols[column].title || cols[column].role || ""
            var order = sortOrder === Qt.AscendingOrder
                    ? qsTr("ascending") : qsTr("descending")
            _announce(qsTr("Sorted by %1, %2").arg(colTitle).arg(order))
        }
        _scheduleRefresh(true)
    }

    function _syncColumnWidths() {
        var cols = columns || []
        var widths = []
        var persisted = columnWidths || []
        for (var i = 0; i < cols.length; ++i) {
            var pw = persisted.length > i ? Number(persisted[i]) : NaN
            if (isFinite(pw) && pw > 0) {
                widths.push(Math.max(minColumnWidth, pw))
                continue
            }
            var w = cols[i].width
            widths.push(w === undefined ? 140 : Number(w))
        }
        _columnWidths = widths
    }

    function _publishColumnWidths() {
        _syncingWidths = true
        columnWidths = _columnWidths.slice()
        _syncingWidths = false
        columnLayoutChanged()
    }

    function _cellText(rowObj, column) {
        var cols = columns || []
        if (column < 0 || column >= cols.length || !rowObj)
            return ""
        var role = cols[column].role || ("c" + column)
        var v = rowObj[role]
        return v === undefined || v === null ? "" : String(v)
    }

    function _moveSelection(delta) {
        if (!_viewRows.length)
            return
        var next = selectedIndex < 0 ? 0 : selectedIndex + delta
        next = Math.max(0, Math.min(_viewRows.length - 1, next))
        select(next)
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Down) {
            _moveSelection(1)
            event.accepted = true
        } else if (event.key === Qt.Key_Up) {
            _moveSelection(-1)
            event.accepted = true
        } else if (event.key === Qt.Key_Home) {
            select(_viewRows.length ? 0 : -1)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            select(_viewRows.length ? _viewRows.length - 1 : -1)
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (selectedIndex >= 0)
                rowActivated(selectedIndex, selectedRow)
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            clearSelection()
            event.accepted = true
        } else if (event.key === Qt.Key_PageDown) {
            _moveSelection(8)
            event.accepted = true
        } else if (event.key === Qt.Key_PageUp) {
            _moveSelection(-8)
            event.accepted = true
        }
    }

    component HeaderCell: Item {
        id: headerCell
        required property int columnIndex
        property real cellWidth: root._columnWidths[columnIndex] || 140

        width: cellWidth
        height: root.headerHeight

        readonly property var colDef: {
            var cols = root.columns || []
            return columnIndex >= 0 && columnIndex < cols.length ? cols[columnIndex] : ({})
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.bgAcrylic
            Accessible.role: Accessible.ColumnHeader
            Accessible.name: {
                var t = headerCell.colDef.title || headerCell.colDef.role || ""
                if (headerCell.colDef.pinned === true)
                    t += qsTr(", pinned")
                var specs = root._effectiveSortSpecs()
                for (var si = 0; si < specs.length; ++si) {
                    if (Number(specs[si].column) === headerCell.columnIndex) {
                        t += Number(specs[si].order) === Qt.AscendingOrder
                             ? qsTr(", sorted ascending")
                             : qsTr(", sorted descending")
                        if (specs.length > 1)
                            t += qsTr(", sort priority %1").arg(si + 1)
                        break
                    }
                }
                return t
            }
            Accessible.onPressAction: root.toggleSort(headerCell.columnIndex)

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.strokeCard
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                spacing: 4

                Label {
                    Layout.fillWidth: true
                    text: headerCell.colDef.title || headerCell.colDef.role || ""
                    elide: Text.ElideRight
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    readonly property int sortRank: {
                        var specs = root._effectiveSortSpecs()
                        for (var si = 0; si < specs.length; ++si) {
                            if (Number(specs[si].column) === headerCell.columnIndex)
                                return si
                        }
                        return -1
                    }
                    visible: sortRank >= 0
                    text: {
                        var specs = root._effectiveSortSpecs()
                        if (sortRank < 0 || !specs || sortRank >= specs.length)
                            return ""
                        var arrow = Number(specs[sortRank].order) === Qt.AscendingOrder ? "▲" : "▼"
                        if (specs.length > 1)
                            return arrow + String(sortRank + 1)
                        return arrow
                    }
                    color: Theme.accent
                    font.pixelSize: Theme.fontCaption
                }
            }

            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: 6
                cursorShape: headerCell.colDef.sortable === false
                             ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: function (mouse) {
                    root.toggleSort(headerCell.columnIndex, !!(mouse.modifiers & Qt.ShiftModifier))
                }
            }

            MouseArea {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 6
                cursorShape: Qt.SplitHCursor
                visible: headerCell.colDef.resizable !== false
                property real _startX: 0
                property real _startW: 0
                onPressed: function (mouse) {
                    _startX = mouse.x
                    _startW = headerCell.width
                }
                onPositionChanged: function (mouse) {
                    if (!pressed)
                        return
                    var nw = Math.max(root.minColumnWidth, _startW + (mouse.x - _startX))
                    var widths = root._columnWidths.slice()
                    widths[headerCell.columnIndex] = nw
                    root._columnWidths = widths
                }
                onReleased: root._publishColumnWidths()
            }
        }
    }

    component DataCell: Item {
        id: dataCell
        required property int columnIndex
        required property var rowObj
        property real cellWidth: root._columnWidths[columnIndex] || 140

        width: cellWidth
        height: root.rowHeight

        readonly property string cellText: root._cellText(rowObj, columnIndex)

        Label {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 8
            text: dataCell.cellText
            elide: Text.ElideRight
            color: Theme.textPrimary
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontBody
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing
        anchors.fill: parent

        TextField {
            id: filterField
            visible: root.filterVisible
            Layout.fillWidth: true
            placeholderText: root.filterPlaceholder
            text: root.filterText
            onTextChanged: root.filterText = text
            Accessible.name: qsTr("Filter table")
            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Down
                        || event.key === Qt.Key_Return
                        || event.key === Qt.Key_Enter) {
                    root.forceActiveFocus()
                    if (root.selectedIndex < 0 && root.rowCount > 0)
                        root.select(0)
                    event.accepted = true
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            radius: Theme.cornerControl
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 0

                Row {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.headerHeight
                    spacing: 0

                    Row {
                        id: pinnedHeaderRow
                        visible: root._pinnedColOrder.length > 0
                        height: root.headerHeight
                        Repeater {
                            model: root._pinnedColOrder
                            delegate: HeaderCell {
                                required property var modelData
                                columnIndex: modelData
                            }
                        }
                        Rectangle {
                            width: root._scrollColOrder.length > 0 ? 1 : 0
                            height: parent.height
                            color: Theme.strokeCard
                        }
                    }

                    Flickable {
                        id: headerFlick
                        width: parent.width - pinnedHeaderRow.width
                        height: root.headerHeight
                        contentWidth: scrollHeaderRow.width
                        contentHeight: height
                        clip: true
                        interactive: false
                        boundsBehavior: Flickable.StopAtBounds
                        contentX: root._scrollX

                        Row {
                            id: scrollHeaderRow
                            height: root.headerHeight
                            Repeater {
                                model: root._scrollColOrder
                                delegate: HeaderCell {
                                    required property var modelData
                                    columnIndex: modelData
                                }
                            }
                        }
                    }
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    reuseItems: true
                    // Fixed row-height fast path (2.66 C1) — avoids variable-height measure
                    cacheBuffer: root.rowHeight * 12
                    boundsBehavior: Flickable.StopAtBounds
                    model: root._groupActive ? root._displayItems : root._viewRows
                    currentIndex: root._listCurrentIndex
                    flickableDirection: Flickable.VerticalFlick

                    add: Transition {
                        enabled: !Theme.reducedMotion && root.itemEnter !== "none"
                        NumberAnimation {
                            property: "opacity"
                            from: 0; to: 1
                            duration: Theme.motion.ms("fast")
                            easing.type: Theme.motion.easing("enter")
                        }
                        NumberAnimation {
                            property: "y"
                            from: root.itemEnter === "slide" ? 12 : 0
                            to: 0
                            duration: Theme.motion.ms("fast")
                            easing.type: Theme.motion.easing("enter")
                        }
                    }
                    remove: Transition {
                        enabled: !Theme.reducedMotion && root.itemExit !== "none"
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: Theme.motion.ms("fast")
                            easing.type: Theme.motion.easing("exit")
                        }
                    }
                    displaced: Transition {
                        enabled: !Theme.reducedMotion
                                 && (root.itemEnter !== "none" || root.itemExit !== "none")
                        NumberAnimation {
                            properties: "x,y"
                            duration: Theme.motion.ms("fast")
                            easing.type: Theme.motion.easing("standard")
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}
                    ScrollBar.horizontal: ScrollBar {
                        id: hScroll
                        policy: root._scrollContentWidth > (list.width - root._pinnedWidth)
                                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        onPositionChanged: {
                            var viewport = Math.max(1, list.width - root._pinnedWidth)
                            var maxX = Math.max(0, root._scrollContentWidth - viewport)
                            root._scrollX = position * maxX
                        }
                    }

                    delegate: Item {
                        id: rowItem
                        required property var modelData
                        required property int index
                        readonly property bool isGroup: root._groupActive && modelData.kind === "group"
                        readonly property int dataIndex: root._groupActive
                                ? (isGroup ? -1 : modelData.rowIndex)
                                : index
                        readonly property var rowObj: root._groupActive
                                ? (isGroup ? null : modelData.row)
                                : modelData
                        width: list.width
                        height: isGroup ? root.groupHeaderHeight : root.rowHeight

                        Accessible.role: isGroup ? Accessible.StaticText : Accessible.ListItem
                        Accessible.name: {
                            if (isGroup)
                                return modelData.label
                            var first = ""
                            if (root.columns && root.columns.length)
                                first = root._cellText(rowObj, 0)
                            return first.length ? first : qsTr("Row %1").arg(dataIndex + 1)
                        }
                        Accessible.description: isGroup ? "" : qsTr("Row %1 of %2")
                                                      .arg(dataIndex + 1).arg(root.rowCount)
                        Accessible.selectable: !isGroup
                        Accessible.selected: !isGroup && dataIndex === root.selectedIndex
                        Accessible.onPressAction: {
                            if (!isGroup)
                                root.select(dataIndex)
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: isGroup
                            color: Theme.bgAcrylic
                            Label {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 8
                                text: (rowItem.isGroup && rowItem.modelData && rowItem.modelData.label)
                                      ? rowItem.modelData.label : ""
                                font.weight: Theme.fontWeightSemiBold
                                color: Theme.textSecondary
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: Theme.strokeCard
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: !isGroup
                            color: dataIndex === root.selectedIndex
                                   ? Theme.fillSubtleSecondary
                                   : (dataIndex % 2 === 0 ? Theme.bgCard : Theme.fillSubtle)

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: Theme.strokeCard
                                opacity: 0.45
                            }

                            Row {
                                height: parent.height
                                spacing: 0

                                Row {
                                    id: pinnedCells
                                    visible: root._pinnedColOrder.length > 0
                                    height: parent.height
                                    Repeater {
                                        model: root._pinnedColOrder
                                        delegate: DataCell {
                                            required property var modelData
                                            columnIndex: modelData
                                            rowObj: rowItem.rowObj
                                        }
                                    }
                                    Rectangle {
                                        width: root._scrollColOrder.length > 0 ? 1 : 0
                                        height: parent.height
                                        color: Theme.strokeCard
                                    }
                                }

                                Item {
                                    width: list.width - pinnedCells.width
                                    height: parent.height
                                    clip: true

                                    Row {
                                        x: -root._scrollX
                                        height: parent.height
                                        Repeater {
                                            model: root._scrollColOrder
                                            delegate: DataCell {
                                                required property var modelData
                                                columnIndex: modelData
                                                rowObj: rowItem.rowObj
                                            }
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.forceActiveFocus()
                                    root.select(rowItem.dataIndex)
                                }
                                onDoubleClicked: {
                                    root.select(rowItem.dataIndex)
                                    root.rowActivated(rowItem.dataIndex, root._viewRows[rowItem.dataIndex])
                                }
                            }
                        }
                    }

                    EmptyState {
                        anchors.centerIn: parent
                        visible: root.rowCount === 0
                        title: qsTr("No rows")
                        description: root.filterText.length
                                     ? qsTr("No rows match this filter.")
                                     : qsTr("Provide rows to populate the table.")
                        symbol: FluentIcons.ViewAll
                    }
                }
            }
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("%1 of %2 rows").arg(root.rowCount).arg((root.rows || []).length)
                  + (root.selectedIndex >= 0
                     ? qsTr(" · selected %1").arg(root.selectedIndex + 1) : "")
                  + (root._groupActive ? qsTr(" · grouped by %1").arg(root.groupRole) : "")
                  + (root._pinnedColOrder.length
                     ? qsTr(" · %1 pinned").arg(root._pinnedColOrder.length) : "")
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
        }
    }

    background: Item {}
}
