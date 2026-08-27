import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Vertical kit V1 (3.07) — admin settings: SettingsCard + FormLayout validation.
// Recipe: docs/forms.md · docs/app-platform-3xx.md

StandardWindow {
    id: window
    width: 760
    height: 820
    visible: true
    title: qsTr("Admin settings")
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "AdminSettingsExample"

    Settings {
        id: prefs
        category: "AdminPrefs"
        property int schemaVersion: 1
        property bool requireMfa: true
        property bool auditLog: true
        property bool dark: false
    }

    property string savedHint: ""

    Component.onCompleted: {
        if (prefs.schemaVersion < 1) {
            prefs.requireMfa = true
            prefs.auditLog = true
            prefs.schemaVersion = 1
        }
        Theme.dark = prefs.dark
    }

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("V1 · SettingsCard · FormLayout")
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

    SettingsView {
        anchors.fill: parent
        title: qsTr("Administration")
        subtitle: qsTr("Account form with validation + policy toggles (3.07).")

        SettingsGroup {
            title: qsTr("Operator profile")
            description: qsTr("FormLayout.validate() before save.")
            symbol: FluentIcons.Contact

            FormLayout {
                id: form
                Layout.fillWidth: true
                accessibleName: qsTr("Operator profile")
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
                    header: qsTr("Work email")
                    placeholderText: qsTr("alex@example.com")
                    text: "alex@example.com"
                }

                HeaderedComboBox {
                    id: roleField
                    header: qsTr("Role")
                    model: [qsTr("Select…"), qsTr("Viewer"), qsTr("Operator"), qsTr("Admin")]
                    currentIndex: 3
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing

                    AccentButton {
                        text: qsTr("Save profile")
                        onClicked: {
                            form.clearErrors()
                            if (nameField.text.trim().length < 2)
                                nameField.errorMessage = qsTr("Enter at least 2 characters")
                            if (emailField.text.indexOf("@") < 1)
                                emailField.errorMessage = qsTr("Enter a valid email")
                            if (roleField.currentIndex < 1)
                                roleField.errorMessage = qsTr("Choose a role")
                            if (form.validate()) {
                                window.savedHint = qsTr("Saved %1 · %2")
                                        .arg(nameField.text.trim())
                                        .arg(roleField.currentText)
                                toasts.success(window.savedHint, qsTr("Profile"))
                            } else {
                                form.scrollToFirstError()
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
        }

        SettingsGroup {
            title: qsTr("Security policy")
            description: qsTr("Persisted via Settings category AdminPrefs.")
            symbol: FluentIcons.Permissions

            SettingsCard {
                title: qsTr("Require MFA")
                description: qsTr("Survives app restart.")
                toggle: true
                checked: prefs.requireMfa
                onToggled: prefs.requireMfa = checked
            }

            SettingsCard {
                title: qsTr("Audit log")
                description: qsTr("Record admin actions locally for this sample.")
                toggle: true
                checked: prefs.auditLog
                onToggled: prefs.auditLog = checked
            }

            SettingsCard {
                title: qsTr("App theme")
                description: qsTr("Theme.dark + prefs.dark")
                symbol: FluentIcons.Color
                toggle: true
                checked: Theme.dark
                onToggled: {
                    Theme.dark = checked
                    prefs.dark = checked
                }
            }
        }
    }
}
