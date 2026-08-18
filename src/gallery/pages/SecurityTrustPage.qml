import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Security & trust boundaries (1.64 · wave 2 **2.13** · wave 3 **2.36**).
// Recipe: docs/security-trust.md · docs/webview2.md · docs/drag-drop.md

CatalogPage {
    id: page
    title: qsTr("Security & trust")
    subtitle: qsTr("Trust boundaries wave 3 — docs/security-trust.md (2.36).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Not a sandbox product")
        qmlSource: "// Trust boundaries · not hardened sandbox\\n// docs/security-trust.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("QWinUI3 embeds WebView2, filters drops by suffix + optional MIME, and owns FilePicker dialogs — it does not cancel unsafe navigations, intercept downloads, or scan file contents. Wave 3 (2.36): FileTree / TreeDataGrid path trust + WebView2 download policy D/E/F.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Wave 3 checklist (2.36)")
        qmlSource: "onFileActivated · rowActivated · download policy D/E/F"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("FileTree / TreeDataGrid: validate paths before open/reveal/execute") }
            CheckBox { text: qsTr("Treat row.name / catalog keys as display text — not security fences") }
            CheckBox { text: qsTr("WebView2: Policy D allowlist prevents most drive-by downloads") }
            CheckBox { text: qsTr("External downloads: Policy E — explicit button + hostAllowed") }
            CheckBox { text: qsTr("No silent saves to user Downloads until native DownloadStarting handler (Policy F)") }
        }
    }

    ControlExample {
        headerText: qsTr("App checklist (2.13 / 2.36)")
        qmlSource: "navigateSafe · acceptMimeTypes · portal parent_window"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("WebView2: Pattern A/B/C — not a raw production URL bar") }
            CheckBox { text: qsTr("Set org/app name before WebView2 user-data folder is created") }
            CheckBox { text: qsTr("Non-empty FileDropZone acceptExtensions for production ingest") }
            CheckBox { text: qsTr("Optional acceptMimeTypes when OS reports MIME (2.13)") }
            CheckBox { text: qsTr("Never auto-execute dropped paths") }
            CheckBox { text: qsTr("Always pass Window.window to FilePicker; handle cancel as empty") }
            CheckBox { text: qsTr("Wayland: re-smoke portal parent_window after shell changes") }
            CheckBox { text: qsTr("Treat clipboard copies as visible to other apps") }
        }
    }

    ControlExample {
        headerText: qsTr("Navigation policy snippet (Pattern C)")
        qmlSource: "function navigateSafe(url) {\n    if (!hostAllowed(url)) return\n    web.source = Qt.resolvedUrl(url)\n}"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            text: qsTr("See docs/security-trust.md — fixed URL, https-only, and host allowlist patterns. Gallery WebView2 demo gates its URL field.")
        }
    }

    ControlExample {
        headerText: qsTr("Open related demos")
        qmlSource: "WebView2 · FileDropZone · System integration · Pitfalls"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Repeater {
                model: [
                    { label: qsTr("FileTree (path trust demo)"), page: "FileTreePage" },
                    { label: qsTr("TreeDataGrid (row trust)"), page: "TreeDataGridPage" },
                    { label: qsTr("WebView2 host (allowlist + download policy)"), page: "WebView2Page" },
                    { label: qsTr("FileDropZone (MIME + suffix)"), page: "FileDropZonePage" },
                    { label: qsTr("System integration (FilePicker / portal)"), page: "SystemIntegrationPage" },
                    { label: qsTr("Pitfalls"), page: "PitfallsPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                        wrapMode: Text.WordWrap
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }
}
