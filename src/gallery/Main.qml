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
    geometryPersistenceKey: "GalleryMain"

    // 1.13 — mirror high-traffic chrome when app layoutDirection is RTL
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property var navModel: buildNavModel()
    property var searchResults: []
    property var paneSearchModel: buildPaneSearchModel()

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
            icon: FluentIcons.Home,
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
                icon: cat.icon || FluentIcons.FolderOpen,
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

    header: StandardTitleChrome {
        id: platformTitle
        targetWindow: window
        showCaptionButtons: window.showCaptionButtons
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize
        showClose: window.showClose
        preferredHeightOption: window.preferredHeightOption

        title: qsTr("QWinUI3 Gallery")
        subtitle: qsTr("Fluent / WinUI 3 controls")
        symbol: FluentIcons.Home
        isPaneToggleButtonVisible: true
        isBackButtonVisible: nav.canGoBack
        isBackButtonEnabled: nav.canGoBack
        searchModel: window.searchResults
        onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
        onBackRequested: nav.navigateBack()
        onSearchTextEdited: function (text) {
            window.searchResults = ControlCatalog.search(text)
        }
        onSearchActivated: function (item) {
            window.navigateToControl(item, "center")
        }

        rightHeader: FrameStatsBadge { }
    }

    FrameStatsOverlay {
        anchors.fill: parent
    }

    Component.onCompleted: {
        FrameStatsMonitor.attachWindow(window)
        Qt.callLater(function () { platformTitle.reportHitTest() })
    }

    NavigationView {
        id: nav
        anchors.fill: parent
        model: window.navModel
        headerText: qsTr("QWinUI3")
        footerText: qsTr("Settings")
        footerIcon: FluentIcons.Settings
        footerComponent: "SettingsPage"
        pageModule: "QWinUI3.Gallery"
        currentKey: "home"
        paneDisplayMode: "auto"
        pageCacheLimit: 24
        initialPageTransition: "none"
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
                platformTitle.searchText = text
        }
        onPageOpened: function (name) {
            GalleryHistory.recordVisit(name)
            var p = nav.pageItem
            if (p && p.componentId !== undefined)
                p.componentId = name
        }
    }

    // HomePage featured / recent cards emit these; reconnect when the stack page changes.
    Connections {
        target: nav.pageItem
        ignoreUnknownSignals: true
        function onOpenControl(item) { window.navigateToControl(item) }
        function onOpenSettings() { nav.selectFooter() }
    }

    // Gallery shell alias for Settings / pages
    property alias pageTransition: nav.pageTransition
    property alias pageTransitionModes: nav.pageTransitionModes
    property alias navigationView: nav

    // Load Theme knobs at startup (Settings page is created later).
    property ThemePrefs themePrefs: ThemePrefs {
        category: "GalleryTheme"
        autoLoad: true
        autoSave: true
    }
}
