import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: qsTr("QWinUI3 Gallery")
    backdrop: WindowHelper.BackdropSolid

    property var navModel: buildNavModel()
    property var searchResults: []
    property var paneSearchModel: buildPaneSearchModel()

    function syncAccessibility() {
        if (!Theme.followSystemAccessibility)
            return
        WindowHelper.refreshAccessibility()
        Theme.reducedMotion = WindowHelper.systemReducedMotion
        Theme.highContrast = WindowHelper.systemHighContrast
    }

    function syncColorScheme() {
        if (!Theme.followSystemColorScheme)
            return
        WindowHelper.refreshColorScheme()
        Theme.dark = WindowHelper.systemPrefersDark
    }

    function buildPaneSearchModel() {
        var out = []
        var m = navModel || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                for (var j = 0; j < it.children.length; ++j) {
                    var ch = it.children[j]
                    out.push({
                        key: (it.key || "") + "/" + j,
                        title: ch.title || "",
                        component: ch.component || ""
                    })
                }
            } else if (it.type !== "header") {
                out.push({
                    key: it.key || ("item_" + i),
                    title: it.title || "",
                    component: it.component || ""
                })
            }
        }
        return out
    }

    function buildNavModel() {
        var items = []
        items.push({
            type: "item",
            key: "home",
            title: qsTr("Home"),
            icon: "\uE80F",
            component: "HomePage",
            description: qsTr("Gallery home")
        })
        for (var c = 0; c < ControlCatalog.categories.length; ++c) {
            var cat = ControlCatalog.categories[c]
            var children = []
            var list = ControlCatalog.controlsInCategory(cat.key)
            for (var i = 0; i < list.length; ++i) {
                var ctrl = list[i]
                children.push({
                    type: "item",
                    title: ctrl.title,
                    icon: ctrl.icon,
                    description: ctrl.description || "",
                    category: ctrl.category,
                    component: ctrl.component
                })
            }
            var entry = {
                type: "group",
                key: cat.key,
                title: cat.title,
                icon: cat.icon || "\uE8F4",
                children: children
            }
            // Badge count on Charts as a Gallery demo of InfoBadge in the rail.
            if (cat.key === "charts")
                entry.badgeValue = children.length
            items.push(entry)
        }
        return items
    }

    function navigateToControl(item, mode) {
        if (!item)
            return
        if (mode === "center")
            nav.openFromCenter(item.component)
        else
            nav.navigateToTitle(item.title, mode || "slide")
    }

    header: PlatformTitleBar {
        id: platformTitle
        targetWindow: window
        showCaptionButtons: window.showCaptionButtons
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize
        showClose: window.showClose
        preferredHeightOption: window.preferredHeightOption

        TitleBar {
            id: titleBar
            anchors.fill: parent
            embedded: true
            dragWindow: window
            useSystemMove: true
            trailingReserve: 0
            title: qsTr("QWinUI3 Gallery")
            subtitle: qsTr("Fluent / WinUI 3 controls")
            symbol: FluentIcons.Home
            isPaneToggleButtonVisible: true
            searchModel: window.searchResults
            onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
            onSearchTextEdited: function (text) {
                window.searchResults = ControlCatalog.search(text)
            }
            onSearchActivated: function (item) {
                window.navigateToControl(item, "center")
            }
            onWidthChanged: platformTitle.reportHitTest()
            onHeightChanged: platformTitle.reportHitTest()
        }
    }

    Component.onCompleted: {
        window.syncAccessibility()
        window.syncColorScheme()
        Qt.callLater(function () { platformTitle.reportHitTest() })
    }

    Connections {
        target: WindowHelper
        function onAccessibilityChanged() { window.syncAccessibility() }
        function onColorSchemeChanged() { window.syncColorScheme() }
    }

    // Re-check when the window is activated (user may have changed OS a11y settings).
    onActiveChanged: {
        if (active) {
            window.syncAccessibility()
            window.syncColorScheme()
        }
    }

    NavigationView {
        id: nav
        anchors.fill: parent
        model: window.navModel
        headerText: qsTr("QWinUI3")
        footerText: qsTr("Settings")
        footerIcon: "\uE713"
        footerComponent: "SettingsPage"
        pageModule: "QWinUI3.Gallery"
        currentKey: "home"
        paneDisplayMode: "auto"
        isPaneSearchEnabled: true
        paneSearchModel: window.paneSearchModel
        isReorderable: true
        pageTransition: "slide"
        onModelReordered: function (m) {
            window.navModel = m
            window.paneSearchModel = window.buildPaneSearchModel()
        }
        onPaneSearchActivated: function (text) {
            // SearchBox suggestion path already selects keys when present.
            if (text)
                titleBar.searchText = text
        }
    }

    // Gallery shell alias for Settings / pages
    property alias pageTransition: nav.pageTransition
    property alias pageTransitionModes: nav.pageTransitionModes
    property alias navigationView: nav
}
