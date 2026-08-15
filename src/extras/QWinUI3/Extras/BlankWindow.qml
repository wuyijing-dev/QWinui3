import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// Empty client shell — declare UI as children.
//
//   BlankWindow {
//       title: qsTr("App")
//       Label { anchors.centerIn: parent; text: "Hello" }
//   }
ShellWindow {
    id: root

    width: 720
    height: 480
    title: qsTr("Blank window")
    subtitle: qsTr("Empty shell")
    symbol: FluentIcons.OpenInNewWindow
}
