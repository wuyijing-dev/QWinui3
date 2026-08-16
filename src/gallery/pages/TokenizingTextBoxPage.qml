import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TokenizingTextBox.
//
// Tokens with ElevatedChrome suggestions, clear(), and Accessible. API: docs/components/TokenizingTextBox.md

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
                title: qsTr("TokenizingTextBox")
                subtitle: qsTr("Tokens with ElevatedChrome suggestions, clear(), and Accessible.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Tags with suggestions")
                qmlSource: "TokenizingTextBox {\n    header: \"Labels\"\n    maxTokens: 6\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 480
                    spacing: Theme.spacing
                    CheckBox {
                        id: errBox
                        text: qsTr("Show error")
                    }
                    RowLayout {
                        Button {
                            text: qsTr("Clear tokens")
                            flat: true
                            onClicked: box.clear()
                        }
                        Label {
                            text: qsTr("%1 tokens").arg(box.tokenCount)
                            color: Theme.textSecondary
                        }
                    }
                    TokenizingTextBox {
                        id: box
                        Layout.fillWidth: true
                        header: qsTr("Labels")
                        description: qsTr("Press Enter or type , / ; to commit.")
                        tokens: [qsTr("Work")]
                        maxTokens: 6
                        maxSuggestionListHeight: 120
                        tokenDelimiters: ",;"
                        errorMessage: errBox.checked ? qsTr("Choose at least one label.") : ""
                        suggestionModel: [
                            qsTr("Design"), qsTr("Engineering"), qsTr("Research"),
                            qsTr("Personal"), qsTr("Urgent"), qsTr("Later")
                        ]
                        placeholderText: qsTr("Add a tag")
                        onQuerySubmitted: function (t) {
                            status.text = qsTr("Added: %1 (%2/%3)")
                                .arg(t).arg(box.tokens.length).arg(box.maxTokens)
                        }
                        onCleared: status.text = qsTr("Cleared")
                    }
                    Label {
                        id: status
                        text: qsTr("Max 6 tokens.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
