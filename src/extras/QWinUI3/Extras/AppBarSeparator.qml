import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// AppBarSeparator — Thin separator for CommandBar / AppBar rows.
//
//   AppBarSeparator { }

T.Control {
    id: root

    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Vertical
    property real thickness: 1
    property color separatorColor: Theme.strokeDivider
    property real margin: orientation === Qt.Vertical ? 4 : 4

    implicitWidth: orientation === Qt.Vertical ? (thickness + margin * 2) : 24
    implicitHeight: orientation === Qt.Vertical ? Theme.controlHeight + 12 : (thickness + margin * 2)
    padding: 0
    Accessible.ignored: true

    contentItem: Item {
        Rectangle {
            anchors.centerIn: parent
            width: root.orientation === Qt.Vertical ? root.thickness
                 : Math.max(12, parent.width - root.margin * 2)
            height: root.orientation === Qt.Vertical
                 ? Math.max(16, parent.height - root.margin * 2) : root.thickness
            color: root.separatorColor
            radius: root.thickness * 0.5
            opacity: 0.9
        }
    }

    background: Item {}
}
