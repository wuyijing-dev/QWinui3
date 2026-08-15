import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: root

    default property alias contentData: grid.data
    property int rows: 0          // 0 = auto from children + columns
    property int columns: 2
    property real rowSpacing: Theme.spacing
    property real columnSpacing: Theme.spacing
    property real cellWidth: -1   // <0 → equal share of width
    property real cellHeight: -1  // <0 → equal share of height / implicit
    property int layoutDirection: Qt.LeftToRight
    property real cellSpacing: -1

    padding: 0
    implicitWidth: 200
    implicitHeight: 200
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Uniform grid")

    readonly property int childCount: {
        var n = 0
        for (var i = 0; i < grid.children.length; ++i) {
            if (grid.children[i] && grid.children[i].visible)
                ++n
        }
        return n
    }

    onCellSpacingChanged: {
        if (cellSpacing >= 0) {
            rowSpacing = cellSpacing
            columnSpacing = cellSpacing
        }
    }

    contentItem: Item {
        id: grid
        onChildrenChanged: Qt.callLater(root.relayout)
        onWidthChanged: root.relayout()
        onHeightChanged: root.relayout()
    }

    onColumnsChanged: relayout()
    onRowsChanged: relayout()
    onRowSpacingChanged: relayout()
    onColumnSpacingChanged: relayout()
    onCellWidthChanged: relayout()
    onCellHeightChanged: relayout()
    onLayoutDirectionChanged: relayout()
    onWidthChanged: relayout()
    onHeightChanged: relayout()

    function visibleChildren() {
        var list = []
        for (var i = 0; i < grid.children.length; ++i) {
            var ch = grid.children[i]
            if (ch && ch.visible && ch.opacity > 0)
                list.push(ch)
        }
        return list
    }

    function relayout() {
        var kids = visibleChildren()
        var cols = Math.max(1, columns)
        var count = kids.length
        var rowCount = rows > 0 ? rows : Math.max(1, Math.ceil(count / cols))
        var availW = Math.max(0, grid.width - columnSpacing * (cols - 1))
        var availH = Math.max(0, grid.height - rowSpacing * (rowCount - 1))
        var cw = cellWidth >= 0 ? cellWidth : (cols > 0 ? availW / cols : availW)
        var ch = cellHeight >= 0 ? cellHeight : (rowCount > 0 ? availH / rowCount : availH)
        var rtl = layoutDirection === Qt.RightToLeft

        for (var i = 0; i < kids.length; ++i) {
            var r = Math.floor(i / cols)
            var c = i % cols
            if (rows > 0 && r >= rows) {
                kids[i].visible = false
                continue
            }
            var col = rtl ? (cols - 1 - c) : c
            kids[i].width = cw
            kids[i].height = ch
            kids[i].x = col * (cw + columnSpacing)
            kids[i].y = r * (ch + rowSpacing)
        }

        if (cellHeight < 0 && cellWidth < 0 && count > 0 && grid.height < 1) {
            // Prefer implicit height when not stretched
            implicitHeight = rowCount * (Theme.controlHeight + rowSpacing) - rowSpacing
                + topPadding + bottomPadding
        }
    }

    Component.onCompleted: Qt.callLater(relayout)
    background: Item {}
}
