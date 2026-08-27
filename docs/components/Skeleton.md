# Skeleton

Form / table loading placeholder composed of Shimmer lines (2.70 B6).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Skeleton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Skeleton.qml)

**Category:** Other · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
Skeleton {
    rows: 4
    lineHeight: 14
    active: button.loading
}

// --- API ---
// rows, lineHeight, spacing, active / isActive, showAvatar, rowWidths
```

## Notes

Handoff pattern: Button.loading → ProgressRing for determinate → Skeleton/Shimmer for lists.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `rows` | `int` | — |
| `lineHeight` | `real` | — |
| `lineSpacing` | `real` | — |
| `showAvatar` | `bool` | — |
| `avatarSize` | `real` | — |
| `active` | `bool` | — |
| `isActive` | `alias` | — |
| `rowWidths` | `var` | Optional per-row width ratios (0…1); default alternates 100% / 72%. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
