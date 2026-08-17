import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Form validation.
//
// FormLayout + ValidationSummary; pickers: docs/pickers.md (1.28).

CatalogPage {
    id: page
    title: qsTr("Form validation")
    subtitle: qsTr("errorMessage → validate(). Async + focusFirstError (2.55). docs/forms-unlike-winui-255.md")

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Sign-up form (top headers)")
        qmlSource: "field.errorMessage = …\nif (form.validate()) { … }"

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

            HeaderedComboBox {
                id: regionField
                header: qsTr("Region")
                description: qsTr("Required for billing.")
                model: [qsTr("Select…"), qsTr("Americas"), qsTr("EMEA"), qsTr("APAC")]
                currentIndex: 0
            }

            NumberBox {
                id: ageField
                header: qsTr("Age")
                description: qsTr("Must be 18 or older.")
                value: 18
                minimum: 0
                maximum: 120
            }

            CalendarDatePicker {
                id: startField
                header: qsTr("Start date")
                description: qsTr("Must be today or later (demo rule).")
            }

            PasswordBox {
                id: passwordField
                header: qsTr("Password")
                description: qsTr("At least 8 characters.")
            }

            RadioButtons {
                id: planField
                header: qsTr("Plan")
                description: qsTr("Free is not allowed in this demo.")
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
                        if (regionField.currentIndex <= 0)
                            regionField.errorMessage = qsTr("Choose a region.")
                        if (ageField.value < 18)
                            ageField.errorMessage = qsTr("You must be 18 or older.")
                        if (startField.selectedDate) {
                            var today = new Date()
                            today.setHours(0, 0, 0, 0)
                            var d = new Date(startField.selectedDate)
                            d.setHours(0, 0, 0, 0)
                            if (d < today)
                                startField.errorMessage = qsTr("Start date must be today or later.")
                        } else {
                            startField.errorMessage = qsTr("Pick a start date.")
                        }
                        if (passwordField.text.length < 8)
                            passwordField.errorMessage = qsTr("Password must be at least 8 characters.")
                        if (planField.selectedIndex === 0)
                            planField.errorMessage = qsTr("Choose Pro or Team.")
                        if (form.validate()) {
                            toasts.successToast(qsTr("All fields passed validation."), qsTr("Looks good"))
                        } else {
                            form.focusFirstError()
                        }
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
        headerText: qsTr("Async validation (2.55)")
        qmlSource: "form.beginValidate()\n// … await server …\nform.endValidate()"

        FormLayout {
            id: asyncForm
            labelWidth: 132

            ValidationSummary {
                errors: asyncForm.errors
            }

            BusyIndicator {
                Layout.alignment: Qt.AlignHCenter
                running: asyncForm.validating
                visible: asyncForm.validating
            }

            HeaderedTextBox {
                id: asyncEmail
                header: qsTr("Work email")
                placeholderText: qsTr("you@company.com")
            }

            Button {
                text: qsTr("Check availability")
                highlighted: true
                enabled: !asyncForm.validating
                onClicked: {
                    asyncForm.beginValidate()
                    asyncTimer.start()
                }
            }

            Timer {
                id: asyncTimer
                interval: 600
                onTriggered: {
                    if (asyncEmail.text.indexOf("@") < 1)
                        asyncEmail.errorMessage = qsTr("Enter a valid email.")
                    else if (asyncEmail.text.indexOf("taken") >= 0)
                        asyncEmail.errorMessage = qsTr("That address is already registered.")
                    if (asyncForm.endValidate())
                        toasts.successToast(qsTr("Email available."), qsTr("Async OK"))
                    else
                        asyncForm.focusFirstError()
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
            HeaderedComboBox {
                header: qsTr("Protocol")
                model: [qsTr("HTTPS"), qsTr("HTTP")]
                currentIndex: 0
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
                value: qsTr("TLS 1.3")
                symbol: FluentIcons.Shop
                labelWidth: leftForm.labelWidth
            }
        }
    }
}
