import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — FileDropZone.
//
// Recipe: docs/drag-drop.md (1.41) — drop + FilePicker browse + clipboard path copy.

CatalogPage {
    id: page

    title: qsTr("FileDropZone")
    subtitle: qsTr("Drop + Browse + MIME filter — docs/files-linux-257.md (2.57).")

    property var lastUrls: []
    property string lastStatus: qsTr("Waiting for drop or Browse…")

    function ingestUrls(urls) {
        if (!urls || !urls.length) {
            page.lastStatus = qsTr("Cancelled / empty")
            return
        }
        page.lastUrls = urls
        page.lastStatus = qsTr("Accepted %1 file(s):\n%2")
            .arg(urls.length)
            .arg(urls.join("\n"))
    }

    function pathsToUrls(paths) {
        var out = []
        for (var i = 0; i < paths.length; ++i) {
            var p = String(paths[i])
            if (!p.length)
                continue
            out.push(p.indexOf("file:") === 0 ? p : ("file:///" + p.replace(/\\/g, "/")))
        }
        return out
    }

    ControlExample {
        headerText: qsTr("Recipe (1.41)")
        qmlSource: "FileDropZone { acceptExtensions: [\".png\", \".jpg\"] }\nFilePicker.openFiles(…)\nWindowHelper.copyText(path)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("DropArea keys include text/uri-list + optional acceptMimeTypes (2.13). Empty acceptExtensions = all URLs — production ingest should set a non-empty suffix list and never auto-execute paths. Always offer Browse (FilePicker). docs/security-trust.md · docs/drag-drop.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Drop images + Browse")
        qmlSource: "FileDropZone {\n    acceptExtensions: [\".png\", \".jpg\"]\n    onFilesDropped: …\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            FileDropZone {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                title: qsTr("Drop images here")
                subtitle: qsTr("Accepts .png / .jpg / .jpeg / .webp — or Browse")
                acceptExtensions: [".png", ".jpg", ".jpeg", ".webp"]
                acceptMimeTypes: ["image/png", "image/jpeg", "image/webp", "image/*"]
                onFilesDropped: function (urls) { page.ingestUrls(urls) }
                onDragRejected: page.lastStatus = qsTr("Rejected — MIME/type not in acceptMimeTypes / acceptExtensions")
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Browse…")
                    onClicked: FilePicker.openFiles(
                        qsTr("Open images"),
                        ["Images (*.png *.jpg *.jpeg *.webp)", "All (*.*)"],
                        function (paths) {
                            page.ingestUrls(page.pathsToUrls(paths || []))
                        },
                        Window.window)
                }
                CopyButton {
                    enabled: page.lastUrls.length > 0
                    textToCopy: page.lastUrls.length ? String(page.lastUrls[0]) : ""
                    onCopyCompleted: page.lastStatus = qsTr("Copied first URL (%1 chars)").arg(String(page.lastUrls[0]).length)
                    onCopyFailed: page.lastStatus = qsTr("Nothing to copy")
                }
                Button {
                    text: qsTr("Copy via WindowHelper")
                    enabled: page.lastUrls.length > 0
                    onClicked: {
                        WindowHelper.copyText(String(page.lastUrls[0]))
                        page.lastStatus = qsTr("WindowHelper.copyText — first URL")
                    }
                }
                Item { Layout.fillWidth: true }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: page.lastStatus
            }
        }
    }

    ControlExample {
        headerText: qsTr("Accept all URLs")
        qmlSource: "FileDropZone { /* acceptExtensions: [] */ }"
        FileDropZone {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            title: qsTr("Drop any files")
            subtitle: qsTr("No extension filter")
            onFilesDropped: function (urls) { page.ingestUrls(urls) }
        }
    }
}
