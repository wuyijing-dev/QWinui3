import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Shared independent shell host (not StandardWindow).
// BlankWindow / NavigationWindow / MenuStatusWindow specialize layout only.
//
//   ShellWindow {
//       title: qsTr("App")
//       subtitle: qsTr("Optional")
//       symbol: FluentIcons.Home
//       isBackButtonVisible: true
//       rightHeader: Button { text: qsTr("Account") }
//   }
ApplicationWindow {
    id: root

    property alias subtitle: chrome.subtitle
    property alias symbol: chrome.symbol
    property alias chrome: chrome
    property bool showPaneToggle: false
    property alias searchEnabled: chrome.searchEnabled
    property alias isBackButtonVisible: chrome.isBackButtonVisible
    property alias isBackButtonEnabled: chrome.isBackButtonEnabled
    property alias leftHeader: chrome.leftHeader
    property alias titleBarContent: chrome.titleBarContent
    property alias rightHeader: chrome.rightHeader
    property alias searchText: chrome.searchText
    property alias searchModel: chrome.searchModel

    property int backdrop: WindowHelper.BackdropSolid
    property int preferredHeightOption: WindowHelper.TitleBarHeightTall
    property int presenter: WindowHelper.PresenterOverlapped
    property int paradigm: WindowHelper.ParadigmStandard
    property bool isAlwaysOnTop: false
    property bool extendsContentIntoTitleBar: WindowHelper.customFrame
    property bool showCaptionButtons: WindowHelper.customFrame
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true

    // AppWindowTitleBar-style caption colors (empty = Theme defaults).
    property color captionButtonBackground: "transparent"
    property color captionButtonHover: Theme.fillSubtle
    property color captionButtonPressed: Theme.fillSubtleTertiary
    property color captionButtonForeground: Theme.textPrimary
    property color captionCloseHover: "#E81123"
    property color captionClosePressed: "#C50F1F"
    property color titleBarBackground: Theme.bgAcrylic
    property bool titleBarInactive: false

    signal paneToggleRequested()
    signal backRequested()
    signal searchActivated(var item)
    signal searchTextEdited(string text)

    // Compat aliases — prefer title / subtitle / symbol.
    property alias windowTitle: chrome.title
    property alias windowSubtitle: chrome.subtitle
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
