import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Admin CRUD template (2.25).
//
// DataTable master + FormLayout editor. Recipe: docs/forms.md · docs/data-collections.md

CatalogPage {
    title: qsTr("Admin CRUD template")
    subtitle: qsTr("DataTable selection + FormLayout edit — LoB admin pattern (2.25).")

    readonly property var userRows: [
        { id: 1, name: qsTr("Alex Chen"), role: qsTr("Admin"), status: qsTr("Active"), email: "alex@contoso.com" },
        { id: 2, name: qsTr("Blake Rivera"), role: qsTr("Editor"), status: qsTr("Active"), email: "blake@contoso.com" },
        { id: 3, name: qsTr("Casey Nguyen"), role: qsTr("Viewer"), status: qsTr("Pending"), email: "casey@contoso.com" },
        { id: 4, name: qsTr("Dana Okonkwo"), role: qsTr("Editor"), status: qsTr("Suspended"), email: "dana@contoso.com" }
    ]

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Users admin (2.25)")
        qmlSource: "DataTable { onSelectionChanged: loadRow }\nFormLayout { … Save / New }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Select a row to edit — form fields mirror the row. Save validates required fields; New clears selection for create mode.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            DataTable {
                id: users
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                filterPlaceholder: qsTr("Filter users")
                columns: [
                    { title: qsTr("Name"), role: "name", width: 140, sortable: true },
                    { title: qsTr("Role"), role: "role", width: 100, sortable: true },
                    { title: qsTr("Status"), role: "status", width: 100, sortable: true },
                    { title: qsTr("Email"), role: "email", width: 180, sortable: true }
                ]
                rows: userRows
                onSelectionChanged: function (index, row) {
                    if (index < 0 || !row) {
                        editorMode.text = qsTr("Create mode — fill the form and Save.")
                        return
                    }
                    editorMode.text = qsTr("Editing %1 (id %2)").arg(row.name).arg(row.id)
                    nameField.text = row.name
                    emailField.text = row.email
                    roleField.currentIndex = Math.max(0, roleField.model.indexOf(row.role))
                    statusField.currentIndex = Math.max(0, statusField.model.indexOf(row.status))
                }
                Component.onCompleted: select(0)
            }
            Label {
                id: editorMode
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            FormLayout {
                id: form
                Layout.fillWidth: true
                accessibleName: qsTr("User editor")
                labelWidth: 120

                ValidationSummary {
                    errors: form.errors
                }

                HeaderedTextBox {
                    id: nameField
                    header: qsTr("Name")
                }

                HeaderedTextBox {
                    id: emailField
                    header: qsTr("Email")
                }

                HeaderedComboBox {
                    id: roleField
                    header: qsTr("Role")
                    model: [qsTr("Admin"), qsTr("Editor"), qsTr("Viewer")]
                    currentIndex: 1
                }

                HeaderedComboBox {
                    id: statusField
                    header: qsTr("Status")
                    model: [qsTr("Active"), qsTr("Pending"), qsTr("Suspended")]
                    currentIndex: 0
                }

                NumberBox {
                    id: quotaField
                    header: qsTr("Storage quota (GB)")
                    description: qsTr("Demo limit 1–1000.")
                    value: 50
                    minimum: 1
                    maximum: 1000
                    decimals: 0
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Button {
                        text: qsTr("Save")
                        highlighted: true
                        onClicked: {
                            form.clearErrors()
                            if (nameField.text.trim().length < 2)
                                nameField.errorMessage = qsTr("Name is required.")
                            if (emailField.text.indexOf("@") < 1)
                                emailField.errorMessage = qsTr("Valid email required.")
                            if (quotaField.value < 1)
                                quotaField.errorMessage = qsTr("Quota must be at least 1 GB.")
                            if (!form.validate())
                                return
                            toasts.successToast(
                                qsTr("Saved (demo)."),
                                qsTr("%1 · %2 GB").arg(nameField.text.trim()).arg(quotaField.value))
                        }
                    }
                    Button {
                        text: qsTr("New user")
                        onClicked: {
                            users.clearSelection()
                            nameField.text = ""
                            emailField.text = ""
                            roleField.currentIndex = 2
                            statusField.currentIndex = 1
                            quotaField.value = 10
                            form.clearErrors()
                            editorMode.text = qsTr("Create mode — fill the form and Save.")
                        }
                    }
                    Button {
                        flat: true
                        text: qsTr("Clear errors")
                        onClicked: form.clearErrors()
                    }
                }
            }
        }
    }
}
