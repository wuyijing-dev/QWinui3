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
//   }
//
//   // --- API ---
//   // signals: onPaneToggleRequested, onBackRequested, onSearchActivated, onSearchTextEdited
//   // inherits ApplicationWindow (+ Qt Quick Controls base API)

ApplicationWindow {
    id: root

    // Secondary subtitle text
    property alias subtitle: chrome.subtitle
    // FluentIcons symbol (preferred over iconGlyph)
    property alias symbol: chrome.symbol
    // WindowChrome / PlatformTitleBar host
    property alias chrome: chrome
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

    // Compat aliases — prefer title / subtitle / symbol.
    property alias windowTitle: chrome.title
    // Window subtitle alias
    property alias windowSubtitle: chrome.subtitle
    // Window symbol alias
    property alias windowSymbol: chrome.symbol

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
        onTitleChanged: {
            if (root.title !== title)
                root.title = title
        }
        onPaneToggleRequested: root.paneToggleRequested()
        onBackRequested: root.backRequested()
        onSearchActivated: function (item) { root.searchActivated(item) }
        onSearchTextEdited: function (text) { root.searchTextEdited(text) }
    }

    onTitleChanged: {
        if (chrome.title !== title)
            chrome.title = title
    }

    background: Rectangle {
        color: root.backdrop === WindowHelper.BackdropSolid
               || root.backdrop === WindowHelper.BackdropNone
               ? Theme.bgLayer : "transparent"
    }

    ShellWindowSupport {
        targetWindow: root
        paradigm: root.paradigm
        backdrop: root.backdrop
        presenter: root.presenter
        isAlwaysOnTop: root.isAlwaysOnTop
        extendsContentIntoTitleBar: root.extendsContentIntoTitleBar
    }
}
