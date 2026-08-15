import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AutoSuggestBox.
//
// Fluent Search icon, ElevatedChrome list, and isSuggestionListOpen. API: docs/components/AutoSuggestBox.md

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
                title: qsTr("AutoSuggestBox")
                subtitle: qsTr("Fluent Search icon, ElevatedChrome list, and isSuggestionListOpen.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Suggestions")
                qmlSource: "AutoSuggestBox {\n    symbol: FluentIcons.Search\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    spacing: Theme.spacing
                    CheckBox {
                        id: updateOnSelect
                        text: qsTr("Update text on select")
                        checked: true
                    }
                    AutoSuggestBox {
                        id: box
                        Layout.fillWidth: true
                        placeholderText: qsTr("Fruit")
                        symbol: FluentIcons.Search
                        updateTextOnSelect: updateOnSelect.checked
                        model: ["Apple", "Apricot", "Banana", "Blueberry", "Cherry", "Grape", "Orange", "Peach", "Pear"]
                        onSuggestionChosen: function (item) {
                            chosen.text = qsTr("SuggestionChosen: %1").arg(typeof item === "string" ? item : String(item))
                        }
                        onQuerySubmitted: function (query) {
                            chosen.text = qsTr("QuerySubmitted: %1").arg(query)
                        }
                    }
                    Label {
                        id: chosen
                        text: qsTr("Type to filter, Enter to submit, or pick a suggestion.")
                        color: Theme.textSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
