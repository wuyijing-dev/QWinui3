import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeDataGrid.
//
// Hierarchical multi-column grid + master-detail readout. Recipe: docs/tree-data.md

CatalogPage {
    id: page

    title: qsTr("TreeDataGrid")
    subtitle: qsTr("Hierarchical columns with sort, resize, freeze — experimental, docs/tree-data.md.")

    readonly property var orgRows: [
        {
            name: qsTr("Engineering"),
            role: qsTr("Group"),
            status: qsTr("Active"),
            location: qsTr("Seattle"),
            level: "L0",
            children: [
                {
                    name: qsTr("Platform"),
                    role: qsTr("Team"),
                    status: qsTr("Active"),
                    children: [
                        { name: qsTr("Alex Rivera"), role: qsTr("Engineer"), status: qsTr("Active") },
                        { name: qsTr("Blake Chen"), role: qsTr("Engineer"), status: qsTr("PTO") }
                    ]
                },
                {
                    name: qsTr("Gallery"),
                    role: qsTr("Team"),
                    status: qsTr("Active"),
                    children: [
                        { name: qsTr("Casey Nguyen"), role: qsTr("Designer"), status: qsTr("Active") },
                        { name: qsTr("Dana Okonkwo"), role: qsTr("Engineer"), status: qsTr("Active") }
                    ]
                }
            ]
        },
        {
            name: qsTr("Operations"),
            role: qsTr("Group"),
            status: qsTr("Active"),
            children: [
                { name: qsTr("Ellis Park"), role: qsTr("Support"), status: qsTr("Active") },
                { name: qsTr("Fran Rossi"), role: qsTr("Support"), status: qsTr("On leave") }
            ]
        }
    ]

    property string detailText: qsTr("Select a row")

    ControlExample {
        headerText: qsTr("Why TreeDataGrid")
        qmlSource: "TreeDataGrid {\n    columns: [ … ]\n    rows: [ { name; children: [ … ] } ]\n}"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("FileTree splits folder tree and flat file table. TreeDataGrid keeps hierarchy inside one multi-column grid — sort per sibling group, filter keeps matching branches. Experimental — not Excel-scale.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Filter perf")
        qmlSource: "TreeDataGrid { filterDebounceMs; maxFilterResults; expandOnFilter }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Branch filter walks nested children — debounce keystrokes (filterDebounceMs), cap matches (maxFilterResults), and rely on expandOnFilter only when needed. Same skip-unchanged pattern as DataTable. Not Excel-scale — prefer C++ model for large org trees. docs/performance..")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Path trust")
        qmlSource: "onRowActivated: treat row fields as untrusted display — docs/security-trust.md"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("TreeDataGrid sort/filter does not sanitize cell text. Validate row data before side effects — same rules as FileTree fileActivated. Cross-link: docs/tree-data.md · docs/security-trust..")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Org chart + detail pane")
        qmlSource: "TreeDataGrid { columns; rows; onSelectionChanged: … }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Expand all")
                    onClicked: grid.expandAll()
                }
                Button {
                    text: qsTr("Collapse all")
                    onClicked: grid.collapseAll()
                }
                Button {
                    text: qsTr("Focus grid")
                    onClicked: grid.focusGrid()
                }
                Item { Layout.fillWidth: true }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing

                TreeDataGrid {
                    id: grid
                    Layout.fillWidth: true
                    Layout.preferredWidth: 520
                    Layout.preferredHeight: 320
                    columns: [
                        { title: qsTr("Name"), role: "name", width: 180, sortable: true },
                        { title: qsTr("Role"), role: "role", width: 110, sortable: true },
                        { title: qsTr("Status"), role: "status", width: 100, sortable: true },
                        { title: qsTr("Location"), role: "location", width: 120, sortable: true },
                        { title: qsTr("Level"), role: "level", width: 80, sortable: true }
                    ]
                    rows: page.orgRows
                    filterPlaceholder: qsTr("Filter org chart")
                    freezeFirstColumn: true
                    columnLayoutKey: "Gallery/TreeDataGrid"
                    onSelectionChanged: function (index, row) {
                        if (!row)
                            page.detailText = qsTr("Selection cleared")
                        else
                            page.detailText = qsTr("%1 · %2 · %3")
                                             .arg(row.name || "").arg(row.role || "").arg(row.status || "")
                    }
                    onRowActivated: function (index, row) {
                        var n = row && row.name ? row.name : qsTr("(row)")
                        toasts.info(qsTr("Activated “%1”").arg(n), qsTr("TreeDataGrid"))
                    }
                }

                ContentCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 320
                    title: qsTr("Detail")
                    subtitle: page.detailText
                    symbol: FluentIcons.Contact
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Related")
        qmlSource: "// Explorer tree + flat table — FileTree"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Folder tree + file metadata columns: FileTree. Flat columns only: DataTable. List + reading pane: ListDetailsView.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    flat: true
                    text: qsTr("FileTree")
                    onClicked: page.openComp("FileTreePage")
                }
                Button {
                    flat: true
                    text: qsTr("DataTable")
                    onClicked: page.openComp("DataTablePage")
                }
            }
        }
    }

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }
}
