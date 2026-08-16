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
//   // selectedIndex / selectedItem, select(index), listPane / details pane slots
//
// @notes
//   ListView master + details host. Collapses via TwoPaneView on narrow widths.
//   model items may be strings or objects (titleRole / subtitleRole).

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

    readonly property var selectedItem: {
        if (!model || selectedIndex < 0 || selectedIndex >= model.length)
            return null
        return model[selectedIndex]
    }

    signal selectionChanged(int index, var item)

    implicitWidth: 720
    implicitHeight: 400
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("List details")

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
                    model: root.model
                    currentIndex: root.selectedIndex
                    delegate: ItemDelegate {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        highlighted: index === root.selectedIndex
                        onClicked: root.select(index)

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

            Item {
                id: detailsSlot
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
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
