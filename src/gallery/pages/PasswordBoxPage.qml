import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PasswordBox.

CatalogPage {
    title: qsTr("PasswordBox")
    subtitle: qsTr("Reveal modes with Fluent View/Hide, error icon, clear, and Accessible.")

    ControlExample {
        headerText: qsTr("Reveal modes")
        qmlSource: "PasswordBox {\n    passwordRevealMode: \"peek\"\n    header: \"Password\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Mode"); color: Theme.textSecondary }
                ComboBox {
                    id: modeBox
                    model: ["peek", "hidden", "visible"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
                CheckBox {
                    id: errBox
                    text: qsTr("Show error")
                }
                CheckBox {
                    id: pasteBox
                    text: qsTr("CanPasteClipboardContent")
                    checked: true
                }
            }
            PasswordBox {
                header: qsTr("Account password")
                description: qsTr("Peek: hold the eye to show. Visible: always clear text.")
                placeholderText: qsTr("Password")
                passwordRevealMode: modeBox.currentText
                canPasteClipboardContent: pasteBox.checked
                clearButtonVisible: true
                errorMessage: errBox.checked ? qsTr("Password must be at least 8 characters.") : ""
            }
        }
    }
}
