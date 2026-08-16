import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// TabViewTearOutWindow — Host window for a torn-out TabView tab.
//
// Loaded at runtime via Qt.createComponent(URL) from TabView so the two types
// do not form a compile-time dependency cycle.

BlankWindow {
    id: tearWin

    Accessible.role: Accessible.Window
    Accessible.name: tearWin.title
    Accessible.description: qsTr("Torn-out tab")

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
