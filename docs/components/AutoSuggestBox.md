# AutoSuggestBox

Text field with filtered suggestion popup.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AutoSuggestBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AutoSuggestBox.qml)

**Category:** Input & forms · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `AutoSuggestBox` — [`src/gallery/pages/AutoSuggestBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AutoSuggestBoxPage.qml)

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

## Notes

Text field + filtered suggestion popup (model / text / suggestionChosen).
Call focusField() / clear(); refreshSuggestions() after model changes.
header / description (WinUI Description); maxSuggestionListHeight caps the popup.

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
| `description` | `string` | WinUI Description — supporting text under the header |
| `maxSuggestionListHeight` | `real` | Max height of the suggestion ListView (WinUI MaxSuggestionListHeight) |
| `chooseSuggestionOnEnter` | `bool` | WinUI ChooseSuggestionOnEnter — Enter picks highlighted row when list is open |
| `filterDebounceMs` | `int` | Debounce suggestion filter keystrokes (2.16). |
| `maxSuggestionResults` | `int` | Cap filtered suggestion rows (2.16). |
| `minFilterLength` | `int` | Skip filter until query length >= this (2.59). |
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
| `refreshSuggestions()` | Rebuild suggestion list from text (immediate — used after model changes). |
| `clear()` | Clear text or selection |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
