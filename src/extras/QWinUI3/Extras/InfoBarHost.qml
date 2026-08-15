import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// InfoBarHost — Stacks InfoBars in a host region.
//
//   InfoBarHost { id: bars }
//   // bars.enqueue({ title: "Hi", severity: InfoBar.Informational })

T.Control {
    id: root

    // contentData / spacing are FINAL on Control — do not redeclare.
    // Children land in contentItem (stack) via Control's default contentData.
    spacing: Theme.spacing
    // Max visible items before overflow
    property int maxVisible: 0 // 0 = unlimited

    // Item count
    readonly property int count: {
        var n = 0
        for (var i = 0; i < stack.children.length; ++i) {
            if (stack.children[i] && stack.children[i].isOpen !== undefined)
                ++n
        }
        return n
    }

    // Open Count
    readonly property int openCount: {
        var n = 0
        for (var i = 0; i < stack.children.length; ++i) {
            var c = stack.children[i]
            if (c && c.isOpen)
                ++n
        }
        return n
    }

    implicitWidth: 480
    implicitHeight: stack.implicitHeight
    visible: openCount > 0 || stack.children.length > 0
    Accessible.role: Accessible.AlertMessage
    Accessible.name: qsTr("Info bars")
    Accessible.description: qsTr("%1 open").arg(openCount)

    // Close All
    function closeAll() {
        for (var i = 0; i < stack.children.length; ++i) {
            var c = stack.children[i]
            if (c && c.isOpen !== undefined)
                c.isOpen = false
        }
    }

    // Clear All
    function clearAll() { closeAll() }

    // Open All
    function openAll() {
        for (var i = 0; i < stack.children.length; ++i) {
            var c = stack.children[i]
            if (c && c.isOpen !== undefined)
                c.isOpen = true
        }
    }

    contentItem: ColumnLayout {
        id: stack
        spacing: root.spacing
        width: root.availableWidth > 0 ? root.availableWidth : root.implicitWidth

        onChildrenChanged: {
            if (root.maxVisible <= 0)
                return
            var bars = []
            for (var i = 0; i < children.length; ++i) {
                if (children[i] && children[i].isOpen !== undefined)
                    bars.push(children[i])
            }
            for (var j = 0; j < bars.length; ++j)
                bars[j].visible = j >= bars.length - root.maxVisible
        }
    }

    background: Item {}
}
