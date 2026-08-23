import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TextField.

CatalogPage {
    title: qsTr("TextField")
    subtitle: qsTr("A single-line text input control.")

    ControlExample {
        headerText: qsTr("A simple TextField")
        qmlSource: "TextField {\n    placeholderText: \"Placeholder\"\n}\nTextField {\n    text: \"Sample text\"\n}\nTextField {\n    text: \"Disabled\"\n    enabled: false\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            TextField {
                Layout.preferredWidth: 320
                placeholderText: qsTr("Placeholder")
            }
            TextField {
                Layout.preferredWidth: 320
                text: qsTr("Sample text")
            }
            TextField {
                Layout.preferredWidth: 320
                text: qsTr("Disabled")
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("Filled vs outline (2.66 A2)")
        qmlSource: "TextField { appearance: \"filled\" }\nTextField { appearance: \"outline\" }\nTextField { hasError: true }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            TextField {
                Layout.preferredWidth: 320
                appearance: "filled"
                placeholderText: qsTr("Filled (default)")
            }
            TextField {
                Layout.preferredWidth: 320
                appearance: "outline"
                placeholderText: qsTr("Outline")
            }
            TextField {
                id: errDemo
                Layout.preferredWidth: 320
                text: qsTr("invalid")
                hasError: true
                placeholderText: qsTr("Validation error")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Leading icon + clear (2.67 I11)")
        qmlSource: "TextField {\n    leadingSymbol: FluentIcons.Search\n    clearButtonVisible: true\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            TextField {
                Layout.preferredWidth: 320
                leadingSymbol: FluentIcons.Search
                placeholderText: qsTr("Search…")
            }
            TextField {
                Layout.preferredWidth: 320
                leadingSymbol: FluentIcons.Mail
                text: qsTr("hello@example.com")
                clearButtonVisible: true
            }
            TextField {
                Layout.preferredWidth: 320
                appearance: "outline"
                leadingSymbol: FluentIcons.Contact
                placeholderText: qsTr("Outline + icon")
            }
        }
    }
}
