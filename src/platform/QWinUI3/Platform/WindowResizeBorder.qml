import QtQuick
import QtQuick.Window

// WindowResizeBorder — Non-native resize hit edges.
//
//   WindowResizeBorder { targetWindow: root }

Item {
    id: root
    anchors.fill: parent
    // Window this chrome is attached to
    property var targetWindow: null
    // Donut ring thickness
    property real thickness: 6
    visible: targetWindow !== null
    enabled: visible
    z: 1000

    // Edge Resize
    function edgeResize(edges) {
        if (root.targetWindow && root.targetWindow.startSystemResize)
            root.targetWindow.startSystemResize(edges)
    }

    // Edges
    MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.thickness
        hoverEnabled: true
        cursorShape: Qt.SizeHorCursor
        onPressed: root.edgeResize(Qt.LeftEdge)
    }
    MouseArea {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.thickness
        hoverEnabled: true
        cursorShape: Qt.SizeHorCursor
        onPressed: root.edgeResize(Qt.RightEdge)
    }
    MouseArea {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.thickness
        hoverEnabled: true
        cursorShape: Qt.SizeVerCursor
        onPressed: root.edgeResize(Qt.TopEdge)
    }
    MouseArea {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.thickness
        hoverEnabled: true
        cursorShape: Qt.SizeVerCursor
        onPressed: root.edgeResize(Qt.BottomEdge)
    }

    // Corners
    MouseArea {
        width: root.thickness * 2
        height: root.thickness * 2
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor
        onPressed: root.edgeResize(Qt.LeftEdge | Qt.TopEdge)
    }
    MouseArea {
        width: root.thickness * 2
        height: root.thickness * 2
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeBDiagCursor
        onPressed: root.edgeResize(Qt.RightEdge | Qt.TopEdge)
    }
    MouseArea {
        width: root.thickness * 2
        height: root.thickness * 2
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeBDiagCursor
        onPressed: root.edgeResize(Qt.LeftEdge | Qt.BottomEdge)
    }
    MouseArea {
        width: root.thickness * 2
        height: root.thickness * 2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor
        onPressed: root.edgeResize(Qt.RightEdge | Qt.BottomEdge)
    }
}
