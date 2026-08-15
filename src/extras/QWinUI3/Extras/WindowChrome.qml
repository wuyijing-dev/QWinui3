import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Shared AppWindow title chrome for shell windows (PlatformTitleBar + TitleBar).
PlatformTitleBar {
    id: root

    property string title: qsTr("Application")
    property string subtitle: ""
    property var symbol: ""
    property bool showPaneToggle: false
    property bool searchEnabled: false
    property alias isBackButtonVisible: titleBar.isBackButtonVisible
    property alias isBackButtonEnabled: titleBar.isBackButtonEnabled
    property alias leftHeader: titleBar.leftHeader
    property alias titleBarContent: titleBar.content
    property alias rightHeader: titleBar.rightHeader
    property alias searchText: titleBar.searchText
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
