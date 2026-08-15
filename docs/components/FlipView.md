# FlipView

Page carousel with optional navigation buttons.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FlipView.qml`](../../src/extras/QWinUI3/Extras/FlipView.qml)

[← Component index](../components.md)

## Usage

```qml
FlipView { model: pages }
```

## Properties

- `currentIndex: alias` — Selected index
- `selectedIndex: alias` — Selected index alias
- `count: alias` — Item count
- `interactive: alias` — Enable hover / click interaction
- `buttonsVisible: bool` — Show next/prev buttons
- `isButtonsVisible: alias` — Alias of buttonsVisible
- `buttonVisibility: string` — always | onHover | hidden
- `isIndicatorVisible: bool` — Show page indicator
- `wrap: bool` — Wrap children to next line
- `contentData: alias` — Default children / content slot

## Signals

- `selectionChanged(int index)` — Selection changed
- `currentIndexChangedByUser(int index)` — Selection changed by user

## Methods

- `goNext()` — Go Next
- `goPrevious()` — Go Previous
- `onCurrentIndexChanged()` — On Current Index Changed

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
