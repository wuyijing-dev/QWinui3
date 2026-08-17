# In-app search & AutoSuggest (1.59)

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

Gallery: **SearchBox**.

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

## Out of scope (1.59)

Full-text / inverted-index engines; cloud search backends; replacing CommandPalette with AutoSuggestBox for global chords.
