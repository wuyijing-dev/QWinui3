import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DataTable.
//
// Fluent virtualizing table: sort, filter, column resize, keyboard.
// Selection tracks the same row object across sort/filter.

CatalogPage {
    title: qsTr("DataTable")
    subtitle: qsTr("Sort, filter, stable selection, keyboard, and row virtualization.")

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
