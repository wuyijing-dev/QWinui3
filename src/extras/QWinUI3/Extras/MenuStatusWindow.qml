import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// TitleBar → MenuBar → content → StatusBar.
// Set menusInTitleBar: true to embed MenuBar in the title chrome (WinUI-style).
ShellWindow {
    id: root

    default property alias menus: menus.contentData
    property alias statusText: statusBar.text
    property alias statusBar: statusBar
    property alias shellMenuBar: menus
    property alias content: body.data
    property alias statusProgress: statusBar.progress
    property alias statusProgressIndeterminate: statusBar.progressIndeterminate
    property alias statusCenter: statusBar.centerContent
    property alias statusRight: statusBar.content
    property bool menusInTitleBar: false

    width: 880
    height: 560
    title: qsTr("Menu + status window")
    subtitle: qsTr("Workbench shell")
    symbol: FluentIcons.OpenInNewWindow
    searchEnabled: false

    titleBarContent: Item {
        id: titleMenuHost
        // Intrinsic size only — TitleBar hit-test uses childrenRect so caption
        // drag still works beside the menus.
        implicitWidth: root.menusInTitleBar ? Math.max(1, menus.implicitWidth) : 0
        implicitHeight: 32
        width: implicitWidth
        height: parent ? parent.height : 32
        clip: true

        onWidthChanged: root.chrome.reportHitTest()
        onHeightChanged: root.chrome.reportHitTest()
        onVisibleChanged: root.chrome.reportHitTest()
    }

    footer: StatusBar {
        id: statusBar
        text: qsTr("Ready")
    }

    function addMenu(menu) {
        if (!menu)
            return
        menus.addMenu(menu)
    }

    function clearMenus() {
        while (menus.count > 0)
            menus.takeMenu(0)
    }

    function _placeMenuBar() {
        if (root.menusInTitleBar) {
            menus.parent = titleMenuHost
            menus.anchors.fill = undefined
            menus.anchors.left = titleMenuHost.left
            menus.anchors.top = titleMenuHost.top
            menus.anchors.bottom = titleMenuHost.bottom
            menus.width = Qt.binding(function () { return Math.max(1, menus.implicitWidth) })
        } else {
            menus.width = undefined
            menus.anchors.fill = undefined
            menus.parent = menuStripHost
            menus.anchors.left = menuStripHost.left
            menus.anchors.right = menuStripHost.right
            menus.anchors.top = menuStripHost.top
        }
        Qt.callLater(function () { root.chrome.reportHitTest() })
    }

    onMenusInTitleBarChanged: _placeMenuBar()
    Component.onCompleted: _placeMenuBar()

    Connections {
        target: menus
        function onImplicitWidthChanged() {
            if (root.menusInTitleBar)
                root.chrome.reportHitTest()
        }
        function onCountChanged() {
            if (root.menusInTitleBar)
                Qt.callLater(function () { root.chrome.reportHitTest() })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: menuStripHost
            visible: !root.menusInTitleBar
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? Math.max(32, menus.implicitHeight) : 0
            clip: true
        }

        MenuBar {
            id: menus
        }

        Item {
            id: body
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
