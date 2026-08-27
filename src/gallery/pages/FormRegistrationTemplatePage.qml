import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Registration template.
//
// LoB sign-up: FormLayout + TokenizingTextBox + MultiSelectComboBox + PasswordBox.
// Recipe: docs/forms.md · docs/items-wrap-grid.md

CatalogPage {
    title: qsTr("Registration template")
    subtitle: qsTr("LoB sign-up — FormLayout, tokens, multi-select, password parity.")

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Create account")
        qmlSource: "FormLayout {\n    TokenizingTextBox { … }\n    MultiSelectComboBox { errorMessage }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Industry registration pattern — set field.errorMessage, form.validate(), commit. Pair with examples/form-settings for persistence.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            FormLayout {
                id: form
                Layout.fillWidth: true
                accessibleName: qsTr("Registration")
                labelWidth: 148

                ValidationSummary {
                    errors: form.errors
                }

                HeaderedTextBox {
                    id: nameField
                    header: qsTr("Full name")
                    placeholderText: qsTr("Alex Chen")
                }

                HeaderedTextBox {
                    id: emailField
                    header: qsTr("Work email")
                    placeholderText: qsTr("alex@contoso.com")
                }

                PasswordBox {
                    id: passwordField
                    header: qsTr("Password")
                    description: qsTr("At least 8 characters.")
                }

                PasswordBox {
                    id: confirmField
                    header: qsTr("Confirm password")
                }

                NumberBox {
                    id: seatsField
                    header: qsTr("Team seats")
                    description: qsTr("1–500 for this demo.")
                    value: 5
                    minimum: 1
                    maximum: 500
                    decimals: 0
                }

                TokenizingTextBox {
                    id: skillsField
                    header: qsTr("Skills")
                    description: qsTr("At least one tag.")
                    tokens: [qsTr("QML")]
                    maxTokens: 8
                    tokenDelimiters: ",;"
                    suggestionModel: [
                        qsTr("QML"), qsTr("C++"), qsTr("Design"),
                        qsTr("DevOps"), qsTr("Testing")
                    ]
                }

                MultiSelectComboBox {
                    id: deptField
                    header: qsTr("Departments")
                    description: qsTr("Select one or more.")
                    model: [
                        { text: qsTr("Engineering"), checked: true },
                        { text: qsTr("Design"), checked: false },
                        { text: qsTr("Sales"), checked: false },
                        { text: qsTr("Support"), checked: false }
                    ]
                    onSelectionChanged: if (selectedItems.length) errorMessage = ""
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Button {
                        text: qsTr("Register")
                        highlighted: true
                        onClicked: {
                            form.clearErrors()
                            if (nameField.text.trim().length < 2)
                                nameField.errorMessage = qsTr("Enter your name.")
                            if (emailField.text.indexOf("@") < 1)
                                emailField.errorMessage = qsTr("Enter a valid email.")
                            if (passwordField.text.length < 8)
                                passwordField.errorMessage = qsTr("Password must be at least 8 characters.")
                            if (confirmField.text !== passwordField.text)
                                confirmField.errorMessage = qsTr("Passwords must match.")
                            if (seatsField.value < 1)
                                seatsField.errorMessage = qsTr("Choose at least one seat.")
                            if (!skillsField.tokenCount)
                                skillsField.errorMessage = qsTr("Add at least one skill.")
                            if (!deptField.selectedItems.length)
                                deptField.errorMessage = qsTr("Choose at least one department.")
                            if (form.validate())
                                toasts.successToast(
                                    qsTr("Account created (demo)."),
                                    qsTr("%1 · %2 seats · %3 depts")
                                        .arg(nameField.text.trim())
                                        .arg(seatsField.value)
                                        .arg(deptField.selectedItems.length))
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
