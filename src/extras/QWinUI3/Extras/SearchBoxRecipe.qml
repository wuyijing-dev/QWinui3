import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// SearchBoxRecipe — standard SearchBox preset for product apps.
//
// Adds a consistent default configuration:
//  - debounced suggestion filtering
//  - capped suggestion results
//  - clear affordance
//  - standard placeholder wiring
//
// @notes
//   This is documentation-oriented glue around SearchBox, not a new search engine.

Item {
    id: root

    // --- API ---
    property var model: []
    property string placeholderText: qsTr("Search")
    property bool clearButtonVisible: true
    property int filterDebounceMs: 120
    property int maxSuggestionResults: 32
    property bool chooseSuggestionOnEnter: true

    // Display text (alias).
    property alias text: box.text

    signal accepted(string text)
    signal suggestionChosen(var item)
    signal cleared()
    signal textChanged(string text)

    // Underlying SearchBox.
    SearchBox {
        id: box
        anchors.fill: parent
        visible: true

        model: root.model
        placeholderText: root.placeholderText
        clearButtonVisible: root.clearButtonVisible
        filterDebounceMs: root.filterDebounceMs
        maxSuggestionResults: root.maxSuggestionResults
        chooseSuggestionOnEnter: root.chooseSuggestionOnEnter

        onTextChanged: {
            root.textChanged(text)
        }
        onAccepted: function (t) { root.accepted(t) }
        onSuggestionChosen: function (item) { root.suggestionChosen(item) }
        onCleared: function () { root.cleared() }
    }

}

