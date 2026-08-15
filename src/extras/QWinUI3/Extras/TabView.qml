import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TabView — Closeable / reorderable tabs.
//
//   TabView {
//       id: tabView
//       model: tabs
//       onCloseRequested: (index) => remove(index)
//   }
//
//   // --- API ---
//   // signals: onTabCloseRequested, onCurrentIndexChangedByUser, onSelectionChanged, onTabMoved, onAddTabButtonClicked
//   // methods: addTab(item), closeTab(index), moveTab(from, to), tabIndexAtContentX(x), tabItemAt(index)
//   // tabView.addTab(item)
//   // tabView.closeTab(index)
//   // tabView.moveTab(from, to)
//   // tabView.tabIndexAtContentX(x)
//
// @notes
//   model items: { title, content, icon? } or a string title.
//   closable tabs emit closeRequested / tabCloseRequested — remove from model yourself.
//   tabsReorderable enables drag reorder (tabMoved).
//   addTab / closeTab / moveTab mutate the model helpers.

T.Control {
    id: control

    // model items: { title, content, icon? } or string title with empty content
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // Shows a close affordance when true
    property bool closable: true
    // Alias of closable
    property alias isClosable: control.closable
    // Allow dragging tabs to reorder
    property bool tabsReorderable: true
    // Alias of tabsReorderable
    property alias canReorderTabs: control.tabsReorderable
    // Tab width mode
    property string tabWidthMode: "sizeToContent"
    // Show add-tab button
    property bool isAddTabButtonVisible: true
    // User asked to close a tab
    signal tabCloseRequested(int index)
    // Selection changed by user
    signal currentIndexChangedByUser(int index)
    // Selection changed
    signal selectionChanged(int index)
    // Tab reordered
    signal tabMoved(int from, int to)
    // Emitted when the add-tab button is clicked
    signal addTabButtonClicked()

    property int _dragFrom: -1
    property int _dropIndex: -1
    readonly property bool _reordering: _dragFrom >= 0
    // Number of tabs
    readonly property int tabCount: model ? model.length : 0
    readonly property real _equalTabWidth: {
        var n = Math.max(1, model.length)
        var addW = isAddTabButtonVisible ? 36 : 0
        var avail = Math.max(120, tabFlick.width - addW - 4)
        return Math.max(72, avail / n)
    }

    implicitWidth: 480
    implicitHeight: 280
    padding: 0
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Tabs")
    Accessible.description: qsTr("Tab %1 of %2").arg(currentIndex + 1).arg(tabCount)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    // Append a tab
    function addTab(item) {
        var next = model.slice()
        next.push(item || { title: qsTr("New tab"), content: "" })
        model = next
        currentIndex = model.length - 1
        addTabButtonClicked()
    }

    // Close tab at index
    function closeTab(index) {
        if (index < 0 || index >= model.length)
            return
        control.tabCloseRequested(index)
        var next = model.slice()
        next.splice(index, 1)
        model = next
        if (currentIndex >= model.length)
            currentIndex = Math.max(0, model.length - 1)
        else if (currentIndex > index)
            currentIndex = currentIndex - 1
    }

    // Move a tab from/to index
    function moveTab(from, to) {
        if (from === to || from < 0 || to < 0)
            return
        if (from >= model.length || to >= model.length)
            return
        var next = model.slice()
        var item = next.splice(from, 1)[0]
        next.splice(to, 0, item)

        var cur = currentIndex
        if (cur === from)
            cur = to
        else if (from < cur && to >= cur)
            cur -= 1
        else if (from > cur && to <= cur)
            cur += 1

        model = next
        currentIndex = cur
        tabMoved(from, to)
    }

    // Tab index under a contentX
    function tabIndexAtContentX(x) {
        var best = model.length - 1
        for (var i = 0; i < tabRow.children.length; ++i) {
            var ch = tabRow.children[i]
            if (!ch || ch.tabIndex === undefined)
                continue
            if (ch.tabIndex === control._dragFrom)
                continue
            var mid = ch.x + ch.width * 0.5
            if (x < mid)
                return ch.tabIndex
            best = ch.tabIndex
        }
        return Math.max(0, best)
    }

    // Tab item at the given index
    function tabItemAt(index) {
        for (var i = 0; i < tabRow.children.length; ++i) {
            var ch = tabRow.children[i]
            if (ch && ch.tabIndex === index)
                return ch
        }
        return null
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        radius: Theme.cornerCard
        elevation: 2
        shadowOpacity: Theme.dark ? 0.18 : 0.08
    }

    contentItem: ColumnLayout {
        spacing: 0

        Rectangle {
            id: tabStrip
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlHeight + 8
            color: Theme.bgAcrylic
            radius: Theme.cornerCard
            clip: true

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: Theme.cornerCard
                color: parent.color
            }

            Flickable {
                id: tabFlick
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                anchors.topMargin: 6
                contentWidth: Math.max(width, tabStripRow.implicitWidth)
                contentHeight: height
                clip: true
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds
                interactive: !control._reordering

                Row {
                    id: tabStripRow
                    height: tabFlick.height
                    spacing: 2

                    Row {
                        id: tabRow
                        height: parent.height
                        spacing: 2

                    Repeater {
                        model: control.model
                        AbstractButton {
                            id: tabBtn
                            required property var modelData
                            required property int index
                            // Tab index in the model
                            property int tabIndex: index
                            // True while a drag is in progress
                            property bool dragActive: control._dragFrom === tabIndex
                            readonly property string _icon: {
                                if (typeof modelData !== "object" || !modelData)
                                    return ""
                                return IconSource.resolve(modelData.symbol || "",
                                                          modelData.icon || modelData.glyph || "")
                            }

                            height: tabRow.height
                            width: {
                                switch (control.tabWidthMode) {
                                case "equal":
                                    return control._equalTabWidth
                                case "compact":
                                    return control.closable ? 72 : 56
                                default: // sizeToContent
                                    return Math.max(96, titleLabel.implicitWidth
                                                    + (_icon.length ? 22 : 0)
                                                    + (control.closable ? 40 : 20))
                                }
                            }
                            hoverEnabled: true
                            checkable: true
                            checked: index === control.currentIndex
                            opacity: dragActive ? 0.35 : 1
                            z: dragActive ? 2 : 0

                            Behavior on opacity {
                                enabled: !Theme.reducedMotion
                                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                            Behavior on width {
                                enabled: !Theme.reducedMotion
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionNormal)
                                    easing.type: Theme.easingStandard
                                }
                            }

                            onClicked: {
                                if (control._reordering)
                                    return
                                control.currentIndex = index
                                control.currentIndexChangedByUser(index)
                            }

                            contentItem: RowLayout {
                                spacing: 4
                                Text {
                                    visible: tabBtn._icon.length > 0
                                    Layout.leftMargin: 8
                                    text: tabBtn._icon
                                    font.family: Theme.fontFamilyIcon
                                    font.pixelSize: 14
                                    color: tabBtn.checked ? Theme.textPrimary : Theme.textSecondary
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    id: titleLabel
                                    Layout.fillWidth: true
                                    Layout.leftMargin: tabBtn._icon.length > 0 ? 0 : 10
                                    visible: control.tabWidthMode !== "compact"
                                             || titleLabel.implicitWidth < tabBtn.width - 36
                                    text: typeof modelData === "string" ? modelData : (modelData.title || "")
                                    elide: Text.ElideRight
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontBody
                                    font.weight: tabBtn.checked ? Theme.fontWeightSemiBold
                                                                : Theme.fontWeightRegular
                                    color: tabBtn.checked ? Theme.textPrimary : Theme.textSecondary
                                    verticalAlignment: Text.AlignVCenter
                                    Behavior on color {
                                        enabled: !Theme.reducedMotion
                                        ColorAnimation {
                                            duration: Theme.duration(Theme.motionFast)
                                        }
                                    }
                                }
                                ToolButton {
                                    id: closeBtn
                                    visible: control.closable
                                    Layout.preferredWidth: 28
                                    Layout.preferredHeight: 28
                                    Layout.rightMargin: 4
                                    text: FluentIcons.ChromeClose
                                    font.family: Theme.fontFamilyIcon
                                    font.pixelSize: 10
                                    Accessible.name: qsTr("Close tab")
                                    scale: down && !Theme.reducedMotion ? 0.9 : 1
                                    Behavior on scale {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                                    }
                                    onClicked: control.closeTab(tabBtn.index)
                                }
                            }

                            background: Item {
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.bottomMargin: tabBtn.checked ? 0 : 2
                                    radius: Theme.cornerControl
                                    color: {
                                        if (tabBtn.checked)
                                            return Theme.bgCard
                                        if (tabBtn.hovered || tabBtn.dragActive)
                                            return Theme.fillSubtle
                                        return "transparent"
                                    }
                                    border.width: tabBtn.checked ? 1 : 0
                                    border.color: Theme.strokeCard
                                    Behavior on color {
                                        enabled: !Theme.reducedMotion
                                        ColorAnimation {
                                            duration: Theme.duration(Theme.motionFast)
                                        }
                                    }
                                }
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    height: 2
                                    radius: 1
                                    color: Theme.accent
                                    opacity: tabBtn.checked ? 1 : 0
                                    scale: tabBtn.checked ? 1 : 0.4
                                    transformOrigin: Item.Bottom
                                    Behavior on opacity {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation {
                                            duration: Theme.duration(Theme.motionNormal)
                                        }
                                    }
                                    Behavior on scale {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation {
                                            duration: Theme.duration(Theme.motionNormal)
                                        }
                                    }
                                }
                            }

                            DragHandler {
                                id: tabDrag
                                enabled: control.tabsReorderable
                                target: null
                                xAxis.enabled: true
                                yAxis.enabled: false
                                acceptedButtons: Qt.LeftButton
                                // Prefer close button when pressing it.
                                grabPermissions: PointerHandler.CanTakeOverFromItems
                                                 | PointerHandler.ApprovesTakeOverByAnything

                                // True after a swipe/slide reveal
                                property bool slid: false

                                onActiveChanged: {
                                    if (active) {
                                        slid = false
                                        control._dragFrom = tabBtn.tabIndex
                                        control._dropIndex = tabBtn.tabIndex
                                        control.currentIndex = tabBtn.tabIndex
                                        ghost.title = titleLabel.text
                                        ghost.width = tabBtn.width
                                        ghost.height = tabBtn.height
                                        var p = tabBtn.mapToItem(tabFlick.contentItem, 0, 0)
                                        ghost.x = p.x
                                        ghost.y = p.y
                                        ghost.visible = true
                                    } else {
                                        var from = control._dragFrom
                                        var to = control._dropIndex
                                        ghost.visible = false
                                        control._dragFrom = -1
                                        control._dropIndex = -1
                                        if (slid && from >= 0 && to >= 0 && from !== to)
                                            control.moveTab(from, to)
                                    }
                                }

                                onTranslationChanged: {
                                    if (!active)
                                        return
                                    if (Math.abs(translation.x) > 6)
                                        slid = true
                                    var origin = tabBtn.mapToItem(tabFlick.contentItem, 0, 0)
                                    ghost.x = origin.x + translation.x
                                    ghost.y = origin.y
                                    var centerX = ghost.x + ghost.width * 0.5
                                    control._dropIndex = control.tabIndexAtContentX(centerX)

                                    // Auto-scroll strip near edges while dragging.
                                    var viewX = centerX - tabFlick.contentX
                                    if (viewX > tabFlick.width - 40)
                                        tabFlick.contentX = Math.min(tabFlick.contentWidth - tabFlick.width,
                                                                     tabFlick.contentX + 12)
                                    else if (viewX < 40)
                                        tabFlick.contentX = Math.max(0, tabFlick.contentX - 12)
                                }
                            }
                        }
                    }
                    } // tabRow

                    // WinUI AddTabButton
                    ToolButton {
                        id: addTabBtn
                        visible: control.isAddTabButtonVisible
                        width: 32
                        height: Math.min(32, parent.height - 4)
                        anchors.verticalCenter: parent.verticalCenter
                        text: FluentIcons.Add
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 12
                        Accessible.name: qsTr("Add tab")
                        scale: down && !Theme.reducedMotion ? 0.92 : 1
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                        onClicked: control.addTab()
                    }
                } // tabStripRow

                // Floating drag preview
                ElevatedChrome {
                    id: ghost
                    // Title text
                    property string title: ""
                    visible: false
                    z: 100
                    radius: Theme.cornerControl
                    color: Theme.bgCard
                    borderWidth: 1
                    borderColor: Theme.strokeCard
                    opacity: 0.95
                    elevation: 4
                    shadowOpacity: 0.22

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        text: ghost.title
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        height: 2
                        radius: 1
                        color: Theme.accent
                    }
                }

                // Drop insertion caret
                Rectangle {
                    id: dropCaret
                    visible: control._reordering && control._dropIndex >= 0
                             && control._dropIndex !== control._dragFrom
                    width: 2
                    height: Math.max(16, tabRow.height - 8)
                    radius: 1
                    color: Theme.accent
                    z: 50
                    y: 4
                    x: {
                        if (!visible)
                            return 0
                        var target = control._dropIndex
                        var from = control._dragFrom
                        var item = control.tabItemAt(target)
                        if (!item)
                            return 0
                        if (from < target)
                            return item.x + item.width - 1
                        return item.x
                    }
                }
            }
        }

        StackLayout {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: control.currentIndex

            Repeater {
                model: control.model
                Item {
                    required property var modelData
                    required property int index
                    Label {
                        anchors.centerIn: parent
                        text: typeof modelData === "string"
                              ? modelData
                              : (modelData.content || modelData.title || "")
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        wrapMode: Text.Wrap
                        width: parent.width - 48
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
