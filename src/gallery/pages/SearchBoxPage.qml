import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SearchBox.
//
// Fluent Search/ChromeClose, ElevatedChrome suggestions, and Accessible. API: docs/components/SearchBox.md

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
                title: qsTr("SearchBox")
                subtitle: qsTr("Fluent Search/ChromeClose, ElevatedChrome suggestions, and Accessible.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Search + suggestions")
                qmlSource: "SearchBox {\n    symbol: FluentIcons.Search\n    model: […]\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    spacing: Theme.spacing
                    SearchBox {
                        id: box
                        Layout.fillWidth: true
                        header: qsTr("Find files")
                        description: qsTr("Type to filter suggestions, Enter to submit.")
                        placeholderText: qsTr("Search files")
                        symbol: FluentIcons.Search
                        model: [
                            qsTr("Documents"),
                            qsTr("Downloads"),
                            qsTr("Desktop"),
                            qsTr("Pictures"),
                            qsTr("Music"),
                            qsTr("Videos")
                        ]
                        onQuerySubmitted: function (query) {
                            status.text = qsTr("QuerySubmitted: %1").arg(query)
                        }
                        onSuggestionChosen: function (item) {
                            status.text = qsTr("Suggestion: %1").arg(item)
                        }
                        onCleared: status.text = qsTr("Cleared")
                    }
                    Label {
                        id: status
                        text: qsTr("Type a letter to open suggestions.")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
