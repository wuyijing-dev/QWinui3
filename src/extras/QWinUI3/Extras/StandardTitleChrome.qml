import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// StandardTitleChrome — PlatformTitleBar + TitleBar with WinUI header slots.
//
//   StandardWindow {
//       id: win
//       header: StandardTitleChrome {
//           targetWindow: win
//           title: qsTr("App")
//           rightHeader: Button { text: qsTr("Share"); flat: true }
//       }
//   }
//
// Same slot model as ShellWindow (leftHeader / titleBarContent / rightHeader).

PlatformTitleBar {
    id: root

    // Primary title text
    property string title: qsTr("Application")
    // Secondary subtitle text
    property string subtitle: ""
    // FluentIcons symbol
    property var symbol: ""
    // WinUI LeftHeader slot
    property alias leftHeader: titleBar.leftHeader
    // Title-bar middle content (menus, toolbar, …)
    property alias titleBarContent: titleBar.content
    // WinUI RightHeader slot
    property alias rightHeader: titleBar.rightHeader
    // Built-in title-bar search
    property alias searchEnabled: titleBar.searchEnabled
    property alias searchText: titleBar.searchText
    property alias searchModel: titleBar.searchModel
    property alias isBackButtonVisible: titleBar.isBackButtonVisible
    property alias isBackButtonEnabled: titleBar.isBackButtonEnabled
    property alias isPaneToggleButtonVisible: titleBar.isPaneToggleButtonVisible

    signal backRequested()
    signal paneToggleRequested()
    signal searchActivated(var item)
    signal searchTextEdited(string text)

    TitleBar {
        id: titleBar
        anchors.fill: parent
        embedded: true
        dragWindow: root.targetWindow
        useSystemMove: true
        preferredHeight: root.resolvedCaptionHeight
        title: root.title
        subtitle: root.subtitle
        symbol: root.symbol
        onBackRequested: root.backRequested()
        onPaneToggleRequested: root.paneToggleRequested()
        onSearchActivated: function (item) { root.searchActivated(item) }
        onSearchTextEdited: function (text) { root.searchTextEdited(text) }
        onWidthChanged: root.reportHitTest()
        onHeightChanged: root.reportHitTest()
    }

    Component.onCompleted: Qt.callLater(function () { root.reportHitTest() })

    Connections {
        target: WindowHelper
        function onScreensChanged() { root.reportHitTest() }
    }
}
