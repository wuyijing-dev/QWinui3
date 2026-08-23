import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AutoSuggestBox.
// Recipe: docs/search.md (1.59)

CatalogPage {
    id: page
    title: qsTr("AutoSuggestBox")
    subtitle: qsTr("Suggest-as-you-type · field-first ↑↓ (2.16) — docs/search.md.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use (1.59)")
        qmlSource: "// AutoSuggestBox — pick from list\n// SearchBox — search chrome\n// CommandPalette — Ctrl+K commands\n// docs/search.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use AutoSuggestBox when typing should narrow a known list (forms, pickers). Prefer SearchBox for explicit search chrome. Global commands stay on CommandPalette (Ctrl+K). See docs/search.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Open SearchBox")
                highlighted: true
                onClicked: page.openComp("SearchBoxPage")
            }
        }
    }

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
