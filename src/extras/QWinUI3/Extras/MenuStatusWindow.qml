import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// MenuStatusWindow — TitleBar + MenuBar + content + StatusBar shell.
//
//   MenuStatusWindow {
//       menusInTitleBar: true
//       Menu { title: qsTr("File") }
//       content: Label { text: "Body" }
//       statusText: qsTr("Ready")
//   }

ShellWindow {
    id: root

    // Declare Menu { } children here
    default property alias menus: menus.contentData
    // StatusBar left text
    property alias statusText: statusBar.text
    // StatusBar instance
    property alias statusBar: statusBar
    // Shell MenuBar instance
    property alias shellMenuBar: menus
    // Main client area
    property alias content: body.data
    // StatusBar progress 0..1
    property alias statusProgress: statusBar.progress
    // StatusBar indeterminate progress
    property alias statusProgressIndeterminate: statusBar.progressIndeterminate
    // StatusBar center slot
    property alias statusCenter: statusBar.centerContent
    // StatusBar right slot
    property alias statusRight: statusBar.content
    // Embed MenuBar in the title chrome instead of a strip below it
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
