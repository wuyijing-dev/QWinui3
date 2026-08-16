import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// BlankWindow — Empty ShellWindow client — declare UI as children.
//
//   BlankWindow {
//       id: win
//       title: qsTr("App")
//       width: 800; height: 600
//       Label { anchors.centerIn: parent; text: qsTr("Hello") }
//   }
//   // --- API ---
//   // inherits ShellWindow chrome API (title, backdrop, …)
//
// @notes
//   Empty ShellWindow client; declare UI as children.
//   See ShellWindow / docs/window-shells.md for chrome slots.

ShellWindow {
    id: root
    width: 720
    height: 480
    title: qsTr("Blank window")
    subtitle: qsTr("Empty shell")
    symbol: FluentIcons.OpenInNewWindow
}
