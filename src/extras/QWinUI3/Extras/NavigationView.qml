import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QWinUI3.Theme

Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property bool paneOpen: true
    property real paneWidth: Theme.navPaneWidth
    property real paneCompactWidth: Theme.navPaneCompactWidth
    property string headerText: qsTr("QWinUI3")
    property string footerText: qsTr("Settings")
    property string footerIcon: "\uE713"
    property string footerComponent: ""
    property string pageModule: "QWinUI3.Gallery"
    property bool footerSelected: false
    // WinUI PaneDisplayMode: left | leftCompact | top
    property string paneDisplayMode: "left"
    property bool isBackButtonVisible: false
    property bool isBackEnabled: true

    // groupKey -> bool; missing means expanded
    property var expandedMap: ({})
    property string currentKey: "home"
    property string pendingMode: "slide" // "slide" | "center"
    property real _enterX: 0
    property real _exitX: 0
    property real _enterScale: 1
    property real _exitScale: 1

    signal footerClicked()
    signal itemClicked(int index)
    signal pageOpened(string name)
    signal backRequested()

    readonly property real _paneWidth: {
        if (paneDisplayMode === "top")
            return 0
        if (paneDisplayMode === "leftCompact")
            return paneCompactWidth
        return paneOpen ? paneWidth : paneCompactWidth
    }
    readonly property alias pageItem: pageStack.currentItem

    onPaneDisplayModeChanged: {
        if (paneDisplayMode === "leftCompact" || paneDisplayMode === "top")
            paneOpen = false
        else if (paneDisplayMode === "left")
            paneOpen = true
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
                    glyph: it.icon || "\uE8F4",
                    expanded: root.isGroupExpanded(gkey)
                })
            } else if (it.type === "header") {
                navModel.append({
                    kind: "header",
                    key: "header_" + i,
                    modelIndex: i,
                    title: it.title || "",
                    glyph: "",
                    expanded: false
                })
            } else {
                navModel.append({
                    kind: "item",
                    key: it.key || ("item_" + i),
                    modelIndex: i,
                    title: it.title || "",
                    glyph: it.icon || "\uE8A7",
                    expanded: false
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
        if (pageStack.depth === 0 && root.currentComponent)
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
                    glyph: ch.icon || "\uE8A7",
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
        var maxY = Math.max(8, root.height - Math.min(flyoutModel.count * Theme.navItemHeight + 20, root.height - 16))
        compactFlyout.y = Math.max(8, Math.min(p.y, maxY))
        compactFlyout.open()
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
    }

    function selectFooter(mode) {
        footerSelected = true
        footerClicked()
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
        if (name) {
            // Resolve key if a component name was passed while selecting
            var m = root.model || []
            for (var i = 0; i < m.length; ++i) {
                var it = m[i]
                if (it && it.type === "group" && it.children) {
                    var gkey = it.key || ("group_" + i)
                    for (var j = 0; j < it.children.length; ++j) {
                        if (it.children[j].component === name) {
                            footerSelected = false
                            currentKey = gkey + "/" + j
                            setGroupExpanded(gkey, true)
                            openPage(name, "center")
                            return
                        }
                    }
                } else if (it && it.component === name) {
                    footerSelected = false
                    currentKey = it.key || ("item_" + i)
                    openPage(name, "center")
                    return
                }
            }
            openPage(name, "center")
        }
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
        openPage(root.currentComponent, "slide")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: topPane
            visible: root.paneDisplayMode === "top"
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
                        text: "\uE72B"
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
                    ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

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
                            text: root.footerIcon
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

        Rectangle {
            id: pane
            visible: root.paneDisplayMode !== "top"
            Layout.preferredWidth: visible ? root._paneWidth : 0
            Layout.fillHeight: true
            color: Theme.bgAcrylic
            clip: true

            Behavior on Layout.preferredWidth {
                enabled: !Theme.reducedMotion
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
                            text: "\uE72B"
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
                    visible: root.paneDisplayMode === "left"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    text: root.paneOpen ? root.headerText : ""
                    onClicked: root.paneOpen = !root.paneOpen
                    ToolTip.visible: !root.paneOpen && hovered
                    ToolTip.text: root.paneOpen ? qsTr("Collapse") : qsTr("Expand")

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: "\uE700"
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
                    visible: root.paneDisplayMode === "leftCompact"
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
                        keyNavigationEnabled: false
                        ScrollBar.vertical: ScrollBar {
                            policy: navList.contentHeight > navList.height
                                    ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        }

                        onCurrentIndexChanged: Qt.callLater(function () {
                            selectionPip.moveToCurrent(false)
                        })
                        onContentYChanged: selectionPip.syncViewport()
                        onHeightChanged: selectionPip.syncViewport()
                        onCountChanged: Qt.callLater(function () {
                            selectionPip.moveToCurrent(true)
                        })

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
                                            text: del.glyph || "\uE8A7"
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
                                        Text {
                                            visible: root.paneOpen && del.kind === "group"
                                            text: "\uE70D"
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
                                                    text: (childRow.modelData && childRow.modelData.icon)
                                                          ? childRow.modelData.icon : "\uE8A7"
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
                                return
                            }
                            var target = contentYForSelection()
                            if (target < 0) {
                                Qt.callLater(function () { moveToCurrent(instant) })
                                return
                            }
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

                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    height: 1
                    color: Theme.strokeDivider
                }

                ItemDelegate {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.navItemHeight
                    highlighted: root.footerSelected
                    onClicked: root.selectFooter("slide")
                    ToolTip.visible: !root.paneOpen && hovered
                    ToolTip.text: root.footerText

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: root.footerIcon
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

        StackView {
            id: pageStack
            Layout.fillWidth: true
            Layout.fillHeight: true
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
        implicitHeight: Math.min(flyoutList.contentHeight + topPadding + bottomPadding,
                                 Math.max(120, root.height - 16))

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
            implicitHeight: flyoutList.contentHeight

            HoverHandler {
                onHoveredChanged: {
                    root.flyoutHovered = hovered
                    if (hovered)
                        flyoutCloseTimer.stop()
                    else
                        root.requestCloseCompactFlyout()
                }
            }

            ListView {
                id: flyoutList
                anchors.fill: parent
                clip: true
                spacing: 2
                model: flyoutModel
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {
                    policy: flyoutList.contentHeight > flyoutList.height
                            ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
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

                    contentItem: Text {
                        text: flyDel.title
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
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
