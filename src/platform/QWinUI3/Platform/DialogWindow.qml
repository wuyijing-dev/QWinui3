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
//       ownerWindow: mainWindow   // optional transient parent
//       width: 420; height: 280
//   }
//   dlg.openDialog()
//
// @notes
//   StandardWindow with ParadigmDialog flags.
//   Prefer openDialog() so owner stacking + centerOnOwner match Gallery patterns (2.14).
//   On Linux/Wayland, setTransientParent realizes surfaces before parenting.

StandardWindow {
    id: root
    paradigm: WindowHelper.ParadigmDialog
    showMaximize: false
    width: 480
    height: 360
    minimumWidth: 320
    minimumHeight: 200
    title: qsTr("Dialog")
    backdrop: WindowHelper.BackdropSolid

    // Optional owner Window / Item for transient parenting (Win HWND owner / Wayland stacking)
    property var ownerWindow: null
    // Center on the owner screen when shown via openDialog()
    property bool centerWhenOpened: true

    // Show as a dialog: wire owner, center, then make visible
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

    // Hide without destroying
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
