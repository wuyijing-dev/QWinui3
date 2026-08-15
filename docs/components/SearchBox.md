# SearchBox

Search field with suggestion list.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SearchBox.qml`](../../src/extras/QWinUI3/Extras/SearchBox.qml)

[← Component index](../components.md)

## Usage

```qml
SearchBox {
    placeholderText: qsTr("Search")
    model: suggestions
    onSuggestionChosen: (item) => open(item)
}
```

## Properties

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `clearButtonVisible: bool` — Show clear affordance
- `symbol: var` — FluentIcons symbol or leave empty to use queryIcon glyph
- `queryIcon: string` — Search glyph fallback string
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `model: var` — Full suggestion catalog; filtered into suggestionModel while typing
- `suggestionModel: var` — Filtered suggestion rows
- `updateTextOnSelect: bool` — When true, choosing a suggestion writes display text into the field
- `textMemberPath: string` — Object field used as display text (fallback: title | text | name)
- `isSuggestionListOpen: bool` — Suggestion popup open state
- `effectiveQueryIcon: string` — Resolved search glyph

## Signals

- `accepted(string text)` — Enter / submit with current text
- `querySubmitted(string query)` — Emitted when a query is submitted
- `suggestionChosen(var item)` — User picked a suggestion row
- `cleared()` — Emitted when content is cleared

## Methods

- `focusField()` — Focus Field
- `displayTextFor(item)` — Display Text For
- `refreshSuggestions()` — Refresh Suggestions
- `clear()` — Clear
- `submitQuery()` — Submit Query

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
