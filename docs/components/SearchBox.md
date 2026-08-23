# SearchBox

Search field with suggestion list.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SearchBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SearchBox.qml)

**Category:** Input & forms · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `SearchBox` — [`src/gallery/pages/SearchBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SearchBoxPage.qml)

**Extends** `Control`.

## Example

```qml
SearchBox {
    id: searchBox
    placeholderText: qsTr("Search")
    model: suggestions
    onSuggestionChosen: (item) => open(item)
}

// --- API ---
// signals: onAccepted, onQuerySubmitted, onSuggestionChosen, onCleared
// methods: focusField(), displayTextFor(item), refreshSuggestions(), clear(), submitQuery()
// searchBox.focusField()
// searchBox.displayTextFor(item)
// searchBox.refreshSuggestions()
// searchBox.clear()
```

## Notes

Search field + suggestion popup (model / text).
Signals: querySubmitted, suggestionChosen, cleared; helpers: focusField, clear, submitQuery.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `alias` | Display / input text |
| `placeholderText` | `alias` | Placeholder when empty |
| `clearButtonVisible` | `bool` | Show clear affordance |
| `symbol` | `var` | FluentIcons symbol or leave empty to use queryIcon glyph |
| `queryIcon` | `string` | Search glyph fallback string |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `model` | `var` | Full suggestion catalog; filtered into suggestionModel while typing |
| `suggestionModel` | `var` | Filtered suggestion rows |
| `updateTextOnSelect` | `bool` | When true, choosing a suggestion writes display text into the field |
| `textMemberPath` | `string` | Object field used as display text (fallback: title \| text \| name) |
| `isSuggestionListOpen` | `bool` | Suggestion popup open state |
| `chooseSuggestionOnEnter` | `bool` | WinUI ChooseSuggestionOnEnter — Enter picks highlighted row when list is open |
| `maxSuggestionListHeight` | `real` | Max height of the suggestion ListView (WinUI MaxSuggestionListHeight) |
| `filterDebounceMs` | `int` | Debounce suggestion filter keystrokes (2.16). |
| `maxSuggestionResults` | `int` | Cap filtered suggestion rows (2.16). |
| `effectiveQueryIcon` | `string` | Resolved search glyph |

### Signals

| Signature | Description |
| --- | --- |
| `accepted(string text)` | Enter / submit with current text |
| `querySubmitted(string query)` | Emitted when a query is submitted |
| `suggestionChosen(var item)` | User picked a suggestion row |
| `cleared()` | Emitted when content is cleared |

### Methods

| Signature | Description |
| --- | --- |
| `focusField()` | Move keyboard focus to the text field |
| `displayTextFor(item)` | Display text for a model item |
| `refreshSuggestions()` | Rebuild suggestion list from text (immediate — used after model changes). |
| `clear()` | Clear text or selection |
| `submitQuery()` | Submit the search query |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
