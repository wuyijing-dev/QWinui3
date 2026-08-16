import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Form validation.
//
// FormLayout + ValidationSummary with top/left headers, RadioButtons, DetailRow.

CatalogPage {
    id: page
    title: qsTr("Form validation")
    subtitle: qsTr("FormLayout pushes labelWidth to left-header fields; ValidationSummary lists errors.")

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Sign-up form (top headers)")
        qmlSource: "FormLayout {\n    ValidationSummary { errors: form.errors }\n    HeaderedTextBox { … }\n    form.validate()\n}"

        FormLayout {
            id: form
            labelWidth: 132

            ValidationSummary {
                errors: form.errors
            }

            HeaderedTextBox {
                id: nameField
                header: qsTr("Display name")
                description: qsTr("At least 2 characters.")
                placeholderText: qsTr("Alex")
            }

            HeaderedTextBox {
                id: emailField
                header: qsTr("Email")
                placeholderText: qsTr("alex@example.com")
            }

            NumberBox {
                id: ageField
                header: qsTr("Age")
                description: qsTr("Must be 18 or older.")
                value: 18
                minimum: 0
                maximum: 120
            }

            PasswordBox {
                id: passwordField
                header: qsTr("Password")
                description: qsTr("At least 8 characters.")
            }

            RadioButtons {
                id: planField
                header: qsTr("Plan")
                description: qsTr("Choose a subscription tier.")
                model: [qsTr("Free"), qsTr("Pro"), qsTr("Team")]
                selectedIndex: 0
            }

            DetailRow {
                label: qsTr("Selected plan")
                value: planField.selectedItem || ""
                symbol: FluentIcons.Shop
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Validate")
                    highlighted: true
                    onClicked: {
                        form.clearErrors()
                        if (nameField.text.trim().length < 2)
                            nameField.errorMessage = qsTr("Enter at least 2 characters.")
                        if (emailField.text.indexOf("@") < 1)
                            emailField.errorMessage = qsTr("Enter a valid email.")
                        if (ageField.value < 18)
                            ageField.errorMessage = qsTr("You must be 18 or older.")
                        if (passwordField.text.length < 8)
                            passwordField.errorMessage = qsTr("Password must be at least 8 characters.")
                        if (form.validate())
                            toasts.successToast(qsTr("All fields passed validation."), qsTr("Looks good"))
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

    ControlExample {
        headerText: qsTr("Left headers + shared labelWidth")
        qmlSource: "FormLayout {\n    labelWidth: 160\n    fieldHeaderPlacement: \"left\"\n}"

        FormLayout {
            id: leftForm
            labelWidth: 160
            fieldHeaderPlacement: "left"

            HeaderedTextBox {
                header: qsTr("Server")
                placeholderText: qsTr("api.example.com")
            }
            NumberBox {
                header: qsTr("Port")
                value: 443
                minimum: 1
                maximum: 65535
                decimals: 0
            }
            PasswordBox {
                header: qsTr("Token")
                placeholderText: qsTr("••••••••")
            }
            DetailRow {
                label: qsTr("Transport")
                value: qsTr("HTTPS")
                symbol: FluentIcons.Shop
                labelWidth: leftForm.labelWidth
            }
        }
    }
}
