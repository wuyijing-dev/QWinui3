# AutoSuggestBox

Text field with filtered suggestion popup.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AutoSuggestBox.qml`](../../src/extras/QWinUI3/Extras/AutoSuggestBox.qml)

[← Component index](../components.md)

## Usage

```qml
AutoSuggestBox {
    placeholderText: qsTr("Suggest")
    model: items
    onSuggestionChosen: (item) => apply(item)
}
```

## Properties

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `model: var` — Data model / item list for this control
- `suggestionModel: var` — Filtered suggestion rows
- `clearButtonVisible: bool` — Show clear affordance
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `queryIcon: string` — Search glyph fallback string
- `updateTextOnSelect: bool` — Write selection into the text field
- `textMemberPath: string` — Object field used as display text
- `isSuggestionListOpen: bool` — Suggestion popup open state
- `header: string` — Header label above the control
- `effectiveQueryIcon: string` — Resolved search glyph

## Signals

- `suggestionChosen(var item)` — Emitted when a suggestion is chosen
- `querySubmitted(string query)` — Emitted when a query is submitted
- `accepted(string text)` — Emitted on accept / submit
- `cleared()` — Emitted when content is cleared

## Methods

- `focusField()` — Focus Field
- `displayTextFor(item)` — Display Text For
- `refreshSuggestions()` — Refresh Suggestions
- `clear()` — Clear

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
