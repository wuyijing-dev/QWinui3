import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// DialogWindow — StandardWindow dialog paradigm.
//
//   DialogWindow {
//       id: dlg
//       title: qsTr("Prompt")
//       width: 420; height: 280
//   }
//
// @notes
//   StandardWindow with ParadigmDialog flags.

StandardWindow {
    id: root

    Accessible.role: Accessible.Window
    Accessible.name: root.title

    paradigm: WindowHelper.ParadigmDialog
    showMaximize: false
    width: 480
    height: 360
    minimumWidth: 320
    minimumHeight: 200
    title: qsTr("Dialog")
}
