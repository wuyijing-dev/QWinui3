import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Form validation.
//
// FormLayout + ValidationSummary with HeaderedTextBox / NumberBox / PasswordBox.

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
                subtitle: qsTr("FormLayout collects field errorMessage values; ValidationSummary lists them.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("Sign-up form")
                qmlSource: "FormLayout {\n    ValidationSummary { errors: form.errors }\n    HeaderedTextBox { … }\n    form.validate()\n}"

                FormLayout {
                    id: form
                    Layout.fillWidth: true

                    ValidationSummary {
                        Layout.fillWidth: true
                        errors: form.errors
                    }

                    HeaderedTextBox {
                        id: nameField
                        Layout.fillWidth: true
                        header: qsTr("Display name")
                        description: qsTr("At least 2 characters.")
                        placeholderText: qsTr("Alex")
                    }

                    HeaderedTextBox {
                        id: emailField
                        Layout.fillWidth: true
                        header: qsTr("Email")
                        placeholderText: qsTr("alex@example.com")
                    }

                    NumberBox {
                        id: ageField
                        Layout.fillWidth: true
                        header: qsTr("Age")
                        description: qsTr("Must be 18 or older.")
                        value: 18
                        minimum: 0
                        maximum: 120
                    }

                    PasswordBox {
                        id: passwordField
                        Layout.fillWidth: true
                        header: qsTr("Password")
                        description: qsTr("At least 8 characters.")
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
        }
    }
}
