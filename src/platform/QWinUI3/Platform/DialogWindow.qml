import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Secondary dialog window paradigm — compact, centered, no maximize.
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
