import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                subtitle: qsTr("Turns entries into tokens. Supports maxTokens and delimiter characters (, ;).")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Tags with suggestions")
                qmlSource: "TokenizingTextBox {\n    maxTokens: 6\n    tokenDelimiters: \",;\"\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 480
                    spacing: Theme.spacing
                    TokenizingTextBox {
                        id: box
                        Layout.fillWidth: true
                        tokens: [qsTr("Work")]
                        maxTokens: 6
                        tokenDelimiters: ",;"
                        suggestionModel: [
                            qsTr("Design"), qsTr("Engineering"), qsTr("Research"),
                            qsTr("Personal"), qsTr("Urgent"), qsTr("Later")
                        ]
                        placeholderText: qsTr("Add a tag")
                        onQuerySubmitted: function (t) {
                            status.text = qsTr("Added: %1 (%2/%3)")
                                .arg(t).arg(box.tokens.length).arg(box.maxTokens)
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Press Enter or type , / ; to commit. Max 6 tokens.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
