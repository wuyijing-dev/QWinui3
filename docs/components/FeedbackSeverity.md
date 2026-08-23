# FeedbackSeverity

Shared severity palette and glyphs for InfoBar, Toast, and TeachingTip.

`import QWinUI3.Extras` · singleton · [`FeedbackSeverity.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FeedbackSeverity.qml)

**Library:** v2.70

[← Component index](../components.md)

## Example

```qml
TeachingTip {
    severity: FeedbackSeverity.warning
    title: qsTr("Check network")
}
color: FeedbackSeverity.colorFor(FeedbackSeverity.error)
```

## API

| Method | Description |
| --- | --- |
| `colorFor(severity)` | Accent color token |
| `backgroundFor(severity)` | Soft fill token |
| `glyphFor(severity)` | Default FluentIcons glyph |
| `nameFor(severity)` | Localized label |
| `fromString(name)` | Parse success/warning/error/info |
