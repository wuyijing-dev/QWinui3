import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ListDetailsView — Master–detail recipe on TwoPaneView.
//
//   ListDetailsView {
//       model: […]
//       titleRole: "title"
//       details: Label { text: listDetails.selectedItem.title }
//   }
//
//   // --- API ---
//   // selectedIndex / selectedItem, select(index), showList(), showDetails()
//   // listHeader / detailToolbar / details slots; multiSelectEnabled + selectedItems (2.64)
//   // connectedAnimationEnabled (+ key) — list→detail and reverse on showList() (2.68 B3)
//
// @notes
//   ListView master + details host. Collapses via TwoPaneView on narrow widths.
//   model items may be strings or objects (titleRole / subtitleRole).
//   Optional filterText filters plain JS arrays (debounced, 1.88).
//   Selection tracks item **object** across filter rebuilds (2.18).
//   multiSelectEnabled adds checkboxes + detailToolbar for bulk actions (2.64).
//   Keyboard: arrows / Home / End / Enter on the list; Esc (or Back) returns to the
//   list in SinglePane mode. Live-region announces selection / pane changes (2.07).

T.Control {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    property var model: []
    property string titleRole: "title"
    property string subtitleRole: "subtitle"
    property string filterText: ""
    property var filterRoles: []
    property int filterDebounceMs: 120
    // Cap filtered master rows (0 = unlimited) — 2.18.
    property int maxFilterResults: 0
    property int selectedIndex: -1
    property real listPaneWidth: 280
    property real minWideWidth: 720
    property alias details: detailsSlot.data
    property alias listHeader: listHeaderSlot.data
    property alias detailToolbar: detailToolbarSlot.data
    // Master multi-select + bulk toolbar slot (2.64).
    property bool multiSelectEnabled: false
    // Morph list row → details pane via ConnectedAnimationService
    property bool connectedAnimationEnabled: false
    property string connectedAnimationKey: "listDetails.hero"
    // Screen-reader name override (1.19)
    property string accessibleName: qsTr("List details")
    property string listAccessibleName: qsTr("Items")
    // Qt 6.8+ Accessible.announce for selection / pane changes (2.07).
    property bool announceChanges: true
    // Master list enter motion: none | fade | slide — 2.67 B2
    property string itemEnter: "fade"
    // Master list exit motion: none | fade | slide
    property string itemExit: "fade"

    readonly property var selectedItem: {
        var m = _listModel
        if (!m || selectedIndex < 0 || selectedIndex >= m.length)
            return null
        return m[selectedIndex]
    }
    readonly property bool singlePaneDetailsOpen: panes.mode === TwoPaneView.SinglePane
                                                  && panes.singlePaneIndex === 1
    readonly property var _listModel: _filterActive ? _filteredModel : model
    readonly property bool _filterActive: Array.isArray(model)
                                          && (filterText || "").trim().length > 0

    property var _filteredModel: []
    property string _lastFilterKey: ""
    property var _lastModelRef: null
    // Object identity of selected item (survives filter when still visible) — 2.18.
    property var _selectedItemRef: null

    readonly property int filteredCount: _listModel ? _listModel.length : 0
    readonly property var selectedItems: {
        var m = _listModel
        if (!m || !_multiRefs.length)
            return []
        var out = []
        for (var i = 0; i < _multiRefs.length; ++i) {
            for (var j = 0; j < m.length; ++j) {
                if (m[j] === _multiRefs[i]) {
                    out.push(m[j])
                    break
                }
            }
        }
        return out
    }
    readonly property int selectionCount: selectedItems.length

    property var _multiRefs: []
    property int _multiAnchorIndex: -1

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

    function _filterRolesList() {
        var roles = filterRoles
        if (roles && roles.length)
            return roles
        var out = []
        if (titleRole)
            out.push(titleRole)
        if (subtitleRole)
            out.push(subtitleRole)
        return out
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
        var roles = _filterRolesList()
        var out = []
        for (var i = 0; i < m.length; ++i) {
            var item = m[i]
            var hit = false
            if (typeof item === "string") {
                hit = item.toLowerCase().indexOf(q) >= 0
            } else {
                for (var r = 0; r < roles.length; ++r) {
                    var v = item && item[roles[r]]
                    if (v !== undefined && v !== null
                            && String(v).toLowerCase().indexOf(q) >= 0) {
                        hit = true
                        break
                    }
                }
            }
            if (hit)
                out.push(item)
            if (root.maxFilterResults > 0 && out.length >= root.maxFilterResults)
                break
        }
        _filteredModel = out

        var prev = root._selectedItemRef
        if (prev !== null && prev !== undefined) {
            var found = -1
            for (var k = 0; k < out.length; ++k) {
                if (out[k] === prev) {
                    found = k
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
                _selectedItemRef = null
                selectionChanged(-1, null)
            }
        } else if (selectedIndex >= out.length) {
            select(out.length ? out.length - 1 : -1)
        }
        _pruneMultiRefs(out)
    }

    function _pruneMultiRefs(visibleModel) {
        if (!_multiRefs.length)
            return
        var m = visibleModel || _listModel
        if (!m) {
            _multiRefs = []
            multiSelectionChanged(selectedItems)
            return
        }
        var kept = []
        for (var i = 0; i < _multiRefs.length; ++i) {
            for (var j = 0; j < m.length; ++j) {
                if (m[j] === _multiRefs[i]) {
                    kept.push(_multiRefs[i])
                    break
                }
            }
        }
        if (kept.length !== _multiRefs.length) {
            _multiRefs = kept
            multiSelectionChanged(selectedItems)
        }
    }

    function isMultiSelected(item) {
        for (var i = 0; i < _multiRefs.length; ++i) {
            if (_multiRefs[i] === item)
                return true
        }
        return false
    }

    function toggleMultiSelect(index) {
        var m = _listModel
        if (!m || index < 0 || index >= m.length)
            return
        var item = m[index]
        var refs = _multiRefs.slice()
        var found = -1
        for (var i = 0; i < refs.length; ++i) {
            if (refs[i] === item) {
                found = i
                break
            }
        }
        if (found >= 0)
            refs.splice(found, 1)
        else
            refs.push(item)
        _multiRefs = refs
        _multiAnchorIndex = index
        multiSelectionChanged(selectedItems)
        if (announceChanges)
            _announce(qsTr("%1 items selected").arg(refs.length))
    }

    function selectAllMulti() {
        var m = _listModel
        if (!m || !m.length)
            return
        _multiRefs = m.slice()
        multiSelectionChanged(selectedItems)
        if (announceChanges)
            _announce(qsTr("All %1 items selected").arg(m.length))
    }

    function clearMultiSelection() {
        if (!_multiRefs.length)
            return
        _multiRefs = []
        _multiAnchorIndex = -1
        multiSelectionChanged(selectedItems)
        if (announceChanges)
            _announce(qsTr("Multi-selection cleared"))
    }

    function _multiSelectRange(toIndex) {
        var m = _listModel
        if (!m || toIndex < 0 || toIndex >= m.length)
            return
        var from = _multiAnchorIndex >= 0 ? _multiAnchorIndex : selectedIndex
        if (from < 0)
            from = toIndex
        var lo = Math.min(from, toIndex)
        var hi = Math.max(from, toIndex)
        var refs = _multiRefs.slice()
        for (var i = lo; i <= hi; ++i) {
            var item = m[i]
            var exists = false
            for (var j = 0; j < refs.length; ++j) {
                if (refs[j] === item) {
                    exists = true
                    break
                }
            }
            if (!exists)
                refs.push(item)
        }
        _multiRefs = refs
        _multiAnchorIndex = toIndex
        multiSelectionChanged(selectedItems)
    }

    signal selectionChanged(int index, var item)
    signal multiSelectionChanged(var items)

    implicitWidth: 720
    implicitHeight: 400
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Pane
    Accessible.name: accessibleName.length ? accessibleName : qsTr("List details")
    Accessible.description: singlePaneDetailsOpen
                            ? qsTr("Details open")
                            : (selectedIndex >= 0 ? qsTr("Item %1 selected").arg(selectedIndex + 1) : "")

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    function select(index) {
        var m = _listModel
        if (!m || index < 0 || index >= m.length) {
            selectedIndex = -1
            _selectedItemRef = null
            selectionChanged(-1, null)
            _announce(qsTr("Selection cleared"))
            return
        }
        var fromItem = null
        if (connectedAnimationEnabled && list.itemAtIndex)
            fromItem = list.itemAtIndex(index)

        function _commit() {
            selectedIndex = index
            _selectedItemRef = m[index]
            selectionChanged(index, selectedItem)
            var title = _titleOf(selectedItem)
            if (title.length) {
                if (panes.mode === TwoPaneView.SinglePane)
                    _announce(qsTr("Details for %1").arg(title))
                else
                    _announce(qsTr("Selected %1").arg(title))
            }
            if (panes.mode === TwoPaneView.SinglePane)
                panes.showPane2()
        }

        if (connectedAnimationEnabled && fromItem && detailsSlot.width > 0) {
            ConnectedAnimationService.register(connectedAnimationKey, fromItem)
            ConnectedAnimationService.register(connectedAnimationKey, detailsSlot)
            ConnectedAnimationService.playBetween(fromItem, detailsSlot, _commit)
        } else {
            _commit()
        }
    }

    function showList() {
        function _commit() {
            panes.showPane1()
            forceActiveFocus()
            _announce(qsTr("Returned to list"))
        }
        var detailsVisible = detailsSlot && detailsSlot.width > 0
                             && (panes.mode !== TwoPaneView.SinglePane || root.singlePaneDetailsOpen)
        if (connectedAnimationEnabled && detailsVisible) {
            var toItem = null
            if (selectedIndex >= 0 && list.itemAtIndex)
                toItem = list.itemAtIndex(selectedIndex)
            if (!toItem)
                toItem = list
            ConnectedAnimationService.register(connectedAnimationKey, detailsSlot)
            ConnectedAnimationService.register(connectedAnimationKey, toItem)
            ConnectedAnimationService.playBetween(detailsSlot, toItem, _commit)
        } else {
            _commit()
        }
    }

    function showDetails() {
        if (selectedIndex >= 0)
            panes.showPane2()
    }

    function _titleOf(item) {
        if (item === undefined || item === null)
            return ""
        if (typeof item === "string")
            return item
        if (item[titleRole] !== undefined)
            return item[titleRole]
        return String(item)
    }

    function _subtitleOf(item) {
        if (!item || typeof item === "string")
            return ""
        if (item[subtitleRole] !== undefined)
            return item[subtitleRole]
        return ""
    }

    function _moveSelection(delta) {
        var m = _listModel
        if (!m || m.length === 0)
            return
        var next = selectedIndex < 0 ? 0 : selectedIndex + delta
        next = Math.max(0, Math.min(m.length - 1, next))
        select(next)
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape && singlePaneDetailsOpen) {
            showList()
            event.accepted = true
            return
        }
        if (singlePaneDetailsOpen)
            return
        if (event.key === Qt.Key_Down) {
            _moveSelection(1)
            event.accepted = true
        } else if (event.key === Qt.Key_Up) {
            _moveSelection(-1)
            event.accepted = true
        } else if (event.key === Qt.Key_Home) {
            if (_listModel && _listModel.length)
                select(0)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            if (_listModel && _listModel.length)
                select(_listModel.length - 1)
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (selectedIndex >= 0 && panes.mode === TwoPaneView.SinglePane)
                panes.showPane2()
            event.accepted = true
        } else if (multiSelectEnabled && event.modifiers & Qt.ControlModifier
                   && event.key === Qt.Key_A) {
            selectAllMulti()
            event.accepted = true
        } else if (multiSelectEnabled && event.key === Qt.Key_Space
                   && selectedIndex >= 0) {
            toggleMultiSelect(selectedIndex)
            event.accepted = true
        }
    }

    contentItem: TwoPaneView {
        id: panes
        anchors.fill: parent
        minWideWidth: root.minWideWidth
        panePriorityWidth: root.listPaneWidth
        preferredMode: TwoPaneView.Wide

        pane1: Rectangle {
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            radius: Theme.cornerCard
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 0

                Item {
                    id: listHeaderSlot
                    Layout.fillWidth: true
                    Layout.preferredHeight: children.length ? childrenRect.height : 0
                    visible: children.length > 0
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    reuseItems: true
                    model: root._listModel
                    currentIndex: root.selectedIndex
                    Accessible.role: Accessible.List
                    Accessible.name: root.listAccessibleName.length ? root.listAccessibleName : qsTr("Items")

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
                            from: root.itemEnter === "slide" ? 20 : 0
                            to: 0
                            duration: Theme.motion.ms("normal")
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
                        enabled: !Theme.reducedMotion && root.itemEnter !== "none"
                        NumberAnimation {
                            properties: "x,y"
                            duration: Theme.motion.ms("fast")
                            easing.type: Theme.motion.easing("standard")
                        }
                    }

                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        readonly property string itemTitle: root._titleOf(modelData)
                        readonly property string itemSubtitle: root._subtitleOf(modelData)
                        readonly property bool multiChecked: root.isMultiSelected(modelData)
                        width: ListView.view.width
                        focusPolicy: Qt.NoFocus
                        highlighted: index === root.selectedIndex
                                     || (root.multiSelectEnabled && multiChecked)
                        Accessible.role: Accessible.ListItem
                        Accessible.name: {
                            var t = itemTitle.length ? itemTitle : qsTr("Item %1").arg(index + 1)
                            if (root.multiSelectEnabled && multiChecked)
                                t += qsTr(", selected")
                            return t
                        }
                        Accessible.description: itemSubtitle
                        Accessible.selectable: true
                        Accessible.selected: index === root.selectedIndex
                                             || (root.multiSelectEnabled && multiChecked)
                        Accessible.onPressAction: root.select(index)
                        onClicked: {
                            root.forceActiveFocus()
                            var mods = Qt.keyboardModifiers
                            if (root.multiSelectEnabled && (mods & Qt.ShiftModifier)) {
                                root._multiSelectRange(index)
                                root.select(index)
                                return
                            }
                            if (root.multiSelectEnabled && (mods & Qt.ControlModifier)) {
                                root.toggleMultiSelect(index)
                                root.select(index)
                                return
                            }
                            root.select(index)
                        }

                        contentItem: RowLayout {
                            spacing: Theme.spacingTight
                            CheckBox {
                                visible: root.multiSelectEnabled
                                checkable: false
                                checked: multiChecked
                                Accessible.name: qsTr("Select %1").arg(itemTitle)
                                onClicked: root.toggleMultiSelect(index)
                            }
                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true
                                Label {
                                    text: itemTitle
                                    font.weight: Theme.fontWeightSemiBold
                                    color: Theme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Label {
                                    visible: itemSubtitle.length > 0
                                    text: itemSubtitle
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontCaption
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    EmptyState {
                        anchors.centerIn: parent
                        visible: !root._listModel || root._listModel.length === 0
                        title: qsTr("No items")
                        description: root.filterText.length
                                     ? qsTr("No items match this filter.")
                                     : qsTr("Provide a model to populate the list.")
                    }
                }
            }
        }

        pane2: Rectangle {
            color: Theme.bgLayer
            border.width: 1
            border.color: Theme.strokeCard
            radius: Theme.cornerCard
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                spacing: Theme.spacing

                Button {
                    flat: true
                    text: qsTr("Back")
                    visible: root.singlePaneDetailsOpen
                    Layout.alignment: Qt.AlignLeft
                    Accessible.name: qsTr("Back to list")
                    onClicked: root.showList()
                }

                Item {
                    id: detailToolbarSlot
                    Layout.fillWidth: true
                    Layout.preferredHeight: children.length ? childrenRect.height : 0
                    visible: children.length > 0
                }

                Item {
                    id: detailsSlot
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            EmptyState {
                anchors.centerIn: parent
                visible: root.selectedIndex < 0
                title: qsTr("Select an item")
                description: qsTr("Details appear here.")
                symbol: FluentIcons.View
            }
        }
    }
}
