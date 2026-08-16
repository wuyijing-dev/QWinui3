import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — CopyButton.
//
// Recipe: docs/drag-drop.md (1.41) — CopyButton vs WindowHelper clipboard.

CatalogPage {
    id: page

    title: qsTr("CopyButton")
    subtitle: qsTr("Copy + paste helpers — docs/drag-drop.md (1.41).")

    property string statusText: qsTr("Ready")

    ControlExample {
        headerText: qsTr("When to use which (1.41)")
        qmlSource: "CopyButton { textToCopy: … }\nWindowHelper.copyText(…)\nWindowHelper.clipboardText()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Visible Copy affordance → CopyButton. Menus / CommandPalette / code → WindowHelper.copyText. Paste actions → WindowHelper.clipboardText (TextField still handles Ctrl+V). Full recipe: docs/drag-drop.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: page.statusText
            }
        }
    }

    ControlExample {
        headerText: qsTr("API key sample")
        qmlSource: "CopyButton {\n    symbol: FluentIcons.Copy\n    textToCopy: secret\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                TextField {
                    id: secret
                    Layout.fillWidth: true
                    text: "sk-demo-qwinui3-4f2a9c"
                    readOnly: true
                }
                CopyButton {
                    textToCopy: secret.text
                    onCopyCompleted: function (t) {
                        page.statusText = qsTr("Copied %1 chars").arg(t.length)
                    }
                    onCopyFailed: page.statusText = qsTr("Nothing to copy")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Paste with WindowHelper")
        qmlSource: "field.text = WindowHelper.clipboardText()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextField {
                id: pasteField
                Layout.fillWidth: true
                placeholderText: qsTr("Paste target")
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Paste")
                    onClicked: {
                        var t = WindowHelper.clipboardText()
                        if (!t.length) {
                            page.statusText = qsTr("Clipboard empty")
                            return
                        }
                        pasteField.text = t
                        page.statusText = qsTr("Pasted %1 chars").arg(t.length)
                    }
                }
                Button {
                    text: qsTr("Copy field via WindowHelper")
                    onClicked: {
                        WindowHelper.copyText(pasteField.text)
                        page.statusText = qsTr("WindowHelper.copyText from field")
                    }
                }
                Item { Layout.fillWidth: true }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Icon only")
        qmlSource: "CopyButton { iconOnly: true; symbol: FluentIcons.Copy }"
        CopyButton {
            iconOnly: true
            textToCopy: qsTr("Hello from QWinUI3")
            onCopyCompleted: page.statusText = qsTr("Icon-only copy OK")
        }
    }
}
