import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// DialogWindow — StandardWindow dialog paradigm.
//
//   DialogWindow { title: qsTr("Dialog") }

StandardWindow {
    id: root

    paradigm: WindowHelper.ParadigmDialog
    showMaximize: false
    width: 480
    height: 360
    minimumWidth: 320
    minimumHeight: 200
    title: qsTr("Dialog")
}
