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

    property var navModel: buildMinimalNavModel()
    property var searchResults: []
    property var paneSearchModel: buildPaneSearchModel()
    property bool _fullNavReady: false

    function buildMinimalNavModel() {
        return [{
            type: "item",
            key: "home",
            title: qsTr("Home"),
            icon: FluentIcons.Home,
            component: "HomePage",
            description: qsTr("Gallery home")
        }]
    }

    function ensureFullNavModel() {
        if (_fullNavReady)
            return
        _fullNavReady = true
        navModel = buildNavModel()
        paneSearchModel = buildPaneSearchModel()
        // Explicit rebuild — model assignment alone can miss a rail refresh on some timings.
        nav.rebuildNavModel()
    }

    function refreshNavForLocale() {
        ControlCatalog.invalidateControls()
        if (_fullNavReady) {
            navModel = buildNavModel()
            paneSearchModel = buildPaneSearchModel()
            nav.rebuildNavModel()
        } else {
            navModel = buildMinimalNavModel()
            paneSearchModel = buildPaneSearchModel()
        }
    }

    Connections {
        target: GalleryLanguage
        function onCurrentLocaleChanged() {
            window.refreshNavForLocale()
        }
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
            icon: FluentIcons.Home,
            component: "HomePage",
            description: qsTr("Gallery home")
        })
        for (var c = 0; c < ControlCatalog.categories.length; ++c) {
            var cat = ControlCatalog.categories[c]
            var children = []
            var list = ControlCatalog.controlsForRail(cat.key)
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
            // Badge count on Charts — rail-visible entries only.
            if (cat.key === "charts" && children.length > 0)
                entry.badgeValue = children.length
            items.push(entry)
        }
        return items
    }

    function navigateToControl(item, mode) {
        if (!item)
            return
        ensureFullNavModel()
        var m = mode || "slide"
        var transition = (m === "center") ? "center" : m
        if (item.component) {
            // Prefer rail selection so the left pip tracks search / featured jumps.
            var anchor = ControlCatalog.railAnchorComponent(item.component)
            var key = nav.keyForComponent(anchor.length ? anchor : item.component)
            if (key.length) {
                nav.selectKey(key, transition, item.component)
                return
            }
            if (m === "center")
                nav.openFromCenter(item.component)
            else
                nav.openPage(item.component, m)
            return
        }
        if (item.title)
            nav.navigateToTitle(item.title, transition)
    }

    function openSettingsPage() {
        if (nav.footerSelected)
            nav.openPage("SettingsPage")
        else
            nav.selectFooter()
        Qt.callLater(function () {
            if (window)
                window.refreshTitleBarHitTest()
        })
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
        isPaneToggleButtonVisible: nav.hasLeftRail
        isBackButtonVisible: nav.hasLeftRail
        isBackButtonEnabled: nav.canGoBack
        searchModel: window.searchResults
        searchPlaceholder: qsTr("Search controls")
        onPaneToggleRequested: {
            window.ensureFullNavModel()
            nav.togglePane()
        }
        onBackRequested: nav.navigateBack()
        onSearchTextEdited: function (text) {
            if (text && text.length)
                window.ensureFullNavModel()
            window.searchResults = ControlCatalog.search(text)
        }
        onSearchActivated: function (item) {
            window.navigateToControl(item, "center")
        }

        leftHeader: TitleBarToolbar {
            IconButton {
                flat: true
                microMotionEnabled: false
                iconSize: 14
                symbol: FluentIcons.Home
                Accessible.name: qsTr("Home")
                ToolTip.text: qsTr("Home")
                ToolTip.visible: hovered
                onClicked: {
                    if (nav.footerSelected || nav.currentKey !== "home")
                        nav.selectKey("home")
                    else
                        nav.openPage("HomePage")
                }
            }
            IconButton {
                flat: true
                microMotionEnabled: false
                iconSize: 14
                symbol: FluentIcons.OpenInNewWindow
                Accessible.name: qsTr("Window shells")
                ToolTip.text: qsTr("Window shells")
                ToolTip.visible: hovered
                onClicked: {
                    window.ensureFullNavModel()
                    var item = ControlCatalog.findByComponent("WindowParadigmPage")
                    if (item)
                        window.navigateToControl(item, "slide")
                }
            }
            IconButton {
                flat: true
                microMotionEnabled: false
                iconSize: 14
                symbol: FluentIcons.Color
                Accessible.name: qsTr("Design")
                ToolTip.text: qsTr("Theme & design")
                ToolTip.visible: hovered
                onClicked: window.openSettingsPage()
            }
        }

        captionRightHeader: Row {
            spacing: 4
            FrameStatsBadge { }
            IconButton {
                flat: true
                microMotionEnabled: false
                iconSize: 14
                symbol: FluentIcons.Settings
                Accessible.name: qsTr("Settings")
                ToolTip.text: qsTr("Settings")
                ToolTip.visible: hovered
                onClicked: window.openSettingsPage()
            }
            onWidthChanged: Qt.callLater(function () {
                if (window)
                    window.refreshTitleBarHitTest()
            })
            onChildrenChanged: Qt.callLater(function () {
                if (window)
                    window.refreshTitleBarHitTest()
            })
        }
    }

    FrameStatsOverlay {
        anchors.fill: parent
    }

    Component.onCompleted: {
        FrameStatsMonitor.attachWindow(window)
        Qt.callLater(function () {
            if (window)
                window.refreshTitleBarHitTest()
        })
    }

    Connections {
        target: FrameStatsMonitor
        function onChanged() { window.refreshTitleBarHitTest() }
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
        compactPaneStyle: "labeled"
        pageCacheLimit: 24
        initialPageTransition: "none"
        isPaneSearchEnabled: true
        paneSearchPlaceholder: qsTr("Search controls")
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
        onPaneSearchTextEdited: function (text) {
            if (text && text.length)
                window.ensureFullNavModel()
        }
        onPaneOpenChanged: {
            if (paneOpen)
                window.ensureFullNavModel()
        }
        onPageOpened: function (name) {
            GalleryHistory.recordVisit(name)
            var p = nav.pageItem
            if (p && p.componentId !== undefined)
                p.componentId = name
        }
    }

    CommandPaletteHost {
        id: galleryPaletteHost
        enabled: true
        commands: []
    }

    // Defer catalog parse one frame (S1); then always populate the left rail.
    Timer {
        interval: 0
        running: true
        repeat: false
        onTriggered: {
            ensureFullNavModel()
            galleryPaletteHost.commands = [
                {
                    id: "home",
                    title: qsTr("Go to Home"),
                    symbol: FluentIcons.Home,
                    action: function () { nav.selectKey("home") }
                },
                {
                    id: "settings",
                    title: qsTr("Open Settings"),
                    shortcut: "Ctrl+,",
                    symbol: FluentIcons.Settings,
                    action: function () { window.openSettingsPage() }
                },
                {
                    id: "commands-help",
                    title: qsTr("Command palette help"),
                    symbol: FluentIcons.Library,
                    action: function () {
                        var item = ControlCatalog.findByComponent("CommandPalettePage")
                        if (item)
                            window.navigateToControl(item, "slide")
                    }
                }
            ]
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
