import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Form + settings shell — FormLayout validation + SettingsCard prefs (docs/forms.md).

StandardWindow {
    id: window
    width: 720
    height: 780
    visible: true
    title: qsTr("Form + settings example")
    backdrop: WindowHelper.BackdropSolid

    property bool shareDiagnostics: true
    property string savedHint: ""

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("FormLayout · docs/forms.md")
        }
    }

    ToastHost {
        id: toasts
        z: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacingSection
        width: 360
        placement: ToastHost.BottomCenter
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        background: null

        ColumnLayout {
            x: Theme.spacingSection
            width: Math.max(0, scroll.availableWidth - 2 * Theme.spacingSection)
            spacing: Theme.spacingSection

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }

            Text {
                text: qsTr("Account profile")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Set field.errorMessage, then form.validate(). Preferences stay on SettingsCard (not FormLayout).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            FormLayout {
                id: form
                Layout.fillWidth: true
                accessibleName: qsTr("Account profile")
                labelWidth: 140

                ValidationSummary {
                    errors: form.errors
                }

                HeaderedTextBox {
                    id: nameField
                    header: qsTr("Display name")
                    description: qsTr("At least 2 characters.")
                    placeholderText: qsTr("Alex Chen")
                    text: qsTr("Alex Chen")
                }

                HeaderedTextBox {
                    id: emailField
                    header: qsTr("Email")
                    placeholderText: qsTr("alex@example.com")
                    text: "alex@example.com"
                }

                HeaderedComboBox {
                    id: planField
                    header: qsTr("Plan")
                    description: qsTr("Required.")
                    model: [qsTr("Select…"), qsTr("Starter"), qsTr("Team"), qsTr("Enterprise")]
                    currentIndex: 2
                }

                NumberBox {
                    id: seatsField
                    header: qsTr("Seats")
                    description: qsTr("1–50 for this sample.")
                    value: 5
                    minimum: 0
                    maximum: 100
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing

                    Button {
                        text: qsTr("Save profile")
                        highlighted: true
                        onClicked: {
                            form.clearErrors()
                            if (nameField.text.trim().length < 2)
                                nameField.errorMessage = qsTr("Enter at least 2 characters")
                            if (emailField.text.indexOf("@") < 1)
                                emailField.errorMessage = qsTr("Enter a valid email")
                            if (planField.currentIndex < 1)
                                planField.errorMessage = qsTr("Choose a plan")
                            if (seatsField.value < 1 || seatsField.value > 50)
                                seatsField.errorMessage = qsTr("Seats must be between 1 and 50")
                            if (form.validate()) {
                                window.savedHint = qsTr("Saved %1 · %2 · %3 seats")
                                        .arg(nameField.text.trim())
                                        .arg(planField.currentText)
                                        .arg(seatsField.value)
                                toasts.success(window.savedHint, qsTr("Profile"))
                            }
                        }
                    }
                    Button {
                        text: qsTr("Clear errors")
                        onClicked: form.clearErrors()
                    }
                }

                Label {
                    Layout.fillWidth: true
                    visible: window.savedHint.length > 0
                    text: window.savedHint
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                }
            }

            SettingsGroup {
                Layout.fillWidth: true
                title: qsTr("Privacy preferences")
                symbol: FluentIcons.Permissions

                SettingsCard {
                    title: qsTr("Share diagnostics")
                    description: qsTr("Settings rows are preferences — keep validation on FormLayout.")
                    toggle: true
                    checked: window.shareDiagnostics
                    onToggled: window.shareDiagnostics = checked
                }

                SettingsCard {
                    title: qsTr("App theme")
                    description: qsTr("Toggle Theme.dark")
                    symbol: FluentIcons.Color
                    toggle: true
                    checked: Theme.dark
                    onToggled: Theme.dark = checked
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
