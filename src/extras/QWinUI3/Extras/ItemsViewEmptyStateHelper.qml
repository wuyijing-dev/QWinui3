import QtQuick

// ItemsViewEmptyStateHelper — unify emptyTitle/emptyMessage for filtered lists.
//
// @notes
//   ItemsView already has EmptyState integration via emptyTitle/emptyMessage,
//   but apps often want different copy:
//     - no items at all
//     - no matches while filter is active

QtObject {
    id: root

    // Attach to a specific ItemsView instance.
    property var itemsView: null

    // Default copy (only used when you have not overridden those on ItemsView).
    property string filteredEmptyTitle: qsTr("No matches")
    property string filteredEmptyMessage: qsTr("Clear the filter to see everything.")

    // Backup of the original values from the target ItemsView.
    property string _origEmptyTitle: ""
    property string _origEmptyMessage: ""

    function attach(view) {
        itemsView = view
        if (!itemsView)
            return
        _origEmptyTitle = itemsView.emptyTitle
        _origEmptyMessage = itemsView.emptyMessage
        _sync()
    }

    function _sync() {
        if (!itemsView)
            return
        var isFilteredEmpty = itemsView.isEmpty && (itemsView.filterText || "").trim().length > 0
        itemsView.emptyTitle = isFilteredEmpty ? filteredEmptyTitle : _origEmptyTitle
        itemsView.emptyMessage = isFilteredEmpty ? filteredEmptyMessage : _origEmptyMessage
    }

    Connections {
        target: root.itemsView
        ignoreUnknownSignals: true
        function onFilterTextChanged() { root._sync() }
        function onModelChanged() { root._sync() }
        function onSelectedIndexesChanged() { root._sync() }
        function onEmptyTitleChanged() { root._sync() }
        function onEmptyMessageChanged() { root._sync() }
    }

    Component.onCompleted: {
        if (itemsView)
            attach(itemsView)
    }
}

