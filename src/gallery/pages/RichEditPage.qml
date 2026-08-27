import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RichEdit mail-editor recipe.
//
// Experimental rich text for templates and mail compose — not WebView2.

CatalogPage {
    id: page

    title: qsTr("RichEdit")
    subtitle: qsTr("Mail / template editor — experimental, docs/rich-edit-261.md.")

    property string statusText: qsTr("Compose a message with the toolbar or paste from Word.")

    Timer {
        id: previewTimer
        interval: 120
        onTriggered: page._refreshPreview()
    }

    ControlExample {
        headerText: qsTr("Why RichEdit")
        qmlSource: "RichEdit { placeholderText: qsTr(\"Body\") }"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Plain TextArea cannot do bold/lists/links with Fluent chrome and IME. WebView2 editors break a11y and keyboard routing. RichEdit is an experimental Extras control for mail, templates, and long notes — not a full document engine.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Mail compose recipe")
        qmlSource: "TokenizingTextBox { header: \"To\" }\nTextField { placeholderText: \"Subject\" }\nRichEdit { placeholderText: \"Body\" }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            TokenizingTextBox {
                id: toField
                Layout.fillWidth: true
                header: qsTr("To")
                placeholderText: qsTr("Add recipients")
                maxTokens: 8
            }

            TextField {
                id: subjectField
                Layout.fillWidth: true
                placeholderText: qsTr("Subject")
            }

            RichEdit {
                id: bodyField
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                placeholderText: qsTr("Write your message…")
                accessibleName: qsTr("Message body")
                onLinkActivated: function (url) {
                    page.statusText = qsTr("Link: %1").arg(url)
                }
                onTextEdited: previewTimer.restart()
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Send (demo)")
                    onClicked: page._refreshPreview()
                }
                Button {
                    text: qsTr("Clear body")
                    onClicked: bodyField.clear()
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: page.statusText
            }
        }
    }


    function _refreshPreview() {
        var toCount = toField.tokenCount
        var subj = subjectField.text.trim()
        var plain = bodyField.plainText
        statusText = qsTr("Draft: %1 recipient(s), subject \"%2\", %3 chars plain")
                       .arg(toCount)
                       .arg(subj.length ? subj : qsTr("(no subject)"))
                       .arg(plain.length)
    }
}
