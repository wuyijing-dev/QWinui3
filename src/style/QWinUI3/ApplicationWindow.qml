import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ApplicationWindow — Fluent ApplicationWindow chrome defaults.
//
//   ApplicationWindow {
//       id: win
//       width: 1024; height: 720
//       title: qsTr("App")
//       visible: true
//   }

T.ApplicationWindow {
    id: window
    color: Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
}
