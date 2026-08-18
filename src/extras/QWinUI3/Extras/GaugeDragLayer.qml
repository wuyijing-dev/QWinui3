import QtQuick

// Maps drags anywhere on the gauge control into coordSpace (face / canvas / track).
MouseArea {
    id: root

    property Item coordSpace: null

    signal dragged(real x, real y)

    anchors.fill: parent
    preventStealing: true
    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    function mapToCoord(mx, my) {
        if (!coordSpace)
            return Qt.point(mx, my)
        return root.mapToItem(coordSpace, mx, my)
    }

    onPressed: function (mouse) { positionChanged(mouse) }
    onPositionChanged: function (mouse) {
        if (!pressed)
            return
        var p = mapToCoord(mouse.x, mouse.y)
        root.dragged(p.x, p.y)
    }
}
