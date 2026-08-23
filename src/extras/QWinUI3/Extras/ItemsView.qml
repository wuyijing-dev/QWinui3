import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ItemsView — ListView recipe: sections, selection, context MenuFlyout, EmptyState.
//
//   ItemsView {
//       model: myModel
//       sectionRole: "group"
//       selectionMode: ItemsView.SelectionMultiple
//       titleRole: "title"
//       subtitleRole: "subtitle"
//       emptyTitle: qsTr("No items")
//       MenuFlyout {
//           id: ctx
//           MenuFlyoutItem { text: qsTr("Open") }
//       }
//       contextMenu: ctx
//   }
//   // --- API ---
//   // methods: clearSelection(), selectAll(), isSelected(index), toggleSelection(index)
//   // itemsView.clearSelection()
//   // itemsView.selectAll()
//
// @notes
//   Fluent list recipe over QQC ListView (`reuseItems`; not a separate virtualization engine).
//   selectionMode: selectionNone | selectionSingle | selectionMultiple.
//   Keyboard: arrows / Home / End / Page / Enter; Space toggles multi-select; Ctrl+A; Esc clears.
//   Right-click / long-press opens contextMenu.
//   Empty list shows EmptyState via emptyTitle / emptyMessage / emptyActionText.
//   Large models: prefer QAbstractListModel. Optional filterText filters plain JS
//   arrays (debounced, 1.88) — C++ models: filter app-side.
//   See docs/data-collections.md for pairing with ListDetailsView.

T.Control {
    id: root

    Layout.fillWidth: true

    // Prefer ItemsView.SelectionMultiple from outside; plain ints avoid
    // "SelectionMode is not defined" when initializing properties in-type.
    enum SelectionMode {
        SelectionNone = 0,
        SelectionSingle = 1,
        SelectionMultiple = 2
    }

    readonly property int selectionNone: 0
    readonly property int selectionSingle: 1
    readonly property int selectionMultiple: 2

    // List model (array or ListModel / QAbstractListModel)
    property var model: []
    // selectionNone | selectionSingle | selectionMultiple
    property int selectionMode: 1
    // Selected row indexes (array of int)
    property var selectedIndexes: []
    // Model role / property name for title
    property string titleRole: "title"
    // Model role / property name for subtitle
    property string subtitleRole: "subtitle"
    // Model role / property name for leading Fluent symbol
    property string symbolRole: "symbol"
    // Model role / property name for section header (empty = no sections)
    property string sectionRole: ""
    // Put multi-select checkboxes in the leading slot (WinUI-like)
    property bool checkboxLeading: true
    // Optional MenuFlyout (or Menu) instance for context actions
    property var contextMenu: null
    // EmptyState title when model is empty
    property string emptyTitle: qsTr("Nothing here yet")
    // EmptyState message
    property string emptyMessage: qsTr("When there is content, it will show up in this area.")
    // EmptyState action label
    property string emptyActionText: ""
    // Filter plain JS array models (debounced). Leave empty for C++ / ListModel — filter app-side.
    property string filterText: ""
    // Roles searched when filterText is set (defaults to title + subtitle + section + symbol).
    property var filterRoles: []
    // Debounce ms before rebuilding the filtered array (1.88).
    property int filterDebounceMs: 120
    // Skip filter until query length >= this (2.59 — huge JS arrays).
    property int minFilterLength: 0
    // Cap filtered rows for plain JS arrays (2.59).
    property int maxFilterResults: 256
    // Row enter motion: none | fade | slide — 2.67 B2 (honors Theme.reducedMotion)
    property string itemEnter: "fade"
    // Row exit motion: none | fade | slide
    property string itemExit: "fade"
    // Emitted when an item is activated (click / Enter)
    signal itemActivated(int index, var itemData)
    // Emitted when selection changes
    signal selectionChanged()
    // Empty action clicked
    signal emptyActionClicked()

    // Screen-reader name override (1.19)
    property string accessibleName: qsTr("Items")

    // Resolved item count
    readonly property int count: listView.count
    readonly property bool isEmpty: count <= 0
    readonly property bool _filterActive: _canFilterModel(model)
                                             && (filterText || "").trim().length > 0

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

    function _canFilterModel(m) {
        return Array.isArray(m)
    }

    function _scheduleFilter(immediate) {
        if (immediate) {
            filterDebounce.stop()
            _rebuildFilter()
        } else {
            filterDebounce.restart()
        }
    }

    function _filterRolesList() {
        var roles = filterRoles
        if (roles && roles.length)
            return roles
        var out = []
        if (titleRole)
            out.push(titleRole)
        if (subtitleRole)
            out.push(subtitleRole)
        if (sectionRole)
            out.push(sectionRole)
        if (symbolRole)
            out.push(symbolRole)
        return out
    }

    function _matchesFilter(item, query, roles) {
        if (!query.length)
            return true
        for (var r = 0; r < roles.length; ++r) {
            var v = _roleValue(item, roles[r], -1)
            if (v !== undefined && v !== null
                    && String(v).toLowerCase().indexOf(query) >= 0)
                return true
        }
        if (typeof item === "string" && item.toLowerCase().indexOf(query) >= 0)
            return true
        return false
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
        if (minFilterLength > 0 && q.length < minFilterLength) {
            _filteredModel = []
            _lastFilterKey = ""
            _lastModelRef = m
            return
        }
        var key = q + "\0" + m.length + "\0" + minFilterLength + "\0" + maxFilterResults
        if (key === _lastFilterKey && m === _lastModelRef)
            return
        _lastFilterKey = key
        _lastModelRef = m
        var roles = _filterRolesList()
        var out = []
        for (var i = 0; i < m.length; ++i) {
            if (_matchesFilter(m[i], q, roles)) {
                out.push(m[i])
                if (maxFilterResults > 0 && out.length >= maxFilterResults)
                    break
            }
        }
        _filteredModel = out
    }

    implicitWidth: 320
    implicitHeight: 280
    padding: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.List
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Items")
    Accessible.description: {
        if (isEmpty)
            return emptyTitle
        var sel = selectedIndexes && selectedIndexes.length
                  ? qsTr("%1 selected").arg(selectedIndexes.length)
                  : ""
        return sel.length
               ? qsTr("%1 items, %2").arg(count).arg(sel)
               : qsTr("%1 items").arg(count)
    }

    function _roleValue(item, role, fallbackIndex) {
        if (item === undefined || item === null)
            return ""
        if (typeof item === "object" && role && item[role] !== undefined)
            return item[role]
        if (typeof item === "string" || typeof item === "number")
            return item
        return ""
    }

    function isSelected(index) {
        return selectedIndexes.indexOf(index) >= 0
    }

    function clearSelection() {
        selectedIndexes = []
        selectionChanged()
    }

    function selectAll() {
        if (selectionMode !== selectionMultiple)
            return
        var all = []
        for (var i = 0; i < listView.count; ++i)
            all.push(i)
        selectedIndexes = all
        selectionChanged()
    }

    function toggleSelection(index) {
        if (selectionMode === selectionNone)
            return
        if (selectionMode === selectionSingle) {
            selectedIndexes = isSelected(index) ? [] : [index]
            selectionChanged()
            return
        }
        var next = selectedIndexes.slice()
        var at = next.indexOf(index)
        if (at >= 0)
            next.splice(at, 1)
        else
            next.push(index)
        selectedIndexes = next
        selectionChanged()
    }

    function _openContext(index, item, globalX, globalY) {
        if (!contextMenu)
            return
        listView.currentIndex = index
        if (selectionMode === selectionSingle && !isSelected(index))
            toggleSelection(index)
        if (contextMenu.showAt)
            contextMenu.showAt(item, 0, item.height)
        else if (contextMenu.popup)
            contextMenu.popup()
    }

    function _itemAt(index) {
        var m = _filterActive ? _filteredModel : model
        if (!m || index < 0)
            return null
        if (typeof m.get === "function" && typeof m.count === "number") {
            if (index >= m.count)
                return null
            return m.get(index)
        }
        if (index >= (m.length || 0))
            return null
        return m[index]
    }

    function _focusIndex(index) {
        if (count <= 0 || index < 0 || index >= count)
            return
        listView.currentIndex = index
        listView.positionViewAtIndex(index, ListView.Contain)
    }

    function _moveCurrent(delta) {
        if (count <= 0)
            return
        var base = listView.currentIndex < 0 ? 0 : listView.currentIndex
        _focusIndex(Math.max(0, Math.min(count - 1, base + delta)))
        if (selectionMode === selectionSingle) {
            selectedIndexes = [listView.currentIndex]
            selectionChanged()
        }
    }

    function _activateCurrent() {
        if (listView.currentIndex < 0 || listView.currentIndex >= count)
            return
        itemActivated(listView.currentIndex, _itemAt(listView.currentIndex))
    }

    onActiveFocusChanged: {
        if (activeFocus && listView.currentIndex < 0 && count > 0)
            _focusIndex(0)
    }

    Keys.onUpPressed: _moveCurrent(-1)
    Keys.onDownPressed: _moveCurrent(1)
    Keys.onPressed: function (event) {
        if (count <= 0)
            return
        if (event.key === Qt.Key_Home) {
            _focusIndex(0)
            if (selectionMode === selectionSingle) {
                selectedIndexes = [0]
                selectionChanged()
            }
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            _focusIndex(count - 1)
            if (selectionMode === selectionSingle) {
                selectedIndexes = [count - 1]
                selectionChanged()
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            _activateCurrent()
            event.accepted = true
        } else if (event.key === Qt.Key_Space && selectionMode === selectionMultiple) {
            if (listView.currentIndex >= 0)
                toggleSelection(listView.currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)
                   && selectionMode === selectionMultiple) {
            selectAll()
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            clearSelection()
            event.accepted = true
        } else if (event.key === Qt.Key_PageDown) {
            _moveCurrent(8)
            event.accepted = true
        } else if (event.key === Qt.Key_PageUp) {
            _moveCurrent(-8)
            event.accepted = true
        }
    }

    contentItem: Item {
        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            reuseItems: true
            model: root._filterActive ? root._filteredModel : root.model
            currentIndex: -1
            visible: !root.isEmpty
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}

            section.property: root.sectionRole
            section.criteria: ViewSection.FullString
            section.delegate: root.sectionRole.length ? sectionDelegate : null

            add: Transition {
                enabled: !Theme.reducedMotion && root.itemEnter !== "none"
                NumberAnimation {
                    property: "opacity"
                    from: 0; to: 1
                    duration: Theme.motion.ms("normal")
                    easing.type: Theme.motion.easing("enter")
                }
                NumberAnimation {
                    property: "x"
                    from: root.itemEnter === "slide" ? 24 : 0
                    to: 0
                    duration: Theme.motion.ms("normal")
                    easing.type: Theme.motion.easing("enter")
                }
            }
            populate: Transition {
                enabled: !Theme.reducedMotion && root.itemEnter !== "none"
                NumberAnimation {
                    property: "opacity"
                    from: 0; to: 1
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
                NumberAnimation {
                    property: "x"
                    to: root.itemExit === "slide" ? -24 : 0
                    duration: Theme.motion.ms("fast")
                    easing.type: Theme.motion.easing("exit")
                }
            }
            displaced: Transition {
                enabled: !Theme.reducedMotion && root.itemEnter !== "none"
                NumberAnimation {
                    properties: "x,y"
                    duration: Theme.motion.ms("fast")
                    easing.type: Theme.motion.easing("standard")
                }
            }

            delegate: ListTile {
                id: tile
                required property int index
                required property var modelData
                readonly property string tileTitle: String(root._roleValue(
                    modelData, root.titleRole, index))
                readonly property string tileSubtitle: String(root._roleValue(
                    modelData, root.subtitleRole, index))
                readonly property string tileSymbol: String(root._roleValue(
                    modelData, root.symbolRole, index))
                width: listView.width
                focusPolicy: Qt.NoFocus
                activeFocusOnTab: false
                title: tileTitle
                subtitle: tileSubtitle
                // When checkbox occupies leading, draw the symbol inside leading too.
                symbol: (root.selectionMode === root.selectionMultiple && root.checkboxLeading)
                        ? ""
                        : tileSymbol
                isSelected: root.isSelected(index)
                highlighted: ListView.isCurrentItem

                leading: RowLayout {
                    spacing: 8
                    visible: (root.selectionMode === root.selectionMultiple && root.checkboxLeading)
                             || tileSymbol.length > 0

                    CheckBox {
                        visible: root.selectionMode === root.selectionMultiple && root.checkboxLeading
                        checked: root.isSelected(index)
                        focusPolicy: Qt.NoFocus
                        activeFocusOnTab: false
                        Accessible.ignored: true
                        onClicked: {
                            root.toggleSelection(index)
                            root.forceActiveFocus()
                        }
                    }

                    Rectangle {
                        visible: root.selectionMode === root.selectionMultiple && root.checkboxLeading
                                 && tileSymbol.length > 0
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: Theme.cornerControl
                        color: Theme.fillSubtle
                        Text {
                            anchors.centerIn: parent
                            text: tileSymbol
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 14
                            color: Theme.accent
                        }
                    }
                }

                onClicked: {
                    listView.currentIndex = index
                    if (root.selectionMode === root.selectionMultiple) {
                        root.toggleSelection(index)
                    } else if (root.selectionMode === root.selectionSingle) {
                        root.selectedIndexes = [index]
                        root.selectionChanged()
                    }
                    root.itemActivated(index, modelData)
                    root.forceActiveFocus()
                }

                onPressAndHold: root._openContext(index, tile, 0, 0)

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: root._openContext(index, tile, 0, 0)
                }

                CheckBox {
                    visible: root.selectionMode === root.selectionMultiple && !root.checkboxLeading
                    checked: root.isSelected(index)
                    focusPolicy: Qt.NoFocus
                    activeFocusOnTab: false
                    onClicked: {
                        root.toggleSelection(index)
                        root.forceActiveFocus()
                    }
                }
            }
        }

        EmptyState {
            anchors.centerIn: parent
            width: Math.min(parent.width - 24, 360)
            visible: root.isEmpty
            title: root.emptyTitle
            message: root.emptyMessage
            actionText: root.emptyActionText
            compact: true
            onActionClicked: root.emptyActionClicked()
        }
    }

    Component {
        id: sectionDelegate
        Rectangle {
            required property string section
            width: ListView.view ? ListView.view.width : 100
            height: Theme.navItemHeight * 0.75
            color: Theme.fillSubtleSecondary
            Text {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                verticalAlignment: Text.AlignVCenter
                text: parent.section
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
                elide: Text.ElideRight
            }
        }
    }
}
