import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Security & trust boundaries (1.64).
// Recipe: docs/security-trust.md · docs/webview2.md · docs/drag-drop.md

CatalogPage {
    id: page
    title: qsTr("Security & trust")
    subtitle: qsTr("What the kit hosts vs what apps must own — docs/security-trust.md (1.64).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Not a sandbox product (1.64)")
        qmlSource: "// Trust boundaries · not hardened sandbox\\n// docs/security-trust.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("QWinUI3 embeds WebView2, filters drops by suffix, and owns FilePicker dialogs — it does not cancel unsafe navigations or scan file contents. Production apps own allowlists, ingest policy, and path validation. Full cookbook: docs/security-trust.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("App checklist")
        qmlSource: "WebView2 allowlist · FileDropZone acceptExtensions · FilePicker parent"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("Gate WebView2 source / navigate (no free-form production URL bar)") }
            CheckBox { text: qsTr("Set org/app name before WebView2 user-data folder is created") }
            CheckBox { text: qsTr("Non-empty FileDropZone acceptExtensions for production ingest") }
            CheckBox { text: qsTr("Never auto-execute dropped paths") }
            CheckBox { text: qsTr("Always pass Window.window to FilePicker; handle cancel as empty") }
            CheckBox { text: qsTr("Treat clipboard copies as visible to other apps") }
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
                    { label: qsTr("WebView2 host"), page: "WebView2Page" },
                    { label: qsTr("FileDropZone"), page: "FileDropZonePage" },
                    { label: qsTr("System integration (FilePicker)"), page: "SystemIntegrationPage" },
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
