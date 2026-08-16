import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CopyButton.

CatalogPage {
    title: qsTr("CopyButton")
    subtitle: qsTr("Clipboard copy with FluentIcons.Copy feedback, focus ring, and press scale.")

    ControlExample {
        headerText: qsTr("API key sample")
        qmlSource: "CopyButton {\n    symbol: FluentIcons.Copy\n    textToCopy: secret\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: copyStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
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
                        copyStatus.text = qsTr("Copied %1 chars").arg(t.length)
                    }
                    onCopyFailed: copyStatus.text = qsTr("Nothing to copy")
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Icon only")
        qmlSource: "CopyButton { iconOnly: true; symbol: FluentIcons.Copy }"
        CopyButton {
            iconOnly: true
            textToCopy: qsTr("Hello from QWinUI3")
        }
    }
}
