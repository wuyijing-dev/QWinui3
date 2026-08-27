import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TextField (WinUI TextBox: Header, read-only, validation, limit).

CatalogPage {
    title: qsTr("TextField")
    subtitle: qsTr("WinUI TextBox — header, description, validation, character limit — docs/components/TextField.md")

    ControlExample {
        headerText: qsTr("A simple TextField")
        qmlSource: "TextField { placeholderText: \"Name\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                placeholderText: qsTr("Name")
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                text: qsTr("Sample text")
                clearButtonVisible: true
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                text: qsTr("Disabled")
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("A TextField with a header")
        qmlSource: "TextField {\n    header: \"Email\"\n    description: \"We'll never share this.\"\n    placeholderText: \"name@example.com\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Header and description sit above the field (WinUI TextBox.Header). For left-aligned form labels use HeaderedTextBox.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Email")
                description: qsTr("We'll never share this with anyone else.")
                placeholderText: qsTr("name@example.com")
                leadingSymbol: FluentIcons.Mail
                clearButtonVisible: true
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Display name")
                placeholderText: qsTr("Alex")
                clearButtonVisible: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("A read-only TextField")
        qmlSource: "TextField {\n    header: \"Device ID\"\n    text: \"QWU-2048\"\n    readOnly: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Device ID")
                description: qsTr("Copied from hardware — not editable.")
                text: "QWU-2048-A1"
                readOnly: true
                clearButtonVisible: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("Validation and character limit")
        qmlSource: "TextField {\n    header: \"Username\"\n    characterLimit: 16\n    errorMessage: tooShort ? \"Too short\" : \"\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            TextField {
                id: userField
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Username")
                description: qsTr("3–16 characters, letters and numbers.")
                placeholderText: qsTr("alex")
                characterLimit: 16
                clearButtonVisible: true
                errorMessage: {
                    if (text.length === 0)
                        return ""
                    if (text.length < 3)
                        return qsTr("Enter at least 3 characters.")
                    if (/[^A-Za-z0-9]/.test(text))
                        return qsTr("Use only letters and numbers.")
                    return ""
                }
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Bio")
                placeholderText: qsTr("Short blurb")
                characterLimit: 40
                text: qsTr("Fluent Qt Quick controls")
                clearButtonVisible: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Password (echoMode)")
        qmlSource: "TextField {\n    header: \"Password\"\n    echoMode: TextInput.Password\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Password")
                description: qsTr("Use at least 8 characters. Prefer PasswordBox for reveal-toggle.")
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                clearButtonVisible: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Filled vs outline")
        qmlSource: "TextField { appearance: \"filled\" }\nTextField { appearance: \"outline\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Filled (default)")
                appearance: "filled"
                placeholderText: qsTr("Filled")
                leadingSymbol: FluentIcons.Search
            }
            TextField {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Outline")
                appearance: "outline"
                placeholderText: qsTr("Outline")
                leadingSymbol: FluentIcons.Contact
            }
        }
    }
}
