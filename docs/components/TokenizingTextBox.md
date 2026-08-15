# TokenizingTextBox

Token chips + text input.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TokenizingTextBox.qml`](../../src/extras/QWinUI3/Extras/TokenizingTextBox.qml)

[← Component index](../components.md)

## Usage

```qml
TokenizingTextBox {
    model: tokens
    placeholderText: qsTr("Add…")
}
```

## Properties

- `text: alias` — Display / input text
- `tokens: var` — Current token list
- `suggestionModel: var` — Filtered suggestion rows
- `placeholderText: string` — Placeholder when empty
- `suggestionsOpen: bool` — Suggestion popup open
- `isOpen: alias` — Open / visible state
- `maxTokens: int` — Maximum number of tokens
- `allowDuplicates: bool` — Allow duplicate tokens
- `tokenDelimiters: string` — Characters that commit a token
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `hasError: bool` — True when validation failed
- `tokenCount: int` — Number of tokens
- `filteredSuggestions: var` — Suggestions matching the query

## Signals

- `tokenAdded(string token)` — Token added
- `tokenRemoved(string token, int index)` — Token removed
- `accepted(string token)` — Emitted on accept / submit
- `querySubmitted(string token)` — Emitted when a query is submitted
- `cleared()` — Emitted when content is cleared

## Methods

- `focusField()` — Move keyboard focus to the text field
- `clear()` — Clear text or selection
- `addToken(value)` — Insert a token from text
- `removeToken(index)` — Remove a token

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
