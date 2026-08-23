# SearchBoxRecipe

standard SearchBox preset for product apps.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SearchBoxRecipe.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SearchBoxRecipe.qml)

**Category:** Input & forms · **Library:** v2.66

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
Adds a consistent default configuration:
- debounced suggestion filtering
- capped suggestion results
- clear affordance
- standard placeholder wiring
```

## Notes

This is documentation-oriented glue around SearchBox, not a new search engine.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | --- API --- |
| `placeholderText` | `string` | — |
| `clearButtonVisible` | `bool` | — |
| `filterDebounceMs` | `int` | — |
| `maxSuggestionResults` | `int` | — |
| `chooseSuggestionOnEnter` | `bool` | — |
| `text` | `alias` | Display text (alias). |

### Signals

| Signature | Description |
| --- | --- |
| `accepted(string text)` | — |
| `suggestionChosen(var item)` | — |
| `cleared()` | — |
| `textChanged(string text)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
