import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// TabViewTearOutWindow — Host window for a torn-out TabView tab.
//
// Kept as a separate type so TabView.qml does not recursively instantiate itself.

BlankWindow {
    id: tearWin

    property var tabData: ({})

    width: 560
    height: 400
    minimumWidth: 320
    minimumHeight: 240
    title: {
        var d = tearWin.tabData
        if (typeof d === "string")
            return d
        if (d && d.title)
            return d.title
        return qsTr("Tab")
    }
    subtitle: qsTr("Torn-out tab")
    symbol: {
        var d = tearWin.tabData
        if (d && typeof d === "object")
            return d.symbol || FluentIcons.OpenInNewWindow
        return FluentIcons.OpenInNewWindow
    }

    TabView {
        id: tornTabs
        anchors.fill: parent
        anchors.margins: 12
        canDragTabs: true
        tabsReorderable: true
        canTearOutTabs: true
        createTearOutWindow: true
        allowTearOutLastTab: true
        isAddTabButtonVisible: true
        closable: true
        model: {
            var d = tearWin.tabData
            if (d === undefined || d === null)
                return []
            return [d]
        }
        onTabCloseRequested: Qt.callLater(function () {
            if (tornTabs.tabCount === 0)
                tearWin.close()
        })
        onTabTearOutRequested: Qt.callLater(function () {
            if (tornTabs.tabCount === 0)
                tearWin.close()
        })
    }
}
