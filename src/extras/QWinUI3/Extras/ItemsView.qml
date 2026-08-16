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
//       selectionMode: ItemsView.selectionMultiple
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
//   Fluent list recipe over QQC ListView (not a separate virtualization engine).
//   selectionMode: selectionNone | selectionSingle | selectionMultiple.
//   Right-click / long-press opens contextMenu.
//   Empty list shows EmptyState via emptyTitle / emptyMessage / emptyActionText.
//   Large models: use a QAbstractListModel; this shell does not add extra pooling.

T.Control {
    id: root

    readonly property int selectionNone: 0
    readonly property int selectionSingle: 1
    readonly property int selectionMultiple: 2

    // List model (array or ListModel / QAbstractListModel)
    property var model: []
    // selectionNone | selectionSingle | selectionMultiple
    property int selectionMode: selectionSingle
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
    // Emitted when an item is activated (click / Enter)
    signal itemActivated(int index, var itemData)
    // Emitted when selection changes
    signal selectionChanged()
    // Empty action clicked
    signal emptyActionClicked()

    // Resolved item count
    readonly property int count: listView.count
    readonly property bool isEmpty: count <= 0

    implicitWidth: 320
    implicitHeight: 280
    padding: 0
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.List
    Accessible.name: qsTr("Items")

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

    contentItem: Item {
        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            model: root.model
            currentIndex: -1
            visible: !root.isEmpty
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}

            section.property: root.sectionRole
            section.criteria: ViewSection.FullString
            section.delegate: root.sectionRole.length ? sectionDelegate : null

            delegate: ListTile {
                id: tile
                required property int index
                required property var modelData
                width: listView.width
                title: String(root._roleValue(modelData, root.titleRole, index))
                subtitle: String(root._roleValue(modelData, root.subtitleRole, index))
                // When checkbox occupies leading, draw the symbol inside leading too.
                symbol: (root.selectionMode === root.selectionMultiple && root.checkboxLeading)
                        ? ""
                        : root._roleValue(modelData, root.symbolRole, index)
                isSelected: root.isSelected(index)
                highlighted: ListView.isCurrentItem

                leading: RowLayout {
                    spacing: 8
                    visible: (root.selectionMode === root.selectionMultiple && root.checkboxLeading)
                             || String(root._roleValue(modelData, root.symbolRole, index)).length > 0

                    CheckBox {
                        visible: root.selectionMode === root.selectionMultiple && root.checkboxLeading
                        checked: root.isSelected(index)
                        onClicked: root.toggleSelection(index)
                    }

                    Rectangle {
                        visible: root.selectionMode === root.selectionMultiple && root.checkboxLeading
                                 && String(root._roleValue(modelData, root.symbolRole, index)).length > 0
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: Theme.cornerControl
                        color: Theme.fillSubtle
                        Text {
                            anchors.centerIn: parent
                            text: String(root._roleValue(modelData, root.symbolRole, index))
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
                    onClicked: root.toggleSelection(index)
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
