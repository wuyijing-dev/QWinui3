import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — FileTree.
//
// Explorer LoB: folder TreeView + file DataTable. Recipe: docs/tree-data.md

CatalogPage {
    id: page

    title: qsTr("FileTree")
    subtitle: qsTr("Explorer layout: folder tree + metadata table. Column chooser + filterText — docs/tree-data.md.")

    readonly property var demoCatalog: ({
        "Documents": [
            { name: "readme.txt", type: qsTr("Text"), size: "2 KB", modified: "2026-01-15" },
            { name: "notes.md", type: qsTr("Markdown"), size: "4 KB", modified: "2026-02-03" }
        ],
        "Projects": [
            { name: "roadmap.md", type: qsTr("Markdown"), size: "18 KB", modified: "2026-03-01" },
            { name: "build.log", type: qsTr("Log"), size: "96 KB", modified: "2026-03-10" }
        ],
        "QWinUI3": [
            { name: "CMakeLists.txt", type: qsTr("CMake"), size: "12 KB", modified: "2026-03-12" },
            { name: "Gallery.qml", type: qsTr("QML"), size: "8 KB", modified: "2026-03-11" },
            { name: "FileTree.qml", type: qsTr("QML"), size: "6 KB", modified: "2026-03-12" }
        ],
        "Pictures": [
            { name: "cover.png", type: qsTr("PNG"), size: "240 KB", modified: "2025-12-20" }
        ],
        "Downloads": [
            { name: "installer.exe", type: qsTr("Application"), size: "42 MB", modified: "2026-02-28" },
            { name: "archive.zip", type: qsTr("Archive"), size: "8 MB", modified: "2026-01-08" }
        ]
    })

    property string folderLabel: qsTr("(none)")
    property string fileLabel: qsTr("(none)")

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Why FileTree")
        qmlSource: "FileTree {\n    treeModel: DemoTreeModel {}\n    fileCatalog: { \"Documents\": [ … ] }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("TreeView + DataTable alone do not share selection, keyboard focus, or folder→file wiring. FileTree composes both for Explorer-style apps. For multi-column hierarchical rows in one grid, use TreeDataGrid.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keyboard: tree ↑/↓/←/→ · Tab switches tree ↔ file table · table arrows / sort / filter per DataTable.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Folders + metadata")
        qmlSource: "FileTree {\n    treeModel: DemoTreeModel {}\n    fileCatalog: folderMap\n    onFileActivated: …\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Expand all")
                    onClicked: explorer.expandAll()
                }
                Button {
                    text: qsTr("Collapse all")
                    onClicked: explorer.collapseAll()
                }
                Button {
                    text: qsTr("Focus tree")
                    onClicked: explorer.focusTree()
                }
                Button {
                    text: qsTr("Focus table")
                    onClicked: explorer.focusTable()
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: qsTr("Folder: %1 · File: %2").arg(page.folderLabel).arg(page.fileLabel)
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                }
            }

            FileTree {
                id: explorer
                Layout.fillWidth: true
                Layout.preferredHeight: 360
                treeModel: DemoTreeModel {}
                fileCatalog: page.demoCatalog
                onFolderChanged: function (row, label) {
                    page.folderLabel = label.length ? label : qsTr("(none)")
                    page.fileLabel = qsTr("(none)")
                }
                onFileSelectionChanged: function (index, row) {
                    page.fileLabel = row && row.name ? row.name : qsTr("(none)")
                }
                onFileActivated: function (index, row) {
                    var name = row && row.name ? row.name : qsTr("(file)")
                    toasts.info(qsTr("Open “%1”").arg(name), qsTr("FileTree"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Column chooser + filterText")
        qmlSource: "FileTree {\n    filterText: query\n    hiddenColumnRoles: [ \"modified\" ]\n}"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("checkboxes above the file table toggle hiddenColumnRoles. Bind filterText to share the DataTable filter with app chrome. docs/collection-perf-264.md")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Filter perf")
        qmlSource: "// Table: DataTable filterDebounceMs / maxFilterResults\n// Tree: filter treeModel app-side — no whole-tree rebuild per key"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("FileTree embeds DataTable for the file list — inherit debounced filter and maxFilterResults on the table side. Folder tree selection switches catalogs; do not rebuild the entire tree model on every filter keystroke. docs/performance. · docs/tree-data.md.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Path trust")
        qmlSource: "onFileActivated: validate path before open — docs/security-trust.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("FileTree displays folder labels and row objects you supply — it does not validate paths. The Downloads folder demo includes installer.exe to show risky filenames in UI; production apps must extension-filter and confirm before open/reveal/execute. See docs/security-trust..")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Related recipes")
        qmlSource: "// TreeView only — docs/tree-data.md\n// DataTable only — docs/data-collections.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Folder-only hierarchy: TreeView recipe. Flat columns without tree: DataTable. List + reading pane: ListDetailsView.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    flat: true
                    text: qsTr("TreeView recipe")
                    onClicked: page.openComp("TreeViewRecipePage")
                }
                Button {
                    flat: true
                    text: qsTr("DataTable")
                    onClicked: page.openComp("DataTablePage")
                }
            }
        }
    }

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }
}
