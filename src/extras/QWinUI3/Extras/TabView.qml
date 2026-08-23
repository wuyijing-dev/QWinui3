import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Window
import QWinUI3.Theme

// TabView — Closeable / reorderable / tear-out tabs.
//
//   TabView {
//       id: tabView
//       model: tabs
//       canTearOutTabs: true
//       onTabTearOutRequested: (index, item, gx, gy) => { … }
//   }
//
//   // --- API ---
//   // signals: onTabCloseRequested, onCurrentIndexChangedByUser, onSelectionChanged,
//   //          onTabMoved, onAddTabButtonClicked, onTabTearOutRequested
//   // methods: addTab(item), closeTab(index), moveTab(from, to), takeTab(index),
//   //          tearOutTab(index, globalX, globalY), tabIndexAtContentX(x), tabItemAt(index)
//   // tabView.addTab(item)
//   // tabView.closeTab(index)
//   // tabView.moveTab(from, to)
//   // tabView.tearOutTab(index, gx, gy)
//
// @notes
//   model items: { title, content, icon? } or a string title.
//   closable tabs emit closeRequested / tabCloseRequested — remove from model yourself.
//   closeButtonOverlayMode: always | onPointerOver | auto (WinUI CloseButtonOverlayMode).
//   tabStripHeader / tabStripFooter for strip chrome; tabsReorderable enables drag reorder.
//   canTearOutTabs: drag a tab vertically past tearOutThreshold to open a new window
//   (or handle tabTearOutRequested yourself). createTearOutWindow builds a BlankWindow
//   hosting another TabView with the torn tab. Drop onto another TabView in this
//   process to dock it back (TabViewDropHub). closeWhenEmpty destroys empty
//   tear-out hosts (close() alone would leave them running in the background).

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
    // WinUI CloseButtonOverlayMode: "always" | "onPointerOver" | "auto"
    property string closeButtonOverlayMode: "always"
    // Allow dragging tabs to reorder
    property bool tabsReorderable: true
    // Alias of tabsReorderable
    property alias canReorderTabs: control.tabsReorderable
    // WinUI CanDragTabs — enable drag gesture (reorder still gated by tabsReorderable)
    property bool canDragTabs: true
    // Drag a tab out of the strip to tear it into a new window
    property bool canTearOutTabs: true
    // Allow tearing out when only one tab remains
    property bool allowTearOutLastTab: true
    // Vertical drag distance (px) before a tear-out is armed
    property real tearOutThreshold: 48
    // When true, TabView opens a BlankWindow for torn tabs (still emits the signal)
    property bool createTearOutWindow: true
    // Close and destroy the host window when the last tab is taken (tear-out windows)
    property bool closeWhenEmpty: false
    // Tab width mode
    property string tabWidthMode: "sizeToContent"
    // Show add-tab button
    property bool isAddTabButtonVisible: true
    // WinUI TabStripHeader
    property alias tabStripHeader: tabStripHeaderSlot.data
    // WinUI TabStripFooter
    property alias tabStripFooter: tabStripFooterSlot.data
    // Currently selected model item (WinUI SelectedItem)
    readonly property var selectedItem: {
        if (!model || currentIndex < 0 || currentIndex >= model.length)
            return null
        return model[currentIndex]
    }
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
    // Tab torn out — item already removed from model when tearOutTab runs
    signal tabTearOutRequested(int index, var item, real globalX, real globalY)

    property int _dragFrom: -1
    property int _dropIndex: -1
    property bool _tearOutArmed: false
    readonly property bool _reordering: _dragFrom >= 0
    // Number of tabs
    readonly property int tabCount: model ? model.length : 0
    readonly property real _equalTabWidth: {
        var n = Math.max(1, model.length)
        // Add button is outside the Flickable — use the full flick viewport.
        var avail = Math.max(120, tabFlick.width - 4)
        return Math.max(72, avail / n)
    }

    implicitWidth: 480
    implicitHeight: 280
    padding: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Tabs")
    Accessible.description: qsTr("Tab %1 of %2").arg(currentIndex + 1).arg(tabCount)

    // Dynamically created TabViewTearOutWindow hosts (createObject). close() only
    // hides ApplicationWindow — they must be destroy()'d or they keep running.
    property var _tearOutWindows: []
    // Tear-out host to dismiss when closeWhenEmpty; never fall back to Gallery.
    property var _hostWindow: null

    Component.onCompleted: TabViewDropHub.register(control)
    Component.onDestruction: {
        TabViewDropHub.unregister(control)
        control._destroyTearOutWindows()
    }

    onCurrentIndexChanged: {
        selectionChanged(currentIndex)
        Qt.callLater(control._ensureCurrentTabVisible)
    }

    Keys.onLeftPressed: function (event) {
        if (tabCount <= 0)
            return
        currentIndex = Math.max(0, currentIndex - 1)
        currentIndexChangedByUser(currentIndex)
        event.accepted = true
    }
    Keys.onRightPressed: function (event) {
        if (tabCount <= 0)
            return
        currentIndex = Math.min(tabCount - 1, currentIndex + 1)
        currentIndexChangedByUser(currentIndex)
        event.accepted = true
    }
    Keys.onPressed: function (event) {
        if (tabCount <= 0 && event.key !== Qt.Key_T)
            return
        if (event.key === Qt.Key_Home) {
            currentIndex = 0
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            currentIndex = Math.max(0, tabCount - 1)
            currentIndexChangedByUser(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_W
                   && (event.modifiers & Qt.ControlModifier)
                   && closable && currentIndex >= 0) {
            closeTab(currentIndex)
            event.accepted = true
        } else if (event.key === Qt.Key_T
                   && (event.modifiers & Qt.ControlModifier)
                   && isAddTabButtonVisible) {
            addTab()
            event.accepted = true
        } else if ((event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace)
                   && closable && currentIndex >= 0) {
            closeTab(currentIndex)
            event.accepted = true
        }
    }

    function _ensureCurrentTabVisible() {
        var item = tabItemAt(currentIndex)
        if (!item || tabFlick.width <= 0)
            return
        var left = item.x
        var right = item.x + item.width
        if (left < tabFlick.contentX)
            tabFlick.contentX = Math.max(0, left - 8)
        else if (right > tabFlick.contentX + tabFlick.width)
            tabFlick.contentX = Math.max(0, right - tabFlick.width + 8)
    }

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
        control._closeIfEmpty()
    }

    // Remove tab and return its model item (no close signal)
    function takeTab(index) {
        if (index < 0 || !model || index >= model.length)
            return null
        if (!allowTearOutLastTab && model.length <= 1)
            return null
        var next = model.slice()
        var item = next.splice(index, 1)[0]
        model = next
        if (currentIndex >= model.length)
            currentIndex = Math.max(0, model.length - 1)
        else if (currentIndex > index)
            currentIndex = currentIndex - 1
        return item
    }

    // Tear tab into a new window (optional) and emit tabTearOutRequested
    function tearOutTab(index, globalX, globalY) {
        if (!canTearOutTabs)
            return null
        var gx = Number(globalX)
        var gy = Number(globalY)
        if (isNaN(gx))
            gx = 120
        if (isNaN(gy))
            gy = 120
        var dock = TabViewDropHub.hit(gx, gy, control)
        var item = takeTab(index)
        if (item === null || item === undefined)
            return null
        tabTearOutRequested(index, item, gx, gy)
        if (dock && typeof dock.insertTab === "function") {
            dock.insertTab(item, dock.dropIndexAt(gx, gy))
            control._closeIfEmpty()
            return item
        }
        if (createTearOutWindow)
            _openTearOutWindow(item, gx, gy)
        control._closeIfEmpty()
        return item
    }

    function _closeIfEmpty() {
        if (!closeWhenEmpty || tabCount > 0)
            return
        var w = control._hostWindow
        if (!w)
            return
        Qt.callLater(function () {
            if (control.tabCount > 0)
                return
            if (typeof w.dismiss === "function")
                w.dismiss()
            else
                control._destroyWindow(w)
        })
    }

    function _trackTearOut(win) {
        if (!win)
            return
        var next = control._tearOutWindows.slice()
        if (next.indexOf(win) < 0)
            next.push(win)
        control._tearOutWindows = next
        win.closing.connect(function () {
            try {
                if (control)
                    control._untrackTearOut(win)
            } catch (err) {
            }
            Qt.callLater(function () {
                try {
                    if (!win || win._qmlGone)
                        return
                    win._qmlGone = true
                    win.destroy()
                } catch (err2) {
                }
            })
        })
    }

    function _untrackTearOut(win) {
        var next = []
        var list = control._tearOutWindows
        for (var i = 0; i < list.length; ++i) {
            if (list[i] && list[i] !== win)
                next.push(list[i])
        }
        control._tearOutWindows = next
    }

    function _destroyWindow(win) {
        if (!win)
            return
        try {
            if (win._qmlGone)
                return
            win._qmlGone = true
            win.destroy()
        } catch (err) {
        }
    }

    function _destroyTearOutWindows() {
        var list = control._tearOutWindows.slice()
        control._tearOutWindows = []
        for (var i = 0; i < list.length; ++i)
            control._destroyWindow(list[i])
    }

    function insertTab(item, index) {
        if (item === undefined || item === null)
            return
        var next = (model && model.slice) ? model.slice() : []
        var i = (index === undefined || index < 0) ? next.length : Math.min(index, next.length)
        next.splice(i, 0, item)
        model = next
        currentIndex = i
    }

    function dropIndexAt(gx, gy) {
        var p = tabFlick.contentItem.mapFromGlobal(gx, gy)
        return tabIndexAtContentX(p.x)
    }

    function containsGlobal(gx, gy) {
        if (!visible)
            return false
        var p = control.mapFromGlobal(gx, gy)
        return p.x >= -16 && p.y >= -16
                && p.x <= control.width + 16
                && p.y <= control.height + 16
    }

    function _openTearOutWindow(item, globalX, globalY) {
        // Load by URL so TabView does not form a compile-time type cycle with
        // TabViewTearOutWindow (which embeds TabView).
        var comp = Qt.createComponent(Qt.resolvedUrl("TabViewTearOutWindow.qml"))
        if (comp.status === Component.Error) {
            console.warn("TabView tear-out:", comp.errorString())
            return null
        }
        if (comp.status !== Component.Ready) {
            console.warn("TabView tear-out: component not ready")
            return null
        }
        var win = comp.createObject(null, {
            "tabData": item,
            "tabModel": [item],
            "x": Math.round(globalX - 48),
            "y": Math.round(globalY - 20)
        })
        if (!win)
            return null
        control._trackTearOut(win)
        win.show()
        win.raise()
        win.requestActivate()
        return win
    }

    function _ghostHost() {
        var w = control.Window.window
        if (w && w.contentItem)
            return w.contentItem
        return tabFlick.contentItem
    }

    function _ghostOverlay() {
        if (typeof Overlay !== "undefined" && Overlay.overlay)
            return Overlay.overlay
        return control._ghostHost()
    }

    function _parkGhostOnTab(tabBtn) {
        var host = control._ghostOverlay()
        ghost.parent = host
        ghost.z = 100000
        var gp = tabBtn.mapToGlobal(0, 0)
        var lp = host.mapFromGlobal(gp.x, gp.y)
        ghost.x = lp.x
        ghost.y = lp.y
    }

    function _moveGhostWithTab(tabBtn, translation) {
        var host = ghost.parent
        if (!host)
            return
        var gp = tabBtn.mapToGlobal(translation.x, translation.y)
        var lp = host.mapFromGlobal(gp.x, gp.y)
        ghost.x = lp.x
        ghost.y = lp.y
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
            clip: !control._tearOutArmed

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: Theme.cornerCard
                color: parent.color
            }

            Item {
                id: tabStripHeaderSlot
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                width: children.length > 0 ? Math.max(childrenRect.width, 1) : 0
                visible: children.length > 0
                z: 2
            }

            Item {
                id: tabStripFooterSlot
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                width: children.length > 0 ? Math.max(childrenRect.width, 1) : 0
                visible: children.length > 0
                z: 2
            }

            // Keep Add fixed outside the scroll viewport so it is never clipped.
            ToolButton {
                id: addTabBtn
                visible: control.isAddTabButtonVisible
                z: 2
                width: 32
                height: 32
                anchors.right: tabStripFooterSlot.visible
                               ? tabStripFooterSlot.left : parent.right
                anchors.rightMargin: tabStripFooterSlot.visible ? 4 : 6
                anchors.top: parent.top
                anchors.topMargin: 6
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

            Flickable {
                id: tabFlick
                anchors.left: parent.left
                anchors.leftMargin: 6 + (tabStripHeaderSlot.visible ? tabStripHeaderSlot.width + 4 : 0)
                anchors.right: addTabBtn.visible ? addTabBtn.left : (tabStripFooterSlot.visible
                               ? tabStripFooterSlot.left : parent.right)
                anchors.rightMargin: addTabBtn.visible ? 4 : (tabStripFooterSlot.visible ? 4 : 6)
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                contentWidth: Math.max(width, tabRow.implicitWidth)
                contentHeight: height
                clip: !control._tearOutArmed
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds
                interactive: !control._reordering

                WheelHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: function (event) {
                        var dx = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                        if (dx === 0)
                            return
                        var next = tabFlick.contentX - dx
                        var maxX = Math.max(0, tabFlick.contentWidth - tabFlick.width)
                        tabFlick.contentX = Math.max(0, Math.min(maxX, next))
                        event.accepted = true
                    }
                }

                Row {
                    id: tabRow
                    height: tabFlick.height
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
                            readonly property bool _showClose: {
                                if (!control.closable)
                                    return false
                                var mode = String(control.closeButtonOverlayMode).toLowerCase()
                                if (mode === "always")
                                    return true
                                return tabBtn.hovered || tabBtn.checked || tabBtn.visualFocus
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
                            focusPolicy: Qt.NoFocus

                            Behavior on opacity {
                                enabled: !Theme.reducedMotion && control._reordering
                                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                            Behavior on width {
                                enabled: !Theme.reducedMotion && control._reordering
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
                                    color: tabBtn.checked ? Theme.accent : Theme.textSecondary
                                    verticalAlignment: Text.AlignVCenter
                                    Behavior on color {
                                        enabled: !Theme.reducedMotion
                                        ColorAnimation {
                                            duration: Theme.motionMs("fast")
                                            easing.type: Theme.motionEasing("standard")
                                        }
                                    }
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
                                                 && (tabBtn.checked || tabBtn.hovered || tabBtn.visualFocus)
                                        ColorAnimation {
                                            duration: Theme.duration(Theme.motionFast)
                                        }
                                    }
                                }
                                ToolButton {
                                    id: closeBtn
                                    visible: tabBtn._showClose
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
                                        NumberAnimation {
                                            duration: Theme.motionMs("fast")
                                            easing.type: Theme.motionEasing("standard")
                                        }
                                    }
                                    // Circular hover affordance (2.68 — I14)
                                    background: Rectangle {
                                        implicitWidth: 22
                                        implicitHeight: 22
                                        radius: width / 2
                                        anchors.centerIn: parent
                                        color: closeBtn.down ? Theme.fillSubtleTertiary
                                             : (closeBtn.hovered ? Theme.fillSubtle : "transparent")
                                        Behavior on color {
                                            enabled: !Theme.reducedMotion
                                            ColorAnimation {
                                                duration: Theme.motionMs("fast")
                                                easing.type: Theme.motionEasing("standard")
                                            }
                                        }
                                    }
                                    onClicked: control.closeTab(tabBtn.index)
                                }
                            }

                            background: Item {
                                scale: tabBtn.down && !Theme.reducedMotion ? 0.98 : 1
                                Behavior on scale {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation {
                                        duration: Theme.motionMs("fast")
                                        easing.type: Theme.motionEasing("standard")
                                    }
                                }
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
                                                 && (tabBtn.checked || tabBtn.hovered || tabBtn.visualFocus)
                                        ColorAnimation {
                                            duration: Theme.motionMs("fast")
                                            easing.type: Theme.motionEasing("standard")
                                        }
                                    }
                                }
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    width: tabBtn.checked ? parent.width - 16
                                         : (tabBtn.hovered ? Math.min(parent.width * 0.45, 28) : 12)
                                    height: 2
                                    radius: 1
                                    color: Theme.accent
                                    opacity: tabBtn.checked ? 1 : (tabBtn.hovered ? 0.35 : 0)
                                    Behavior on width {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation {
                                            duration: Theme.motionMs("normal")
                                            easing.type: Theme.motionEasing("enter")
                                        }
                                    }
                                    Behavior on opacity {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation {
                                            duration: Theme.motionMs("normal")
                                            easing.type: Theme.motionEasing("standard")
                                        }
                                    }
                                }
                            }

                            DragHandler {
                                id: tabDrag
                                enabled: control.canDragTabs
                                target: null
                                xAxis.enabled: true
                                yAxis.enabled: control.canTearOutTabs
                                acceptedButtons: Qt.LeftButton
                                // Prefer close button when pressing it.
                                grabPermissions: PointerHandler.CanTakeOverFromItems
                                                 | PointerHandler.ApprovesTakeOverByAnything

                                // True after a swipe/slide reveal
                                property bool slid: false

                                onActiveChanged: {
                                    if (active) {
                                        slid = false
                                        control._tearOutArmed = false
                                        control._dragFrom = tabBtn.tabIndex
                                        control._dropIndex = tabBtn.tabIndex
                                        control.currentIndex = tabBtn.tabIndex
                                        ghost.title = titleLabel.text
                                        ghost.width = tabBtn.width
                                        ghost.height = tabBtn.height
                                        control._parkGhostOnTab(tabBtn)
                                        ghost.visible = true
                                        ghost.elevation = 4
                                    } else {
                                        var from = control._dragFrom
                                        var to = control._dropIndex
                                        var tear = control._tearOutArmed
                                        var gpos = ghost.mapToGlobal(ghost.width * 0.5, ghost.height * 0.5)
                                        ghost.visible = false
                                        ghost.parent = tabFlick.contentItem
                                        ghost.z = 100
                                        ghost.elevation = 4
                                        control._dragFrom = -1
                                        control._dropIndex = -1
                                        control._tearOutArmed = false
                                        var dock = TabViewDropHub.hit(gpos.x, gpos.y, null)
                                        if (dock && dock !== control && from >= 0) {
                                            var moved = control.takeTab(from)
                                            if (moved !== null && moved !== undefined) {
                                                dock.insertTab(moved, dock.dropIndexAt(gpos.x, gpos.y))
                                                control._closeIfEmpty()
                                            }
                                        } else if (dock === control) {
                                            if (slid && control.tabsReorderable
                                                    && from >= 0 && to >= 0 && from !== to)
                                                control.moveTab(from, to)
                                        } else if (tear && from >= 0) {
                                            control.tearOutTab(from, gpos.x, gpos.y)
                                        } else if (slid && control.tabsReorderable
                                                   && from >= 0 && to >= 0 && from !== to) {
                                            control.moveTab(from, to)
                                        }
                                    }
                                }

                                onTranslationChanged: {
                                    if (!active)
                                        return
                                    if (Math.abs(translation.x) > 6 || Math.abs(translation.y) > 6)
                                        slid = true

                                    var canTear = control.canTearOutTabs
                                            && (control.allowTearOutLastTab || control.tabCount > 1)
                                    var armed = canTear
                                            && Math.abs(translation.y) >= control.tearOutThreshold
                                    control._tearOutArmed = armed

                                    if (armed) {
                                        control._moveGhostWithTab(tabBtn, translation)
                                        ghost.elevation = 8
                                        control._dropIndex = control._dragFrom
                                    } else {
                                        control._moveGhostWithTab(tabBtn, translation)
                                        ghost.elevation = 4
                                        var localX = ghost.mapToItem(tabFlick.contentItem,
                                                                       ghost.width * 0.5, ghost.height * 0.5).x
                                        control._dropIndex = control.tabIndexAtContentX(localX)

                                        // Auto-scroll strip near edges while dragging.
                                        var viewX = localX - tabFlick.contentX
                                        if (viewX > tabFlick.width - 40)
                                            tabFlick.contentX = Math.min(tabFlick.contentWidth - tabFlick.width,
                                                                         tabFlick.contentX + 12)
                                        else if (viewX < 40)
                                            tabFlick.contentX = Math.max(0, tabFlick.contentX - 12)
                                    }
                                }
                            }
                        }
                    } // Repeater
                } // tabRow

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
                    opacity: control._tearOutArmed ? 0.98 : 0.95
                    elevation: 4
                    shadowOpacity: 0.22
                    scale: control._tearOutArmed && !Theme.reducedMotion ? 1.04 : 1
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }

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
                    visible: control._reordering && !control._tearOutArmed
                             && control._dropIndex >= 0
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
            } // tabFlick
        } // tabStrip

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
