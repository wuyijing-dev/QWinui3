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
        if (!model || selectedIndex < 0 || selectedIndex >= model.length)
            return null
        return model[selectedIndex]
    }
    readonly property bool singlePaneDetailsOpen: panes.mode === TwoPaneView.SinglePane
                                                  && panes.singlePaneIndex === 1

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
        if (!model || index < 0 || index >= model.length) {
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
        if (!model || model.length === 0)
            return
        var next = selectedIndex < 0 ? 0 : selectedIndex + delta
        next = Math.max(0, Math.min(model.length - 1, next))
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
            if (model && model.length)
                select(0)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            if (model && model.length)
                select(model.length - 1)
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
                    model: root.model
                    currentIndex: root.selectedIndex
                    Accessible.role: Accessible.List
                    Accessible.name: root.listAccessibleName.length ? root.listAccessibleName : qsTr("Items")
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        focusPolicy: Qt.NoFocus
                        highlighted: index === root.selectedIndex
                        Accessible.role: Accessible.ListItem
                        Accessible.name: {
                            var t = root._titleOf(modelData)
                            return t.length ? t : qsTr("Item %1").arg(index + 1)
                        }
                        Accessible.description: root._subtitleOf(modelData)
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
                                text: root._titleOf(modelData)
                                font.weight: Theme.fontWeightSemiBold
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Label {
                                visible: root._subtitleOf(modelData).length > 0
                                text: root._subtitleOf(modelData)
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontCaption
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                    }

                    EmptyState {
                        anchors.centerIn: parent
                        visible: !root.model || root.model.length === 0
                        title: qsTr("No items")
                        description: qsTr("Provide a model to populate the list.")
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
