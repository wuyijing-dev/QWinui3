import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SearchBox.
// Recipe: docs/search.md

CatalogPage {
    id: page
    title: qsTr("SearchBox")
    subtitle: qsTr("Search field + suggestions — docs/search.md.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// SearchBox — query + clear\n// AutoSuggestBox — form suggest\n// docs/search.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("SearchBox pairs a search glyph, clear affordance, and suggestion popup for “find …” flows. AutoSuggestBox is the form-field cousin. See docs/search.md for filter-above and catalog jump patterns.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Open AutoSuggestBox")
                onClicked: page.openComp("AutoSuggestBoxPage")
            }
        }
    }

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
