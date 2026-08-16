import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Form validation.
//
// FormLayout + ValidationSummary with top/left headers, RadioButtons, DetailRow.

Page {
    id: page
    padding: 0

    ToastHost {
        id: toasts
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
        z: 10
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("Form validation")
                subtitle: qsTr("FormLayout pushes labelWidth to left-header fields; ValidationSummary lists errors.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                        Layout.fillWidth: true
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("Left headers + shared labelWidth")
                qmlSource: "FormLayout {\n    labelWidth: 160\n    HeaderedTextBox { headerPlacement: \"left\" }\n}"

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
    }
}
