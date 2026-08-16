import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// DataTable — Fluent virtualizing table with sort, filter, resize, and keyboard.
//
//   DataTable {
//       columns: [
//           { title: qsTr("Name"), role: "name", width: 160, sortable: true },
//           { title: qsTr("Role"), role: "role", width: 140, sortable: true },
//           { title: qsTr("Status"), role: "status", width: 120 }
//       ]
//       rows: [ { name: "Alex", role: "Design", status: "Active" }, … ]
//       filterPlaceholder: qsTr("Filter rows")
//   }
//
//   // --- API ---
//   // selectedRow / selectedIndex, sortColumn / sortOrder, filterText
//   // methods: select(row), clearSelection(), refresh(), focusTable()
//   // signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int)
//
// @notes
//   ListView virtualizes rows (`reuseItems`). Filter + sort rebuild `_viewRows` in JS —
//   fine for hundreds of plain objects; prefer a C++ model + custom view for thousands+.
//   Selection tracks the row **object** across sort/filter (clears if the row is filtered out).
//   Tab into the table or press Down from the filter; arrows / Home / End / Page / Enter /
//   Esc navigate. Horizontal scroll via the bottom scrollbar (list flick is vertical).
//   See docs/data-collections.md for DataTable vs ItemsView vs ListDetailsView.

T.Control {
    id: root

    property var columns: []
    property var rows: []
    property string filterText: ""
    property string filterPlaceholder: qsTr("Filter")
    property bool filterVisible: true
    property int selectedIndex: -1
    property int sortColumn: -1
    property int sortOrder: Qt.AscendingOrder
    property real rowHeight: Theme.navItemHeight
    property real minColumnWidth: 64
    property real headerHeight: Theme.navItemHeight

    readonly property var selectedRow: {
        if (selectedIndex < 0 || selectedIndex >= _viewRows.length)
            return null
        return _viewRows[selectedIndex]
    }
    readonly property int rowCount: _viewRows.length
    readonly property int columnCount: columns ? columns.length : 0

    signal rowActivated(int index, var row)
    signal selectionChanged(int index, var row)
    signal sortChanged(int column, int order)

    property var _viewRows: []
    property var _columnWidths: []
    // Object identity of the selected row (survives sort/filter when still visible).
    property var _selectedRowRef: null

    implicitWidth: 640
    implicitHeight: 360
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    // Screen-reader name override (1.19)
    property string accessibleName: qsTr("Data table")
    Accessible.role: Accessible.Table
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Data table")
    Accessible.description: qsTr("%1 rows, %2 columns").arg(rowCount).arg(columnCount)

    onColumnsChanged: {
        _syncColumnWidths()
        Qt.callLater(refresh)
    }
    onRowsChanged: Qt.callLater(refresh)
    onFilterTextChanged: Qt.callLater(refresh)
    onSortColumnChanged: Qt.callLater(refresh)
    onSortOrderChanged: Qt.callLater(refresh)
    Component.onCompleted: {
        _syncColumnWidths()
        refresh()
    }

    function focusTable() {
        forceActiveFocus()
    }

    function clearSelection() {
        select(-1)
    }

    function select(index) {
        if (index < -1 || index >= _viewRows.length)
            return
        selectedIndex = index
        _selectedRowRef = index >= 0 ? _viewRows[index] : null
        selectionChanged(index, selectedRow)
        if (index >= 0)
            list.positionViewAtIndex(index, ListView.Contain)
    }

    function refresh() {
        var src = rows || []
        var cols = columns || []
        var q = (filterText || "").trim().toLowerCase()
        var filtered = []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            if (!q.length) {
                filtered.push(row)
                continue
            }
            var hit = false
            for (var c = 0; c < cols.length; ++c) {
                var role = cols[c].role || ("c" + c)
                var v = row[role]
                if (v !== undefined && String(v).toLowerCase().indexOf(q) >= 0) {
                    hit = true
                    break
                }
            }
            if (hit)
                filtered.push(row)
        }
        if (sortColumn >= 0 && sortColumn < cols.length && cols[sortColumn].sortable !== false) {
            var roleSort = cols[sortColumn].role || ("c" + sortColumn)
            var asc = sortOrder === Qt.AscendingOrder
            filtered = filtered.slice().sort(function (a, b) {
                var av = a[roleSort]
                var bv = b[roleSort]
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
        }

        var prev = _selectedRowRef
        _viewRows = filtered

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
                list.positionViewAtIndex(found, ListView.Contain)
            } else {
                selectedIndex = -1
                _selectedRowRef = null
                selectionChanged(-1, null)
            }
        } else if (selectedIndex >= _viewRows.length) {
            select(_viewRows.length ? _viewRows.length - 1 : -1)
        }
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
        refresh()
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

                Flickable {
                    id: headerFlick
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.headerHeight
                    contentWidth: headerRow.width
                    contentHeight: height
                    clip: true
                    interactive: false
                    boundsBehavior: Flickable.StopAtBounds

                    Row {
                        id: headerRow
                        height: root.headerHeight

                        Repeater {
                            model: root.columns || []

                            delegate: Item {
                                id: headerCell
                                required property var modelData
                                required property int index
                                width: root._columnWidths[index] || 140
                                height: root.headerHeight

                                Rectangle {
                                    anchors.fill: parent
                                    color: Theme.bgAcrylic
                                    Accessible.role: Accessible.ColumnHeader
                                    Accessible.name: {
                                        var t = headerCell.modelData.title
                                                || headerCell.modelData.role || ""
                                        if (root.sortColumn === headerCell.index) {
                                            t += root.sortOrder === Qt.AscendingOrder
                                                 ? qsTr(", sorted ascending")
                                                 : qsTr(", sorted descending")
                                        }
                                        return t
                                    }
                                    Accessible.onPressAction: root.toggleSort(headerCell.index)

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
                                            text: headerCell.modelData.title
                                                  || headerCell.modelData.role
                                                  || ""
                                            elide: Text.ElideRight
                                            font.weight: Theme.fontWeightSemiBold
                                            color: Theme.textPrimary
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        Label {
                                            visible: root.sortColumn === headerCell.index
                                            text: root.sortOrder === Qt.AscendingOrder ? "▲" : "▼"
                                            color: Theme.accent
                                            font.pixelSize: Theme.fontCaption
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.rightMargin: 6
                                        cursorShape: headerCell.modelData.sortable === false
                                                     ? Qt.ArrowCursor : Qt.PointingHandCursor
                                        onClicked: root.toggleSort(headerCell.index)
                                    }

                                    MouseArea {
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                        width: 6
                                        cursorShape: Qt.SplitHCursor
                                        visible: headerCell.modelData.resizable !== false
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
                                            widths[headerCell.index] = nw
                                            root._columnWidths = widths
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
                    contentWidth: headerRow.width
                    flickableDirection: Flickable.VerticalFlick
                    onContentXChanged: headerFlick.contentX = contentX

                    ScrollBar.vertical: ScrollBar {}
                    ScrollBar.horizontal: ScrollBar {
                        policy: list.contentWidth > list.width
                                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        onPositionChanged: {
                            list.contentX = position * (list.contentWidth - list.width)
                            headerFlick.contentX = list.contentX
                        }
                    }

                    delegate: Item {
                        id: rowItem
                        required property var modelData
                        required property int index
                        width: Math.max(list.width, headerRow.width)
                        height: root.rowHeight

                        Accessible.role: Accessible.ListItem
                        Accessible.name: {
                            var first = ""
                            if (root.columns && root.columns.length)
                                first = root._cellText(modelData, 0)
                            return first.length
                                   ? first
                                   : qsTr("Row %1").arg(index + 1)
                        }
                        Accessible.description: qsTr("Row %1 of %2").arg(index + 1).arg(root.rowCount)
                        Accessible.selectable: true
                        Accessible.selected: index === root.selectedIndex
                        Accessible.onPressAction: root.select(index)

                        Rectangle {
                            anchors.fill: parent
                            color: index === root.selectedIndex
                                   ? Theme.fillSubtleSecondary
                                   : (index % 2 === 0 ? Theme.bgCard : Theme.fillSubtle)

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: Theme.strokeCard
                                opacity: 0.45
                            }

                            Row {
                                id: cellRow
                                height: parent.height

                                Repeater {
                                    model: root.columns || []

                                    delegate: Item {
                                        required property var modelData
                                        required property int index
                                        width: root._columnWidths[index] || 140
                                        height: root.rowHeight

                                        Label {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            anchors.rightMargin: 8
                                            text: root._cellText(rowItem.modelData, index)
                                            elide: Text.ElideRight
                                            color: Theme.textPrimary
                                            verticalAlignment: Text.AlignVCenter
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontBody
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
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
        }
    }

    background: Item {}
}
