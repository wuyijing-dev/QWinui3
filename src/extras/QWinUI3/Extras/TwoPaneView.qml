import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TwoPaneView — Responsive dual-pane layout.
//
//   TwoPaneView {
//       id: twoPaneView
//       pane1: Rectangle { }
//       pane2: Rectangle { }
//   }
//
//   // --- API ---
//   // methods: showPane1(), showPane2(), toggleSinglePane(), swapPanes()
//   // twoPaneView.showPane1()
//   // twoPaneView.showPane2()
//   // twoPaneView.toggleSinglePane()
//   // twoPaneView.swapPanes()
//
// @notes
//   Dual-pane layout with wide / tall / single modes.
//   panePriority + minWideWidth control collapse; swapPanes / toggleSinglePane.
//   Put Pane1 / Pane2 content via pane1 / pane2 aliases (or children APIs).

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
    // Width threshold for pane priority
    property real panePriorityWidth: 320
    // Primary pane length
    property alias pane1Length: root.panePriorityWidth
    // Minimum width for wide layout
    property real minWideWidth: 720
    // Preferred display mode
    property int preferredMode: TwoPaneView.Wide
    // Which pane takes priority when collapsing
    property int panePriority: TwoPaneView.Pane1
    // WinUI WideModeConfiguration: leftRight | rightLeft | singlePane
    property string wideModeConfiguration: "leftRight"
    // WinUI TallModeConfiguration: topBottom | bottomTop | singlePane
    property string tallModeConfiguration: "topBottom"
    // Display / interaction mode
    property int mode: {
        if (wideModeConfiguration === "singlePane" && preferredMode !== TwoPaneView.Tall)
            return TwoPaneView.SinglePane
        if (tallModeConfiguration === "singlePane" && preferredMode === TwoPaneView.Tall)
            return TwoPaneView.SinglePane
        if (width < minWideWidth)
            return preferredMode === TwoPaneView.Tall ? TwoPaneView.Tall : TwoPaneView.SinglePane
        return preferredMode === TwoPaneView.Tall ? TwoPaneView.Tall : TwoPaneView.Wide
    }
    // Which pane is shown in single-pane mode
    property int singlePaneIndex: 0

    // Human-readable mode name
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

    // Show primary pane
    function showPane1() { singlePaneIndex = 0 }
    // Show secondary pane
    function showPane2() { singlePaneIndex = 1 }
    // Toggle single-pane mode
    function toggleSinglePane() {
        singlePaneIndex = singlePaneIndex === 0 ? 1 : 0
    }

    // Swap primary / secondary panes
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
        Qt.callLater(function () {
            if (host)
                host.layoutPanes()
        })
    }

    contentItem: Item {
        id: host

        // Reparent TwoPaneView panes for mode
        function reparentPanes() {
            if (root.pane1 && root.pane1.parent !== host)
                root.pane1.parent = host
            if (root.pane2 && root.pane2.parent !== host)
                root.pane2.parent = host
            layoutPanes()
        }

        // Recompute TwoPaneView pane layout
        function layoutPanes() {
            var gap = root.spacing
            var w = width
            var h = height
            if (!root.pane1 && !root.pane2)
                return

            if (root.mode === TwoPaneView.Wide) {
                var leftW = Math.min(root.panePriorityWidth, Math.max(120, w * 0.38))
                var rightFirst = root.wideModeConfiguration === "rightLeft"
                var first = rightFirst ? root.pane2 : root.pane1
                var second = rightFirst ? root.pane1 : root.pane2
                if (first) {
                    first.visible = true
                    first.x = 0; first.y = 0
                    first.width = leftW; first.height = h
                }
                if (second) {
                    second.visible = true
                    second.x = leftW + gap; second.y = 0
                    second.width = Math.max(0, w - leftW - gap)
                    second.height = h
                }
            } else if (root.mode === TwoPaneView.Tall) {
                var topH = Math.min(root.panePriorityWidth, Math.max(80, h * 0.38))
                var bottomFirst = root.tallModeConfiguration === "bottomTop"
                var topPane = bottomFirst ? root.pane2 : root.pane1
                var bottomPane = bottomFirst ? root.pane1 : root.pane2
                if (topPane) {
                    topPane.visible = true
                    topPane.x = 0; topPane.y = 0
                    topPane.width = w; topPane.height = topH
                }
                if (bottomPane) {
                    bottomPane.visible = true
                    bottomPane.x = 0; bottomPane.y = topH + gap
                    bottomPane.width = w
                    bottomPane.height = Math.max(0, h - topH - gap)
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

    onPane1Changed: Qt.callLater(function () {
        if (host)
            host.reparentPanes()
    })
    onPane2Changed: Qt.callLater(function () {
        if (host)
            host.reparentPanes()
    })
    onModeChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })
    onSinglePaneIndexChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })
    onSpacingChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })
    onPanePriorityWidthChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })
    onWideModeConfigurationChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })
    onTallModeConfigurationChanged: Qt.callLater(function () {
        if (host)
            host.layoutPanes()
    })

    background: Rectangle {
        color: Theme.bgLayer
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
