import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TreeDataGrid — hierarchical multi-column grid with sort + filter (2.21).
//
//   TreeDataGrid {
//       columns: [
//           { title: qsTr("Name"), role: "name", width: 200, sortable: true },
//           { title: qsTr("Role"), role: "role", width: 120, sortable: true },
//           { title: qsTr("Status"), role: "status", width: 100 }
//       ]
//       rows: [
//           { name: "Engineering", role: "Group", status: "Active",
//             children: [ { name: "Alex", role: "Engineer", status: "Active" } ] }
//       ]
//   }
//
//   // --- API ---
//   // selectedRow / selectedIndex, sortColumn / sortOrder, filterText
//   // methods: select(index), clearSelection(), refresh(), focusGrid(),
//   //          expandAll(), collapseAll(), toggleExpanded(path)
//   // signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int)
//
// @notes
//   Experimental — nested JS rows with optional `children`. Sort applies per sibling
//   group; filter keeps matching branches (ancestors auto-expanded). Not Excel-scale;
//   prefer C++ model + custom view for huge trees. Filter debounce + maxFilterResults
//   match DataTable (2.18 / 2.40). Column resize + freezeFirstColumn (2.64).
//   See docs/tree-data.md · docs/collection-perf-264.md.

T.Control {
    id: root

    property var columns: []
    property var rows: []
    property string filterText: ""
    property string filterPlaceholder: qsTr("Filter rows")
    property bool filterVisible: true
    property int selectedIndex: -1
    property int sortColumn: -1
    property int sortOrder: Qt.AscendingOrder
    property real rowHeight: Theme.navItemHeight
    property real minColumnWidth: 64
    property real headerHeight: Theme.navItemHeight
    property real indentWidth: 16
    property int filterDebounceMs: 120
    property int maxFilterResults: 0
    property bool announceChanges: true
    property bool expandOnFilter: true
    // Keep name column visible during horizontal scroll (2.64).
    property bool freezeFirstColumn: false

    readonly property var selectedRow: {
        if (selectedIndex < 0 || selectedIndex >= _viewRows.length)
            return null
        return _viewRows[selectedIndex].row
    }
    readonly property int rowCount: _viewRows.length
    readonly property int columnCount: columns ? columns.length : 0
    readonly property real _frozenWidth: root.freezeFirstColumn ? (root._columnWidths[0] || 140) : 0
    readonly property var _frozenColOrder: root.freezeFirstColumn && root.columnCount ? [0] : []
    readonly property var _scrollColOrder: {
        var out = []
        var start = root.freezeFirstColumn ? 1 : 0
        for (var i = start; i < root.columnCount; ++i)
            out.push(i)
        return out
    }
    readonly property real _scrollGridWidth: {
        var w = 0
        for (var i = 0; i < _scrollColOrder.length; ++i)
            w += root._columnWidths[_scrollColOrder[i]] || 140
        return w
    }

    property real _scrollX: 0

    signal rowActivated(int index, var row)
    signal selectionChanged(int index, var row)
    signal sortChanged(int column, int order)
    signal expandedChanged(string path, bool expanded)

    property var _viewRows: []
    property var _columnWidths: []
    property var _expandedPaths: ({})
    property string _lastRefreshKey: ""
    property var _lastRowsRef: null
    property var _selectedRowRef: null
    property string _lastAnnouncedFilterSummary: ""

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    function _cellText(rowObj, column) {
        var cols = columns || []
        if (column < 0 || column >= cols.length || !rowObj)
            return ""
        var role = cols[column].role || ("c" + column)
        var v = rowObj[role]
        return v === undefined || v === null ? "" : String(v)
    }

    function _rowMatches(rowObj, q) {
        if (!q.length)
            return true
        var cols = columns || []
        for (var c = 0; c < cols.length; ++c) {
            var t = _cellText(rowObj, c).toLowerCase()
            if (t.indexOf(q) >= 0)
                return true
        }
        return false
    }

    function _branchMatches(rowObj, q) {
        if (_rowMatches(rowObj, q))
            return true
        var kids = rowObj.children || []
        for (var i = 0; i < kids.length; ++i) {
            if (_branchMatches(kids[i], q))
                return true
        }
        return false
    }

    function _cloneRowShallow(rowObj) {
        var out = {}
        for (var k in rowObj) {
            if (k !== "children")
                out[k] = rowObj[k]
        }
        return out
    }

    function _filterTree(items, q) {
        if (!q.length)
            return items || []
        var out = []
        var src = items || []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            if (!_branchMatches(row, q))
                continue
            var copy = _cloneRowShallow(row)
            var kids = row.children || []
            if (kids.length)
                copy.children = _filterTree(kids, q)
            out.push(copy)
            if (root.maxFilterResults > 0 && out.length >= root.maxFilterResults)
                break
        }
        return out
    }

    function _sortSiblings(items) {
        var cols = columns || []
        if (sortColumn < 0 || sortColumn >= cols.length || cols[sortColumn].sortable === false)
            return items || []
        var role = cols[sortColumn].role || ("c" + sortColumn)
        var asc = sortOrder === Qt.AscendingOrder
        var sorted = (items || []).slice().sort(function (a, b) {
            var av = a[role]
            var bv = b[role]
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
        })
        for (var i = 0; i < sorted.length; ++i) {
            var kids = sorted[i].children
            if (kids && kids.length)
                sorted[i].children = _sortSiblings(kids)
        }
        return sorted
    }

    function _isExpanded(path) {
        if (!path || path.length === 0)
            return true
        var v = _expandedPaths[path]
        return v === undefined ? true : v
    }

    function _flatten(items, depth, pathPrefix, out, q) {
        var src = items || []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            var path = pathPrefix + String(i)
            var kids = row.children || []
            var hasChildren = kids.length > 0
            out.push({ row: row, depth: depth, path: path, hasChildren: hasChildren })
            if (hasChildren && _isExpanded(path)) {
                if (root.maxFilterResults > 0 && out.length >= root.maxFilterResults)
                    break
                _flatten(kids, depth + 1, path + "/", out, q)
            }
            if (root.maxFilterResults > 0 && out.length >= root.maxFilterResults)
                break
        }
    }

    function toggleExpanded(path) {
        if (!path || path.length === 0)
            return
        var next = !_isExpanded(path)
        var copy = Object.assign({}, _expandedPaths)
        copy[path] = next
        _expandedPaths = copy
        expandedChanged(path, next)
        if (root.announceChanges) {
            for (var i = 0; i < _viewRows.length; ++i) {
                if (_viewRows[i].path === path) {
                    var label = _cellText(_viewRows[i].row, 0)
                    if (label.length)
                        _announce(next ? qsTr("%1 expanded").arg(label)
                                      : qsTr("%1 collapsed").arg(label))
                    break
                }
            }
        }
        refresh()
    }

    function expandAll() {
        var copy = Object.assign({}, _expandedPaths)
        for (var i = 0; i < _viewRows.length; ++i) {
            var e = _viewRows[i]
            if (e.hasChildren)
                copy[e.path] = true
        }
        _expandedPaths = copy
        refresh()
    }

    function collapseAll() {
        _expandedPaths = {}
        refresh()
    }

    function focusGrid() {
        forceActiveFocus()
    }

    function clearSelection() {
        select(-1)
    }

    function select(index) {
        if (index < -1 || index >= _viewRows.length)
            return
        selectedIndex = index
        _selectedRowRef = index >= 0 ? _viewRows[index].row : null
        selectionChanged(index, selectedRow)
        if (index >= 0)
            list.positionViewAtIndex(index, ListView.Contain)
        _announceSelection(index)
    }

    function _announceSelection(index) {
        if (!root.announceChanges)
            return
        if (index < 0) {
            _announce(qsTr("Selection cleared"))
            return
        }
        var entry = _viewRows[index]
        if (!entry)
            return
        var name = _cellText(entry.row, 0)
        if (!name.length)
            name = qsTr("Row %1").arg(index + 1)
        _announce(qsTr("%1, level %2, row %3 of %4")
                  .arg(name).arg(entry.depth + 1).arg(index + 1).arg(rowCount))
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
    property string accessibleName: qsTr("Tree data grid")
    Accessible.role: Accessible.Table
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Tree data grid")
    Accessible.description: qsTr("%1 rows, %2 columns").arg(rowCount).arg(columnCount)

    onColumnsChanged: {
        _syncColumnWidths()
        _scheduleRefresh(true)
    }
    onRowsChanged: _scheduleRefresh(true)
    onFilterTextChanged: _scheduleRefresh(false)
    onSortColumnChanged: _scheduleRefresh(true)
    onSortOrderChanged: _scheduleRefresh(true)
    Component.onCompleted: {
        _syncColumnWidths()
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

    function _syncColumnWidths() {
        var cols = columns || []
        var widths = []
        for (var i = 0; i < cols.length; ++i) {
            var w = cols[i].width
            widths.push(w === undefined ? 140 : Number(w))
        }
        _columnWidths = widths
    }

    function toggleSort(column) {
        var cols = columns || []
        if (column < 0 || column >= cols.length)
            return
        if (cols[column].sortable === false)
            return
        if (sortColumn === column)
            sortOrder = sortOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
        else {
            sortColumn = column
            sortOrder = Qt.AscendingOrder
        }
        sortChanged(sortColumn, sortOrder)
        if (announceChanges) {
            var colTitle = cols[column].title || cols[column].role || ""
            var order = sortOrder === Qt.AscendingOrder ? qsTr("ascending") : qsTr("descending")
            _announce(qsTr("Sorted by %1, %2").arg(colTitle).arg(order))
        }
    }

    function refresh() {
        var src = rows || []
        var q = (filterText || "").trim().toLowerCase()
        var refreshKey = q + "\0" + sortColumn + "\0" + sortOrder + "\0" + src.length
        if (refreshKey === _lastRefreshKey && src === _lastRowsRef)
            return
        _lastRefreshKey = refreshKey
        _lastRowsRef = src

        var tree = _filterTree(src, q)
        tree = _sortSiblings(tree)

        if (q.length && expandOnFilter) {
            var expandCopy = Object.assign({}, _expandedPaths)
            function markExpanded(items, pathPrefix) {
                var arr = items || []
                for (var i = 0; i < arr.length; ++i) {
                    var path = pathPrefix + String(i)
                    var kids = arr[i].children || []
                    if (kids.length) {
                        expandCopy[path] = true
                        markExpanded(kids, path + "/")
                    }
                }
            }
            markExpanded(tree, "")
            _expandedPaths = expandCopy
        }

        var flat = []
        _flatten(tree, 0, "", flat, q)
        var prev = _selectedRowRef
        _viewRows = flat

        if (prev !== null && prev !== undefined) {
            var found = -1
            for (var j = 0; j < _viewRows.length; ++j) {
                if (_viewRows[j].row === prev) {
                    found = j
                    break
                }
            }
            if (found >= 0) {
                if (selectedIndex !== found)
                    selectedIndex = found
                list.positionViewAtIndex(found, ListView.Contain)
            } else {
                selectedIndex = -1
                _selectedRowRef = null
            }
        } else if (selectedIndex >= _viewRows.length) {
            select(_viewRows.length ? _viewRows.length - 1 : -1)
        }

        var summary = q.length
                ? qsTr("%1 rows match filter").arg(_viewRows.length)
                : qsTr("%1 rows").arg(_viewRows.length)
        if (summary !== _lastAnnouncedFilterSummary) {
            _lastAnnouncedFilterSummary = summary
            _announce(summary)
        }
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
        } else if (event.key === Qt.Key_Left) {
            if (selectedIndex >= 0) {
                var e = _viewRows[selectedIndex]
                if (e && e.hasChildren && _isExpanded(e.path))
                    toggleExpanded(e.path)
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            if (selectedIndex >= 0) {
                var e2 = _viewRows[selectedIndex]
                if (e2 && e2.hasChildren && !_isExpanded(e2.path))
                    toggleExpanded(e2.path)
            }
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
            Accessible.name: qsTr("Filter tree")
            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Down || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
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

                    Item {
                        id: frozenHeaderHost
                        visible: root._frozenColOrder.length > 0
                        height: root.headerHeight
                        width: frozenHeaderRow.width

                        Row {
                            id: frozenHeaderRow
                            height: parent.height
                            Repeater {
                                model: root._frozenColOrder
                                delegate: Item {
                                    id: frozenHeaderCell
                                    required property var modelData
                                    readonly property int columnIndex: modelData
                                    width: root._columnWidths[columnIndex] || 140
                                    height: root.headerHeight
                                    readonly property var colDef: (root.columns || [])[columnIndex] || ({})

                                    Rectangle {
                                        anchors.fill: parent
                                        color: Theme.bgAcrylic
                                        Accessible.role: Accessible.ColumnHeader
                                        Accessible.name: frozenHeaderCell.colDef.title
                                                         || frozenHeaderCell.colDef.role || ""
                                        Accessible.onPressAction: root.toggleSort(frozenHeaderCell.columnIndex)

                                        Label {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            anchors.rightMargin: 8
                                            text: frozenHeaderCell.colDef.title
                                                  || frozenHeaderCell.colDef.role || ""
                                            elide: Text.ElideRight
                                            font.weight: Theme.fontWeightSemiBold
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.rightMargin: 6
                                            onClicked: root.toggleSort(frozenHeaderCell.columnIndex)
                                        }
                                        MouseArea {
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            anchors.right: parent.right
                                            width: 6
                                            cursorShape: Qt.SplitHCursor
                                            visible: frozenHeaderCell.colDef.resizable !== false
                                            property real _startX: 0
                                            property real _startW: 0
                                            onPressed: function (mouse) {
                                                _startX = mouse.x
                                                _startW = frozenHeaderCell.width
                                            }
                                            onPositionChanged: function (mouse) {
                                                if (!pressed)
                                                    return
                                                var nw = Math.max(root.minColumnWidth, _startW + (mouse.x - _startX))
                                                var widths = root._columnWidths.slice()
                                                widths[frozenHeaderCell.columnIndex] = nw
                                                root._columnWidths = widths
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Rectangle {
                            anchors.right: parent.right
                            width: 1
                            height: parent.height
                            color: Theme.strokeCard
                            visible: root._scrollColOrder.length > 0
                        }
                    }

                    Flickable {
                        id: headerFlick
                        width: parent.width - frozenHeaderHost.width
                        height: root.headerHeight
                        contentWidth: scrollHeaderRow.width
                        contentHeight: height
                        clip: true
                        interactive: false
                        contentX: root._scrollX

                        Row {
                            id: scrollHeaderRow
                            height: root.headerHeight
                            Repeater {
                                model: root._scrollColOrder
                                delegate: Item {
                                    id: headerCell
                                    required property var modelData
                                    readonly property int columnIndex: modelData
                                    width: root._columnWidths[columnIndex] || 140
                                    height: root.headerHeight
                                    readonly property var colDef: (root.columns || [])[columnIndex] || ({})

                                    Rectangle {
                                        anchors.fill: parent
                                        color: Theme.bgAcrylic
                                        Accessible.role: Accessible.ColumnHeader
                                        Accessible.name: {
                                            var t = headerCell.colDef.title
                                                    || headerCell.colDef.role || ""
                                            if (root.sortColumn === headerCell.columnIndex) {
                                                t += root.sortOrder === Qt.AscendingOrder
                                                     ? qsTr(", sorted ascending")
                                                     : qsTr(", sorted descending")
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
                                            Label {
                                                Layout.fillWidth: true
                                                text: headerCell.colDef.title
                                                      || headerCell.colDef.role || ""
                                                elide: Text.ElideRight
                                                font.weight: Theme.fontWeightSemiBold
                                            }
                                            Label {
                                                visible: root.sortColumn === headerCell.columnIndex
                                                text: root.sortOrder === Qt.AscendingOrder ? "▲" : "▼"
                                                color: Theme.accent
                                                font.pixelSize: Theme.fontCaption
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.rightMargin: 6
                                            cursorShape: headerCell.colDef.sortable === false
                                                         ? Qt.ArrowCursor : Qt.PointingHandCursor
                                            onClicked: root.toggleSort(headerCell.columnIndex)
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
                                                var nw = Math.max(root.minColumnWidth,
                                                                  _startW + (mouse.x - _startX))
                                                var widths = root._columnWidths.slice()
                                                widths[headerCell.columnIndex] = nw
                                                root._columnWidths = widths
                                            }
                                        }
                                    }
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
                    boundsBehavior: Flickable.StopAtBounds
                    model: root._viewRows
                    currentIndex: root.selectedIndex
                    flickableDirection: Flickable.VerticalFlick

                    ScrollBar.vertical: ScrollBar {}
                    ScrollBar.horizontal: ScrollBar {
                        policy: root._scrollGridWidth > (list.width - root._frozenWidth)
                                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        onPositionChanged: {
                            var viewport = Math.max(1, list.width - root._frozenWidth)
                            var maxX = Math.max(0, root._scrollGridWidth - viewport)
                            root._scrollX = position * maxX
                        }
                    }

                    delegate: Item {
                        id: rowItem
                        required property var modelData
                        required property int index
                        width: list.width
                        height: root.rowHeight

                        Accessible.role: Accessible.TreeItem
                        Accessible.name: {
                            var first = root._cellText(modelData.row, 0)
                            return first.length ? first : qsTr("Row %1").arg(index + 1)
                        }
                        Accessible.description: qsTr("Level %1, row %2 of %3")
                                              .arg(modelData.depth + 1)
                                              .arg(index + 1)
                                              .arg(root.rowCount)
                        Accessible.selectable: true
                        Accessible.selected: index === root.selectedIndex
                        Accessible.onPressAction: root.select(index)

                        Rectangle {
                            anchors.fill: parent
                            color: index === root.selectedIndex
                                   ? Theme.fillSubtleSecondary
                                   : (index % 2 === 0 ? Theme.bgCard : Theme.fillSubtle)

                            Row {
                                id: cellRow
                                height: parent.height
                                spacing: 0

                                Item {
                                    id: frozenCellHost
                                    visible: root._frozenColOrder.length > 0
                                    height: parent.height
                                    width: frozenCells.width

                                    Row {
                                        id: frozenCells
                                        height: parent.height
                                        Repeater {
                                            model: root._frozenColOrder
                                            delegate: Item {
                                                required property var modelData
                                                readonly property int columnIndex: modelData
                                                readonly property real indent: rowItem.modelData.depth * root.indentWidth
                                                width: (root._columnWidths[columnIndex] || 140)
                                                height: root.rowHeight
                                                Row {
                                                    x: indent
                                                    height: parent.height
                                                    spacing: 4
                                                    Item {
                                                        width: 20
                                                        height: parent.height
                                                        visible: rowItem.modelData.hasChildren
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: FluentIcons.ChevronRight
                                                            font.family: Theme.fontFamilyIcon
                                                            font.pixelSize: 10
                                                            color: Theme.textSecondary
                                                            rotation: root._isExpanded(rowItem.modelData.path) ? 90 : 0
                                                        }
                                                        MouseArea {
                                                            anchors.fill: parent
                                                            onClicked: root.toggleExpanded(rowItem.modelData.path)
                                                        }
                                                    }
                                                    Label {
                                                        width: Math.max(40, parent.parent.width - indent - 28)
                                                        height: parent.height
                                                        text: root._cellText(rowItem.modelData.row, columnIndex)
                                                        elide: Text.ElideRight
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: Theme.textPrimary
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Rectangle {
                                        anchors.right: parent.right
                                        width: 1
                                        height: parent.height
                                        color: Theme.strokeCard
                                        visible: root._scrollColOrder.length > 0
                                    }
                                }

                                Item {
                                    width: list.width - frozenCellHost.width
                                    height: parent.height
                                    clip: true
                                    Row {
                                        x: -root._scrollX
                                        height: parent.height
                                        Repeater {
                                            model: root._scrollColOrder
                                            delegate: Item {
                                                required property var modelData
                                                readonly property int columnIndex: modelData
                                                readonly property bool isFirst: columnIndex === 0
                                                readonly property real indent: isFirst
                                                        ? (rowItem.modelData.depth * root.indentWidth) : 0
                                                width: (root._columnWidths[columnIndex] || 140)
                                                height: root.rowHeight
                                                Row {
                                                    x: indent
                                                    height: parent.height
                                                    spacing: 4
                                                    Item {
                                                        width: 20
                                                        height: parent.height
                                                        visible: isFirst && rowItem.modelData.hasChildren
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: FluentIcons.ChevronRight
                                                            font.family: Theme.fontFamilyIcon
                                                            font.pixelSize: 10
                                                            color: Theme.textSecondary
                                                            rotation: root._isExpanded(rowItem.modelData.path) ? 90 : 0
                                                        }
                                                        MouseArea {
                                                            anchors.fill: parent
                                                            onClicked: root.toggleExpanded(rowItem.modelData.path)
                                                        }
                                                    }
                                                    Label {
                                                        width: Math.max(40, parent.parent.width - indent - (isFirst ? 28 : 8))
                                                        height: parent.height
                                                        text: root._cellText(rowItem.modelData.row, columnIndex)
                                                        elide: Text.ElideRight
                                                        verticalAlignment: Text.AlignVCenter
                                                        color: Theme.textPrimary
                                                        font.family: Theme.fontFamily
                                                        font.pixelSize: Theme.fontBody
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.forceActiveFocus()
                                    root.select(rowItem.index)
                                }
                                onDoubleClicked: {
                                    root.select(rowItem.index)
                                    root.rowActivated(rowItem.index, root.selectedRow)
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
                                     : qsTr("Provide hierarchical rows to populate the grid.")
                        symbol: FluentIcons.ViewAll
                    }
                }
            }
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("%1 visible rows").arg(root.rowCount)
                  + (root.selectedIndex >= 0
                     ? qsTr(" · selected %1").arg(root.selectedIndex + 1) : "")
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
        }
    }

    background: Item {}
}
