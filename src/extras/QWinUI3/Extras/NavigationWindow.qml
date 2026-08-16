import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// NavigationWindow — ShellWindow hosting NavigationView + content.
//
//   NavigationWindow {
//       id: navigationWindow
//       title: qsTr("App")
//       paneDisplayMode: "left"
//       navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
//       content: Label { text: "Hello" }
//   }
//
//   // --- API ---
//   // signals: onNavActivated, onFooterClicked, onPaneSearchActivated
//   // methods: clearNav(), addNavItem(item), addNavGroup(group), selectNavKey(key)
//   // navigationWindow.clearNav()
//   // navigationWindow.addNavItem(item)
//   // navigationWindow.addNavGroup(group)
//   // navigationWindow.selectNavKey(key)
//   // inherits ShellWindow (+ Qt Quick Controls base API)
//
// @notes
//   ShellWindow hosting NavigationView with hostContent.
//   Wire navModel / paneDisplayMode; content goes in the NavigationView content slot.

ShellWindow {
    id: root
    // Navigation pane expanded
    property alias paneOpen: nav.paneOpen
    // Expanded pane width
    property alias paneWidth: nav.paneWidth
    // NavigationWindow pane header text
    property alias paneHeaderText: nav.headerText
    // left | leftCompact | leftMinimal | top | auto
    property alias paneDisplayMode: nav.paneDisplayMode
    // Selected navigation key
    property alias currentKey: nav.currentKey
    // Content slot / children host
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

    onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
    onPaneDisplayModeChanged: _syncPaneToggle()
    Component.onCompleted: _syncPaneToggle()

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
        }
    }
}
