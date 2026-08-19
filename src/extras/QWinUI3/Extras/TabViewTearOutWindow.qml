import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// TabViewTearOutWindow — Host window for a torn-out TabView tab.
//
// Loaded at runtime via Qt.createComponent(URL) from TabView so the two types
// do not form a compile-time dependency cycle.
//
//   TabView { canTearOutTabs: true; createTearOutWindow: true }
//
// close() only hides a dynamically created ApplicationWindow. dismiss() hides
// and destroy()s the host so it cannot keep running after the last tab is
// closed, docked back, or the source TabView is recycled.

BlankWindow {
    id: tearWin
    property var tabData: ({})
    property var tabModel: []
    property bool _dismissing: false
    property bool _hostReady: false
    property bool _qmlGone: false

    width: 560
    height: 400
    minimumWidth: 320
    minimumHeight: 240
    title: {
        var item = tornTabs.selectedItem
        if (item === undefined || item === null) {
            var m = tornTabs.model
            if (m && m.length)
                item = m[0]
        }
        if (typeof item === "string")
            return item
        if (item && item.title)
            return item.title
        var d = tearWin.tabData
        if (typeof d === "string")
            return d
        if (d && d.title)
            return d.title
        return qsTr("Tab")
    }
    subtitle: qsTr("Torn-out tab")
    symbol: {
        var item = tornTabs.selectedItem
        if (item && typeof item === "object" && item.symbol)
            return item.symbol
        var d = tearWin.tabData
        if (d && typeof d === "object")
            return d.symbol || FluentIcons.OpenInNewWindow
        return FluentIcons.OpenInNewWindow
    }

    function dismiss() {
        if (tearWin._dismissing)
            return
        tearWin._dismissing = true
        if (visible)
            close()
        Qt.callLater(function () {
            if (!tearWin || tearWin._qmlGone)
                return
            tearWin._qmlGone = true
            tearWin.destroy()
        })
    }

    onClosing: function () {
        tearWin._dismissing = true
        Qt.callLater(function () {
            if (!tearWin || tearWin._qmlGone)
                return
            tearWin._qmlGone = true
            tearWin.destroy()
        })
    }

    Component.onCompleted: {
        if (!tabModel || tabModel.length === 0) {
            var d = tearWin.tabData
            tabModel = (d === undefined || d === null) ? [] : [d]
        }
        tearWin._hostReady = true
        if (tornTabs.tabCount === 0)
            tearWin.dismiss()
    }

    TabView {
        id: tornTabs
        anchors.fill: parent
        anchors.margins: 12
        _hostWindow: tearWin
        canDragTabs: true
        tabsReorderable: true
        canTearOutTabs: true
        createTearOutWindow: true
        allowTearOutLastTab: true
        closeWhenEmpty: true
        isAddTabButtonVisible: true
        closable: true
        model: tearWin.tabModel
        onTabCountChanged: {
            if (tearWin._hostReady && tornTabs.tabCount === 0)
                tearWin.dismiss()
        }
    }
}
