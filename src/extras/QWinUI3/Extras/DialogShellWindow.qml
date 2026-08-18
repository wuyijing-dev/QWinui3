import QtQuick
import QWinUI3.Theme
import QWinUI3.Platform

// DialogShellWindow — ShellWindow with dialog paradigm flags.
//
//   DialogShellWindow {
//       title: qsTr("Confirm")
//       ownerWindow: mainWindow
//       width: 440; height: 280
//   }
//   dlg.openDialog()
//
// @notes
//   ShellWindow with WindowHelper.ParadigmDialog flags.
//   Prefer openDialog() for owner stacking + centerOnOwner (2.14).

ShellWindow {
    id: root
    paradigm: WindowHelper.ParadigmDialog
    showMaximize: false
    width: 480
    height: 360
    minimumWidth: 320
    minimumHeight: 200
    title: qsTr("Dialog")
    subtitle: qsTr("Dialog shell")
    symbol: FluentIcons.OpenInNewWindow
    backdrop: WindowHelper.BackdropSolid

    // Optional owner Window / Item for transient parenting
    property var ownerWindow: null
    property bool centerWhenOpened: true

    function openDialog(owner) {
        if (owner !== undefined && owner !== null)
            ownerWindow = owner
        if (ownerWindow)
            WindowHelper.setTransientParent(root, ownerWindow)
        else
            WindowHelper.ensureWindowCreated(root)
        if (centerWhenOpened) {
            if (ownerWindow)
                WindowHelper.centerOnOwner(root, ownerWindow)
            else
                WindowHelper.centerOnScreen(root)
        }
        visible = true
        requestActivate()
    }

    function closeDialog() {
        visible = false
    }

    Component.onCompleted: {
        if (ownerWindow)
            WindowHelper.setTransientParent(root, ownerWindow)
    }

    onOwnerWindowChanged: {
        if (ownerWindow)
            WindowHelper.setTransientParent(root, ownerWindow)
    }
}
