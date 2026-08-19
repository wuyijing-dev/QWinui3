import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// NavigationWindow — ShellWindow hosting NavigationView + content.
//
//   // Simple hostContent slot:
//   NavigationWindow {
//       navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
//       content: Label { text: "Hello" }
//   }
//
//   // Gallery-style pageModule shell (1.50):
//   NavigationWindow {
//       geometryPersistenceKey: "MyAppMain"
//       hostContent: false
//       pageModule: "MyApp"
//       footerText: qsTr("Settings")
//       footerComponent: "SettingsPage"
//       navModel: [{ key: "home", title: qsTr("Home"),
//                    symbol: FluentIcons.Home, component: "HomePage" }]
//   }
//
//   // --- API ---
//   // signals: onNavActivated, onFooterClicked, onPaneSearchActivated
//   // methods: clearNav(), addNavItem(item), addNavGroup(group), selectNavKey(key), navigateBack()
//   // inherits ShellWindow (+ Qt Quick Controls base API)
//
// @notes
//   ShellWindow hosting NavigationView. Default hostContent + content slot;
//   set hostContent: false + pageModule for StackView pages (Gallery / examples/gallery-shell).

ShellWindow {
    id: root
    // Prefer Solid for product shells (Gallery / examples). Mica still works on Windows via backdrop.
    backdrop: WindowHelper.BackdropSolid
    // Navigation pane expanded
    property alias paneOpen: nav.paneOpen
    // Expanded pane width
    property alias paneWidth: nav.paneWidth
    // NavigationWindow pane header text
    property alias paneHeaderText: nav.headerText
    // When true, pane stays open across auto/scrim dismiss (2.56)
    property alias isPanePinned: nav.isPanePinned
    // Width below which auto mode uses leftMinimal overlay drawer
    property alias autoMinimalThreshold: nav.autoMinimalThreshold
    // left | leftCompact | leftMinimal | top | auto
    property alias paneDisplayMode: nav.paneDisplayMode
    // Selected navigation key
    property alias currentKey: nav.currentKey
    // Content slot / children host (when hostContent)
    property alias content: nav.content
    // NavigationView model
    property alias navModel: nav.model
    // Enable back button
    property alias isBackEnabled: nav.isBackEnabled
    // Show back in the pane
    property alias isPaneBackButtonVisible: nav.isBackButtonVisible
    // Show pane SearchBox
    property alias isPaneSearchEnabled: nav.isPaneSearchEnabled
    // Pane SearchBox text
    property alias paneSearchText: nav.paneSearchText
    // Pane search suggestion model
    property alias paneSearchModel: nav.paneSearchModel
    // Custom pane header slot
    property alias paneHeader: nav.paneHeader
    // Custom pane footer slot
    property alias paneFooter: nav.paneFooter
    // Footer row label
    property alias footerText: nav.footerText
    // Footer FluentIcons symbol
    property alias footerSymbol: nav.footerSymbol
    // Footer glyph string fallback
    property alias footerIcon: nav.footerIcon
    // Footer page component
    property alias footerComponent: nav.footerComponent
    // QML module URI for page components (1.50)
    property alias pageModule: nav.pageModule
    // true = content slot; false = StackView via pageModule (Gallery pattern)
    property alias hostContent: nav.hostContent
    // Page enter transition name
    property alias pageTransition: nav.pageTransition
    // First openPage transition (default none — 1.39 cold start)
    property alias initialPageTransition: nav.initialPageTransition
    // LRU page Component cache cap (0 = unlimited)
    property alias pageCacheLimit: nav.pageCacheLimit
    // Cached page Component hits (diagnostics — 2.18)
    readonly property alias pageCacheHits: nav.pageCacheHits
    // Entries in page Component cache
    readonly property alias pageCacheCount: nav.pageCacheCount
    // selectKey skips when destination already selected (2.28)
    readonly property alias sameKeySkipCount: nav.sameKeySkipCount
    // openPage skips when same component already open (2.28)
    readonly property alias samePageSkipCount: nav.samePageSkipCount
    // TitleBar / pane can go back
    readonly property alias canGoBack: nav.canGoBack
    // Bind TitleBar isBackButtonVisible to these — not a static true (2.56)
    readonly property alias effectiveBackVisible: nav.effectiveBackVisible
    readonly property alias effectiveBackEnabled: nav.effectiveBackEnabled
    // Mirror last breadcrumb segment into ShellWindow.subtitle (2.23)
    property bool syncSubtitleFromNavigation: false

    // Emitted when a nav item is activated
    signal navActivated(var item)
    // Footer row clicked
    signal footerClicked()
    // Pane search accepted
    signal paneSearchActivated(string text)

    width: 960
    height: 640
    title: qsTr("Navigation window")
    subtitle: qsTr("Left pane shell")
    symbol: FluentIcons.GlobalNavButton
    showPaneToggle: true
    footerText: ""
    footerComponent: ""
    isBackButtonVisible: nav.canGoBack
    isBackButtonEnabled: nav.canGoBack

    onPaneToggleRequested: nav.togglePane()
    onPaneDisplayModeChanged: _syncPaneToggle()
    onBackRequested: nav.navigateBack()
    Component.onCompleted: {
        _syncPaneToggle()
        _syncBreadcrumbSubtitle()
    }

    // TitleBar back (ShellWindow) + NavigationView pane back -> backRequested
    Connections {
        target: nav
        // Forward NavigationView back request
        function onBackRequested() { root.backRequested() }
        // Forward footer click
        function onFooterClicked() { root.footerClicked() }
        // Forward pane search activation
        function onPaneSearchActivated(text) { root.paneSearchActivated(text) }
    }

    function _syncPaneToggle() {
        showPaneToggle = paneDisplayMode !== "top"
    }

    // Clear navigation model
    function clearNav() {
        navModel = []
        nav.currentKey = ""
    }

    // Append a navigation item
    function addNavItem(item) {
        if (!item)
            return ""
        var m = navModel || []
        var entry = {
            "type": "item",
            "key": item.key || ("item_" + m.length),
            "title": item.title || qsTr("Item"),
            "symbol": item.symbol || "",
            "icon": item.icon || "",
            "component": item.component || ""
        }
        var next = m.length ? m.slice() : []
        next.push(entry)
        navModel = next
        if (!nav.currentKey.length)
            nav.currentKey = entry.key
        return entry.key
    }

    // Append a navigation group
    function addNavGroup(group) {
        if (!group)
            return ""
        var m = navModel || []
        var children = []
        var src = group.children || []
        for (var i = 0; i < src.length; ++i) {
            var ch = src[i] || {}
            children.push({
                "type": "item",
                "key": ch.key || "",
                "title": ch.title || qsTr("Item"),
                "symbol": ch.symbol || "",
                "icon": ch.icon || "",
                "component": ch.component || ""
            })
        }
        var entry = {
            "type": "group",
            "key": group.key || ("group_" + m.length),
            "title": group.title || qsTr("Group"),
            "symbol": group.symbol || FluentIcons.Library,
            "icon": group.icon || "",
            "children": children
        }
        var next = m.length ? m.slice() : []
        next.push(entry)
        navModel = next
        return entry.key
    }

    // Forward selection to the hosted NavigationView
    function selectNavKey(key) {
        if (!key)
            return
        nav.selectKey(key, "slide")
    }

    // Restore previous page (TitleBar Back)
    function navigateBack(mode) {
        return nav.navigateBack(mode)
    }

    // In-page drill with soft history (2.56)
    function navigateToPage(name, mode) {
        nav.navigateToPage(name, mode)
    }

    // Drop cached page Components (keeps current page by default)
    function clearPageCache(keepCurrent) {
        nav.clearPageCache(keepCurrent)
    }

    // Breadcrumb helpers — forward to hosted NavigationView (2.23)
    function breadcrumbPathForKey(key) {
        return nav.breadcrumbPathForKey(key || nav.currentKey)
    }

    function breadcrumbModelForKey(key) {
        return nav.breadcrumbModelForKey(key || nav.currentKey)
    }

    function selectBreadcrumbIndex(index, mode) {
        nav.selectBreadcrumbIndex(index, mode)
    }

    function _syncBreadcrumbSubtitle() {
        if (!syncSubtitleFromNavigation)
            return
        var path = nav.breadcrumbPathForKey(nav.currentKey)
        if (path.length)
            root.subtitle = path[path.length - 1].title || root.subtitle
    }

    function _findNavItem(key) {
        var m = navModel || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    var child = it.children[j]
                    var ck = child.key || (gkey + "/" + j)
                    if (ck === key || (gkey + "/" + j) === key)
                        return child
                }
            } else if ((it.key || ("item_" + i)) === key) {
                return it
            }
        }
        return null
    }

    WindowShellContentClip {
        id: shellClip
        anchors.fill: parent
        targetWindow: root

        NavigationView {
            id: nav
            anchors.fill: parent
            hostContent: true
            model: []
            headerText: qsTr("Navigation")
            footerText: ""
            footerComponent: ""
            pageModule: ""
            currentKey: "home"
            paneDisplayMode: "left"

            onItemClicked: {
                var item = root._findNavItem(nav.currentKey)
                if (item)
                    root.navActivated(item)
                root._syncBreadcrumbSubtitle()
            }
            onCurrentKeyChanged: root._syncBreadcrumbSubtitle()
            onFooterSelectedChanged: root._syncBreadcrumbSubtitle()
        }
    }
}
