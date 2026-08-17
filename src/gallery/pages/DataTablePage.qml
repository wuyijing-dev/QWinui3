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
    title: qsTr("DataTable")
    subtitle: qsTr("Sort, filter, stable selection, keyboard, row virtualization. Wave 10 pin/group — docs/collection-perf-264.md.")

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
            rows: {
                var out = []
                var roles = ["Design", "Engineering", "Product"]
                var teams = ["Alpha", "Beta", "Gamma"]
                var statuses = ["Active", "Away", "Busy"]
                var regions = ["EMEA", "APAC", "Americas", "Global"]
                for (var i = 0; i < 80; ++i) {
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
            Component.onCompleted: select(2)
        }
        Label {
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("2.64: pinned name column · groupRole inserts team headers · scroll wide columns horizontally. docs/collection-perf-264.md")
        }
    }

    ControlExample {
        headerText: qsTr("Wave 7 checklist (2.40)")
        qmlSource: "filterDebounceMs: 120 · maxFilterResults: 0\n// identical query/sort skips rebuild"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("Filter debounces before _viewRows rebuild (filterDebounceMs)") }
            CheckBox { text: qsTr("Identical filter/sort/rows ref skips refresh (_lastRefreshKey)") }
            CheckBox { text: qsTr("Set maxFilterResults when JS arrays exceed a few hundred rows") }
            CheckBox { text: qsTr("Selection tracks row object — clears when filtered out") }
        }
    }

    ControlExample {
        headerText: qsTr("Performance (2.18)")
        qmlSource: "// DataTable → ListView + reuseItems\n// filterDebounceMs · maxFilterResults\n// docs/performance.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("~200 plain JS rows — fine for Gallery. ListView + reuseItems virtualizes rows. Filter debounces (120 ms); identical query/sort skips rebuild (1.88). maxFilterResults caps filter walk for huge arrays (2.18). Selection tracks row object identity. docs/performance.md wave 5.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Also see ItemsView / ItemsRepeater (reuseItems) and the Charts hub for Canvas point budgets.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
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
            rows: {
                var out = []
                var roles = ["Design", "Engineering", "Product", "Support", "Research"]
                var teams = ["Alpha", "Beta", "Gamma", "Delta"]
                var statuses = ["Active", "Away", "Busy", "Offline"]
                var names = ["Alex", "Jordan", "Sam", "Riley", "Casey", "Morgan", "Quinn", "Avery", "Reese", "Parker"]
                for (var i = 0; i < 200; ++i) {
                    out.push({
                        name: names[i % names.length] + " " + (i + 1),
                        role: roles[i % roles.length],
                        team: teams[i % teams.length],
                        status: statuses[i % statuses.length],
                        score: 40 + ((i * 17) % 60)
                    })
                }
                return out
            }
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
            text: qsTr("Filter → Down / Tab into table · arrows / Page / Enter · click headers to sort")
        }
    }
}
