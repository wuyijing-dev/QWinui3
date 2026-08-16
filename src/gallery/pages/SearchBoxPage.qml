import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SearchBox.

CatalogPage {
    title: qsTr("SearchBox")
    subtitle: qsTr("Fluent Search/ChromeClose, ElevatedChrome suggestions, and Accessible.")

    ControlExample {
        headerText: qsTr("Search + suggestions")
        qmlSource: "SearchBox {\n    symbol: FluentIcons.Search\n    model: […]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            spacing: Theme.spacing
            CheckBox {
                id: chooseOnEnter
                text: qsTr("ChooseSuggestionOnEnter")
                checked: true
            }
            SearchBox {
                id: box
                header: qsTr("Find files")
                description: qsTr("Type to filter suggestions, Enter to submit or choose.")
                placeholderText: qsTr("Search files")
                symbol: FluentIcons.Search
                chooseSuggestionOnEnter: chooseOnEnter.checked
                maxSuggestionListHeight: 160
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
}
