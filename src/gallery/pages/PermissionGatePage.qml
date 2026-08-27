import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PermissionGate.

CatalogPage {
    id: page
    title: qsTr("PermissionGate")
    subtitle: qsTr("Declarative hide/disable by role — enforce real auth in the app model.")

    property string role: "viewer"

    ControlExample {
        headerText: qsTr("Hide vs disable")
        qmlSource: "PermissionGate {\n    currentRole: \"viewer\"\n    allowedRoles: [\"admin\"]\n    mode: \"hide\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacing
                Label { text: qsTr("Role"); color: Theme.textSecondary }
                ComboBox {
                    model: ["viewer", "editor", "admin"]
                    currentIndex: model.indexOf(page.role)
                    onActivated: page.role = currentText
                }
            }
            PermissionGate {
                currentRole: page.role
                allowedRoles: ["admin", "editor"]
                mode: "hide"
                Button {
                    text: qsTr("Edit (hidden for viewer)")
                }
            }
            PermissionGate {
                currentRole: page.role
                allowedRoles: ["admin"]
                mode: "disable"
                Button {
                    text: qsTr("Delete (disabled unless admin)")
                }
            }
            Label {
                text: qsTr("Current role: %1").arg(page.role)
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }
}
