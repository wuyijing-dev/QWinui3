import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ComboBox (WinUI Header, editable, validation).

CatalogPage {
    title: qsTr("ComboBox")
    subtitle: qsTr("WinUI ComboBox — header, editable, errorMessage — docs/components/ComboBox.md")

    ControlExample {
        headerText: qsTr("A simple ComboBox")
        qmlSource: "ComboBox {\n    model: [\"Red\", \"Green\", \"Blue\", \"Orange\"]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ComboBox {
                Layout.preferredWidth: 280
                model: [qsTr("Red"), qsTr("Green"), qsTr("Blue"), qsTr("Orange")]
            }
            ComboBox {
                Layout.preferredWidth: 280
                model: [qsTr("One"), qsTr("Two"), qsTr("Three")]
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("A ComboBox with a header")
        qmlSource: "ComboBox {\n    header: \"Favorite color\"\n    description: \"Used on your profile.\"\n    model: [\"Red\", \"Green\", \"Blue\"]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Header and description sit above the field. For FormLayout left labels use HeaderedComboBox.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ComboBox {
                Layout.preferredWidth: 320
                Layout.fillWidth: true
                header: qsTr("Favorite color")
                description: qsTr("Used on your profile card.")
                model: [qsTr("Red"), qsTr("Green"), qsTr("Blue"), qsTr("Orange"), qsTr("Purple")]
            }
            ComboBox {
                Layout.preferredWidth: 320
                Layout.fillWidth: true
                header: qsTr("Plan")
                model: [qsTr("Free"), qsTr("Pro"), qsTr("Enterprise")]
                currentIndex: 1
            }
        }
    }

    ControlExample {
        headerText: qsTr("An editable ComboBox")
        qmlSource: "ComboBox {\n    editable: true\n    header: \"Font\"\n    model: [\"Segoe UI\", \"Consolas\"]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Type a value that is not in the list, or pick from the drop-down (Qt editable).")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ComboBox {
                Layout.preferredWidth: 320
                Layout.fillWidth: true
                header: qsTr("Font family")
                description: qsTr("Pick or type a family name.")
                editable: true
                model: ["Segoe UI", "Consolas", "Cascadia Code", "Arial", "Courier New"]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Validation")
        qmlSource: "ComboBox {\n    header: \"Country\"\n    errorMessage: currentIndex < 0 ? \"Required\" : \"\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ComboBox {
                id: countryBox
                Layout.preferredWidth: 320
                Layout.fillWidth: true
                header: qsTr("Country / region")
                description: qsTr("Required for shipping.")
                model: [qsTr("United States"), qsTr("China"), qsTr("Germany"), qsTr("Japan")]
                currentIndex: -1
                displayText: currentIndex < 0 ? qsTr("Select…") : currentText
                errorMessage: currentIndex < 0 ? qsTr("Choose a country or region.") : ""
            }
            ComboBox {
                Layout.preferredWidth: 320
                Layout.fillWidth: true
                header: qsTr("Has error (flag)")
                appearance: "outline"
                hasError: true
                model: [qsTr("Option A"), qsTr("Option B")]
            }
        }
    }

    ControlExample {
        headerText: qsTr("Filled vs outline")
        qmlSource: "ComboBox { appearance: \"filled\" }\nComboBox { appearance: \"outline\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ComboBox {
                Layout.preferredWidth: 280
                header: qsTr("Filled (default)")
                appearance: "filled"
                model: [qsTr("Filled"), qsTr("Option B")]
            }
            ComboBox {
                Layout.preferredWidth: 280
                header: qsTr("Outline")
                appearance: "outline"
                model: [qsTr("Outline"), qsTr("Option B")]
            }
        }
    }
}
