import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ToolSeparator — Fluent styled ToolSeparator.
//
//   ToolBar {
//       ToolButton { text: qsTr("A") }
//       ToolSeparator { }
//       ToolButton { text: qsTr("B") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls ToolSeparator.
//   Public API is the Qt Quick Controls ToolSeparator type; this file supplies visuals/metrics only.

T.ToolSeparator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 4

    contentItem: Rectangle {
        implicitWidth: control.horizontal ? 1 : 16
        implicitHeight: control.horizontal ? 16 : 1
        color: Theme.strokeDivider
        opacity: 0.9
        radius: 0.5
    }
}
