import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// Left NavigationView + content. Prefer declarative navModel:
//
//   NavigationWindow {
//       title: qsTr("App")
//       paneDisplayMode: "left"   // left | leftCompact | top
//       isBackButtonVisible: true
//       footerText: qsTr("Settings")
//       navModel: [
//           { key: "home", title: qsTr("Home"), symbol: FluentIcons.Home }
//       ]
//       content: Label { anchors.centerIn: parent; text: "Content" }
//       onNavActivated: (item) => { }
//       onBackRequested: { }
//       onFooterClicked: { }
//   }
ShellWindow {
    id: root

    property alias paneOpen: nav.paneOpen
    property alias paneWidth: nav.paneWidth
    property alias paneHeaderText: nav.headerText
    property alias paneDisplayMode: nav.paneDisplayMode
    property alias currentKey: nav.currentKey
    property alias content: nav.content
    property alias navModel: nav.model
    property alias isBackEnabled: nav.isBackEnabled
    property alias isPaneBackButtonVisible: nav.isBackButtonVisible
    property alias isPaneSearchEnabled: nav.isPaneSearchEnabled
    property alias paneSearchText: nav.paneSearchText
    property alias paneSearchModel: nav.paneSearchModel
    property alias paneHeader: nav.paneHeader
    property alias paneFooter: nav.paneFooter
    property alias footerText: nav.footerText
    property alias footerSymbol: nav.footerSymbol
    property alias footerIcon: nav.footerIcon
    property alias footerComponent: nav.footerComponent

    signal navActivated(var item)
    signal footerClicked()
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

    // TitleBar back (ShellWindow) + NavigationView pane back → backRequested
    Connections {
        target: nav
        function onBackRequested() { root.backRequested() }
        function onFooterClicked() { root.footerClicked() }
        function onPaneSearchActivated(text) { root.paneSearchActivated(text) }
    }

    function _syncPaneToggle() {
        showPaneToggle = paneDisplayMode !== "top"
    }

    function clearNav() {
        navModel = []
        nav.currentKey = ""
    }

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
