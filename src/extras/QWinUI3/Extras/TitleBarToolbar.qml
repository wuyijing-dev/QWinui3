import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme

// TitleBarToolbar — horizontal action row for titleBarContent / leftHeader slots.
//
//   NavigationWindow {
//       titleBarContent: TitleBarToolbar {
//           Button { text: qsTr("Undo"); flat: true }
//           Button { text: qsTr("Redo"); flat: true }
//       }
//   }
//
// @notes
//   Sized for the title band; refreshes NC hit-test when children resize.

RowLayout {
    id: root

    spacing: Theme.spacingTight
    implicitHeight: Theme.searchBoxHeight - 8

    onWidthChanged: _refreshHitTest()
    onHeightChanged: _refreshHitTest()
    onImplicitWidthChanged: _refreshHitTest()
    onImplicitHeightChanged: _refreshHitTest()
    onChildrenChanged: _refreshHitTest()

    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root._refreshHitTest()
    })

    function _refreshHitTest() {
        var p = parent
        while (p) {
            if (typeof p.notifyChromeHitTest === "function") {
                p.notifyChromeHitTest()
                return
            }
            if (typeof p.reportHitTest === "function") {
                p.reportHitTest()
                return
            }
            p = p.parent
        }
    }
}
