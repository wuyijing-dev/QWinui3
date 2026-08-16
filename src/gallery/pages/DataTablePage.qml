import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DataTable.
//
// Fluent virtualizing table: sort, filter, column resize, keyboard.

CatalogPage {
    title: qsTr("DataTable")
    subtitle: qsTr("Sort, filter, column resize, keyboard navigation, and row virtualization.")

    ControlExample {
        headerText: qsTr("Employees")
        qmlSource: "DataTable {\n    columns: [ { title, role, width, sortable } ]\n    rows: [ … ]\n}"

        DataTable {
            id: table
            Layout.fillWidth: true
            Layout.preferredHeight: 420
            filterPlaceholder: qsTr("Filter name, role, or status")
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
            onRowActivated: function (index, row) {
                activatedLabel.text = qsTr("Activated: %1 (%2)").arg(row.name).arg(row.role)
            }
        }

        Label {
            id: activatedLabel
            Layout.fillWidth: true
            color: Theme.textSecondary
            text: qsTr("Click a header to sort · drag edges to resize · arrows / Enter")
        }
    }
}
