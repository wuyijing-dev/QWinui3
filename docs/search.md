# In-app search & AutoSuggest (1.59 · 2.16 wave 2)

Content filter and suggestion patterns for QWinUI3 LoB apps. **CommandPalette** stays the home for global “type to run” chords ([commands.md](commands.md) · [keyboard.md](keyboard.md)). This page covers **finding content** inside a page or shell—not a full-text engine.

Gallery: **Search recipes** · **AutoSuggestBox** · **SearchBox** · **ItemsView** (filter-above) · Gallery title-bar catalog search · **CommandPalette**.

---

## When to use which

| Need | Prefer | Why |
|------|--------|-----|
| Global commands / jump (Ctrl+K) | **`CommandPalette`** | Fuzzy commands + shortcuts — [commands.md](commands.md) |
| Pick from a known list while typing | **`AutoSuggestBox`** | Suggestion popup; Enter can choose highlighted row |
| Search field chrome + clear + submit | **`SearchBox`** | Same suggest model; stronger “query” framing |
| Filter an on-page list / table | **TextField / SearchBox above** + filtered model | ItemsView / DataTable have no built-in filter — [data-collections.md](data-collections.md) |
| Shell catalog / nav jump | TitleBar `searchModel` + app `search()` | Gallery Main + `ControlCatalog.search` |

Do **not** use CommandPalette as a general document search. Do **not** invent a second suggestion popup when AutoSuggestBox / SearchBox already fit.

---

## AutoSuggestBox

```qml
AutoSuggestBox {
    header: qsTr("Fruit")
    placeholderText: qsTr("Type to filter…")
    symbol: FluentIcons.Search
    model: ["Apple", "Banana", "Cherry"]
    updateTextOnSelect: true
    chooseSuggestionOnEnter: true
    onSuggestionChosen: (item) => apply(item)
    onQuerySubmitted: (query) => runQuery(query)
}
```

| Behavior | Detail |
|----------|--------|
| Filter | Client-side `model.filter` on display text (case-insensitive contains) |
| Enter | Chooses highlighted suggestion when `chooseSuggestionOnEnter` and list open; else `querySubmitted` |
| Objects | Set `textMemberPath` when model rows are objects |
| A11y | ComboBox role; name from `header` |

**Keyboard (2.16):** ↑↓ move highlight **without leaving the field**; Enter chooses highlighted row when `chooseSuggestionOnEnter`; Esc closes popup (field keeps focus); ↑ at first list row returns focus to field when navigating inside the popup.

**Performance (2.16):** `filterDebounceMs` (default **120**); `maxSuggestionResults` (default **32**).

Gallery: **AutoSuggestBox**.

---

## SearchBox

```qml
SearchBox {
    placeholderText: qsTr("Search files")
    model: folderNames
    onQuerySubmitted: (q) => searchFiles(q)
    onSuggestionChosen: (item) => openFolder(item)
    onCleared: reset()
}
```

Same suggestion mechanics as AutoSuggestBox with search glyph / clear affordances. Prefer when the primary verb is **Search** / submit a query.

**Keyboard / perf:** same **2.16** model as AutoSuggestBox (`filterDebounceMs`, `maxSuggestionResults`, field-first ↑↓).

Gallery: **SearchBox**.

---

## Wave 2 — keyboard polish & filter perf (2.16)

| Property | Default | Surfaces |
|----------|---------|----------|
| `filterDebounceMs` | 120 | **AutoSuggestBox**, **SearchBox** |
| `maxSuggestionResults` | 32 | Cap popup rows while typing |
| `chooseSuggestionOnEnter` | true | Enter picks highlight when popup open |

**Keyboard traps avoided**

1. **Field-first navigation** — ↑↓ adjust highlight while typing; focus stays in the text field.
2. **Esc** — closes suggestion popup only; does not steal focus from the field.
3. **List ↑ at row 0** — returns focus to the field (no dead-end in the popup).

Gallery **Search recipes** checklist · `python scripts/check_command_search.py`.

---

## Filter-above list (catalog pattern)

```qml
property string filterQuery: ""
readonly property var filteredModel: {
    var q = filterQuery.trim().toLowerCase()
    return source.filter(function (row) {
        return !q.length || String(row.title).toLowerCase().indexOf(q) >= 0
    })
}

ColumnLayout {
    TextField {
        placeholderText: qsTr("Filter…")
        onTextChanged: filterQuery = text
    }
    ItemsView {
        model: filteredModel
        emptyMessage: qsTr("No matches — clear the filter.")
    }
}
```

Cap result counts for huge catalogs (Gallery title-bar search limits to **24**). Match on title + keywords/description when useful.

Gallery title bar:

```qml
onSearchTextEdited: (text) => { searchResults = ControlCatalog.search(text) }
onSearchActivated: (item) => { navigateToControl(item) }
```

---

## Choosing a surface (quick)

| Surface | Best for |
|---------|----------|
| **CommandPalette** | Commands, settings jump, chords |
| **AutoSuggestBox** | Form field with suggestions |
| **SearchBox** | Explicit search UI + clear |
| **Filter-above** | Narrowing a visible list/table |
| **TitleBar search** | App-wide control/page jump (Gallery pattern) |

Cross-links: [navigation.md](navigation.md) (shell chrome) · [forms.md](forms.md) (headered fields) · [data-collections.md](data-collections.md).

---

## Out of scope (1.59 · 2.16)

Full-text / inverted-index engines; cloud search backends; replacing CommandPalette with AutoSuggestBox for global chords.
