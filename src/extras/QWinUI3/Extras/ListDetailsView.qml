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
//   // listHeader / details slots; connectedAnimationEnabled (+ key)
//
// @notes
//   ListView master + details host. Collapses via TwoPaneView on narrow widths.
//   model items may be strings or objects (titleRole / subtitleRole).
//   Optional filterText filters plain JS arrays (debounced, 1.88).
//   Keyboard: arrows / Home / End / Enter on the list; Esc (or Back) returns to the
//   list in SinglePane mode. Pair with ItemsView for multi-select masters — see
//   docs/data-collections.md.

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
    property int selectedIndex: -1
    property real listPaneWidth: 280
    property real minWideWidth: 720
    property alias details: detailsSlot.data
    property alias listHeader: listHeaderSlot.data
    // Morph list row → details pane via ConnectedAnimationService
    property bool connectedAnimationEnabled: false
    property string connectedAnimationKey: "listDetails.hero"
    // Screen-reader name override (1.19)
    property string accessibleName: qsTr("List details")
    property string listAccessibleName: qsTr("Items")

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
        }
        _filteredModel = out
        if (selectedIndex >= out.length)
            select(out.length ? out.length - 1 : -1)
    }

    signal selectionChanged(int index, var item)

    implicitWidth: 720
    implicitHeight: 400
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Pane
    Accessible.name: accessibleName.length ? accessibleName : qsTr("List details")
    Accessible.description: singlePaneDetailsOpen
                            ? qsTr("Details open")
                            : (selectedIndex >= 0 ? qsTr("Item %1 selected").arg(selectedIndex + 1) : "")

    function select(index) {
        var m = _listModel
        if (!m || index < 0 || index >= m.length) {
            selectedIndex = -1
            selectionChanged(-1, null)
            return
        }
        var fromItem = null
        if (connectedAnimationEnabled && list.itemAtIndex)
            fromItem = list.itemAtIndex(index)

        function _commit() {
            selectedIndex = index
            selectionChanged(index, selectedItem)
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
        panes.showPane1()
        forceActiveFocus()
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
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        readonly property string itemTitle: root._titleOf(modelData)
                        readonly property string itemSubtitle: root._subtitleOf(modelData)
                        width: ListView.view.width
                        focusPolicy: Qt.NoFocus
                        highlighted: index === root.selectedIndex
                        Accessible.role: Accessible.ListItem
                        Accessible.name: {
                            return itemTitle.length ? itemTitle : qsTr("Item %1").arg(index + 1)
                        }
                        Accessible.description: itemSubtitle
                        Accessible.selectable: true
                        Accessible.selected: index === root.selectedIndex
                        Accessible.onPressAction: root.select(index)
                        onClicked: {
                            root.forceActiveFocus()
                            root.select(index)
                        }

                        contentItem: ColumnLayout {
                            spacing: 2
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
