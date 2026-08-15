import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TwoPaneView — Responsive dual-pane layout.
//
//   TwoPaneView {
//       pane1: Rectangle { }
//       pane2: Rectangle { }
//   }

T.Control {
    id: root

    enum Mode {
        Wide,
        Tall,
        SinglePane
    }

    enum PanePriority {
        Pane1,
        Pane2
    }

    // First pane content
    property Item pane1: null
    // Second pane content
    property Item pane2: null
    property real panePriorityWidth: 320
    property alias pane1Length: root.panePriorityWidth
    property real minWideWidth: 720
    property int preferredMode: TwoPaneView.Wide
    property int panePriority: TwoPaneView.Pane1
    property int mode: {
        if (width < minWideWidth)
            return preferredMode === TwoPaneView.Tall ? TwoPaneView.Tall : TwoPaneView.SinglePane
        return preferredMode === TwoPaneView.Tall ? TwoPaneView.Tall : TwoPaneView.Wide
    }
    property int singlePaneIndex: 0

    readonly property string modeName: {
        switch (mode) {
        case TwoPaneView.Wide: return qsTr("Wide")
        case TwoPaneView.Tall: return qsTr("Tall")
        default: return qsTr("SinglePane")
        }
    }

    padding: 0
    spacing: Theme.spacing
    implicitWidth: 640
    implicitHeight: 360
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Two pane view")
    Accessible.description: modeName

    function showPane1() { singlePaneIndex = 0 }
    function showPane2() { singlePaneIndex = 1 }
    function toggleSinglePane() {
        singlePaneIndex = singlePaneIndex === 0 ? 1 : 0
    }

    function swapPanes() {
        var a = pane1
        pane1 = pane2
        pane2 = a
    }

    function _syncPanePriority() {
        singlePaneIndex = panePriority === TwoPaneView.Pane2 ? 1 : 0
    }

    Component.onCompleted: _syncPanePriority()
    onPanePriorityChanged: {
        _syncPanePriority()
        Qt.callLater(host.layoutPanes)
    }

    contentItem: Item {
        id: host

        function reparentPanes() {
            if (root.pane1 && root.pane1.parent !== host)
                root.pane1.parent = host
            if (root.pane2 && root.pane2.parent !== host)
                root.pane2.parent = host
            layoutPanes()
        }

        function layoutPanes() {
            var gap = root.spacing
            var w = width
            var h = height
            if (!root.pane1 && !root.pane2)
                return

            if (root.mode === TwoPaneView.Wide) {
                var leftW = Math.min(root.panePriorityWidth, Math.max(120, w * 0.38))
                if (root.pane1) {
                    root.pane1.visible = true
                    root.pane1.x = 0; root.pane1.y = 0
                    root.pane1.width = leftW; root.pane1.height = h
                }
                if (root.pane2) {
                    root.pane2.visible = true
                    root.pane2.x = leftW + gap; root.pane2.y = 0
                    root.pane2.width = Math.max(0, w - leftW - gap)
                    root.pane2.height = h
                }
            } else if (root.mode === TwoPaneView.Tall) {
                var topH = Math.min(root.panePriorityWidth, Math.max(80, h * 0.38))
                if (root.pane1) {
                    root.pane1.visible = true
                    root.pane1.x = 0; root.pane1.y = 0
                    root.pane1.width = w; root.pane1.height = topH
                }
                if (root.pane2) {
                    root.pane2.visible = true
                    root.pane2.x = 0; root.pane2.y = topH + gap
                    root.pane2.width = w
                    root.pane2.height = Math.max(0, h - topH - gap)
                }
            } else {
                if (root.pane1) {
                    root.pane1.visible = root.singlePaneIndex === 0
                    root.pane1.x = 0; root.pane1.y = 0
                    root.pane1.width = w; root.pane1.height = h
                }
                if (root.pane2) {
                    root.pane2.visible = root.singlePaneIndex === 1
                    root.pane2.x = 0; root.pane2.y = 0
                    root.pane2.width = w; root.pane2.height = h
                }
            }
        }

        onWidthChanged: layoutPanes()
        onHeightChanged: layoutPanes()
        Component.onCompleted: reparentPanes()
    }

    onPane1Changed: Qt.callLater(host.reparentPanes)
    onPane2Changed: Qt.callLater(host.reparentPanes)
    onModeChanged: Qt.callLater(host.layoutPanes)
    onSinglePaneIndexChanged: Qt.callLater(host.layoutPanes)
    onSpacingChanged: Qt.callLater(host.layoutPanes)
    onPanePriorityWidthChanged: Qt.callLater(host.layoutPanes)

    background: Rectangle {
        color: Theme.bgLayer
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
