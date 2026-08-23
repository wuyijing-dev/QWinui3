import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DataTable.
//
// Fluent virtualizing table: sort, filter, column resize, keyboard.
// Selection tracks the same row object across sort/filter.
// Performance: docs/performance.md (1.25).

CatalogPage {
    id: page
    title: qsTr("DataTable")
    subtitle: qsTr("2.66 pro grid — multi-sort, column visibility, width persistence, 10k path. docs/data-collections.md")

    property var benchWidths: []
    property string benchNote: qsTr("Idle")
    property var chooserHidden: []

    function makeRows(n) {
        var out = []
        var roles = ["Design", "Engineering", "Product", "Support", "Research"]
        var teams = ["Alpha", "Beta", "Gamma", "Delta"]
        var statuses = ["Active", "Away", "Busy", "Offline"]
        var regions = ["EMEA", "APAC", "Americas", "Global"]
        for (var i = 0; i < n; ++i) {
            out.push({
                name: qsTr("User %1").arg(i + 1),
                role: roles[i % roles.length],
                team: teams[i % teams.length],
                status: statuses[i % statuses.length],
                region: regions[i % regions.length],
                score: 40 + ((i * 13) % 60)
            })
        }
        return out
    }

    ControlExample {
        headerText: qsTr("Pro grid — multi-sort · visibility · widths (2.66 D1)")
        qmlSource: "DataTable {\n    sortSpecs: [ { column: 1, order: Qt.AscendingOrder } ]\n    hiddenColumns: [ 4 ]\n    columnWidths: persisted\n    // Shift+click header = secondary sort\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Shift+click a header to add a secondary sort. Use the checkboxes to hide columns. Resize columns — widths bind to columnWidths for Settings persistence.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Repeater {
                    model: [
                        { label: qsTr("Name"), index: 0 },
                        { label: qsTr("Role"), index: 1 },
                        { label: qsTr("Team"), index: 2 },
                        { label: qsTr("Status"), index: 3 },
                        { label: qsTr("Region"), index: 4 },
                        { label: qsTr("Score"), index: 5 }
                    ]
                    delegate: CheckBox {
                        required property var modelData
                        text: modelData.label
                        checked: page.chooserHidden.indexOf(modelData.index) < 0
                        onToggled: proTable.setColumnVisible(modelData.index, checked)
                    }
                }
            }

            DataTable {
                id: proTable
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                filterPlaceholder: qsTr("Filter · Shift+click headers for multi-sort")
                columns: [
                    { title: qsTr("Name"), role: "name", width: 140, sortable: true, pinned: true },
                    { title: qsTr("Role"), role: "role", width: 120, sortable: true },
                    { title: qsTr("Team"), role: "team", width: 100, sortable: true },
                    { title: qsTr("Status"), role: "status", width: 90, sortable: true },
                    { title: qsTr("Region"), role: "region", width: 110, sortable: true },
                    { title: qsTr("Score"), role: "score", width: 80, sortable: true }
                ]
                rows: page.makeRows(120)
                onColumnLayoutChanged: {
                    page.chooserHidden = hiddenColumns.slice()
                    page.benchWidths = columnWidths.slice()
                }
                Component.onCompleted: select(1)
            }

            Label {
                Layout.fillWidth: true
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Widths: %1 · hidden: %2")
                        .arg(JSON.stringify(page.benchWidths))
                        .arg(JSON.stringify(page.chooserHidden))
            }
        }
    }

    ControlExample {
        headerText: qsTr("10k row path (2.66 C1)")
        qmlSource: "DataTable {\n    maxFilterResults: 500\n    // ListView reuseItems + fixed rowHeight\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Loads 10 000 plain JS rows. Row virtualization stays on ListView + reuseItems with fixed rowHeight. Cap filter walk with maxFilterResults for interactive typing.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            RowLayout {
                Button {
                    text: qsTr("Load 10k")
                    onClicked: {
                        var t0 = Date.now()
                        benchTable.rows = page.makeRows(10000)
                        page.benchNote = qsTr("Built 10k rows in %1 ms · visible %2")
                                .arg(Date.now() - t0).arg(benchTable.rowCount)
                    }
                }
                Button {
                    text: qsTr("Clear")
                    onClicked: {
                        benchTable.rows = []
                        page.benchNote = qsTr("Cleared")
                    }
                }
                Label {
                    Layout.fillWidth: true
                    text: page.benchNote
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                }
            }

            DataTable {
                id: benchTable
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                maxFilterResults: 500
                filterPlaceholder: qsTr("Filter (capped at 500 matches)")
                columns: [
                    { title: qsTr("Name"), role: "name", width: 160, sortable: true },
                    { title: qsTr("Role"), role: "role", width: 140, sortable: true },
                    { title: qsTr("Team"), role: "team", width: 120, sortable: true },
                    { title: qsTr("Score"), role: "score", width: 90, sortable: true }
                ]
                rows: []
            }
        }
    }

    ControlExample {
        headerText: qsTr("Ops table — pin + group (2.64)")
        qmlSource: "DataTable {\n    groupRole: \"team\"\n    columns: [ { pinned: true, … } ]\n}"
        DataTable {
            id: opsTable
            Layout.fillWidth: true
            Layout.preferredHeight: 360
            groupRole: "team"
            filterPlaceholder: qsTr("Filter · Name column pinned · grouped by team")
            columns: [
                { title: qsTr("Name"), role: "name", width: 150, sortable: true, pinned: true },
                { title: qsTr("Role"), role: "role", width: 130, sortable: true },
                { title: qsTr("Team"), role: "team", width: 110, sortable: true },
                { title: qsTr("Status"), role: "status", width: 100, sortable: true },
                { title: qsTr("Region"), role: "region", width: 120, sortable: true },
                { title: qsTr("Score"), role: "score", width: 80, sortable: true }
            ]
            rows: page.makeRows(80)
            Component.onCompleted: select(2)
        }
        Label {
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("2.64: pinned name column · groupRole inserts team headers · scroll wide columns horizontally.")
        }
    }

    ControlExample {
        headerText: qsTr("Employees")
        qmlSource: "DataTable {\n    columns: [ { title, role, width, sortable } ]\n    rows: [ … ]\n}"

        DataTable {
            id: table
            Layout.fillWidth: true
            Layout.preferredHeight: 420
            filterPlaceholder: qsTr("Filter name, role, or status · Down focuses rows")
            columns: [
                { title: qsTr("Name"), role: "name", width: 160, sortable: true },
                { title: qsTr("Role"), role: "role", width: 150, sortable: true },
                { title: qsTr("Team"), role: "team", width: 130, sortable: true },
                { title: qsTr("Status"), role: "status", width: 110, sortable: true },
                { title: qsTr("Score"), role: "score", width: 90, sortable: true }
            ]
            rows: page.makeRows(200)
            onSelectionChanged: function (index, row) {
                if (index < 0 || !row) {
                    selectionHint.text = qsTr("No selection")
                    return
                }
                selectionHint.text = qsTr("Selected %1 · index %2 (survives sort/filter)")
                                         .arg(row.name).arg(index + 1)
            }
            onRowActivated: function (index, row) {
                activatedLabel.text = qsTr("Activated: %1 (%2)").arg(row.name).arg(row.role)
            }
            Component.onCompleted: select(3)
        }

        Label {
            id: selectionHint
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Select a row, then sort a column — selection stays on the same person.")
        }

        Label {
            id: activatedLabel
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Filter → Down / Tab into table · arrows / Page / Enter · Shift+click headers for multi-sort")
        }
    }
}
