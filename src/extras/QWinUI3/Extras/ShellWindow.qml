import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// ShellWindow — Independent ApplicationWindow + WindowChrome host.
//
//   ShellWindow {
//       title: qsTr("App")
//       symbol: FluentIcons.Home
//       paradigm: WindowHelper.ParadigmStandard
//       presenter: WindowHelper.PresenterOverlapped
//   }
//
//   // --- API ---
//   // roles:    paradigm (Standard/Dialog/Tool), presenter, isAlwaysOnTop, backdrop
//   // actions:  applyWindowRole(), setPresenterKind(k), setWindowParadigm(p),
//   //           setAlwaysOnTopEnabled(on), centerOnScreen()
//   // signals: onPaneToggleRequested, onBackRequested, onSearchActivated, onSearchTextEdited
//   // inherits ApplicationWindow (+ Qt Quick Controls base API)
//
// @notes
//   ApplicationWindow + WindowChrome; does not subclass StandardWindow.
//   Use BlankWindow / NavigationWindow / MenuStatusWindow / DialogShellWindow /
//   ToolShellWindow / CompactOverlayShellWindow for common layouts.
//   Title-bar slots: leftHeader, titleBarContent, rightHeader, menusInTitleBar.
//   Window roles (作用): paradigm + presenter + always-on-top via WindowHelper.
//   Backdrop / paradigm via WindowHelper (see docs/window-helper.md).

ApplicationWindow {
    id: root

    // Secondary subtitle text
    property alias subtitle: chrome.subtitle
    // FluentIcons symbol (preferred over iconGlyph)
    property alias symbol: chrome.symbol
    // WindowChrome / PlatformTitleBar host
    property alias chrome: chrome
    // Shared WindowHelper install glue
    property alias shellSupport: shellSupport
    // Show navigation pane toggle
    property bool showPaneToggle: false
    // Enable title-bar search
    property alias searchEnabled: chrome.searchEnabled
    // Show back button
    property alias isBackButtonVisible: chrome.isBackButtonVisible
    // Enable back button
    property alias isBackButtonEnabled: chrome.isBackButtonEnabled
    // WinUI LeftHeader slot
    property alias leftHeader: chrome.leftHeader
    // Extra title-bar middle content (e.g. MenuBar when menusInTitleBar)
    property alias titleBarContent: chrome.titleBarContent
    // WinUI RightHeader slot
    property alias rightHeader: chrome.rightHeader
    // Title-bar search field text
    property alias searchText: chrome.searchText
    // Title-bar search suggestions
    property alias searchModel: chrome.searchModel

    // WindowHelper.Backdrop*
    property int backdrop: WindowHelper.BackdropSolid
    // Platform-safe backdrop (Linux coerces Mica/Acrylic → Solid).
    readonly property int effectiveBackdrop: WindowHelper.resolveBackdrop(backdrop)
    // WindowHelper.TitleBarHeightStandard | TitleBarHeightTall
    property int preferredHeightOption: WindowHelper.TitleBarHeightTall
    // WindowHelper.Presenter*
    property int presenter: WindowHelper.PresenterOverlapped
    // WindowHelper.Paradigm*
    property int paradigm: WindowHelper.ParadigmStandard
    // Keep window above others
    property bool isAlwaysOnTop: false
    // Custom frame / extend content
    property bool extendsContentIntoTitleBar: WindowHelper.customFrame
    // Show min/max/close
    property bool showCaptionButtons: WindowHelper.customFrame
    // Show minimize caption button
    property bool showMinimize: true
    // Show maximize caption button
    property bool showMaximize: true
    // Show close caption button
    property bool showClose: true

    // AppWindowTitleBar-style caption colors (empty = Theme defaults).
    property color captionButtonBackground: "transparent"
    // Caption button hover fill
    property color captionButtonHover: Theme.fillSubtle
    // Caption button pressed fill
    property color captionButtonPressed: Theme.fillSubtleTertiary
    // Caption button glyph color
    property color captionButtonForeground: Theme.textPrimary
    // Close button hover fill
    property color captionCloseHover: "#E81123"
    // Close button pressed fill
    property color captionClosePressed: "#C50F1F"
    // Title bar background color
    property color titleBarBackground: Theme.bgAcrylic
    // Dim title bar when inactive
    property bool titleBarInactive: false

    // Emitted when pane toggle is clicked
    signal paneToggleRequested()
    // Emitted when back is requested
    signal backRequested()
    // Emitted when a search result is activated
    signal searchActivated(var item)
    // Emitted when search text changes
    signal searchTextEdited(string text)
    // Emitted when a CommandPalette command is run
    signal commandTriggered(var command)

    // Ctrl+K command palette (modern desktop launcher)
    property bool commandPaletteEnabled: true
    property var commandPaletteCommands: []
    property alias commandPalette: commandPalette

    // Compat aliases — prefer title / subtitle / symbol.
    property alias windowTitle: chrome.title
    // Window subtitle alias
    property alias windowSubtitle: chrome.subtitle
    // Window symbol alias
    property alias windowSymbol: chrome.symbol

    // Human-readable role summary for Gallery / diagnostics
    readonly property string windowRoleSummary: {
        return WindowHelper.paradigmName(paradigm)
                + " · " + WindowHelper.presenterName(presenter)
                + (isAlwaysOnTop ? " · topmost" : "")
    }

    // Re-apply paradigm + presenter + always-on-top + backdrop
    function applyWindowRole() {
        shellSupport.applyChrome()
    }

    // Switch AppWindowPresenterKind at runtime
    function setPresenterKind(kind) {
        presenter = kind
    }

    // Switch Standard / Dialog / Tool paradigm at runtime
    function setWindowParadigm(kind) {
        paradigm = kind
    }

    // Toggle stay-on-top
    function setAlwaysOnTopEnabled(on) {
        isAlwaysOnTop = !!on
    }

    // Center on the current screen
    function centerOnScreen() {
        shellSupport.centerOnScreen()
    }

    flags: WindowHelper.recommendedFlags
    color: Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    header: WindowChrome {
        id: chrome
        targetWindow: root
        preferredHeightOption: root.preferredHeightOption
        title: root.title
        showPaneToggle: root.showPaneToggle
        showCaptionButtons: root.showCaptionButtons && root.extendsContentIntoTitleBar
        showMinimize: root.showMinimize
        showMaximize: root.showMaximize
        showClose: root.showClose
        captionButtonBackground: root.captionButtonBackground
        captionButtonHover: root.captionButtonHover
        captionButtonPressed: root.captionButtonPressed
        captionButtonForeground: root.captionButtonForeground
        captionCloseHover: root.captionCloseHover
        captionClosePressed: root.captionClosePressed
        titleBarBackground: root.titleBarBackground
        titleBarInactive: root.titleBarInactive
        onTitleChanged: function () {
            if (root.title !== chrome.title)
                root.title = chrome.title
        }
        onPaneToggleRequested: root.paneToggleRequested()
        onBackRequested: root.backRequested()
        onSearchActivated: function (item) { root.searchActivated(item) }
        onSearchTextEdited: function (text) { root.searchTextEdited(text) }
    }

    onTitleChanged: function () {
        if (chrome.title !== root.title)
            chrome.title = root.title
    }

    background: Rectangle {
        color: root.effectiveBackdrop === WindowHelper.BackdropSolid
               || root.effectiveBackdrop === WindowHelper.BackdropNone
               ? Theme.bgLayer : "transparent"
    }

    ShellWindowSupport {
        id: shellSupport
        targetWindow: root
        paradigm: root.paradigm
        backdrop: root.effectiveBackdrop
        presenter: root.presenter
        isAlwaysOnTop: root.isAlwaysOnTop
        extendsContentIntoTitleBar: root.extendsContentIntoTitleBar
    }

    Shortcut {
        enabled: root.commandPaletteEnabled && root.visible
        sequences: ["Ctrl+K", "Meta+K"]
        onActivated: commandPalette.toggle()
    }

    CommandPalette {
        id: commandPalette
        parent: Overlay.overlay
        commands: root.commandPaletteCommands
        onCommandTriggered: function (cmd) { root.commandTriggered(cmd) }
    }
}
