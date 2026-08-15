import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QWinUI3.Theme

// NavigationView — WinUI NavigationView with pane modes and page stack.
//
//   NavigationView {
//       anchors.fill: parent
//       paneDisplayMode: "auto"
//       model: navModel
//       isPaneSearchEnabled: true
//       pageModule: "MyApp"
//   }

Item {
    id: root

    // Navigation items: [{ type, key, title, icon|symbol, children?, badge?, badgeValue? }]
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Expanded pane when true (left / leftMinimal); compact modes force false
    property bool paneOpen: true
    // Expanded pane width
    property real paneWidth: Theme.navPaneWidth
    // Compact pane width
    property real paneCompactWidth: Theme.navPaneCompactWidth
    property string headerText: qsTr("QWinUI3")
    property string footerText: qsTr("Settings")
    property var footerSymbol: FluentIcons.Settings
    property string footerIcon: ""
    // Page component name loaded for the footer row (e.g. "SettingsPage")
    property string footerComponent: ""
    // QML import URI used to resolve page components
    property string pageModule: "QWinUI3.Gallery"
    property bool footerSelected: false
    // WinUI PaneDisplayMode: left | leftCompact | leftMinimal | top | auto
    property string paneDisplayMode: "left"
    // Width below which auto mode uses leftCompact
    property real autoCompactThreshold: 1008
    // Show back button
    property bool isBackButtonVisible: false
    // Enable back button
    property bool isBackEnabled: true
    // Shows SearchBox at the top of the pane when open
    property bool isPaneSearchEnabled: false
    property string paneSearchText: ""
    // Suggestion model for pane SearchBox: [{ title, key?, component? }]
    property var paneSearchModel: []
    property alias paneHeader: paneHeaderHost.data
    property alias paneFooter: paneFooterHost.data
    // Drag rows to reorder top-level model entries
    property bool isReorderable: false
    // Shell host: show `content:` instead of StackView page loading (NavigationWindow).
    property bool hostContent: false
    // Content slot / children host
    property alias content: contentHost.data

    readonly property string effectiveFooterIcon: IconSource.resolve(footerSymbol, footerIcon)
    readonly property string resolvedPaneMode: {
        if (paneDisplayMode === "auto")
            return root.width < autoCompactThreshold ? "leftCompact" : "left"
        return paneDisplayMode
    }

    // groupKey -> bool; missing means expanded
    property var expandedMap: ({})
    // Selected nav key (supports "group/0" child paths)
    property string currentKey: "home"
    // Pending page transition: "slide" | "center"
    property string pendingMode: "slide"
    property real _enterX: 0
    property real _exitX: 0
    property real _enterScale: 1
    property real _exitScale: 1
    property string _typeAhead: ""
    property int _dragFromIndex: -1

    signal footerClicked()
    signal itemClicked(int index)
    signal pageOpened(string name)
    signal backRequested()
    signal paneSearchActivated(string text)
    signal paneSearchTextEdited(string text)
    // Emitted after a successful drag-reorder with the new model array
    signal modelReordered(var model)

    readonly property real _paneWidth: {
        if (resolvedPaneMode === "top")
            return 0
        if (resolvedPaneMode === "leftMinimal")
            return paneOpen ? paneWidth : 0
        if (resolvedPaneMode === "leftCompact")
            return paneCompactWidth
        return paneOpen ? paneWidth : paneCompactWidth
    }
    // leftMinimal overlays content — layout width stays 0 so the page does not shrink.
    readonly property real _paneLayoutWidth: resolvedPaneMode === "leftMinimal" ? 0 : _paneWidth
    readonly property alias pageItem: pageStack.currentItem
    readonly property bool _paneShowsLabels: paneOpen && resolvedPaneMode !== "leftCompact"
    readonly property bool _minimalOverlay: resolvedPaneMode === "leftMinimal" && paneOpen

    onPaneDisplayModeChanged: _syncPaneOpenForMode()
    onResolvedPaneModeChanged: _syncPaneOpenForMode()
    onWidthChanged: {
        if (paneDisplayMode === "auto")
            _syncPaneOpenForMode()
    }

    function _syncPaneOpenForMode() {
        var mode = resolvedPaneMode
        if (mode === "leftCompact" || mode === "top")
            paneOpen = false
        else if (mode === "left")
            paneOpen = true
        // leftMinimal: keep current paneOpen (hamburger-driven)
    }

    function moveNavItem(fromIndex, toIndex) {
        if (!root.isReorderable)
            return
        var m = (root.model && root.model.slice) ? root.model.slice() : []
        if (fromIndex < 0 || toIndex < 0 || fromIndex >= m.length || toIndex >= m.length
                || fromIndex === toIndex)
            return
        var item = m.splice(fromIndex, 1)[0]
        m.splice(toIndex, 0, item)
        root.model = m
        root.modelReordered(m)
    }

    ListModel {
        id: navModel
    }

    readonly property string currentComponent: {
        if (root.footerSelected)
            return root.footerComponent
        return root.componentForKey(root.currentKey)
    }

    function isGroupExpanded(key) {
        if (root.expandedMap.hasOwnProperty(key))
            return !!root.expandedMap[key]
        return true
    }

    function rebuildNavModel() {
        navModel.clear()
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group") {
                var gkey = it.key || ("group_" + i)
                navModel.append({
                    kind: "group",
                    key: gkey,
                    modelIndex: i,
                    title: it.title || "",
                    glyph: IconSource.resolve(it.symbol || "", it.icon || FluentIcons.Library),
                    expanded: root.isGroupExpanded(gkey),
                    badge: it.badge !== undefined ? it.badge : "",
                    badgeValue: it.badgeValue !== undefined ? Number(it.badgeValue) : -1
                })
            } else if (it.type === "header") {
                navModel.append({
                    kind: "header",
                    key: "header_" + i,
                    modelIndex: i,
                    title: it.title || "",
                    glyph: "",
                    expanded: false,
                    badge: "",
                    badgeValue: -1
                })
            } else {
                navModel.append({
                    kind: "item",
                    key: it.key || ("item_" + i),
                    modelIndex: i,
                    title: it.title || "",
                    glyph: IconSource.resolve(it.symbol || "", it.icon || FluentIcons.Placeholder),
                    expanded: false,
                    badge: it.badge !== undefined ? it.badge : "",
                    badgeValue: it.badgeValue !== undefined ? Number(it.badgeValue) : -1
                })
            }
        }
    }

    function setGroupExpanded(key, expanded) {
        if (!!root.isGroupExpanded(key) === !!expanded)
            return
        var next = Object.assign({}, root.expandedMap)
        next[key] = expanded
        root.expandedMap = next
        for (var i = 0; i < navModel.count; ++i) {
            var row = navModel.get(i)
            if (row.kind === "group" && row.key === key) {
                navModel.setProperty(i, "expanded", expanded)
                break
            }
        }
        // Animate pip: collapsed selection moves to group header; expand returns to child
        Qt.callLater(function () { selectionPip.moveToCurrent(false) })
    }

    function selectionAnchorItem() {
        var idx = navList.currentIndex
        if (idx < 0)
            return null
        var row = navList.itemAtIndex(idx)
        if (!row)
            return null
        if (row.selectionItem)
            return row.selectionItem
        return row
    }

    function toggleGroup(key) {
        setGroupExpanded(key, !isGroupExpanded(key))
    }

    onModelChanged: {
        rebuildNavModel()
        // If the first openPage() ran against an empty model, load now.
        if (!root.hostContent && pageStack.depth === 0 && root.currentComponent)
            openPage(root.currentComponent, root.pendingMode || "slide")
    }
    onPaneOpenChanged: {
        rebuildNavModel()
        compactFlyout.close()
    }

    property string flyoutGroupKey: ""
    property string pendingFlyoutKey: ""
    property var pendingFlyoutAnchor: null
    property bool flyoutHovered: false

    ListModel { id: flyoutModel }

    function groupTitle(key) {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && it.type === "group" && (it.key || ("group_" + i)) === key)
                return it.title || ""
        }
        return ""
    }

    function fillFlyoutModel(key) {
        flyoutModel.clear()
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it || it.type !== "group")
                continue
            var gkey = it.key || ("group_" + i)
            if (gkey !== key || !it.children)
                continue
            for (var j = 0; j < it.children.length; ++j) {
                var ch = it.children[j]
                flyoutModel.append({
                    key: gkey + "/" + j,
                    title: ch.title || "",
                    glyph: IconSource.resolve(ch.symbol || "", ch.icon || FluentIcons.Placeholder),
                    component: ch.component || ""
                })
            }
            break
        }
    }

    function openCompactFlyout(groupKey, anchorItem) {
        if (root.paneOpen || !groupKey || !anchorItem)
            return
        flyoutGroupKey = groupKey
        fillFlyoutModel(groupKey)
        if (flyoutModel.count === 0)
            return
        var p = anchorItem.mapToItem(root, 0, 0)
        compactFlyout.x = root._paneWidth + 4
        // Keep flyout on-screen vertically
        var maxY = Math.max(8, root.height - Math.min(flyoutModel.count * Theme.navItemHeight + 40, root.height - 16))
        compactFlyout.y = Math.max(8, Math.min(p.y, maxY))
        compactFlyout.open()
        Qt.callLater(function () {
            if (flyoutList) {
                flyoutList.positionViewAtBeginning()
                flyoutList.currentIndex = 0
                flyoutList.forceActiveFocus()
            }
        })
    }

    function requestCompactFlyout(groupKey, anchorItem) {
        pendingFlyoutKey = groupKey
        pendingFlyoutAnchor = anchorItem
        flyoutCloseTimer.stop()
        if (compactFlyout.visible && flyoutGroupKey === groupKey)
            return
        flyoutOpenTimer.restart()
    }

    function requestCloseCompactFlyout() {
        flyoutOpenTimer.stop()
        flyoutCloseTimer.restart()
    }

    Timer {
        id: flyoutOpenTimer
        interval: 200
        onTriggered: {
            if (!root.paneOpen && root.pendingFlyoutAnchor)
                root.openCompactFlyout(root.pendingFlyoutKey, root.pendingFlyoutAnchor)
        }
    }
    Timer {
        id: flyoutCloseTimer
        interval: 280
        onTriggered: {
            if (!root.flyoutHovered)
                compactFlyout.close()
        }
    }

    function componentForKey(key) {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    if ((gkey + "/" + j) === key)
                        return it.children[j].component || ""
                }
            } else if (it.type !== "header" && it.type !== "group") {
                var ikey = it.key || ("item_" + i)
                if (ikey === key)
                    return it.component || ""
            }
        }
        return ""
    }

    function flatIndexForKey(key) {
        for (var i = 0; i < navModel.count; ++i) {
            var row = navModel.get(i)
            if (row.kind === "item" && row.key === key)
                return i
            if (row.kind === "group" && key.indexOf(row.key + "/") === 0)
                return i
        }
        return -1
    }

    function ensureSelectionVisible() {
        if (!navList || root.footerSelected)
            return -1
        var idx = flatIndexForKey(root.currentKey)
        if (idx < 0)
            return -1
        // Search / programmatic nav often lands on an off-screen group — force the
        // delegate to exist so selectionPip can mapToItem a real anchor.
        navList.positionViewAtIndex(idx, ListView.Contain)
        return idx
    }

    function selectIndex(index) {
        // Legacy: index into root.model (top-level only)
        if (index < 0 || index >= root.model.length)
            return
        var it = root.model[index]
        if (!it || it.type === "header" || it.type === "group")
            return
        selectKey(it.key || ("item_" + index), "slide")
        itemClicked(index)
    }

    function selectKey(key, mode) {
        if (!key)
            return
        footerSelected = false
        currentKey = key
        // Expand parent group if nested
        var slash = key.indexOf("/")
        if (slash > 0)
            setGroupExpanded(key.substring(0, slash), true)
        ensureSelectionVisible()
        if (!root.hostContent)
            openPage(currentComponent, mode || "slide")
        // Sync legacy currentIndex for top-level items
        for (var i = 0; i < root.model.length; ++i) {
            var it = root.model[i]
            if (it && it.type !== "group" && it.type !== "header") {
                if ((it.key || ("item_" + i)) === key) {
                    currentIndex = i
                    break
                }
            }
        }
        itemClicked(currentIndex)
        // Child rows may still be laying out after expand + scroll.
        Qt.callLater(function () {
            ensureSelectionVisible()
            selectionPip.moveToCurrent(false)
            Qt.callLater(function () { selectionPip.moveToCurrent(false) })
        })
    }

    function selectFooter(mode) {
        footerSelected = true
        footerClicked()
        if (!root.hostContent)
            openPage(root.footerComponent, mode || "slide")
    }

    property var _compCache: ({})

    function ensureComponent(name) {
        if (!name || !root.pageModule)
            return null
        var cached = root._compCache[name]
        if (cached && cached.status !== Component.Error)
            return cached
        var comp = Qt.createComponent(root.pageModule, name)
        if (comp.status === Component.Error) {
            console.warn("Failed to load", root.pageModule, name, comp.errorString())
            return null
        }
        // Cache Ready or Loading; drop Error entries.
        var next = Object.assign({}, root._compCache)
        next[name] = comp
        root._compCache = next
        return comp
    }

    function openPage(name, mode) {
        var useMode = mode || "slide"
        root.pendingMode = useMode
        if (useMode === "center") {
            root._enterX = 0
            root._exitX = 0
            root._enterScale = 0.94
            root._exitScale = 0.98
        } else {
            root._enterX = pageStack.width > 0 ? -0.12 * pageStack.width : -48
            root._exitX = pageStack.width > 0 ? 0.06 * pageStack.width : 24
            root._enterScale = 1
            root._exitScale = 1
        }

        var comp = ensureComponent(name)
        if (!comp)
            return
        function doReplace(c) {
            var props = { transformOrigin: Item.Center }
            if (pageStack.depth === 0)
                pageStack.push(c, props, StackView.Immediate)
            else
                pageStack.replace(c, props)
            root.pageOpened(name)
        }
        if (comp.status === Component.Ready) {
            doReplace(comp)
        } else {
            comp.statusChanged.connect(function () {
                if (comp.status === Component.Ready)
                    doReplace(comp)
                else if (comp.status === Component.Error)
                    console.warn("Failed to load", root.pageModule, name, comp.errorString())
            })
        }
    }

    // Left-nav style: content slides in from the left
    function openSlide(name) {
        openPage(name, "slide")
    }

    // Keep center-open API (scale + fade from middle)
    function openFromCenter(name) {
        if (!name)
            return
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    if (it.children[j].component === name) {
                        // Same selection path as sidebar clicks — expands group,
                        // scrolls into view, and drives the left selection pip.
                        selectKey(gkey + "/" + j, "center")
                        return
                    }
                }
            } else if (it && it.component === name) {
                selectKey(it.key || ("item_" + i), "center")
                return
            }
        }
        openPage(name, "center")
    }

    function navigateToTitle(title, mode) {
        if (!title)
            return
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    if (it.children[j].title === title) {
                        selectKey(gkey + "/" + j, mode || "slide")
                        return
                    }
                }
            } else if (it && it.title === title) {
                selectKey(it.key || ("item_" + i), mode || "slide")
                return
            }
        }
    }

    function reloadPage() {
        openPage(root.currentComponent, root.pendingMode || "slide")
    }

    Component.onCompleted: {
        rebuildNavModel()
        if (!root.hostContent)
            openPage(root.currentComponent, "slide")
    }

    // leftMinimal: pane reparents here so it floats over content (WinUI light-dismiss).
    Item {
        id: minimalOverlayLayer
        anchors.fill: parent
        z: 50
        visible: root.resolvedPaneMode === "leftMinimal"

        Rectangle {
            anchors.fill: parent
            visible: root.paneOpen
            color: Theme.bgSmoke
            opacity: visible ? 1 : 0
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.paneOpen = false
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: topPane
            visible: root.resolvedPaneMode === "top"
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? Theme.navItemHeight + 8 : 0
            color: Theme.bgAcrylic
            clip: true

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Theme.strokeDivider
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 2

                ItemDelegate {
                    visible: root.isBackButtonVisible
                    enabled: root.isBackEnabled
                    Layout.preferredWidth: Theme.navItemHeight
                    Layout.preferredHeight: Theme.navItemHeight
                    opacity: enabled ? 1 : 0.4
                    onClicked: root.backRequested()
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Back")
                    contentItem: Text {
                        text: FluentIcons.Back
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 16
                        color: Theme.textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: Theme.cornerControl
                        color: parent.down ? Theme.fillSubtleTertiary
                             : (parent.hovered ? Theme.fillSubtle : "transparent")
                    }
                }

                Text {
                    text: root.headerText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    Layout.rightMargin: 8
                }

                ListView {
                    id: topNavList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    orientation: ListView.Horizontal
                    clip: true
                    spacing: 2
                    model: navModel
                    currentIndex: root.footerSelected ? -1 : root.flatIndexForKey(root.currentKey)
                    boundsBehavior: Flickable.StopAtBounds
                    ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }

                    readonly property bool hasOverflow: contentWidth > width + 1

                    delegate: ItemDelegate {
                        id: topDel
                        required property int index
                        required property string kind
                        required property string key
                        required property string title
                        required property string glyph
                        required property int modelIndex
                        required property bool expanded

                        visible: kind === "item" || kind === "group"
                        width: visible ? Math.max(88, topRow.implicitWidth + 20) : 0
                        height: ListView.view.height
                        highlighted: !root.footerSelected && root.currentKey === key
                        onClicked: {
                            if (kind === "group") {
                                var m = root.model || []
                                for (var i = 0; i < m.length; ++i) {
                                    var it = m[i]
                                    if (!it || it.type !== "group")
                                        continue
                                    var gkey = it.key || ("group_" + i)
                                    if (gkey !== key || !it.children || !it.children.length)
                                        continue
                                    root.selectKey(gkey + "/0", "slide")
                                    root.itemClicked(modelIndex)
                                    return
                                }
                                return
                            }
                            root.selectKey(key, "slide")
                            root.itemClicked(modelIndex)
                        }

                        contentItem: RowLayout {
                            id: topRow
                            spacing: 8
                            Text {
                                text: topDel.glyph
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 14
                                color: topDel.highlighted ? Theme.accent : Theme.textPrimary
                            }
                            Text {
                                text: topDel.title
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontCaption
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                            }
                        }
                        background: Rectangle {
                            radius: Theme.cornerControl
                            color: topDel.down ? Theme.fillSubtleTertiary
                                 : (topDel.highlighted || topDel.hovered ? Theme.fillSubtle : "transparent")
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                height: 2
                                radius: 1
                                color: Theme.accent
                                visible: topDel.highlighted
                            }
                        }
                    }
                }

                ToolButton {
                    id: topOverflowBtn
                    visible: topNavList.hasOverflow
                    Layout.preferredWidth: Theme.navItemHeight
                    Layout.preferredHeight: Theme.navItemHeight
                    ToolTip.text: qsTr("More")
                    ToolTip.visible: hovered
                    contentItem: Text {
                        text: FluentIcons.More
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 16
                        color: Theme.textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        while (topOverflowMenu.count > 0)
                            topOverflowMenu.takeItem(0)
                        for (var i = 0; i < navModel.count; ++i) {
                            var row = navModel.get(i)
                            if (!row || (row.kind !== "item" && row.kind !== "group"))
                                continue
                            var delItem = topNavList.itemAtIndex(i)
                            if (delItem) {
                                var left = delItem.x - topNavList.contentX
                                var right = left + delItem.width
                                // Fully (or mostly) visible — skip from overflow menu
                                if (left >= -2 && right <= topNavList.width + 2)
                                    continue
                            }
                            var mi = Qt.createQmlObject(
                                        'import QtQuick.Controls; MenuItem { }',
                                        topOverflowMenu, "overflowItem")
                            mi.text = row.title || ""
                            mi.objectName = row.key
                            mi.triggered.connect((function (key, kind) {
                                return function () {
                                    if (kind === "group") {
                                        var m = root.model || []
                                        for (var j = 0; j < m.length; ++j) {
                                            var it = m[j]
                                            if (!it || it.type !== "group")
                                                continue
                                            var gkey = it.key || ("group_" + j)
                                            if (gkey === key && it.children && it.children.length) {
                                                root.selectKey(gkey + "/0", "slide")
                                                return
                                            }
                                        }
                                    } else {
                                        root.selectKey(key, "slide")
                                    }
                                }
                            })(row.key, row.kind))
                            topOverflowMenu.addItem(mi)
                        }
                        if (topOverflowMenu.count === 0)
                            return
                        topOverflowMenu.open()
                    }
                    Menu {
                        id: topOverflowMenu
                        y: topOverflowBtn.height
                    }
                }

                ItemDelegate {
                    visible: root.footerComponent.length > 0 || root.footerText.length > 0
                    Layout.preferredHeight: Theme.navItemHeight
                    Layout.preferredWidth: Math.max(Theme.navItemHeight, footerTopRow.implicitWidth + 16)
                    highlighted: root.footerSelected
                    onClicked: {
                        root.footerSelected = true
                        root.footerClicked()
                        if (root.footerComponent.length)
                            root.openPage(root.footerComponent, "slide")
                    }
                    contentItem: RowLayout {
                        id: footerTopRow
                        spacing: 8
                        Text {
                            text: root.effectiveFooterIcon
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 14
                            color: Theme.textPrimary
                        }
                        Text {
                            text: root.footerText
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textPrimary
                        }
                    }
                    background: Rectangle {
                        radius: Theme.cornerControl
                        color: parent.down ? Theme.fillSubtleTertiary
                             : (parent.highlighted || parent.hovered ? Theme.fillSubtle : "transparent")
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

        Item {
            id: paneSlot
            // leftMinimal uses overlay layer — keep a zero-width layout stub only.
            visible: root.resolvedPaneMode !== "top" && root.resolvedPaneMode !== "leftMinimal"
            Layout.preferredWidth: visible ? root._paneLayoutWidth : 0
            Layout.fillHeight: true
            clip: false

            Behavior on Layout.preferredWidth {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Rectangle {
            id: pane
            parent: root.resolvedPaneMode === "leftMinimal" ? minimalOverlayLayer : paneSlot
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            z: root.resolvedPaneMode === "leftMinimal" ? 1 : 0
            width: root.resolvedPaneMode === "leftMinimal"
                   ? (root.paneOpen ? root.paneWidth : 0)
                   : parent.width
            color: Theme.bgAcrylic
            clip: true

            Behavior on width {
                enabled: !Theme.reducedMotion && root.resolvedPaneMode === "leftMinimal"
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: Theme.strokeDivider
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 2

                ItemDelegate {
                    visible: root.isBackButtonVisible
                    enabled: root.isBackEnabled
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    opacity: enabled ? 1 : 0.4
                    onClicked: root.backRequested()
                    ToolTip.visible: !root.paneOpen && hovered
                    ToolTip.text: qsTr("Back")

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: FluentIcons.Back
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 16
                            color: Theme.textPrimary
                            Layout.preferredWidth: 20
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            visible: root.paneOpen
                            text: qsTr("Back")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontBody
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                        }
                    }
                    background: Rectangle {
                        radius: Theme.cornerControl
                        color: parent.down ? Theme.fillSubtleTertiary
                             : (parent.hovered ? Theme.fillSubtle : "transparent")
                    }
                }

                ItemDelegate {
                    visible: root.resolvedPaneMode === "left" || root.resolvedPaneMode === "leftMinimal"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    text: root.paneOpen ? root.headerText : ""
                    onClicked: root.paneOpen = !root.paneOpen
                    ToolTip.visible: !root.paneOpen && hovered
                    ToolTip.text: root.paneOpen ? qsTr("Collapse") : qsTr("Expand")

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: FluentIcons.GlobalNavButton
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 16
                            color: Theme.textPrimary
                            Layout.preferredWidth: 20
                            horizontalAlignment: Text.AlignHCenter
                            rotation: root.paneOpen ? 0 : 180
                            Behavior on rotation {
                                enabled: !Theme.reducedMotion
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionNormal)
                                    easing.type: Theme.easingStandard
                                }
                            }
                        }
                        Text {
                            visible: root.paneOpen
                            opacity: root.paneOpen ? 1 : 0
                            text: root.headerText
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontBody
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Behavior on opacity {
                                enabled: !Theme.reducedMotion
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionFast)
                                }
                            }
                        }
                    }
                }

                ItemDelegate {
                    visible: root.resolvedPaneMode === "leftCompact"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    enabled: false
                    contentItem: Text {
                        text: root.headerText.length ? root.headerText.charAt(0) : "Q"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Item {
                    id: paneHeaderHost
                    visible: root.paneOpen && children.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? Math.max(implicitHeight, childrenRect.height) : 0
                    implicitHeight: childrenRect.height
                }

                SearchBox {
                    id: paneSearch
                    visible: root.isPaneSearchEnabled && root.paneOpen
                    Layout.fillWidth: true
                    Layout.leftMargin: 4
                    Layout.rightMargin: 4
                    Layout.preferredHeight: visible ? implicitHeight : 0
                    placeholderText: qsTr("Search")
                    text: root.paneSearchText
                    model: root.paneSearchModel
                    onTextChanged: {
                        root.paneSearchText = text
                        root.paneSearchTextEdited(text)
                    }
                    onAccepted: function (t) { root.paneSearchActivated(t) }
                    onSuggestionChosen: function (item) {
                        if (item && item.key)
                            root.selectKey(item.key, "slide")
                        else if (item && item.title)
                            root.navigateToTitle(item.title, "slide")
                        root.paneSearchActivated(paneSearch.displayTextFor(item))
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        id: navList
                        anchors.fill: parent
                        clip: true
                        spacing: 2
                        model: navModel
                        currentIndex: root.footerSelected ? -1 : root.flatIndexForKey(root.currentKey)
                        boundsBehavior: Flickable.StopAtBounds
                        highlightFollowsCurrentItem: false
                        keyNavigationEnabled: true
                        focus: true
                        ScrollBar.vertical: ScrollBar {
                            policy: navList.contentHeight > navList.height
                                    ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        }

                        // Throttle pip updates while flicking for stability.
                        Timer {
                            id: pipScrollTimer
                            interval: 16
                            repeat: false
                            onTriggered: selectionPip.syncViewport()
                        }

                        onCurrentIndexChanged: Qt.callLater(function () {
                            selectionPip.moveToCurrent(false)
                        })
                        onContentYChanged: pipScrollTimer.restart()
                        onHeightChanged: selectionPip.syncViewport()
                        onCountChanged: Qt.callLater(function () {
                            selectionPip.moveToCurrent(true)
                        })

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Home) {
                                if (navModel.count > 0)
                                    root.selectKey(navModel.get(0).key, "slide")
                                event.accepted = true
                            } else if (event.key === Qt.Key_End) {
                                if (navModel.count > 0)
                                    root.selectKey(navModel.get(navModel.count - 1).key, "slide")
                                event.accepted = true
                            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Return
                                       || event.key === Qt.Key_Enter) {
                                var row = navModel.get(navList.currentIndex)
                                if (row && row.kind === "group")
                                    root.setGroupExpanded(row.key, true)
                                event.accepted = true
                            } else if (event.key === Qt.Key_Left) {
                                var rowL = navModel.get(navList.currentIndex)
                                if (rowL && rowL.kind === "group")
                                    root.setGroupExpanded(rowL.key, false)
                                event.accepted = true
                            } else if (event.text && event.text.length === 1) {
                                root._typeAhead += event.text.toLowerCase()
                                typeAheadTimer.restart()
                                for (var i = 0; i < navModel.count; ++i) {
                                    var r = navModel.get(i)
                                    if (!r || r.kind === "header")
                                        continue
                                    if (String(r.title || "").toLowerCase().indexOf(root._typeAhead) === 0) {
                                        if (r.kind === "item")
                                            root.selectKey(r.key, "slide")
                                        else
                                            navList.currentIndex = i
                                        break
                                    }
                                }
                                event.accepted = true
                            }
                        }

                        Timer {
                            id: typeAheadTimer
                            interval: 700
                            onTriggered: root._typeAhead = ""
                        }

                        Connections {
                            target: root
                            function onCurrentKeyChanged() {
                                Qt.callLater(function () {
                                    selectionPip.moveToCurrent(false)
                                })
                            }
                            function onFooterSelectedChanged() {
                                Qt.callLater(function () {
                                    selectionPip.moveToCurrent(true)
                                })
                            }
                        }

                        delegate: Column {
                            id: del
                            required property int index
                            required property string kind
                            required property string key
                            required property string title
                            required property string glyph
                            required property int modelIndex
                            required property bool expanded
                            required property string badge
                            required property real badgeValue

                            width: ListView.view.width
                            spacing: 0

                            readonly property var childItems: {
                                var m = root.model || []
                                var it = m[del.modelIndex]
                                return (it && it.children) ? it.children : []
                            }

                            // Anchor used by the selection pip (child row when nested)
                            readonly property Item selectionItem: {
                                if (del.kind === "item")
                                    return topRow
                                if (del.kind !== "group")
                                    return null
                                if (!root.paneOpen)
                                    return topRow
                                var prefix = del.key + "/"
                                if (root.currentKey.indexOf(prefix) !== 0)
                                    return null
                                // Collapsed: keep pip on the group header (child is clipped away)
                                if (!del.expanded)
                                    return topRow
                                var ci = Number(root.currentKey.slice(prefix.length))
                                if (isNaN(ci) || ci < 0)
                                    return null
                                return childRepeater.itemAt(ci)
                            }

                            ItemDelegate {
                                id: topRow
                                width: parent.width
                                height: {
                                    if (del.kind === "header")
                                        return root.paneOpen ? 28 : 0
                                    return Theme.navItemHeight
                                }
                                visible: del.kind === "header" ? root.paneOpen : true
                                enabled: del.kind !== "header"
                                highlighted: !root.footerSelected && (
                                    (del.kind === "item" && del.key === root.currentKey)
                                    || (del.kind === "group"
                                        && root.currentKey.indexOf(del.key + "/") === 0
                                        && (!root.paneOpen || !del.expanded))
                                    || (del.kind === "group" && !root.paneOpen
                                        && compactFlyout.visible && root.flyoutGroupKey === del.key)
                                )

                                onClicked: {
                                    if (del.kind === "group") {
                                        if (!root.paneOpen)
                                            root.openCompactFlyout(del.key, topRow)
                                        else
                                            root.toggleGroup(del.key)
                                    } else if (del.kind === "item") {
                                        root.selectKey(del.key, "slide")
                                    }
                                }

                                onHoveredChanged: {
                                    if (root.paneOpen || del.kind !== "group")
                                        return
                                    if (hovered)
                                        root.requestCompactFlyout(del.key, topRow)
                                    else
                                        root.requestCloseCompactFlyout()
                                }

                                ToolTip.visible: !root.paneOpen && del.kind === "item" && hovered
                                                 && !compactFlyout.visible
                                ToolTip.text: del.title || ""

                                DragHandler {
                                    id: reorderDrag
                                    enabled: root.isReorderable && root.paneOpen
                                             && (del.kind === "item" || del.kind === "group")
                                    target: null
                                    acceptedButtons: Qt.LeftButton
                                    // Prefer click-to-select; only reorder after a clear drag.
                                    dragThreshold: 12
                                    onActiveChanged: {
                                        if (active) {
                                            root._dragFromIndex = del.modelIndex
                                            topRow.opacity = 0.55
                                        } else {
                                            topRow.opacity = 1
                                            var from = root._dragFromIndex
                                            root._dragFromIndex = -1
                                            if (from < 0)
                                                return
                                            var p = navList.mapFromItem(topRow,
                                                        reorderDrag.centroid.position.x,
                                                        reorderDrag.centroid.position.y)
                                            var idx = navList.indexAt(10, p.y + navList.contentY)
                                            if (idx < 0)
                                                return
                                            var row = navModel.get(idx)
                                            if (!row || row.kind === "header")
                                                return
                                            root.moveNavItem(from, row.modelIndex)
                                        }
                                    }
                                }

                                background: Item {
                                    implicitHeight: Theme.navItemHeight
                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.leftMargin: 4
                                        anchors.rightMargin: 4
                                        anchors.topMargin: 2
                                        anchors.bottomMargin: 2
                                        radius: Theme.cornerControl
                                        color: {
                                            if (!topRow.enabled || topRow.height < 8)
                                                return "transparent"
                                            if (topRow.down)
                                                return Theme.fillSubtleTertiary
                                            if (topRow.highlighted)
                                                return Theme.fillSubtle
                                            if (topRow.hovered)
                                                return Theme.fillSubtleSecondary
                                            return "transparent"
                                        }
                                        Behavior on color {
                                            enabled: !Theme.reducedMotion
                                            ColorAnimation {
                                                duration: Theme.duration(Theme.motionFast)
                                                easing.type: Theme.easingStandard
                                            }
                                        }
                                    }
                                }

                                contentItem: Item {
                                    anchors.fill: parent

                                    Text {
                                        visible: del.kind === "header" && root.paneOpen
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.leftMargin: 12
                                        text: del.title || ""
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontCaption
                                        font.weight: Theme.fontWeightSemiBold
                                        color: Theme.textSecondary
                                        elide: Text.ElideRight
                                    }

                                    RowLayout {
                                        visible: del.kind === "group" || del.kind === "item"
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8
                                        spacing: 12

                                        Text {
                                            text: del.glyph || FluentIcons.Placeholder
                                            font.family: Theme.fontFamilyIcon
                                            font.pixelSize: 16
                                            color: topRow.highlighted ? Theme.textPrimary : Theme.textSecondary
                                            Layout.preferredWidth: 20
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            visible: root.paneOpen
                                            text: del.title || ""
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontBody
                                            color: Theme.textPrimary
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                        InfoBadge {
                                            visible: root.paneOpen && (del.badge.length > 0 || del.badgeValue >= 0)
                                            Layout.alignment: Qt.AlignVCenter
                                            text: del.badge
                                            value: del.badgeValue >= 0 ? del.badgeValue : 0
                                            severity: informational
                                            hideWhenEmpty: false
                                        }
                                        Text {
                                            visible: root.paneOpen && del.kind === "group"
                                            text: FluentIcons.ChevronDown
                                            font.family: Theme.fontFamilyIcon
                                            font.pixelSize: 10
                                            color: Theme.textSecondary
                                            rotation: del.expanded ? 180 : 0
                                            Behavior on rotation {
                                                enabled: !Theme.reducedMotion
                                                NumberAnimation {
                                                    duration: Theme.duration(Theme.motionNormal)
                                                    easing.type: Theme.easingStandard
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Nested children: one height animation (no phantom ListView spacing)
                            Item {
                                id: expandPane
                                width: parent.width
                                clip: true
                                visible: del.kind === "group"
                                height: {
                                    if (del.kind !== "group" || !root.paneOpen || !del.expanded)
                                        return 0
                                    return childrenCol.implicitHeight
                                }

                                Behavior on height {
                                    enabled: !Theme.reducedMotion && del.kind === "group" && root.paneOpen
                                    NumberAnimation {
                                        duration: Theme.duration(Theme.motionSlow)
                                        easing.type: del.expanded ? Theme.easingEnter
                                                                  : Theme.easingExit
                                    }
                                }

                                onHeightChanged: selectionPip.syncToCurrent()

                                Column {
                                    id: childrenCol
                                    width: parent.width
                                    spacing: 2

                                    Repeater {
                                        id: childRepeater
                                        model: del.kind === "group" ? del.childItems : []

                                        ItemDelegate {
                                            id: childRow
                                            required property int index
                                            required property var modelData

                                            width: childrenCol.width
                                            height: Theme.navItemHeight
                                            highlighted: !root.footerSelected
                                                         && ((del.key + "/" + index) === root.currentKey)

                                            onClicked: root.selectKey(del.key + "/" + index, "slide")

                                            background: Item {
                                                implicitHeight: Theme.navItemHeight
                                                Rectangle {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 4
                                                    anchors.rightMargin: 4
                                                    anchors.topMargin: 2
                                                    anchors.bottomMargin: 2
                                                    radius: Theme.cornerControl
                                                    color: {
                                                        if (childRow.down)
                                                            return Theme.fillSubtleTertiary
                                                        if (childRow.highlighted)
                                                            return Theme.fillSubtle
                                                        if (childRow.hovered)
                                                            return Theme.fillSubtleSecondary
                                                        return "transparent"
                                                    }
                                                    Behavior on color {
                                                        enabled: !Theme.reducedMotion
                                                        ColorAnimation {
                                                            duration: Theme.duration(Theme.motionFast)
                                                            easing.type: Theme.easingStandard
                                                        }
                                                    }
                                                }
                                            }

                                            contentItem: RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 24
                                                anchors.rightMargin: 8
                                                spacing: 12

                                                Text {
                                                    text: IconSource.resolve(
                                                              (childRow.modelData && childRow.modelData.symbol) || "",
                                                              (childRow.modelData && childRow.modelData.icon)
                                                              || FluentIcons.Placeholder)
                                                    font.family: Theme.fontFamilyIcon
                                                    font.pixelSize: 16
                                                    color: childRow.highlighted ? Theme.textPrimary
                                                                                : Theme.textSecondary
                                                    Layout.preferredWidth: 20
                                                    horizontalAlignment: Text.AlignHCenter
                                                }
                                                Text {
                                                    text: (childRow.modelData && childRow.modelData.title)
                                                          ? childRow.modelData.title : ""
                                                    font.family: Theme.fontFamily
                                                    font.pixelSize: Theme.fontBody
                                                    color: Theme.textPrimary
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // WinUI selection indicator: accelerate, stretch mid-travel, settle
                    Rectangle {
                        id: selectionPip
                        width: 3
                        radius: 1.5
                        color: Theme.accent
                        x: 4
                        z: 2
                        visible: opacity > 0.01
                        opacity: {
                            if (root.footerSelected || navList.currentIndex < 0)
                                return 0
                            var item = root.selectionAnchorItem()
                            if (!item || item.height < 8)
                                return 0
                            return 1
                        }

                        property real baseHeight: 16
                        property real contentFromY: 0
                        property real contentToY: 0
                        property real progress: 1
                        property bool ready: false
                        property int moveRetries: 0

                        readonly property real eased: {
                            var t = progress
                            // Cubic ease-in-out: accelerate then decelerate into settle
                            return t < 0.5
                                   ? 4 * t * t * t
                                   : 1 - Math.pow(-2 * t + 2, 3) / 2
                        }
                        readonly property real travel: Math.abs(contentToY - contentFromY)
                        // Stretch peaks in the middle of the path
                        readonly property real stretch: Math.min(36, Math.max(10, travel * 0.45))
                        readonly property real contentCenterY: contentFromY
                                                              + (contentToY - contentFromY) * eased
                                                              + baseHeight * 0.5
                        readonly property real visualHeight: baseHeight
                                                            + stretch * Math.sin(Math.PI * progress)

                        height: visualHeight
                        y: contentCenterY - visualHeight * 0.5 - navList.contentY

                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionFast)
                                easing.type: Theme.easingStandard
                            }
                        }

                        NumberAnimation on progress {
                            id: pipAnim
                            from: 0
                            to: 1
                            duration: Theme.reducedMotion ? 1 : 333
                            easing.type: Easing.Linear
                            running: false
                        }

                        function contentYForSelection() {
                            var item = root.selectionAnchorItem()
                            if (!item || item.height < 8)
                                return -1
                            var p = item.mapToItem(navList.contentItem, 0, 0)
                            return p.y + (item.height - baseHeight) * 0.5
                        }

                        function currentContentY() {
                            if (progress >= 1)
                                return contentToY
                            return contentFromY + (contentToY - contentFromY) * eased
                        }

                        function syncViewport() {
                            // y binding already depends on contentY
                        }

                        // Follow layout shifts (expand/collapse of other rows) without
                        // restarting the stretch animation.
                        function syncToCurrent() {
                            if (root.footerSelected || navList.currentIndex < 0)
                                return
                            var target = contentYForSelection()
                            if (target < 0)
                                return
                            if (pipAnim.running) {
                                contentToY = target
                            } else {
                                contentFromY = target
                                contentToY = target
                            }
                        }

                        function moveToCurrent(instant) {
                            if (navList.currentIndex < 0 || root.footerSelected) {
                                ready = true
                                moveRetries = 0
                                return
                            }
                            root.ensureSelectionVisible()
                            var target = contentYForSelection()
                            if (target < 0) {
                                if (moveRetries++ < 8)
                                    Qt.callLater(function () { moveToCurrent(instant) })
                                else
                                    moveRetries = 0
                                return
                            }
                            moveRetries = 0
                            if (!ready || instant || Theme.reducedMotion) {
                                pipAnim.stop()
                                contentFromY = target
                                contentToY = target
                                progress = 1
                                ready = true
                                return
                            }
                            if (Math.abs(target - contentToY) < 0.5 && progress >= 1)
                                return
                            pipAnim.stop()
                            contentFromY = currentContentY()
                            contentToY = target
                            progress = 0
                            pipAnim.start()
                            ready = true
                        }

                        Component.onCompleted: Qt.callLater(function () {
                            moveToCurrent(true)
                        })
                    }
                }

                Item {
                    id: paneFooterHost
                    visible: root.paneOpen && children.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? Math.max(implicitHeight, childrenRect.height) : 0
                    implicitHeight: childrenRect.height
                }

                Rectangle {
                    visible: root.footerComponent.length > 0 || root.footerText.length > 0
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    height: visible ? 1 : 0
                    color: Theme.strokeDivider
                }

                ItemDelegate {
                    visible: root.footerComponent.length > 0 || root.footerText.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    highlighted: root.footerSelected
                    onClicked: root.selectFooter("slide")
                    ToolTip.visible: !root.paneOpen && hovered
                    ToolTip.text: root.footerText

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: root.effectiveFooterIcon
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 16
                            color: root.footerSelected ? Theme.textPrimary : Theme.textSecondary
                            Layout.preferredWidth: 20
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            visible: root.paneOpen
                            text: root.footerText
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontBody
                            color: Theme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Item {
                id: contentHost
                anchors.fill: parent
                visible: root.hostContent
            }

        StackView {
            id: pageStack
            anchors.fill: parent
            visible: !root.hostContent
            enabled: !root.hostContent
            clip: true

            replaceEnter: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0; to: 1
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "x"
                        from: root._enterX
                        to: 0
                        duration: Theme.duration(Theme.motionSlow)
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "scale"
                        from: root._enterScale
                        to: 1
                        duration: Theme.duration(Theme.motionSlow)
                        easing.type: Theme.easingEnter
                    }
                }
            }
            replaceExit: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 1; to: 0
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingExit
                    }
                    NumberAnimation {
                        property: "x"
                        from: 0
                        to: root._exitX
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingExit
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 1
                        to: root._exitScale
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingExit
                    }
                }
            }
            pushEnter: replaceEnter
            pushExit: replaceExit
            popEnter: replaceEnter
            popExit: replaceExit
        }
        }
        }
    }

    // Compact pane: WinUI-style flyout listing group children to the right of the rail
    Popup {
        id: compactFlyout
        parent: root
        padding: 6
        modal: false
        dim: false
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        transformOrigin: Item.Left
        width: 220
        // Cap to the NavigationView height so long groups (e.g. Charts) scroll.
        readonly property real maxBodyHeight: Math.max(120, root.height - 16
                                                       - topPadding - bottomPadding)
        readonly property real bodyHeight: Math.min(
            flyoutHeader.implicitHeight + flyoutList.contentHeight + (flyoutHeader.visible ? 4 : 0),
            maxBodyHeight)
        implicitHeight: bodyHeight + topPadding + bottomPadding
        height: implicitHeight

        onClosed: {
            root.flyoutHovered = false
            root.flyoutGroupKey = ""
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0; to: 1
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
            NumberAnimation {
                property: "scale"
                from: 0.96; to: 1
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1; to: 0
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingExit
            }
        }

        background: Item {
            Rectangle {
                id: flyoutPanel
                anchors.fill: parent
                radius: Theme.cornerOverlay
                color: Theme.bgCardElevated
                border.width: 1
                border.color: Theme.strokeCard

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: Theme.dark ? 0.28 : 0.14
                    shadowColor: "#000000"
                    shadowHorizontalOffset: 4
                    shadowVerticalOffset: 8
                    blurMax: 28
                    autoPaddingEnabled: true
                }
            }
        }

        contentItem: Item {
            implicitWidth: compactFlyout.width - compactFlyout.leftPadding - compactFlyout.rightPadding
            implicitHeight: compactFlyout.bodyHeight
            height: compactFlyout.bodyHeight
            clip: true

            HoverHandler {
                onHoveredChanged: {
                    root.flyoutHovered = hovered
                    if (hovered)
                        flyoutCloseTimer.stop()
                    else
                        root.requestCloseCompactFlyout()
                }
            }

            Column {
                anchors.fill: parent
                spacing: 4

                Text {
                    id: flyoutHeader
                    width: parent.width
                    visible: text.length > 0
                    text: root.groupTitle(root.flyoutGroupKey)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textSecondary
                    leftPadding: 12
                    rightPadding: 8
                    topPadding: 4
                    bottomPadding: 2
                    elide: Text.ElideRight
                }

                ListView {
                    id: flyoutList
                    width: parent.width
                    height: parent.height - (flyoutHeader.visible ? flyoutHeader.height + 4 : 0)
                    clip: true
                    spacing: 2
                    model: flyoutModel
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick
                    interactive: contentHeight > height
                    keyNavigationEnabled: true
                    focus: true
                    highlightFollowsCurrentItem: true
                    ScrollBar.vertical: ScrollBar {
                        policy: flyoutList.contentHeight > flyoutList.height
                                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                    }
                    Component.onCompleted: Qt.callLater(function () { flyoutList.forceActiveFocus() })
                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Escape) {
                            compactFlyout.close()
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (currentIndex >= 0 && currentIndex < flyoutModel.count) {
                                root.selectKey(flyoutModel.get(currentIndex).key, "slide")
                                compactFlyout.close()
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up) {
                            if (currentIndex > 0)
                                currentIndex--
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down) {
                            if (currentIndex < flyoutModel.count - 1)
                                currentIndex++
                            event.accepted = true
                        } else if (event.key === Qt.Key_Home) {
                            currentIndex = 0
                            event.accepted = true
                        } else if (event.key === Qt.Key_End) {
                            currentIndex = Math.max(0, flyoutModel.count - 1)
                            event.accepted = true
                        }
                    }
                    WheelHandler {
                        // Keep wheel scrolling even when HoverHandler is on the parent.
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: function (event) {
                            if (flyoutList.contentHeight <= flyoutList.height)
                                return
                            flyoutList.contentY = Math.max(
                                        0, Math.min(flyoutList.contentHeight - flyoutList.height,
                                                    flyoutList.contentY - event.angleDelta.y / 4))
                            event.accepted = true
                        }
                    }

                    delegate: ItemDelegate {
                        id: flyDel
                        required property int index
                        required property string key
                        required property string title
                        required property string glyph
                        width: ListView.view.width
                        height: Theme.navItemHeight
                        highlighted: key === root.currentKey
                        onClicked: {
                            root.selectKey(key, "slide")
                            compactFlyout.close()
                        }

                        contentItem: Row {
                            spacing: 10
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                text: flyDel.glyph || FluentIcons.Placeholder
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 14
                                color: flyDel.highlighted ? Theme.textPrimary : Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 30
                                text: flyDel.title
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                            }
                        }

                        background: Item {
                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: 2
                                anchors.rightMargin: 2
                                anchors.topMargin: 1
                                anchors.bottomMargin: 1
                                radius: Theme.cornerControl
                                color: {
                                    if (flyDel.down)
                                        return Theme.fillSubtleTertiary
                                    if (flyDel.highlighted || flyDel.hovered)
                                        return Theme.fillSubtle
                                    return "transparent"
                                }
                            }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.leftMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                                width: 3
                                height: flyDel.highlighted ? 16 : 0
                                radius: 1.5
                                color: Theme.accent
                                Behavior on height {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation {
                                        duration: Theme.duration(Theme.motionNormal)
                                        easing.type: Theme.easingStandard
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
