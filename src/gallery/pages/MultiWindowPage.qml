import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Multi-window & secondary shells.
//
// Main + tool + owned dialog recipes. Runnable sample: examples/multi-window.
// docs/window-shells.md · docs/window-helper.md · docs/window-chrome.md

CatalogPage {
    id: root
    title: qsTr("Multi-window")
    subtitle: qsTr("Secondary shells + transient parent — docs/window-shells.md.")

    readonly property string portalParentReadout: {
        var host = root.Window ? root.Window.window : null
        if (!host)
            return qsTr("portal parent_window=(no host window)")
        var id = WindowHelper.portalParentWindow(host)
        return id.length
            ? qsTr("portal parent_window=%1").arg(id)
            : qsTr("portal parent_window=(empty — pure Wayland without xdg-foreign export)")
    }

    property var _openWindows: []

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            root.openControl(it)
    }

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
                    text: qsTr("openDialog(owner) sets transient parent (realize surfaces) and centers on the owner screen.")
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
        headerText: qsTr("Onboarding + z-order")
        qmlSource: "// Coach on main shell only\n// Settings category != WindowGeometry\n// docs/multi-window-onboarding.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("First-run TeachingTip tours should run on the primary shell after it is visible — not on tool windows. Finish or pause the coach before openDialog(owner). Persist don’t-show-again in a dedicated Settings category, not geometryPersistenceKey. Gallery Onboarding coach demonstrates persistence.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Open Onboarding coach")
                    onClicked: root.openComp("OnboardingCoachPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "ToolShellWindow { geometryPersistenceKey }\nDialogShellWindow { openDialog(owner) }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use a second top-level shell for inspectors, previews, or true dialog HWNDs. Keep ContentDialog for in-window confirms. One Theme per process. Unique geometryPersistenceKey per window role. openDialog(owner) realizes surfaces + centerOnOwner on Wayland. Runnable sample: examples/multi-window.")
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
        headerText: qsTr("Wayland modal stack")
        qmlSource: "openDialog(owner) · centerOnOwner · portalParentWindow"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: root.portalParentReadout
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("After spawning a dialog, confirm it stacks with Gallery on your compositor. Empty portal id on pure Wayland is expected without xdg-foreign — transient parent still helps. Regression: docs/security-trust.md · docs/platform-linux-wayland.md.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textTertiary
            }
        }
    }

}
