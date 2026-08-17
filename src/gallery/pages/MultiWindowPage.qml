import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Multi-window & secondary shells (1.56).
//
// Main + tool + owned dialog recipes. Runnable sample: examples/multi-window.
// docs/window-shells.md · docs/window-helper.md · docs/window-chrome.md

CatalogPage {
    id: root
    title: qsTr("Multi-window")
    subtitle: qsTr("Secondary shells + geometry keys + transient parent — docs/window-shells.md (1.56).")

    property var _openWindows: []

    function track(win) {
        if (!win)
            return
        _openWindows = _openWindows.concat([win])
        win.closing.connect(function () {
            var next = []
            for (var i = 0; i < root._openWindows.length; ++i) {
                if (root._openWindows[i] !== win)
                    next.push(root._openWindows[i])
            }
            root._openWindows = next
        })
    }

    function spawnTool() {
        var win = toolComp.createObject(null)
        if (!win)
            return
        track(win)
        win.geometryPersistenceKey = "GalleryMultiWindowTool"
        Qt.callLater(function () {
            if (!win)
                return
            win.visible = true
            win.raise()
            win.requestActivate()
        })
    }

    function spawnOwnedDialog() {
        var win = dialogComp.createObject(null)
        if (!win)
            return
        track(win)
        win.geometryPersistenceKey = "GalleryMultiWindowDialog"
        Qt.callLater(function () {
            if (!win)
                return
            var host = root.Window ? root.Window.window : null
            win.openDialog(host)
        })
    }

    function closeAll() {
        var list = _openWindows.slice()
        for (var i = 0; i < list.length; ++i) {
            if (list[i])
                list[i].close()
        }
        _openWindows = []
    }

    Component {
        id: toolComp
        ToolShellWindow {
            id: win
            title: qsTr("Inspector")
            subtitle: qsTr("Gallery multi-window tool")
            width: 360
            height: 420
            backdrop: WindowHelper.BackdropSolid
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                spacing: Theme.spacing
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Independent top-level tool. Own geometryPersistenceKey. Shares Theme with Gallery.")
                    color: Theme.textSecondary
                }
                Label {
                    text: Theme.dark ? qsTr("Theme: dark") : qsTr("Theme: light")
                    color: Theme.textPrimary
                }
                Item { Layout.fillHeight: true }
                Button {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Close")
                    onClicked: win.close()
                }
            }
        }
    }

    Component {
        id: dialogComp
        DialogShellWindow {
            id: win
            title: qsTr("Owned dialog")
            subtitle: qsTr("setTransientParent + center")
            width: 400
            height: 240
            backdrop: WindowHelper.BackdropSolid
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                spacing: Theme.spacing
                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("openDialog(owner) sets the transient parent so the dialog stacks with the Gallery window.")
                    color: Theme.textSecondary
                }
                Item { Layout.fillHeight: true }
                AccentButton {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("OK")
                    onClicked: win.closeDialog()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("When to use (1.56)")
        qmlSource: "ToolShellWindow { geometryPersistenceKey }\nDialogShellWindow { openDialog(owner) }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use a second top-level shell for inspectors, previews, or true dialog HWNDs. Keep ContentDialog for in-window confirms. One Theme per process. Unique geometryPersistenceKey per window role. Runnable sample: examples/multi-window.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Spawn secondary shells")
        qmlSource: "examples/multi-window\nqwinui3_example_multi_window"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Open tool window")
                    onClicked: root.spawnTool()
                }
                Button {
                    text: qsTr("Open owned dialog")
                    onClicked: root.spawnOwnedDialog()
                }
                Button {
                    text: qsTr("Close spawned")
                    onClicked: root.closeAll()
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Open count: %1").arg(root._openWindows.length)
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build build --config Release --target qwinui3_example_multi_window"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build build --config Release --target qwinui3_example_multi_window"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Win + Linux checklist")
        qmlSource: "docs/window-shells.md · docs/platform-linux-wayland.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("BackdropSolid on every secondary shell") }
            CheckBox { text: qsTr("Distinct geometryPersistenceKey (Main vs Tool vs Dialog)") }
            CheckBox { text: qsTr("DialogShellWindow.openDialog(owner) for stacking") }
            CheckBox { text: qsTr("Theme toggles apply to all windows in-process") }
            CheckBox { text: qsTr("Wayland: Bootstrap configureEnvironment; expect compositor-owned stacking") }
        }
    }
}
