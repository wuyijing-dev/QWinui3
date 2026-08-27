import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtCore
import QWinUI3.Theme

// NavigationView — WinUI NavigationView with pane modes and page stack.
//
//   NavigationView {
//       id: nav
//       anchors.fill: parent
//       paneDisplayMode: "auto"
//       paneAppearance: "standard"   // standard | minimal | branded
//       model: navModel
//       isPaneSearchEnabled: true
//       pageModule: "MyApp"
//       pinnedPageCache: ["HomePage", "SettingsPage"]
//       onItemClicked: (index) => { /* … */ }
//       onPageOpened: (name) => { /* … */ }
//       onBackRequested: { /* … */ }
//   }
//
//   // --- API ---
//   // navigate: nav.selectKey("home"), nav.selectFooter(), nav.openPage("HomePage")
//   //           nav.reloadPage()  // force rebuild current page with transition
//   // Same-key / same-page clicks skip StackView replace + pageTransition.
//   //           nav.openSlide("HomePage"), nav.openFromCenter("HomePage")
//   //           nav.openFade("HomePage"), nav.openDrill("HomePage")
//   //           nav.navigateToTitle("Home"), nav.reloadPage()
//   //           nav.navigateToPage("DetailPage", "drill")  // in-page drill + history (2.56)
//   //           nav.pushDrilldown(title, component) / popDrilldown()  // 3.04 N3
//   //           nav.clearPageCache()  // drop cached page Components (keep current)
//   // groups:   nav.toggleGroup(key), nav.setGroupExpanded(key, true)
//   // pins:     nav.pinNavKey(key), nav.toggleNavPin(key)  // 3.04 N1
//   // jump:     jumpListEnabled + nav.openJumpList()  // 3.04 N2
//   // pane:     nav.togglePane()  // TitleBar hamburger; no-op when too narrow
//   //           compactPaneStyle "iconOnly" | "labeled"
//   // reorder:  nav.moveNavItem(from, to)   // requires isReorderable
//   // patch:     nav.patchNavItem("home", { badge: "3", title: "Home" })  // incremental — 2.88 C9
//   // signals:  onItemClicked, onPageOpened, onFooterClicked, onBackRequested,
//   //           onPaneSearchActivated, onPaneSearchTextEdited, onModelReordered
//   // footer:    footerBadge / footerBadgeValue on settings row
//   // search:    paneSearchHighlightQuery highlights matching nav titles while typing
//
// @notes
//   model entries: type "item"|"group"|"header"; groups use children[].
//   pageModule + component names load StackView pages (unless hostContent).
//   Pages compile on first open — not at shell startup; pageCacheLimit LRU (1.39).
//   paneAppearance: standard | minimal | branded (logo band + footer chrome — 2.68).
//   pinnedPageCache + pageCacheMemoryAware weighted LRU (2.68 C3).
//   initialPageTransition defaults to "none" for a snappy first paint.
//   paneDisplayMode auto: left → leftCompact → leftMinimal (drawer) by width.
//   leftMinimal / compact drawer overlay content with a light-dismiss scrim (Calculator-like).
//   Left-rail title bar is hamburger + paneTitle (paired); Back is top mode / TitleBar.
//   pageTransition / openPage modes: slide | slideRight | fade | center | drill |
//   up | down | cover | none (suppress). Pane clicks use pageTransition.
//   WinUI aliases: paneTitle, openPaneLength, compactPaneLength, isSettingsVisible, isPaneToggleButtonVisible.
//   compactPaneStyle: "iconOnly" (WinUI) | "labeled" (Store — icon above caption).
//   togglePane() — TitleBar hamburger; leftCompact expands inline or opens a drawer
//   when the window is too narrow; leftMinimal opens the overlay drawer.
//   Prefer selectKey / openPage over mutating currentIndex alone.
//   Live-region announces nav selection / pane expand (2.07) when announceChanges is true.

Item {
    id: root

    Accessible.role: Accessible.Pane
    Accessible.name: root.headerText.length ? root.headerText : qsTr("Navigation")
    Accessible.description: qsTr("Navigation pane and content")
    // Qt 6.8+ Accessible.announce for selection / pane changes (2.07).
    property bool announceChanges: true
    property bool _a11yReady: false
    property bool _pipMoveInstant: false

    Timer {
        id: pipMoveCoalesce
        interval: 16
        repeat: false
        onTriggered: {
            selectionPip.moveToCurrent(_pipMoveInstant)
            _pipMoveInstant = false
        }
    }

    function schedulePipMove(instant) {
        // Last writer wins within the coalesce window. Sticky OR-true used to
        // let onCountChanged/footer snaps cancel a following animated move
        // (selection pip teleported with zero travel).
        _pipMoveInstant = !!instant
        pipMoveCoalesce.restart()
    }

    // Navigation items: [{ type, key, title, icon|symbol, children?, badge?, badgeValue? }]
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Expanded pane when true (left / leftMinimal); compact modes force false
    property bool paneOpen: true
    // WinUI IsPaneOpen alias
    property alias isPaneOpen: root.paneOpen
    // When true, auto mode / scrim will not collapse the pane (2.56)
    property bool isPanePinned: false
    // WinUI IsPaneVisible — hide the navigation pane entirely when false
    property bool isPaneVisible: true
    // WinUI AlwaysShowHeader — show the pane title bar in leftCompact (hamburger + title)
    property bool alwaysShowHeader: false
    // Expanded pane width (WinUI OpenPaneLength)
    property real paneWidth: Theme.navPaneWidth
    property alias openPaneLength: root.paneWidth
    // Compact pane width (WinUI CompactPaneLength)
    property real paneCompactWidth: Theme.navPaneCompactWidth
    property alias compactPaneLength: root.paneCompactWidth
    // Compact rail: "iconOnly" (WinUI) or "labeled" (Store icon-above-caption)
    property string compactPaneStyle: "iconOnly"
    // Pane chrome: "standard" | "minimal" | "branded" (2.68 A5)
    property string paneAppearance: "standard"
    // Logo slot for branded pane (Image / Item children)
    property alias paneLogo: paneLogoHost.data
    // Optional brand title shown next to the logo band
    property string brandedTitle: ""
    // Minimum page width reserved when the left pane is expanded
    property real minContentWidth: 320
    // Pane header title text (WinUI PaneTitle)
    property string headerText: qsTr("QWinUI3")
    property alias paneTitle: root.headerText
    // Footer row label
    property string footerText: qsTr("Settings")
    // Footer FluentIcons symbol
    property var footerSymbol: FluentIcons.Settings
    // Footer glyph string fallback
    property string footerIcon: ""
    // Footer InfoBadge text / numeric count (2.82 D16).
    property string footerBadge: ""
    property real footerBadgeValue: -1
    // Page component name loaded for the footer row (e.g. "SettingsPage")
    property string footerComponent: ""
    // QML import URI used to resolve page components
    property string pageModule: "QWinUI3.Gallery"
    // True when footer row is selected
    property bool footerSelected: false
    // WinUI IsSettingsVisible — show the settings/footer item
    property bool isSettingsVisible: true
    // WinUI IsPaneToggleButtonVisible — left-rail title bar (hamburger + paneTitle as a pair)
    property bool isPaneToggleButtonVisible: false
    // WinUI PaneDisplayMode: left | leftCompact | leftMinimal | top | auto
    property string paneDisplayMode: "left"
    // Width below which auto mode uses leftCompact (icon rail)
    property real autoCompactThreshold: 1008
    // Width below which auto mode uses leftMinimal (overlay drawer — Calculator-like)
    property real autoMinimalThreshold: 640
    // Show back in top pane mode only (left rail uses TitleBar / ShellWindow back)
    property bool isBackButtonVisible: false
    // Enable back button
    property bool isBackEnabled: true
    // Shows SearchBox at the top of the pane when open
    property bool isPaneSearchEnabled: false
    // Pane SearchBox text
    property string paneSearchText: ""
    // Suggestion model for pane SearchBox: [{ title, key?, component? }]
    property var paneSearchModel: []
    // Placeholder for pane SearchBox (product apps: qsTr("Search photos"))
    property string paneSearchPlaceholder: qsTr("Search")
    // Non-empty when pane search should highlight matching nav titles (2.82 D16).
    readonly property string paneSearchHighlightQuery: (isPaneSearchEnabled && paneSearchText.trim().length)
            ? paneSearchText.trim() : ""
    // User-pinnable destinations shown above the pane list (3.04 N1). Keys match model keys.
    property var pinnedNavKeys: []
    property int maxPinnedNavKeys: 8
    // Non-empty → persist pinnedNavKeys in Settings (JSON array).
    property string pinnedNavSettingsCategory: ""
    // Alphabetical / group jump-list flyout (3.04 N2).
    property bool jumpListEnabled: false
    // In-page drill trail beyond the selected nav key (3.04 N3).
    property var drilldownStack: []
    readonly property int drilldownDepth: (drilldownStack && drilldownStack.length) ? drilldownStack.length : 0
    // Bind BreadcrumbBar.model to this so drilldown crumbs refresh (3.04 N3).
    readonly property var breadcrumbTrail: {
        var _d = drilldownDepth
        var _k = currentKey
        var _f = footerSelected
        return breadcrumbModelForKey(_k)
    }
    // Custom pane header slot
    property alias paneHeader: paneHeaderHost.data
    // Custom pane footer slot
    property alias paneFooter: paneFooterHost.data
    // Drag rows to reorder top-level model entries
    property bool isReorderable: false
    // Shell host: show `content:` instead of StackView page loading (NavigationWindow).
    property bool hostContent: false
    // Content slot / children host
    property alias content: contentHost.data
    // Soft navigation history for TitleBar / pane back (replace stack still applies)
    property var pageHistory: []
    property bool _suppressHistory: false
    readonly property bool canGoBack: pageHistory.length > 0 || drilldownDepth > 0
    // TitleBar / ShellWindow: bind isBackButtonVisible to this (not a static true)
    readonly property bool effectiveBackVisible: isBackButtonVisible || canGoBack
    readonly property bool effectiveBackEnabled: isBackEnabled && canGoBack
    // True when a left navigation rail is active (TitleBar chrome)
    readonly property bool hasLeftRail: resolvedPaneMode === "left"
                                       || resolvedPaneMode === "leftCompact"
                                       || resolvedPaneMode === "leftMinimal"
    // Left-rail title bar: hamburger + paneTitle must appear together when shown
    readonly property bool _showPaneTitleBar: {
        if (!isPaneToggleButtonVisible || !isPaneVisible)
            return false
        var mode = resolvedPaneMode
        if (mode === "top")
            return false
        // Compact: no title-only glyph; show the full pair only with AlwaysShowHeader
        if (mode === "leftCompact")
            return alwaysShowHeader
        return true
    }

    // Resolved footer icon
    readonly property string effectiveFooterIcon: IconSource.resolve(footerSymbol, footerIcon)
    // Effective pane mode after auto
    readonly property string resolvedPaneMode: {
        if (paneDisplayMode !== "auto")
            return paneDisplayMode
        if (root.width < autoMinimalThreshold)
            return "leftMinimal"
        if (root.width < autoCompactThreshold)
            return "leftCompact"
        return "left"
    }

    // Room to widen the rail inline (left / leftCompact)
    readonly property bool _canExpandPaneInline: _expandedPaneWidth > _effectiveCompactWidth + 8
            && (_effectiveCompactWidth + _expandedPaneWidth + minContentWidth <= root.width + 1)
    // leftCompact + too narrow for inline expand → overlay drawer over content
    readonly property bool _compactDrawerOverlay: resolvedPaneMode === "leftCompact"
            && paneOpen && !_canExpandPaneInline
    // Overlay drawer active (leftMinimal or compact fallback)
    readonly property bool _paneOverlayActive: (resolvedPaneMode === "leftMinimal" && paneOpen)
            || _compactDrawerOverlay

    // groupKey -> bool; missing means expanded
    property var expandedMap: ({})
    // Selected nav key (supports "group/0" child paths)
    property string currentKey: "home"
    // Default page transition for pane clicks (see openPage modes)
    property string pageTransition: "slide"
    // First openPage from Component.onCompleted (Gallery cold start — 1.39)
    property string initialPageTransition: "none"
    // Last / pending page transition mode
    property string pendingMode: "slide"
    // Last page component successfully shown in pageStack (skip re-animate if same)
    property string _openedPageName: ""
    // Max cached page Components from pageModule (0 = unlimited). LRU eviction (1.39).
    property int pageCacheLimit: 24
    // Page names never evicted by LRU (2.68 C3)
    property var pinnedPageCache: []
    // Weight pinned pages as 2; prefer evicting unpinned oldest first (2.68 C3)
    property bool pageCacheMemoryAware: true
    // Weight budget (0 = derive from pageCacheLimit). Rough MB≈weight units.
    property int pageCacheMemoryBudgetMb: 0
    // Cached Component hits (diagnostics — 2.18).
    property int pageCacheHits: 0
    // Number of entries in the page Component cache
    property int pageCacheCount: 0
    // True when paneAppearance is branded
    readonly property bool _paneBranded: paneAppearance === "branded"
    // True when paneAppearance is minimal (quieter chrome)
    readonly property bool _paneMinimal: paneAppearance === "minimal"
    // selectKey skipped — same nav key already active (diagnostics — 2.28).
    property int sameKeySkipCount: 0
    // openPage skipped — same page component already showing (diagnostics — 2.28).
    property int samePageSkipCount: 0
    // Supported mode ids for Settings / Gallery pickers
    readonly property var pageTransitionModes: [
        "slide", "slideRight", "fade", "center", "drill", "up", "down", "cover", "none"
    ]
    property real _enterX: 0
    property real _exitX: 0
    property real _enterY: 0
    property real _exitY: 0
    property real _enterScale: 1
    property real _exitScale: 1
    property real _enterOpacity: 0
    property real _exitOpacity: 0
    // Per-axis StackView animators — skip no-op x/y/scale on slide/fade (1.87).
    property bool _animOpacity: true
    property bool _animX: false
    property bool _animY: false
    property bool _animScale: false
    property string _typeAhead: ""
    property string _prevResolvedPaneMode: ""
    property int _dragFromIndex: -1

    // Footer row clicked
    signal footerClicked()
    // Emitted when an item is clicked
    signal itemClicked(int index)
    // Page was opened
    signal pageOpened(string name)
    // Emitted when back is requested
    signal backRequested()
    // Pane search accepted
    signal paneSearchActivated(string text)
    // Pane search text changed
    signal paneSearchTextEdited(string text)
    // Emitted after a successful drag-reorder with the new model array
    signal modelReordered(var model)

    readonly property real _effectiveCompactWidth: compactPaneStyle === "labeled"
        ? Math.max(paneCompactWidth, Theme.navPaneLabeledCompactWidth)
        : paneCompactWidth
    readonly property real _maxExpandedPaneWidth: Math.max(_effectiveCompactWidth,
                                                           root.width - minContentWidth)
    readonly property real _expandedPaneWidth: Math.min(paneWidth, _maxExpandedPaneWidth)
    readonly property real _paneWidth: {
        if (resolvedPaneMode === "top")
            return 0
        if (resolvedPaneMode === "leftMinimal")
            return paneOpen ? _expandedPaneWidth : 0
        if (resolvedPaneMode === "leftCompact")
            return paneOpen && _canExpandPaneInline ? _expandedPaneWidth : _effectiveCompactWidth
        return paneOpen ? _expandedPaneWidth : _effectiveCompactWidth
    }
    // leftMinimal / compact drawer overlays content — layout width stays 0.
    readonly property real _paneLayoutWidth: {
        if (!isPaneVisible)
            return 0
        if (resolvedPaneMode === "leftMinimal" || _compactDrawerOverlay)
            return 0
        return _paneWidth
    }
    // Current page item
    readonly property alias pageItem: pageStack.currentItem
    readonly property bool _paneShowsLabels: {
        if (resolvedPaneMode === "top")
            return false
        if (resolvedPaneMode === "leftMinimal")
            return paneOpen
        if (resolvedPaneMode === "leftCompact")
            return paneOpen
        // Follow the animated slot width — flipping labels on paneOpen immediately
        // paints a full row inside a still-compact rail and overflows the page.
        return paneSlot.width >= Math.max(_effectiveCompactWidth + 56, 140)
    }
    readonly property bool _useLabeledCompact: compactPaneStyle === "labeled"
                                               && resolvedPaneMode !== "top"
                                               && !_paneShowsLabels
    readonly property real _railItemHeight: _useLabeledCompact
                                            ? Theme.navItemLabeledCompactHeight
                                            : Theme.navItemHeight
    readonly property bool _minimalOverlay: _paneOverlayActive

    onPaneDisplayModeChanged: _syncPaneOpenForMode()
    onResolvedPaneModeChanged: _syncPaneOpenForMode()

    function _syncPaneOpenForMode() {
        var mode = resolvedPaneMode
        var prev = _prevResolvedPaneMode
        _prevResolvedPaneMode = mode
        if (root.isPanePinned)
            return
        if (mode === "top") {
            paneOpen = false
            return
        }
        if (mode === "leftMinimal" && prev !== "leftMinimal")
            paneOpen = false
        if (mode === "leftCompact" && (prev === "left" || prev === "leftMinimal"))
            paneOpen = false
        // Auto-expand only when crossing into Left from a compact/top rail — not on
        // every width tick (that reopened the pane mid-collapse and left a blank column).
        if (mode === "left" && (prev === "leftCompact" || prev === "top" || prev === "leftMinimal"))
            paneOpen = true
    }

    function _dismissPaneDrawerIfNeeded() {
        if (root.isPanePinned || !root.paneOpen)
            return
        if (root.resolvedPaneMode === "leftMinimal" || root._compactDrawerOverlay)
            root.paneOpen = false
    }

    // Reorder a top-level nav model entry (requires isReorderable)
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

    // Current page component name
    readonly property string currentComponent: {
        if (root.footerSelected)
            return root.footerComponent
        return root.componentForKey(root.currentKey)
    }

    // True when the nav group is expanded
    function isGroupExpanded(key) {
        if (root.expandedMap.hasOwnProperty(key))
            return !!root.expandedMap[key]
        return true
    }

    // Rebuild the flattened ListModel from model
    function _navRowFromSource(it, index) {
        if (!it)
            return null
        if (it.type === "group") {
            var gkey = it.key || ("group_" + index)
            return {
                kind: "group",
                key: gkey,
                modelIndex: index,
                title: it.title || "",
                glyph: IconSource.resolve(it.symbol || "", it.icon || FluentIcons.Library),
                expanded: root.isGroupExpanded(gkey),
                badge: it.badge !== undefined ? it.badge : "",
                badgeValue: it.badgeValue !== undefined ? Number(it.badgeValue) : -1
            }
        }
        if (it.type === "header") {
            return {
                kind: "header",
                key: it.key || ("header_" + index),
                modelIndex: index,
                title: it.title || "",
                glyph: "",
                expanded: false,
                badge: "",
                badgeValue: -1
            }
        }
        return {
            kind: "item",
            key: it.key || ("item_" + index),
            modelIndex: index,
            title: it.title || "",
            glyph: IconSource.resolve(it.symbol || "", it.icon || FluentIcons.Placeholder),
            expanded: false,
            badge: it.badge !== undefined ? it.badge : "",
            badgeValue: it.badgeValue !== undefined ? Number(it.badgeValue) : -1
        }
    }

    function _collectNavRows(m) {
        var rows = []
        m = m || []
        for (var i = 0; i < m.length; ++i) {
            var row = _navRowFromSource(m[i], i)
            if (row)
                rows.push(row)
        }
        return rows
    }

    function _applyNavRowPatch(listIndex, row) {
        var cur = navModel.get(listIndex)
        if (cur.title !== row.title)
            navModel.setProperty(listIndex, "title", row.title)
        if (cur.glyph !== row.glyph)
            navModel.setProperty(listIndex, "glyph", row.glyph)
        if (cur.badge !== row.badge)
            navModel.setProperty(listIndex, "badge", row.badge)
        if (cur.badgeValue !== row.badgeValue)
            navModel.setProperty(listIndex, "badgeValue", row.badgeValue)
        if (cur.kind === "group" && cur.expanded !== row.expanded)
            navModel.setProperty(listIndex, "expanded", row.expanded)
    }

    // Incremental ListModel sync when structure (keys/kinds/order) is unchanged — 2.88 C9.
    function _syncNavModelIncremental() {
        var rows = _collectNavRows(root.model)
        if (rows.length !== navModel.count)
            return false
        for (var i = 0; i < rows.length; ++i) {
            var row = rows[i]
            var cur = navModel.get(i)
            if (cur.kind !== row.kind || cur.key !== row.key || cur.modelIndex !== row.modelIndex)
                return false
        }
        for (var j = 0; j < rows.length; ++j)
            _applyNavRowPatch(j, rows[j])
        return true
    }

    function rebuildNavModel() {
        navModel.clear()
        var rows = _collectNavRows(root.model)
        for (var i = 0; i < rows.length; ++i)
            navModel.append(rows[i])
    }

    // Patch a single nav entry (title / badge / icon) without replacing model — 2.88 C9.
    function patchNavItem(key, patch) {
        if (!key || !patch)
            return false
        var ent = _findSourceEntry(key)
        if (!ent)
            return false
        var it = ent.item
        if (patch.title !== undefined)
            it.title = patch.title
        if (patch.symbol !== undefined)
            it.symbol = patch.symbol
        if (patch.icon !== undefined)
            it.icon = patch.icon
        if (patch.badge !== undefined)
            it.badge = patch.badge
        if (patch.badgeValue !== undefined)
            it.badgeValue = patch.badgeValue
        var row = _navRowFromSource(it, ent.modelIndex)
        if (!row)
            return false
        for (var i = 0; i < navModel.count; ++i) {
            if (navModel.get(i).key !== key)
                continue
            _applyNavRowPatch(i, row)
            return true
        }
        return false
    }

    function _pinnedStoreCategory() {
        return root.pinnedNavSettingsCategory || "NavigationViewPins"
    }

    Settings {
        id: pinnedStore
        category: root._pinnedStoreCategory()
        property string keysJson: "[]"
    }

    function _loadPinnedNavKeys() {
        if (!root.pinnedNavSettingsCategory.length)
            return
        try {
            var v = JSON.parse(pinnedStore.keysJson || "[]")
            if (Array.isArray(v))
                root.pinnedNavKeys = v
        } catch (e) {
        }
    }

    function _savePinnedNavKeys() {
        if (!root.pinnedNavSettingsCategory.length)
            return
        pinnedStore.keysJson = JSON.stringify(root.pinnedNavKeys || [])
    }

    function isNavPinned(key) {
        var k = String(key || "")
        if (!k.length)
            return false
        return (root.pinnedNavKeys || []).indexOf(k) >= 0
    }

    function pinNavKey(key) {
        var k = String(key || "")
        if (!k.length || isNavPinned(k))
            return false
        var next = (root.pinnedNavKeys || []).slice()
        next.push(k)
        if (root.maxPinnedNavKeys > 0 && next.length > root.maxPinnedNavKeys)
            next = next.slice(next.length - root.maxPinnedNavKeys)
        root.pinnedNavKeys = next
        _savePinnedNavKeys()
        return true
    }

    function unpinNavKey(key) {
        var k = String(key || "")
        if (!isNavPinned(k))
            return false
        root.pinnedNavKeys = (root.pinnedNavKeys || []).filter(function (x) { return x !== k })
        _savePinnedNavKeys()
        return true
    }

    function toggleNavPin(key) {
        if (isNavPinned(key))
            return unpinNavKey(key)
        return pinNavKey(key)
    }

    function pinnedNavEntries() {
        var keys = root.pinnedNavKeys || []
        var out = []
        for (var i = 0; i < keys.length; ++i) {
            var rec = _navRecordForKey(keys[i])
            if (rec)
                out.push(rec)
        }
        return out
    }

    function _navRecordForKey(key) {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    var ck = gkey + "/" + j
                    if (ck === key) {
                        var ch = it.children[j]
                        return {
                            key: ck,
                            title: ch.title || "",
                            glyph: IconSource.resolve(ch.symbol || "", ch.icon || FluentIcons.Placeholder),
                            group: it.title || ""
                        }
                    }
                }
            } else if (it.type !== "header" && it.type !== "group") {
                var ikey = it.key || ("item_" + i)
                if (ikey === key) {
                    return {
                        key: ikey,
                        title: it.title || "",
                        glyph: IconSource.resolve(it.symbol || "", it.icon || FluentIcons.Placeholder),
                        group: ""
                    }
                }
            }
        }
        return null
    }

    function collectJumpListEntries() {
        var out = []
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                var gtitle = it.title || qsTr("Group")
                for (var j = 0; j < it.children.length; ++j) {
                    var ch = it.children[j]
                    if (!ch)
                        continue
                    out.push({
                        key: gkey + "/" + j,
                        title: ch.title || "",
                        group: gtitle,
                        letter: String(ch.title || "?").charAt(0).toUpperCase()
                    })
                }
            } else if (it.type !== "header" && it.type !== "group") {
                var title = it.title || ""
                out.push({
                    key: it.key || ("item_" + i),
                    title: title,
                    group: qsTr("Pages"),
                    letter: String(title || "?").charAt(0).toUpperCase()
                })
            }
        }
        out.sort(function (a, b) {
            var ga = String(a.group || "")
            var gb = String(b.group || "")
            if (ga !== gb)
                return ga < gb ? -1 : 1
            var ta = String(a.title || "").toLowerCase()
            var tb = String(b.title || "").toLowerCase()
            return ta < tb ? -1 : (ta > tb ? 1 : 0)
        })
        return out
    }

    function openJumpList() {
        if (!root.jumpListEnabled)
            return
        jumpListPopup.open()
    }

    function closeJumpList() {
        jumpListPopup.close()
    }

    function clearDrilldown() {
        if (!drilldownDepth)
            return
        root.drilldownStack = []
    }

    function pushDrilldown(title, component, mode) {
        if (!component)
            return false
        var stack = (root.drilldownStack || []).slice()
        stack.push({ title: title || component, component: component })
        root.drilldownStack = stack
        if (!root.hostContent)
            openPage(component, mode || "drill")
        return true
    }

    function popDrilldown(mode) {
        if (!drilldownDepth)
            return false
        var stack = (root.drilldownStack || []).slice()
        stack.pop()
        root.drilldownStack = stack
        var backMode = mode || "slideRight"
        if (!root.hostContent) {
            if (stack.length)
                openPage(stack[stack.length - 1].component, backMode)
            else
                openPage(root.currentComponent, backMode)
        }
        return true
    }

    function _findSourceEntry(key) {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group") {
                var gkey = it.key || ("group_" + i)
                if (gkey === key)
                    return { item: it, modelIndex: i }
                if (it.children) {
                    for (var j = 0; j < it.children.length; ++j) {
                        if ((gkey + "/" + j) === key)
                            return { item: it.children[j], modelIndex: i }
                    }
                }
            } else if (it.type === "header") {
                if ((it.key || ("header_" + i)) === key)
                    return { item: it, modelIndex: i }
            } else {
                if ((it.key || ("item_" + i)) === key)
                    return { item: it, modelIndex: i }
            }
        }
        return null
    }

    // Expand or collapse a nav group by key
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
        schedulePipMove(false)
    }

    // Visual anchor item for the selection pip
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

    // Toggle a nav group expanded state
    function toggleGroup(key) {
        setGroupExpanded(key, !isGroupExpanded(key))
    }

    onModelChanged: {
        if (!_syncNavModelIncremental())
            rebuildNavModel()
        // If the first openPage() ran against an empty model, load now.
        if (!root.hostContent && pageStack.depth === 0 && root.currentComponent)
            openPage(root.currentComponent, root.pendingMode || "slide")
    }
    onPaneOpenChanged: {
        compactFlyout.close()
        if (root._a11yReady)
            _announce(root.paneOpen ? qsTr("Navigation pane expanded")
                                    : qsTr("Navigation pane collapsed"))
        // Keep ListView still while Layout.preferredWidth Behavior runs — touching
        // scroll/pip mid-tween aborts the rail animation (seen as a teleport).
        if (root.paneOpen) {
            var slash = root.currentKey.indexOf("/")
            if (slash > 0)
                setGroupExpanded(root.currentKey.substring(0, slash), true)
        }
        paneWidthSettleTimer.interval = Theme.reducedMotion
                ? 1 : (Theme.duration(Theme.motionSlow) + 80)
        paneWidthSettleTimer.restart()
    }

    Timer {
        id: paneWidthSettleTimer
        interval: 300
        repeat: false
        onTriggered: {
            if (!selectionPip)
                return
            root.ensureSelectionVisible()
            schedulePipMove(true)
        }
    }

    // Toggle the left pane / overlay drawer
    function togglePane() {
        compactFlyout.close()
        var mode = resolvedPaneMode
        if (mode === "top")
            return
        if (mode === "left" && !paneOpen && !_canExpandPaneInline)
            return
        paneOpen = !paneOpen
    }

    // Group key for exclusive flyouts
    property string flyoutGroupKey: ""
    // Key for a pending flyout
    property string pendingFlyoutKey: ""
    // Anchor item for a pending flyout
    property var pendingFlyoutAnchor: null
    // True while the flyout is hovered
    property bool flyoutHovered: false

    ListModel { id: flyoutModel }

    // Title text for a nav group key
    function groupTitle(key) {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && it.type === "group" && (it.key || ("group_" + i)) === key)
                return it.title || ""
        }
        return ""
    }

    // Populate the compact-mode group flyout model
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

    // Open the compact pane group flyout
    function openCompactFlyout(groupKey, anchorItem) {
        if (root.paneOpen || !groupKey || !anchorItem)
            return
        flyoutGroupKey = groupKey
        fillFlyoutModel(groupKey)
        if (flyoutModel.count === 0)
            return
        var p = anchorItem.mapToItem(root, 0, 0)
        compactFlyout.x = Math.min(root._paneWidth + 4,
                                   Math.max(4, root.width - 280))
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

    // Schedule opening the compact flyout (hover delay)
    function requestCompactFlyout(groupKey, anchorItem) {
        pendingFlyoutKey = groupKey
        pendingFlyoutAnchor = anchorItem
        flyoutCloseTimer.stop()
        if (compactFlyout.visible && flyoutGroupKey === groupKey)
            return
        flyoutOpenTimer.restart()
    }

    // Schedule closing the compact flyout
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

    // Resolve page component name for a nav key
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

    // First nav key whose component matches (for search / featured → rail pip).
    function keyForComponent(componentName) {
        if (!componentName || !componentName.length)
            return ""
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    if ((it.children[j].component || "") === componentName)
                        return gkey + "/" + j
                }
            } else if (it.type !== "header" && it.type !== "group") {
                if ((it.component || "") === componentName)
                    return it.key || ("item_" + i)
            }
        }
        return ""
    }

    // Display title for a nav key (item or group/child path)
    function titleForKey(key) {
        if (!key)
            return ""
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    if ((gkey + "/" + j) === key)
                        return it.children[j].title || ""
                }
            } else if (it.type !== "header" && it.type !== "group") {
                var ikey = it.key || ("item_" + i)
                if (ikey === key)
                    return it.title || ""
            }
        }
        return ""
    }

    // First top-level nav item key (home/default)
    function _defaultHomeKey() {
        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && it.type !== "group" && it.type !== "header")
                return it.key || ("item_" + i)
        }
        return ""
    }

    // Breadcrumb path for a nav key — [{ title, symbol?, navKey }] (2.23)
    function breadcrumbPathForKey(key) {
        if (root.footerSelected) {
            var ft = root.footerText.length ? root.footerText : qsTr("Settings")
            return [
                { title: root.headerText, navKey: _defaultHomeKey() },
                { title: ft, navKey: "__footer__" }
            ]
        }
        if (!key || !key.length)
            key = root.currentKey
        var out = []
        var homeKey = _defaultHomeKey()
        out.push({ title: root.headerText, navKey: homeKey })

        var m = root.model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            if (it.type === "group" && it.children) {
                var gkey = it.key || ("group_" + i)
                for (var j = 0; j < it.children.length; ++j) {
                    var ck = gkey + "/" + j
                    if (ck === key) {
                        out.push({
                            title: it.title || "",
                            navKey: gkey + "/0",
                            symbol: it.symbol || it.icon || ""
                        })
                        var child = it.children[j]
                        out.push({
                            title: child.title || "",
                            navKey: ck,
                            symbol: child.symbol || child.icon || ""
                        })
                        return _appendDrilldownCrumbs(out)
                    }
                }
            } else if (it.type !== "header" && it.type !== "group") {
                var ikey = it.key || ("item_" + i)
                if (ikey === key) {
                    out.push({
                        title: it.title || "",
                        navKey: key,
                        symbol: it.symbol || it.icon || ""
                    })
                    return _appendDrilldownCrumbs(out)
                }
            }
        }
        var t = titleForKey(key)
        if (t.length)
            out.push({ title: t, navKey: key })
        return _appendDrilldownCrumbs(out)
    }

    function _appendDrilldownCrumbs(out) {
        var stack = root.drilldownStack || []
        for (var d = 0; d < stack.length; ++d) {
            out.push({
                title: stack[d].title || stack[d].component || "",
                navKey: "__drill__/" + d
            })
        }
        return out
    }

    // Plain BreadcrumbBar model derived from breadcrumbPathForKey (2.23)
    function breadcrumbModelForKey(key) {
        var path = breadcrumbPathForKey(key)
        var out = []
        for (var i = 0; i < path.length; ++i) {
            var e = path[i]
            out.push({ title: e.title || "", symbol: e.symbol || "" })
        }
        return out
    }

    // navKey at breadcrumb index for the given selection key
    function navKeyForBreadcrumbIndex(key, index) {
        var path = breadcrumbPathForKey(key)
        if (index < 0 || index >= path.length)
            return ""
        return path[index].navKey || ""
    }

    // Select nav destination for a breadcrumb index (2.23) — no history push (2.56)
    function selectBreadcrumbIndex(index, mode) {
        var path = breadcrumbPathForKey(root.currentKey)
        if (index < 0 || index >= path.length)
            return
        var nk = path[index].navKey
        root._suppressHistory = true
        if (nk === "__footer__") {
            clearDrilldown()
            selectFooter(mode)
        } else if (nk && nk.indexOf("__drill__/") === 0) {
            var keep = Number(nk.substring(10)) + 1
            var stack = (root.drilldownStack || []).slice()
            while (stack.length > keep)
                stack.pop()
            root.drilldownStack = stack
            if (!root.hostContent && stack.length)
                openPage(stack[stack.length - 1].component, mode || "slideRight")
        } else if (nk && nk.length) {
            clearDrilldown()
            selectKey(nk, mode)
        }
        root._suppressHistory = false
    }

    function _announce(text) {
        if (!root.announceChanges || !root._a11yReady || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    // Flat list index for a nav key
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

    // Scroll so the current selection is on-screen
    function ensureSelectionVisible() {
        if (!navList || root.footerSelected)
            return -1
        var idx = flatIndexForKey(root.currentKey)
        if (idx < 0)
            return -1

        // Prefer the pip anchor (child row inside an expanded group). Using
        // ListView.Contain on a tall group delegate snaps to the group top and
        // can scroll the clicked control out of view.
        var anchor = selectionAnchorItem()
        if (anchor && anchor.height >= 8) {
            var p = anchor.mapToItem(navList.contentItem, 0, 0)
            var top = p.y
            var bottom = p.y + anchor.height
            var viewTop = navList.contentY
            var viewBottom = navList.contentY + navList.height
            var margin = 8
            var maxY = Math.max(0, navList.contentHeight - navList.height)
            if (top < viewTop + margin) {
                navList.contentY = Math.max(0, Math.min(maxY, top - margin))
            } else if (bottom > viewBottom - margin) {
                navList.contentY = Math.max(0, Math.min(maxY, bottom - navList.height + margin))
            }
            return idx
        }

        // Fallback when the delegate is not instantiated yet (off-screen).
        navList.positionViewAtIndex(idx, ListView.Contain)
        return idx
    }

    // Select a top-level model index (legacy)
    function selectIndex(index) {
        // Legacy: index into root.model (top-level only)
        if (index < 0 || index >= root.model.length)
            return
        var it = root.model[index]
        if (!it || it.type === "header" || it.type === "group")
            return
        selectKey(it.key || ("item_" + index), root.pageTransition)
        itemClicked(index)
    }

    // Select by nav key and open the page.
    // Optional pageName: open a different page while keeping rail selection on key
    // (Gallery search / hub pages that are not themselves rail entries).
    function selectKey(key, mode, pageName) {
        if (!key)
            return
        var page = (pageName && pageName.length) ? pageName : ""
        // Same nav selection already active — no history push / no page transition
        if (!root.footerSelected && key === root.currentKey) {
            if (root.drilldownDepth) {
                clearDrilldown()
                if (!root.hostContent)
                    openPage(page.length ? page : currentComponent, mode || root.pageTransition)
                return
            }
            if (page.length && !root.hostContent && page !== root._openedPageName) {
                openPage(page, mode || root.pageTransition)
                return
            }
            root.sameKeySkipCount++
            ensureSelectionVisible()
            Qt.callLater(function () {
                schedulePipMove(false)
            })
            return
        }
        if (!_suppressHistory)
            pushHistorySnapshot()
        if (!_suppressHistory)
            clearDrilldown()
        footerSelected = false
        currentKey = key
        // Arm the pip move before ensureSelectionVisible/scroll so syncViewport
        // cannot snap contentFromY/ToY to the new row and zero out travel.
        schedulePipMove(false)
        // Expand parent group if nested
        var slash = key.indexOf("/")
        if (slash > 0)
            setGroupExpanded(key.substring(0, slash), true)
        ensureSelectionVisible()
        if (!root.hostContent)
            openPage(page.length ? page : currentComponent, mode || root.pageTransition)
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
        var navTitle = titleForKey(key)
        if (navTitle.length)
            _announce(qsTr("Navigated to %1").arg(navTitle))
        // Child rows may still be laying out after expand + scroll.
        Qt.callLater(function () {
            if (!root)
                return
            ensureSelectionVisible()
            schedulePipMove(false)
        })
        _dismissPaneDrawerIfNeeded()
    }

    // Select the footer row and open footerComponent
    function selectFooter(mode) {
        // Already on footer page — skip transition
        if (root.footerSelected)
            return
        if (!_suppressHistory)
            pushHistorySnapshot()
        clearDrilldown()
        footerSelected = true
        footerClicked()
        _announce(qsTr("Navigated to %1").arg(
                      root.footerText.length ? root.footerText : qsTr("Settings")))
        if (!root.hostContent)
            openPage(root.footerComponent, mode || root.pageTransition)
        _dismissPaneDrawerIfNeeded()
    }

    // Snapshot current selection for TitleBar back
    function pushHistorySnapshot() {
        var snap = {
            key: currentKey,
            footer: footerSelected,
            component: currentComponent || ""
        }
        var hist = pageHistory.slice()
        // Skip duplicate consecutive entries
        if (hist.length) {
            var last = hist[hist.length - 1]
            if (last.key === snap.key && last.footer === snap.footer)
                return
        }
        hist.push(snap)
        if (hist.length > 32)
            hist = hist.slice(hist.length - 32)
        pageHistory = hist
    }

    // Restore previous nav selection (slideRight by default)
    function navigateBack(mode) {
        if (drilldownDepth)
            return popDrilldown(mode)
        if (!pageHistory.length)
            return false
        var hist = pageHistory.slice()
        var prev = hist.pop()
        pageHistory = hist
        _suppressHistory = true
        if (prev.footer)
            selectFooter(mode || "slideRight")
        else
            selectKey(prev.key, mode || "slideRight")
        _suppressHistory = false
        return true
    }

    function clearHistory() {
        pageHistory = []
    }

    property var _compCache: ({})
    // LRU order of cached page names (oldest first)
    property var _compCacheOrder: []

    function _isPinnedPage(name) {
        var pinned = root.pinnedPageCache || []
        return !!name && pinned.indexOf(name) >= 0
    }

    function _pageCacheWeight(name) {
        if (!root.pageCacheMemoryAware)
            return 1
        return root._isPinnedPage(name) ? 2 : 1
    }

    function _pageCacheBudget() {
        if (root.pageCacheLimit <= 0 && root.pageCacheMemoryBudgetMb <= 0)
            return -1
        if (root.pageCacheMemoryAware && root.pageCacheMemoryBudgetMb > 0)
            return Math.max(1, root.pageCacheMemoryBudgetMb)
        return root.pageCacheLimit
    }

    function _touchPageCache(name) {
        var order = root._compCacheOrder.slice()
        var idx = order.indexOf(name)
        if (idx >= 0)
            order.splice(idx, 1)
        order.push(name)
        root._compCacheOrder = order
        root._evictPageCache()
        root.pageCacheCount = root._compCacheOrder.length
    }

    function _evictPageCache() {
        var budget = root._pageCacheBudget()
        if (budget < 0)
            return
        var order = root._compCacheOrder.slice()
        var cache = Object.assign({}, root._compCache)

        function totalWeight() {
            var w = 0
            for (var i = 0; i < order.length; ++i)
                w += root._pageCacheWeight(order[i])
            return root.pageCacheMemoryAware ? w : order.length
        }

        while (totalWeight() > budget) {
            var drop = ""
            // Prefer unpinned oldest (skip current page)
            for (var i = 0; i < order.length; ++i) {
                if (order[i] === root._openedPageName)
                    continue
                if (root._isPinnedPage(order[i]))
                    continue
                drop = order[i]
                order.splice(i, 1)
                break
            }
            if (!drop) {
                // Fall back: oldest non-current (may include pinned if over budget)
                for (var j = 0; j < order.length; ++j) {
                    if (order[j] !== root._openedPageName) {
                        drop = order[j]
                        order.splice(j, 1)
                        break
                    }
                }
            }
            if (!drop)
                break
            delete cache[drop]
        }
        root._compCache = cache
        root._compCacheOrder = order
    }

    // Drop cached page Components. keepCurrent (default true) retains the open page type.
    function clearPageCache(keepCurrent) {
        if (keepCurrent === undefined)
            keepCurrent = true
        var cur = root._openedPageName
        var kept = {}
        var order = []
        if (keepCurrent && cur && root._compCache[cur]) {
            kept[cur] = root._compCache[cur]
            order = [cur]
        }
        root._compCache = kept
        root._compCacheOrder = order
        root.pageCacheCount = order.length
        root.pageCacheHits = 0
    }

    // Load / cache a page Component from pageModule (lazy — not at shell startup)
    function ensureComponent(name) {
        if (!name || !root.pageModule)
            return null
        var cached = root._compCache[name]
        if (cached && cached.status !== Component.Error) {
            root.pageCacheHits++
            root._touchPageCache(name)
            return cached
        }
        var comp = Qt.createComponent(root.pageModule, name)
        if (comp.status === Component.Error) {
            console.warn("Failed to load", root.pageModule, name, comp.errorString())
            return null
        }
        // Cache Ready or Loading; drop Error entries.
        var next = Object.assign({}, root._compCache)
        next[name] = comp
        root._compCache = next
        root._touchPageCache(name)
        return comp
    }

    // Configure enter/exit transform targets for a named transition mode
    function applyPageTransition(mode) {
        var m = String(mode || root.pageTransition || "slide").toLowerCase()
        if (m === "suppress")
            m = "none"
        if (m === "drillin")
            m = "drill"
        if (Theme.reducedMotion && m !== "none")
            m = "fade"

        root.pendingMode = m
        root._enterX = 0
        root._exitX = 0
        root._enterY = 0
        root._exitY = 0
        root._enterScale = 1
        root._exitScale = 1
        root._enterOpacity = 0
        root._exitOpacity = 0
        root._animOpacity = false
        root._animX = false
        root._animY = false
        root._animScale = false

        var w = pageStack.width > 0 ? pageStack.width : 400
        var h = pageStack.height > 0 ? pageStack.height : 300

        switch (m) {
        case "none":
            root._enterOpacity = 1
            break
        case "fade":
            root._animOpacity = true
            break
        case "center":
            root._enterScale = 0.94
            root._exitScale = 0.98
            root._animOpacity = true
            root._animScale = true
            break
        case "drill":
            root._enterScale = 0.88
            root._exitScale = 1.06
            root._animOpacity = true
            root._animScale = true
            break
        case "slide":
        case "slideleft":
            root._enterX = -0.12 * w
            root._exitX = 0.06 * w
            root._animOpacity = true
            root._animX = true
            break
        case "slideright":
            root._enterX = 0.12 * w
            root._exitX = -0.06 * w
            root._animOpacity = true
            root._animX = true
            break
        case "cover":
            root._enterX = Math.max(48, 0.28 * w)
            root._exitX = -0.08 * w
            root._animOpacity = true
            root._animX = true
            break
        case "up":
            root._enterY = Math.max(24, 0.08 * h)
            root._exitY = -Math.max(12, 0.04 * h)
            root._animOpacity = true
            root._animY = true
            break
        case "down":
            root._enterY = -Math.max(24, 0.08 * h)
            root._exitY = Math.max(12, 0.04 * h)
            root._animOpacity = true
            root._animY = true
            break
        default:
            root._enterX = -0.12 * w
            root._exitX = 0.06 * w
            root.pendingMode = "slide"
            root._animOpacity = true
            root._animX = true
            break
        }
    }

    // Replace the page stack with the named component.
    // forceReload: true rebuilds even when the same page is already open (reloadPage).
    function openPage(name, mode, forceReload) {
        if (!name)
            return
        // Same page already showing — skip StackView replace / enter-exit animation
        if (!forceReload && name === root._openedPageName && pageStack.depth > 0) {
            root.samePageSkipCount++
            return
        }

        var useMode = mode || root.pageTransition || "slide"
        applyPageTransition(useMode)
        var immediate = root.pendingMode === "none"

        var comp = ensureComponent(name)
        if (!comp)
            return
        function doReplace(c) {
            var props = { transformOrigin: Item.Center }
            if (pageStack.depth === 0)
                pageStack.push(c, props, StackView.Immediate)
            else if (immediate)
                pageStack.replace(c, props, StackView.Immediate)
            else
                pageStack.replace(c, props)
            root._openedPageName = name
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

    // Forward slide from the right
    function openSlideRight(name) {
        openPage(name, "slideRight")
    }

    // Opacity-only crossfade
    function openFade(name) {
        openPage(name, "fade")
    }

    // Stronger scale drill-in (WinUI DrillIn–style)
    function openDrill(name) {
        openPage(name, "drill")
    }

    // In-page drill/detail — records soft history so TitleBar Back works (2.56)
    function navigateToPage(name, mode) {
        if (!name)
            return
        if (!_suppressHistory)
            pushHistorySnapshot()
        openPage(name, mode || root.pageTransition)
    }

    function openDrillWithHistory(name) {
        navigateToPage(name, "drill")
    }

    // Vertical rise from below
    function openUp(name) {
        openPage(name, "up")
    }

    // Vertical settle from above
    function openDown(name) {
        openPage(name, "down")
    }

    // Covering slide from the right
    function openCover(name) {
        openPage(name, "cover")
    }

    // Instant swap (no motion)
    function openNone(name) {
        openPage(name, "none")
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

    // Select the first nav item matching a title
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
                        selectKey(gkey + "/" + j, mode || root.pageTransition)
                        return
                    }
                }
            } else if (it && it.title === title) {
                selectKey(it.key || ("item_" + i), mode || root.pageTransition)
                return
            }
        }
    }

    // Reload the current page component
    function reloadPage() {
        openPage(root.currentComponent, root.pendingMode || root.pageTransition || "slide", true)
    }

    Component.onCompleted: {
        _loadPinnedNavKeys()
        rebuildNavModel()
        if (!root.hostContent)
            openPage(root.currentComponent, root.initialPageTransition || "none")
        Qt.callLater(function () { root._a11yReady = true })
    }

    // leftMinimal / compact drawer: pane reparents here so it floats over content.
    Item {
        id: minimalOverlayLayer
        anchors.fill: parent
        z: 50
        visible: root.resolvedPaneMode === "leftMinimal" || root._compactDrawerOverlay

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: root._compactDrawerOverlay ? root._effectiveCompactWidth : 0
            visible: root._paneOverlayActive
            color: Theme.bgSmoke
            opacity: visible ? 1 : 0
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root._dismissPaneDrawerIfNeeded()
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
                    visible: root.effectiveBackVisible
                    enabled: root.effectiveBackEnabled
                    Layout.preferredWidth: Theme.navItemHeight
                    Layout.preferredHeight: Theme.navItemHeight
                    opacity: enabled ? 1 : 0.4
                    Accessible.role: Accessible.Button
                    Accessible.name: qsTr("Back")
                    onClicked: {
                        if (root.canGoBack)
                            root.navigateBack()
                        else
                            root.backRequested()
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Back")
                    contentItem: Text {
                        text: FluentIcons.Back
                        font: Theme.iconFontFor(16)
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

                    // True when content overflows the visible area
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
                        Accessible.role: Accessible.ListItem
                        Accessible.name: title.length ? title : qsTr("Navigation item")
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
                                    root.selectKey(gkey + "/0", root.pageTransition)
                                    root.itemClicked(modelIndex)
                                    return
                                }
                                return
                            }
                            root.selectKey(key, root.pageTransition)
                            root.itemClicked(modelIndex)
                        }

                        contentItem: RowLayout {
                            id: topRow
                            spacing: 8
                            Text {
                                text: topDel.glyph
                                font: Theme.iconFontFor(14)
                                color: topDel.highlighted ? Theme.accent : Theme.textPrimary
                            }
                            Text {
                                text: topDel.title
                                font.pixelSize: Theme.fontCaption
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                                visible: !root.paneSearchHighlightQuery.length
                            }
                            MatchHighlightText {
                                visible: root.paneSearchHighlightQuery.length > 0
                                sourceText: topDel.title
                                query: root.paneSearchHighlightQuery
                                font.pixelSize: Theme.fontCaption
                                normalColor: Theme.textPrimary
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
                    focusPolicy: Qt.StrongFocus
                    Accessible.role: Accessible.Button
                    Accessible.name: qsTr("More navigation")
                    ToolTip.text: qsTr("More")
                    ToolTip.visible: hovered
                    contentItem: Text {
                        text: FluentIcons.More
                        font: Theme.iconFontFor(16)
                        color: Theme.textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Keys.onDownPressed: if (!topOverflowMenu.visible) topOverflowBtn.clicked()
                    Keys.onReturnPressed: topOverflowBtn.clicked()
                    Keys.onEnterPressed: topOverflowBtn.clicked()
                    Keys.onSpacePressed: topOverflowBtn.clicked()
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
                                                root.selectKey(gkey + "/0", root.pageTransition)
                                                return
                                            }
                                        }
                                    } else {
                                        root.selectKey(key, root.pageTransition)
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
                    visible: root.isSettingsVisible
                             && (root.footerComponent.length > 0 || root.footerText.length > 0)
                    Layout.preferredHeight: Theme.navItemHeight
                    Layout.preferredWidth: Math.max(Theme.navItemHeight, footerTopRow.implicitWidth + 16)
                    highlighted: root.footerSelected
                    Accessible.role: Accessible.ListItem
                    Accessible.name: root.footerText.length ? root.footerText : qsTr("Settings")
                    onClicked: {
                        root.footerSelected = true
                        root.footerClicked()
                        if (root.footerComponent.length)
                            root.openPage(root.footerComponent, root.pageTransition)
                    }
                    contentItem: RowLayout {
                        id: footerTopRow
                        spacing: 8
                        Text {
                            text: root.effectiveFooterIcon
                            font: Theme.iconFontFor(14)
                            color: Theme.textPrimary
                        }
                        Text {
                            text: root.footerText
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textPrimary
                        }
                        InfoBadge {
                            visible: root.footerBadge.length > 0 || root.footerBadgeValue >= 0
                            text: root.footerBadge
                            value: root.footerBadgeValue >= 0 ? root.footerBadgeValue : 0
                            severity: informational
                            hideWhenEmpty: false
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
            visible: root.isPaneVisible
                     && root.resolvedPaneMode !== "top"
                     && root.resolvedPaneMode !== "leftMinimal"
                     && !root._compactDrawerOverlay
            Layout.preferredWidth: visible ? root._paneLayoutWidth : 0
            Layout.fillHeight: true
            clip: true

            // Animate rail width in left / leftCompact. _paneShowsLabels keeps labels visible
            // until the slot is actually compact so we do not get an empty wide acrylic column.
            Behavior on Layout.preferredWidth {
                enabled: !Theme.reducedMotion
                         && root.resolvedPaneMode !== "leftMinimal"
                         && !root._compactDrawerOverlay
                         && root.resolvedPaneMode !== "top"
                NumberAnimation {
                    duration: Theme.duration(Theme.motionSlow)
                    easing.type: Theme.easingStandard
                }
            }
            z: 1
        }

        Rectangle {
            id: pane
            parent: root._paneOverlayActive ? minimalOverlayLayer : paneSlot
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            x: root._compactDrawerOverlay ? root._effectiveCompactWidth : 0
            z: root._paneOverlayActive ? 1 : 0
            width: root.resolvedPaneMode === "leftMinimal"
                   ? (root.paneOpen ? root._expandedPaneWidth : 0)
                   : root._compactDrawerOverlay
                     ? root._expandedPaneWidth
                     : parent.width
            visible: root.isPaneVisible
            color: Theme.bgAcrylic
            clip: true

            Behavior on width {
                enabled: !Theme.reducedMotion
                         && (root.resolvedPaneMode === "leftMinimal" || root._compactDrawerOverlay)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on x {
                enabled: !Theme.reducedMotion && root._compactDrawerOverlay
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: root._paneMinimal ? 0 : 1
                visible: !root._paneMinimal
                color: Theme.strokeDivider
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: root._paneMinimal ? 2 : 4
                spacing: root._paneMinimal ? 1 : 2

                // Branded logo band above pane header (2.68 A5)
                ColumnLayout {
                    id: brandedBand
                    visible: root._paneBranded && root.paneOpen
                             && (paneLogoHost.children.length > 0 || root.brandedTitle.length > 0)
                    Layout.fillWidth: true
                    spacing: 4

                    Item {
                        id: paneLogoHost
                        Layout.fillWidth: true
                        Layout.preferredHeight: children.length > 0
                                                ? Math.max(32, childrenRect.height) : 0
                        visible: children.length > 0
                        clip: true
                    }
                    Text {
                        id: brandTitleRow
                        visible: root.brandedTitle.length > 0
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        text: root.brandedTitle
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        height: 1
                        color: Theme.strokeDivider
                    }
                }

                // Pane title bar: hamburger + paneTitle only (Back lives on TitleBar / top mode)
                ItemDelegate {
                    id: paneTitleBar
                    visible: root._showPaneTitleBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: root._railItemHeight
                    text: root.headerText
                    Accessible.role: Accessible.Button
                    Accessible.name: root.paneOpen
                                     ? (root.headerText.length ? root.headerText : qsTr("Collapse navigation"))
                                     : qsTr("Expand navigation")
                    onClicked: root.togglePane()
                    ToolTip.visible: hovered && root._paneWidth < 120
                    ToolTip.text: root.paneOpen ? qsTr("Collapse") : qsTr("Expand")

                    contentItem: RowLayout {
                        spacing: 12
                        Text {
                            text: FluentIcons.GlobalNavButton
                            font: Theme.iconFontFor(16)
                            color: Theme.textPrimary
                            Layout.preferredWidth: 20
                            horizontalAlignment: Text.AlignHCenter
                            rotation: root.paneOpen || root.resolvedPaneMode === "leftCompact" ? 0 : 180
                            Behavior on rotation {
                                enabled: !Theme.reducedMotion
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionNormal)
                                    easing.type: Theme.easingStandard
                                }
                            }
                        }
                        Text {
                            // Title is required whenever the rail title bar is shown
                            visible: root._paneShowsLabels
                            text: root.headerText.length ? root.headerText : qsTr("Navigation")
                            font.pixelSize: Theme.fontBody
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
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
                    placeholderText: root.paneSearchPlaceholder
                    text: root.paneSearchText
                    model: root.paneSearchModel
                    onTextChanged: {
                        root.paneSearchText = text
                        root.paneSearchTextEdited(text)
                    }
                    onAccepted: function (t) { root.paneSearchActivated(t) }
                    onSuggestionChosen: function (item) {
                        if (item && item.key)
                            root.selectKey(item.key, root.pageTransition)
                        else if (item && item.title)
                            root.navigateToTitle(item.title, root.pageTransition)
                        root.paneSearchActivated(paneSearch.displayTextFor(item))
                    }
                }

                RowLayout {
                    visible: root.paneOpen && root.jumpListEnabled
                    Layout.fillWidth: true
                    Layout.leftMargin: 4
                    Layout.rightMargin: 4
                    Layout.preferredHeight: visible ? Theme.navItemHeight : 0
                    spacing: Theme.spacingTight
                    Button {
                        flat: true
                        text: qsTr("Jump list")
                        Accessible.name: qsTr("Jump list")
                        Layout.fillWidth: true
                        onClicked: root.openJumpList()
                    }
                }

                Flow {
                    id: pinnedFlow
                    visible: root.paneOpen && (root.pinnedNavKeys || []).length > 0
                    Layout.fillWidth: true
                    Layout.leftMargin: 4
                    Layout.rightMargin: 4
                    Layout.preferredHeight: visible ? implicitHeight : 0
                    spacing: 4
                    Repeater {
                        model: root.pinnedNavKeys || []
                        delegate: Button {
                            required property var modelData
                            readonly property var pinRec: root._navRecordForKey(modelData)
                            flat: true
                            text: pinRec ? (pinRec.title || modelData) : modelData
                            Accessible.name: qsTr("Pinned %1").arg(text)
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Click to open · right-click to unpin")
                            onClicked: root.selectKey(modelData, root.pageTransition)
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                onClicked: root.unpinNavKey(modelData)
                            }
                        }
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
                        // 3.43 H12 — pool delegates; buffer keeps SelectionPip anchors alive.
                        reuseItems: true
                        // Keep selected rows instantiated longer so the pip can
                        // re-sync after expand/collapse without waiting on recycle.
                        cacheBuffer: Math.max(240, Math.round(height * 1.5))
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
                            if (root)
                                schedulePipMove(false)
                        })
                        onContentYChanged: pipScrollTimer.restart()
                        onHeightChanged: selectionPip.syncViewport()
                        onCountChanged: Qt.callLater(function () {
                            if (root)
                                schedulePipMove(true)
                        })

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Home) {
                                if (navModel.count > 0)
                                    root.selectKey(navModel.get(0).key, root.pageTransition)
                                event.accepted = true
                            } else if (event.key === Qt.Key_End) {
                                if (navModel.count > 0)
                                    root.selectKey(navModel.get(navModel.count - 1).key, root.pageTransition)
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
                                            root.selectKey(r.key, root.pageTransition)
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
                            // Nested siblings share one ListView index (the group row);
                            // currentIndex may not change — drive the pip from currentKey.
                            function onCurrentKeyChanged() {
                                Qt.callLater(function () {
                                    if (root)
                                        schedulePipMove(false)
                                })
                            }
                            function onFooterSelectedChanged() {
                                schedulePipMove(true)
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

                            // Expanded child rows for a nav group
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
                                    return topRow
                                // Collapsed: keep pip on the group header (child is clipped away)
                                if (!del.expanded)
                                    return topRow
                                var ci = Number(root.currentKey.slice(prefix.length))
                                if (isNaN(ci) || ci < 0)
                                    return topRow
                                // Child may not exist yet during expand / recycle — fall back to header
                                var child = childRepeater.itemAt(ci)
                                return child ? child : topRow
                            }

                            ItemDelegate {
                                id: topRow
                                width: parent.width
                                height: {
                                    if (del.kind === "header")
                                        return root._paneShowsLabels ? 28 : 0
                                    return root._railItemHeight
                                }
                                visible: del.kind === "header" ? root._paneShowsLabels : true
                                enabled: del.kind !== "header"
                                highlighted: !root.footerSelected && (
                                    (del.kind === "item" && del.key === root.currentKey)
                                    || (del.kind === "group"
                                        && root.currentKey.indexOf(del.key + "/") === 0
                                        && (!root.paneOpen || !del.expanded))
                                    || (del.kind === "group" && !root.paneOpen
                                        && compactFlyout.visible && root.flyoutGroupKey === del.key)
                                )
                                Accessible.role: del.kind === "header" ? Accessible.StaticText
                                               : Accessible.ListItem
                                Accessible.name: del.title.length ? del.title : qsTr("Navigation item")
                                Accessible.checkable: del.kind === "group"
                                Accessible.checked: del.kind === "group" && del.expanded

                                onClicked: {
                                    if (del.kind === "group") {
                                        if (!root.paneOpen)
                                            root.openCompactFlyout(del.key, topRow)
                                        else
                                            root.toggleGroup(del.key)
                                    } else if (del.kind === "item") {
                                        root.selectKey(del.key, root.pageTransition)
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

                                ToolTip.visible: !root._useLabeledCompact && !root.paneOpen
                                                 && del.kind === "item" && hovered
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
                                    implicitHeight: root._railItemHeight
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
                                        visible: del.kind === "header" && root._paneShowsLabels
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.leftMargin: 12
                                        text: del.title || ""
                                        font.pixelSize: Theme.fontCaption
                                        font.weight: Theme.fontWeightSemiBold
                                        color: Theme.textSecondary
                                        elide: Text.ElideRight
                                    }

                                    RowLayout {
                                        visible: (del.kind === "group" || del.kind === "item")
                                                 && !root._useLabeledCompact
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8
                                        spacing: 12

                                        Text {
                                            text: del.glyph || FluentIcons.Placeholder
                                            font: Theme.iconFontFor(16)
                                            color: topRow.highlighted ? Theme.textPrimary : Theme.textSecondary
                                            Layout.preferredWidth: 20
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            visible: root._paneShowsLabels && !root.paneSearchHighlightQuery.length
                                            text: del.title || ""
                                            font.pixelSize: Theme.fontBody
                                            color: Theme.textPrimary
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                        MatchHighlightText {
                                            visible: root._paneShowsLabels && root.paneSearchHighlightQuery.length > 0
                                            sourceText: del.title || ""
                                            query: root.paneSearchHighlightQuery
                                            font.pixelSize: Theme.fontBody
                                            normalColor: Theme.textPrimary
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                        InfoBadge {
                                            visible: root._paneShowsLabels && (del.badge.length > 0 || del.badgeValue >= 0)
                                            Layout.alignment: Qt.AlignVCenter
                                            text: del.badge
                                            value: del.badgeValue >= 0 ? del.badgeValue : 0
                                            severity: informational
                                            hideWhenEmpty: false
                                        }
                                        Text {
                                            visible: root._paneShowsLabels && del.kind === "group"
                                            text: FluentIcons.ChevronDown
                                            font: Theme.iconFontFor(10)
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

                                    Column {
                                        visible: (del.kind === "group" || del.kind === "item")
                                                 && root._useLabeledCompact
                                        anchors.fill: parent
                                        anchors.topMargin: 6
                                        anchors.bottomMargin: 4
                                        anchors.leftMargin: 2
                                        anchors.rightMargin: 2
                                        spacing: 2

                                        Text {
                                            width: parent.width
                                            text: del.glyph || FluentIcons.Placeholder
                                            font: Theme.iconFontFor(16)
                                            color: topRow.highlighted ? Theme.textPrimary : Theme.textSecondary
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        Text {
                                            visible: !root.paneSearchHighlightQuery.length
                                            width: parent.width
                                            text: del.title || ""
                                            font.pixelSize: Theme.fontCaption
                                            color: Theme.textPrimary
                                            horizontalAlignment: Text.AlignHCenter
                                            wrapMode: Text.Wrap
                                            maximumLineCount: 2
                                            elide: Text.ElideRight
                                        }
                                        MatchHighlightText {
                                            visible: root.paneSearchHighlightQuery.length > 0
                                            width: parent.width
                                            sourceText: del.title || ""
                                            query: root.paneSearchHighlightQuery
                                            font.pixelSize: Theme.fontCaption
                                            normalColor: Theme.textPrimary
                                            horizontalAlignment: Text.AlignHCenter
                                            wrapMode: Text.Wrap
                                            maximumLineCount: 2
                                            elide: Text.ElideRight
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
                                    if (!root._paneShowsLabels)
                                        return 0
                                    return childrenCol.implicitHeight
                                }

                                Behavior on height {
                                    enabled: !Theme.reducedMotion && del.kind === "group" && root.paneOpen
                                    NumberAnimation {
                                        duration: Theme.duration(Theme.motionNormal
                                            + Math.min(280, childRepeater.count * 14))
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
                                            Accessible.role: Accessible.ListItem
                                            Accessible.name: (modelData && modelData.title)
                                                             ? modelData.title : qsTr("Navigation item")

                                            onClicked: root.selectKey(del.key + "/" + index, root.pageTransition)

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
                                                    font: Theme.iconFontFor(16)
                                                    color: childRow.highlighted ? Theme.textPrimary
                                                                                : Theme.textSecondary
                                                    Layout.preferredWidth: 20
                                                    horizontalAlignment: Text.AlignHCenter
                                                }
                                                Text {
                                                    visible: !root.paneSearchHighlightQuery.length
                                                    text: (childRow.modelData && childRow.modelData.title)
                                                          ? childRow.modelData.title : ""
                                                    font.pixelSize: Theme.fontBody
                                                    color: Theme.textPrimary
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }
                                                MatchHighlightText {
                                                    visible: root.paneSearchHighlightQuery.length > 0
                                                    sourceText: (childRow.modelData && childRow.modelData.title)
                                                                 ? childRow.modelData.title : ""
                                                    query: root.paneSearchHighlightQuery
                                                    font.pixelSize: Theme.fontBody
                                                    normalColor: Theme.textPrimary
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

                    // WinUI selection indicator: accelerate, stretch mid-travel, settle.
                    // Keep last contentY when the selected delegate is recycled off-screen;
                    // do not drive opacity from itemAtIndex (that made the pip vanish while scrolling).
                    Rectangle {
                        id: selectionPip
                        width: root._paneMinimal ? 2 : 3
                        radius: root._paneMinimal ? 1 : 1.5
                        color: Theme.accent
                        x: root._paneMinimal ? 2 : 4
                        z: 2
                        visible: opacity > 0.01
                        opacity: {
                            if (root.footerSelected || navList.currentIndex < 0 || !ready)
                                return 0
                            return 1
                        }

                        // Selection pip rest height
                        property real baseHeight: root._paneMinimal ? 12 : 16
                        // Pip animation start contentY
                        property real contentFromY: 0
                        // Pip animation end contentY
                        property real contentToY: 0
                        // 0..1 animation / progress value
                        property real progress: 1
                        // True after the first successful position sync
                        property bool ready: false
                        // Retry count when moving a window
                        property int moveRetries: 0

                        // Eased 0..1 animation progress
                        readonly property real eased: {
                            var t = progress
                            // Cubic ease-in-out: accelerate then decelerate into settle
                            return t < 0.5
                                   ? 4 * t * t * t
                                   : 1 - Math.pow(-2 * t + 2, 3) / 2
                        }
                        // Absolute pip travel distance
                        readonly property real travel: Math.abs(contentToY - contentFromY)
                        // Stretch peaks in the middle of the path
                        readonly property real stretch: Math.min(36, Math.max(10, travel * 0.45))
                        // Animated pip center Y in content coords
                        readonly property real contentCenterY: contentFromY
                                                              + (contentToY - contentFromY) * eased
                                                              + baseHeight * 0.5
                        // Current pip visual height (stretch)
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
                            // Viewport scroll is handled by the y binding (- contentY).
                            // Refresh absolute content coords when the delegate is alive
                            // (expand/collapse / recycle can shift rows without a selection change).
                            if (root.footerSelected || navList.currentIndex < 0 || !ready)
                                return
                            // Pending / running move owns contentFromY→contentToY; snapping
                            // here zeroes travel and kills the WinUI stretch animation.
                            if (pipAnim.running || pipMoveCoalesce.running)
                                return
                            var target = contentYForSelection()
                            if (target < 0)
                                return
                            if (Math.abs(target - contentToY) < 0.5)
                                return
                            contentFromY = target
                            contentToY = target
                        }

                        // Follow layout shifts (expand/collapse of other rows) without
                        // restarting the stretch animation.
                        function syncToCurrent() {
                            if (root.footerSelected || navList.currentIndex < 0)
                                return
                            if (pipMoveCoalesce.running)
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
                                ready = false
                                moveRetries = 0
                                return
                            }
                            root.ensureSelectionVisible()
                            var target = contentYForSelection()
                            if (target < 0) {
                                if (moveRetries++ < 12)
                                    Qt.callLater(function () {
                                        if (selectionPip)
                                            selectionPip.moveToCurrent(instant)
                                    })
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
                            pipAnim.from = 0
                            pipAnim.to = 1
                            pipAnim.restart()
                            ready = true
                        }

                        Component.onCompleted: Qt.callLater(function () {
                            if (selectionPip)
                                selectionPip.moveToCurrent(true)
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
                    visible: root.isSettingsVisible
                             && (root.footerComponent.length > 0 || root.footerText.length > 0)
                             && !root._paneMinimal
                    Layout.fillWidth: true
                    Layout.leftMargin: root._paneBranded ? 4 : 8
                    Layout.rightMargin: root._paneBranded ? 4 : 8
                    height: visible ? (root._paneBranded ? 2 : 1) : 0
                    color: root._paneBranded ? Theme.strokeCard : Theme.strokeDivider
                    opacity: root._paneBranded ? 1 : 1
                }

                ItemDelegate {
                    visible: root.isSettingsVisible
                             && (root.footerComponent.length > 0 || root.footerText.length > 0)
                    Layout.fillWidth: true
                    Layout.preferredHeight: root._railItemHeight
                    highlighted: root.footerSelected
                    Accessible.role: Accessible.ListItem
                    Accessible.name: root.footerText.length ? root.footerText : qsTr("Settings")
                    onClicked: root.selectFooter("slide")
                    ToolTip.visible: !root._useLabeledCompact && !root.paneOpen && hovered
                    ToolTip.text: root.footerText

                    contentItem: Item {
                        RowLayout {
                            visible: !root._useLabeledCompact
                            anchors.fill: parent
                            spacing: 12
                            Text {
                                text: root.effectiveFooterIcon
                                font: Theme.iconFontFor(16)
                                color: root.footerSelected ? Theme.textPrimary : Theme.textSecondary
                                Layout.preferredWidth: 20
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                visible: root._paneShowsLabels && !root.paneSearchHighlightQuery.length
                                text: root.footerText
                                font.pixelSize: Theme.fontBody
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            MatchHighlightText {
                                visible: root._paneShowsLabels && root.paneSearchHighlightQuery.length > 0
                                sourceText: root.footerText
                                query: root.paneSearchHighlightQuery
                                font.pixelSize: Theme.fontBody
                                normalColor: Theme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            InfoBadge {
                                visible: root._paneShowsLabels
                                         && (root.footerBadge.length > 0 || root.footerBadgeValue >= 0)
                                Layout.alignment: Qt.AlignVCenter
                                text: root.footerBadge
                                value: root.footerBadgeValue >= 0 ? root.footerBadgeValue : 0
                                severity: informational
                                hideWhenEmpty: false
                            }
                        }
                        Column {
                            visible: root._useLabeledCompact
                            anchors.fill: parent
                            anchors.topMargin: 6
                            anchors.bottomMargin: 4
                            spacing: 2
                            Text {
                                width: parent.width
                                text: root.effectiveFooterIcon
                                font: Theme.iconFontFor(16)
                                color: root.footerSelected ? Theme.textPrimary : Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                visible: !root.paneSearchHighlightQuery.length
                                width: parent.width
                                text: root.footerText
                                font.pixelSize: Theme.fontCaption
                                color: Theme.textPrimary
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                            MatchHighlightText {
                                visible: root.paneSearchHighlightQuery.length > 0
                                width: parent.width
                                sourceText: root.footerText
                                query: root.paneSearchHighlightQuery
                                font.pixelSize: Theme.fontCaption
                                normalColor: Theme.textPrimary
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
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
                        from: root._enterOpacity
                        to: 1
                        duration: root._animOpacity ? Theme.duration(Theme.motionNormal) : 0
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "x"
                        from: root._enterX
                        to: 0
                        duration: root._animX ? Theme.duration(Theme.motionSlow) : 0
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "y"
                        from: root._enterY
                        to: 0
                        duration: root._animY ? Theme.duration(Theme.motionSlow) : 0
                        easing.type: Theme.easingEnter
                    }
                    NumberAnimation {
                        property: "scale"
                        from: root._enterScale
                        to: 1
                        duration: root._animScale ? Theme.duration(Theme.motionSlow) : 0
                        easing.type: Theme.easingEnter
                    }
                }
            }
            replaceExit: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 1
                        to: root._exitOpacity
                        duration: root._animOpacity ? Theme.duration(Theme.motionFast) : 0
                        easing.type: Theme.easingExit
                    }
                    NumberAnimation {
                        property: "x"
                        from: 0
                        to: root._exitX
                        duration: root._animX ? Theme.duration(Theme.motionFast) : 0
                        easing.type: Theme.easingExit
                    }
                    NumberAnimation {
                        property: "y"
                        from: 0
                        to: root._exitY
                        duration: root._animY ? Theme.duration(Theme.motionFast) : 0
                        easing.type: Theme.easingExit
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 1
                        to: root._exitScale
                        duration: root._animScale ? Theme.duration(Theme.motionFast) : 0
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
        // Body content height
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

                layer.enabled: compactFlyout.opened && !Theme.reducedMotion
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
                    Component.onCompleted: Qt.callLater(function () {
                        if (flyoutList)
                            flyoutList.forceActiveFocus()
                    })
                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Escape) {
                            compactFlyout.close()
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (currentIndex >= 0 && currentIndex < flyoutModel.count) {
                                root.selectKey(flyoutModel.get(currentIndex).key, root.pageTransition)
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
                            root.selectKey(key, root.pageTransition)
                            compactFlyout.close()
                        }

                        contentItem: Row {
                            spacing: 10
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                text: flyDel.glyph || FluentIcons.Placeholder
                                font: Theme.iconFontFor(14)
                                color: flyDel.highlighted ? Theme.textPrimary : Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 30
                                visible: !root.paneSearchHighlightQuery.length
                                text: flyDel.title
                                font.pixelSize: Theme.fontBody
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                            }
                            MatchHighlightText {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 30
                                visible: root.paneSearchHighlightQuery.length > 0
                                sourceText: flyDel.title
                                query: root.paneSearchHighlightQuery
                                font.pixelSize: Theme.fontBody
                                normalColor: Theme.textPrimary
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

    Popup {
        id: jumpListPopup
        parent: Overlay.overlay
        modal: true
        focus: true
        property var entries: []
        width: Math.min(320, root.width - 24)
        height: Math.min(420, jumpListCol.implicitHeight + 24)
        x: parent ? Math.round((parent.width - width) / 2) : 40
        y: parent ? Math.round(parent.height * 0.12) : 80
        padding: Theme.spacing
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onAboutToShow: entries = root.collectJumpListEntries()
        background: ElevatedChrome {
            radius: Theme.cornerOverlay
        }
        contentItem: ColumnLayout {
            id: jumpListCol
            spacing: Theme.spacingTight
            width: jumpListPopup.availableWidth
            Text {
                text: qsTr("Jump to page")
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Flickable {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(360, jumpListInner.implicitHeight)
                contentHeight: jumpListInner.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ColumnLayout {
                    id: jumpListInner
                    width: parent.width
                    spacing: 2
                    Repeater {
                        model: jumpListPopup.entries
                        delegate: ItemDelegate {
                            required property var modelData
                            required property int index
                            Layout.fillWidth: true
                            height: Theme.navItemHeight
                            Accessible.name: modelData.title
                            onClicked: {
                                root.selectKey(modelData.key, root.pageTransition)
                                jumpListPopup.close()
                            }
                            contentItem: ColumnLayout {
                                spacing: 0
                                Text {
                                    visible: {
                                        if (index === 0)
                                            return true
                                        var prev = jumpListPopup.entries[index - 1]
                                        return !prev || prev.group !== modelData.group
                                    }
                                    text: modelData.group || qsTr("Pages")
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                }
                                Text {
                                    text: modelData.title
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
}
