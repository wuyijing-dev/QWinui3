import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AutoSuggestBox.

CatalogPage {
    title: qsTr("AutoSuggestBox")
    subtitle: qsTr("Fluent Search icon, ElevatedChrome list, and isSuggestionListOpen.")

    ControlExample {
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
            CheckBox {
                id: chooseOnEnter
                text: qsTr("ChooseSuggestionOnEnter")
                checked: true
            }
            AutoSuggestBox {
                id: box
                header: qsTr("Fruit")
                description: qsTr("Type to filter. Enter chooses the highlighted suggestion when enabled.")
                placeholderText: qsTr("Apple, Banana…")
                symbol: FluentIcons.Search
                updateTextOnSelect: updateOnSelect.checked
                chooseSuggestionOnEnter: chooseOnEnter.checked
                maxSuggestionListHeight: 160
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
}
