import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CopyButton.
//
// Clipboard copy with FluentIcons.Copy feedback, focus ring, and press scale. API: docs/components/CopyButton.md

Page {
    padding: 0
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
                title: qsTr("CopyButton")
                subtitle: qsTr("Clipboard copy with FluentIcons.Copy feedback, focus ring, and press scale.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Icon only")
                qmlSource: "CopyButton { iconOnly: true; symbol: FluentIcons.Copy }"
                CopyButton {
                    iconOnly: true
                    textToCopy: qsTr("Hello from QWinUI3")
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
