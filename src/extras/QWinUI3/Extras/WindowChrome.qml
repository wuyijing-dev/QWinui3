import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// WindowChrome — PlatformTitleBar + TitleBar bundle for shells.
//
//   WindowChrome { targetWindow: root; title: qsTr("App") }

PlatformTitleBar {
    id: root

    // Primary title text
    property string title: qsTr("Application")
    // Secondary subtitle text
    property string subtitle: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Show navigation pane toggle
    property bool showPaneToggle: false
    // Enable title-bar search
    property bool searchEnabled: false
    // Show back button
    property alias isBackButtonVisible: titleBar.isBackButtonVisible
    // Enable back button
    property alias isBackButtonEnabled: titleBar.isBackButtonEnabled
    // WinUI LeftHeader slot
    property alias leftHeader: titleBar.leftHeader
    // Title-bar middle content slot
    property alias titleBarContent: titleBar.content
    // WinUI RightHeader slot
    property alias rightHeader: titleBar.rightHeader
    // Title-bar search field text
    property alias searchText: titleBar.searchText
    // Title-bar search suggestions
    property alias searchModel: titleBar.searchModel

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

    showMinimize: true
    showMaximize: true
    showClose: true
    chromeBackground: titleBarBackground
    chromeInactive: titleBarInactive
    buttonBackground: captionButtonBackground
    buttonHover: captionButtonHover
    buttonPressed: captionButtonPressed
    buttonForeground: captionButtonForeground
    closeHover: captionCloseHover
    closePressed: captionClosePressed

    TitleBar {
        id: titleBar
        anchors.fill: parent
        embedded: true
        dragWindow: root.targetWindow
        useSystemMove: true
        preferredHeight: root.resolvedCaptionHeight
        searchEnabled: root.searchEnabled
        title: root.title
        subtitle: root.subtitle
        symbol: root.symbol
        isPaneToggleButtonVisible: root.showPaneToggle
        onPaneToggleRequested: root.paneToggleRequested()
        onBackRequested: root.backRequested()
        onSearchActivated: function (item) { root.searchActivated(item) }
        onSearchTextEdited: function (text) { root.searchTextEdited(text) }
        onWidthChanged: root.reportHitTest()
        onHeightChanged: root.reportHitTest()
    }

    Component.onCompleted: Qt.callLater(function () { root.reportHitTest() })
}
