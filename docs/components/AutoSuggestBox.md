# AutoSuggestBox

Text field with filtered suggestion popup.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AutoSuggestBox.qml`](../../src/extras/QWinUI3/Extras/AutoSuggestBox.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
AutoSuggestBox {
    id: autoSuggestBox
    placeholderText: qsTr("Suggest")
    model: items
    onSuggestionChosen: (item) => apply(item)
}

// --- API ---
// signals: onSuggestionChosen, onQuerySubmitted, onAccepted, onCleared
// methods: focusField(), displayTextFor(item), refreshSuggestions(), clear()
// autoSuggestBox.focusField()
// autoSuggestBox.displayTextFor(item)
// autoSuggestBox.refreshSuggestions()
// autoSuggestBox.clear()
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `alias` | Display / input text |
| `placeholderText` | `alias` | Placeholder when empty |
| `model` | `var` | Data model / item list for this control |
| `suggestionModel` | `var` | Filtered suggestion rows |
| `clearButtonVisible` | `bool` | Show clear affordance |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `queryIcon` | `string` | Search glyph fallback string |
| `updateTextOnSelect` | `bool` | Write selection into the text field |
| `textMemberPath` | `string` | Object field used as display text |
| `isSuggestionListOpen` | `bool` | Suggestion popup open state |
| `header` | `string` | Header label above the control |
| `effectiveQueryIcon` | `string` | Resolved search glyph |

### Signals

| Signature | Description |
| --- | --- |
| `suggestionChosen(var item)` | Emitted when a suggestion is chosen |
| `querySubmitted(string query)` | Emitted when a query is submitted |
| `accepted(string text)` | Emitted on accept / submit |
| `cleared()` | Emitted when content is cleared |

### Methods

| Signature | Description |
| --- | --- |
| `focusField()` | Move keyboard focus to the text field |
| `displayTextFor(item)` | Display text for a model item |
| `refreshSuggestions()` | Rebuild suggestion list from text |
| `clear()` | Clear text or selection |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
