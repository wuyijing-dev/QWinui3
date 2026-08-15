import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Host that stacks InfoBar children with spacing and optional max visible count.
T.Control {
    id: root

    default property alias contentData: stack.data
    property int spacing: Theme.spacing
    property int maxVisible: 0 // 0 = unlimited

    readonly property int count: {
        var n = 0
        for (var i = 0; i < stack.children.length; ++i) {
            if (stack.children[i] && stack.children[i].isOpen !== undefined)
                ++n
        }
        return n
    }

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

    function closeAll() {
        for (var i = 0; i < stack.children.length; ++i) {
            var c = stack.children[i]
            if (c && c.isOpen !== undefined)
                c.isOpen = false
        }
    }

    function clearAll() { closeAll() }

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
