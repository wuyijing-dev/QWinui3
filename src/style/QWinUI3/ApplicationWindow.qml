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
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls ApplicationWindow.
//   Public API is the Qt Quick Controls ApplicationWindow type; this file supplies visuals/metrics only.

T.ApplicationWindow {
    id: window

    color: Theme.bgLayer
    // Locale-aware WinUI stack (YaHei UI when zh). revision keeps the binding live.
    font: ThemeFonts.uiFontFor(Theme.fontBody + (0 * ThemeFonts.revision))
}
