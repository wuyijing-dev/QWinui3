# TokenizingTextBox

Token chips + text input.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TokenizingTextBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TokenizingTextBox.qml)

**Category:** Input & forms · **Library:** v2.51

[← Component index](../components.md)

**Gallery:** `TokenizingTextBox` — [`src/gallery/pages/TokenizingTextBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TokenizingTextBoxPage.qml)

**Extends** `Control`.

## Example

```qml
TokenizingTextBox {
    id: tokens
    placeholderText: qsTr("Add people")
    onTokenAdded: (text) => { /* … */ }
    onTokenRemoved: (text) => { /* … */ }
}
// --- API ---
// tokens.addToken(text) / removeToken(text) / clear()
```

## Notes

Token chips + trailing TextField; tokens: string[].
addToken / removeToken / clear; suggestionModel for popup picks.
formBound lets FormLayout host the field (docs/forms.md).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `alias` | Display / input text |
| `tokens` | `var` | Current token list |
| `suggestionModel` | `var` | Filtered suggestion rows |
| `placeholderText` | `string` | Placeholder when empty |
| `suggestionsOpen` | `bool` | Suggestion popup open |
| `isOpen` | `alias` | Open / visible state |
| `maxTokens` | `int` | Maximum number of tokens |
| `allowDuplicates` | `bool` | Allow duplicate tokens |
| `tokenDelimiters` | `string` | Characters that commit a token |
| `maxSuggestionListHeight` | `real` | Max height of the suggestion ListView (WinUI MaxSuggestionListHeight) |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text |
| `formBound` | `bool` | When true, FormLayout may push labelWidth / fieldHeaderPlacement |
| `labelWidth` | `real` | — |
| `headerPlacement` | `string` | — |
| `hasError` | `bool` | True when validation failed |
| `tokenCount` | `int` | Number of tokens |
| `filteredSuggestions` | `var` | Suggestions matching the query |

### Signals

| Signature | Description |
| --- | --- |
| `tokenAdded(string token)` | Token added |
| `tokenRemoved(string token, int index)` | Token removed |
| `accepted(string token)` | Emitted on accept / submit |
| `querySubmitted(string token)` | Emitted when a query is submitted |
| `cleared()` | Emitted when content is cleared |

### Methods

| Signature | Description |
| --- | --- |
| `focusField()` | Move keyboard focus to the text field |
| `clear()` | Clear text or selection |
| `addToken(value)` | Insert a token from text |
| `removeToken(index)` | Remove a token |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
