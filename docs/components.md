# QWinUI3 component API

Generated from **QML source comments** by regex (`scripts/generate_component_docs.py`).
Edit the `// Name — …` + indented usage block in each `.qml` file, then re-run the script.

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

Public components: **179**. Shell overview: `docs/window-shells.md`.

## Index

### `QWinUI3.Extras`

- [AccentButton](#accentbutton) — Always-accent primary CTA with optional Fluent symbol.
- [AcrylicSurface](#acrylicsurface) — Frosted pane; keep translucent under system Mica/Acrylic.
- [ActionCard](#actioncard) — Clickable card with symbol, title, description, and chevron.
- [AnnotatedScrollBar](#annotatedscrollbar) — Scroll area with a value label on the vertical scrollbar.
- [AppBarButton](#appbarbutton) — CommandBar icon button with label position overrides.
- [AppBarSeparator](#appbarseparator) — Thin separator for CommandBar / AppBar rows.
- [AppBarToggleButton](#appbartogglebutton) — Checkable AppBarButton for CommandBar.
- [ArcGauge](#arcgauge) — Open-arc dashboard gauge with center value and thresholds.
- [AreaChart](#areachart) — Filled area chart with legend and hover crosshair.
- [AutoSuggestBox](#autosuggestbox) — Text field with filtered suggestion popup.
- [AvatarGroup](#avatargroup) — Overlapping PersonPicture stack with overflow count.
- [BarChart](#barchart) — Vertical bar chart with reveal animation.
- [BlankWindow](#blankwindow) — Empty ShellWindow client — declare UI as children.
- [BreadcrumbBar](#breadcrumbbar) — Path trail; model items raise itemClicked.
- [BulletChart](#bulletchart) — Compact KPI bullet (ranges + performance + target).
- [CalendarDatePicker](#calendardatepicker) — Date field with calendar flyout.
- [ChartCard](#chartcard) — Title/subtitle chrome around a chart child.
- [ChartLegend](#chartlegend) — Fluent legend for series/slices.
- [Chip](#chip) — Compact selectable tag; optional close affordance.
- [ChipGroup](#chipgroup) — Horizontal chip group for filters / single select.
- [ColorPicker](#colorpicker) — Spectrum + RGB/Hex color editor.
- [ColorPickerButton](#colorpickerbutton) — Color swatch button that opens ColorPicker.
- [CommandBar](#commandbar) — Primary/secondary command row (AppBar host).
- [CommandBarFlyout](#commandbarflyout) — Popup CommandBar with primary + secondary commands.
- [CompactOverlayShellWindow](#compactoverlayshellwindow) — Always-on-top compact overlay shell.
- [ContentCard](#contentcard) — Surface card with title, subtitle, symbol, and body slot.
- [ContentDialog](#contentdialog) — Modal dialog with primary / secondary / close actions.
- [ContentDialogQueue](#contentdialogqueue) — Singleton queue so ContentDialogs open one at a time.
- [CopyButton](#copybutton) — Copies textToCopy and flashes a success glyph.
- [DatePicker](#datepicker) — Date selectors (year / month / day).
- [DialogShellWindow](#dialogshellwindow) — ShellWindow with dialog paradigm flags.
- [DockPanel](#dockpanel) — Dock children Top/Bottom/Left/Right/Fill.
- [DonutChart](#donutchart) — Donut chart with hover and legend.
- [DropDownButton](#dropdownbutton) — Button that opens a MenuFlyout of actions.
- [EmptyState](#emptystate) — Placeholder illustration + title + optional action.
- [Expander](#expander) — Collapsible header with expandable content.
- [FlipView](#flipview) — Page carousel with optional navigation buttons.
- [Flyout](#flyout) — Light-dismiss popup anchored to a target.
- [FontIcon](#fonticon) — FluentIcons glyph as Text.
- [GridTile](#gridtile) — Icon + title tile for launchers / galleries.
- [HeaderedContentControl](#headeredcontentcontrol) — Labeled content host.
- [HeaderedTextBox](#headeredtextbox) — TextBox with header and description.
- [HeatmapChart](#heatmapchart) — Heatmap matrix chart.
- [HorizontalBarChart](#horizontalbarchart) — Horizontal bar chart.
- [HyperlinkButton](#hyperlinkbutton) — Link-styled button.
- [IconButton](#iconbutton) — Icon-only button helper.
- [IconicButton](#iconicbutton) — Base icon + label button used by AppBar*.
- [InfoBadge](#infobadge) — Count / status / glyph badge.
- [InfoBar](#infobar) — Inline severity banner with optional action.
- [InfoBarHost](#infobarhost) — Stacks InfoBars in a host region.
- [KeyChordVisual](#keychordvisual) — Renders Ctrl+K style shortcuts as KeyVisuals.
- [KeyVisual](#keyvisual) — Single keyboard key chrome.
- [LinearGauge](#lineargauge) — Horizontal/vertical track gauge with thresholds.
- [LineChart](#linechart) — Multi-series line/area chart.
- [ListTile](#listtile) — List row: leading, title, subtitle, trailing.
- [MenuFlyout](#menuflyout) — Elevated Menu with showAt / isOpen helpers.
- [MenuFlyoutHeader](#menuflyoutheader) — Non-interactive MenuFlyout section header.
- [MenuFlyoutItem](#menuflyoutitem) — Menu row with glyph and accelerator text.
- [MenuFlyoutSeparator](#menuflyoutseparator) — MenuFlyout divider.
- [MenuStatusWindow](#menustatuswindow) — TitleBar + MenuBar + content + StatusBar shell.
- [MetadataControl](#metadatacontrol) — Stacked or flowed label/value metadata block.
- [MetadataItem](#metadataitem) — One label/value pair for MetadataControl.
- [MeterBar](#meterbar) — Multi-segment stacked meter (e.g. disk usage).
- [MultiSelectComboBox](#multiselectcombobox) — Combo that keeps the popup open for multi-select.
- [NavigationView](#navigationview) — WinUI NavigationView with pane modes and page stack.
- [NavigationWindow](#navigationwindow) — ShellWindow hosting NavigationView + content.
- [NumberBox](#numberbox) — Numeric spin/edit with validation.
- [PasswordBox](#passwordbox) — Password field with reveal toggle.
- [PersonPicture](#personpicture) — Avatar from image or initials.
- [PieChart](#piechart) — Pie chart with legend.
- [PipsPager](#pipspager) — Dot pager for carousels.
- [Pivot](#pivot) — Header tabs with sliding underline and pages.
- [ProgressButton](#progressbutton) — Button with inline determinate/indeterminate fill.
- [ProgressRing](#progressring) — Circular progress / busy ring.
- [RadarChart](#radarchart) — Radar / spider chart.
- [RadialGauge](#radialgauge) — Circular gauge with needle and zones.
- [RadioButtons](#radiobuttons) — Grouped RadioButton list from a model.
- [RadioMenuFlyoutItem](#radiomenuflyoutitem) — Exclusive radio MenuFlyout item.
- [RatingControl](#ratingcontrol) — Star rating; stepSize supports halves.
- [RefreshContainer](#refreshcontainer) — Pull-to-refresh host for flickable content.
- [RelativePanel](#relativepanel) — Constraint-based relative layout.
- [ScatterChart](#scatterchart) — Scatter / bubble chart.
- [SearchBox](#searchbox) — Search field with suggestion list.
- [SegmentedControl](#segmentedcontrol) — Mutually exclusive segment buttons.
- [SegmentedGauge](#segmentedgauge) — Segmented progress / capacity gauge.
- [SelectorBar](#selectorbar) — Compact horizontal item selector.
- [SettingsCard](#settingscard) — Settings row: icon, title, description, action.
- [SettingsExpander](#settingsexpander) — Expandable settings group.
- [ShellWindow](#shellwindow) — Independent ApplicationWindow + WindowChrome host.
- [Shimmer](#shimmer) — Skeleton shimmer placeholder.
- [Sparkline](#sparkline) — Inline mini line chart.
- [SplitButton](#splitbutton) — Primary action + chevron menu.
- [StackedBarChart](#stackedbarchart) — Stacked bar chart.
- [StackPanel](#stackpanel) — Simple stack layout (orientation + spacing).
- [StatusBar](#statusbar) — Window status strip with progress and slots.
- [StatusDot](#statusdot) — Colored status indicator dot.
- [StepBar](#stepbar) — Horizontal step / wizard progress.
- [SwipeAction](#swipeaction) — Action revealed by SwipeControl.
- [SwipeControl](#swipecontrol) — Swipe-to-reveal actions on content.
- [SwitchCase](#switchcase) — Case child for SwitchPresenter.
- [SwitchPresenter](#switchpresenter) — Shows the SwitchCase matching value.
- [TabView](#tabview) — Closeable / reorderable tabs.
- [TeachingTip](#teachingtip) — Anchored tip with title, subtitle, and actions.
- [TextBlock](#textblock) — Fluent typography styles (title, body, caption…).
- [Timeline](#timeline) — Vertical event timeline.
- [TimePicker](#timepicker) — Hour / minute (and period) selectors.
- [TitleBar](#titlebar) — WinUI TitleBar content chrome (not caption buttons).
- [Toast](#toast) — Transient toast item.
- [ToastHost](#toasthost) — Hosts stacked Toasts.
- [ToggleButton](#togglebutton) — Checkable button with Fluent chrome.
- [ToggleMenuFlyoutItem](#togglemenuflyoutitem) — Checkable MenuFlyout item.
- [ToggleSplitButton](#togglesplitbutton) — Toggle primary + menu SplitButton.
- [TokenizingTextBox](#tokenizingtextbox) — Token chips + text input.
- [ToolShellWindow](#toolshellwindow) — ShellWindow with tool paradigm.
- [TwoPaneView](#twopaneview) — Responsive dual-pane layout.
- [UniformGrid](#uniformgrid) — Even cell grid.
- [WaterfallChart](#waterfallchart) — Waterfall chart.
- [WrapPanel](#wrappanel) — Flow / wrap layout.
- [ZoneGauge](#zonegauge) — Gauge with colored zones.

### `QWinUI3.Platform`

- [CompactOverlayWindow](#compactoverlaywindow) — StandardWindow compact overlay presenter.
- [DialogWindow](#dialogwindow) — StandardWindow dialog paradigm.
- [PlatformTitleBar](#platformtitlebar) — Caption buttons + drag region + TitleBar host.
- [StandardWindow](#standardwindow) — Platform ApplicationWindow + PlatformTitleBar host.
- [ToolWindow](#toolwindow) — StandardWindow tool paradigm.

### `QWinUI3.Theme`

- [Theme](#theme) — Fluent color / type / motion token singleton.

### `QtQuick.Controls.QWinUI3`

- [ApplicationWindow](#applicationwindow) — Fluent ApplicationWindow chrome defaults.
- [BusyIndicator](#busyindicator) — Fluent styled BusyIndicator.
- [Button](#button) — Fluent styled Button.
- [CheckBox](#checkbox) — Fluent styled CheckBox.
- [CheckDelegate](#checkdelegate) — Fluent styled CheckDelegate.
- [ComboBox](#combobox) — Fluent styled ComboBox.
- [DayOfWeekRow](#dayofweekrow) — Fluent styled DayOfWeekRow.
- [DelayButton](#delaybutton) — Fluent styled DelayButton.
- [Dial](#dial) — Fluent styled Dial.
- [Dialog](#dialog) — Fluent styled Dialog.
- [DialogButtonBox](#dialogbuttonbox) — Fluent styled DialogButtonBox.
- [Drawer](#drawer) — Fluent styled Drawer.
- [Frame](#frame) — Fluent styled Frame.
- [GroupBox](#groupbox) — Fluent styled GroupBox.
- [HorizontalHeaderView](#horizontalheaderview) — Fluent styled HorizontalHeaderView.
- [ItemDelegate](#itemdelegate) — Fluent styled ItemDelegate.
- [Label](#label) — Fluent styled Label.
- [Menu](#menu) — Fluent styled Menu.
- [MenuBar](#menubar) — Fluent styled MenuBar.
- [MenuBarItem](#menubaritem) — Fluent styled MenuBarItem.
- [MenuItem](#menuitem) — Fluent styled MenuItem.
- [MenuSeparator](#menuseparator) — Fluent styled MenuSeparator.
- [MonthGrid](#monthgrid) — Fluent styled MonthGrid.
- [Page](#page) — Fluent styled Page.
- [PageIndicator](#pageindicator) — Fluent styled PageIndicator.
- [Pane](#pane) — Fluent styled Pane.
- [Popup](#popup) — Fluent styled Popup chrome.
- [ProgressBar](#progressbar) — Fluent styled ProgressBar.
- [RadioButton](#radiobutton) — Fluent styled RadioButton.
- [RadioDelegate](#radiodelegate) — Fluent styled RadioDelegate.
- [RangeSlider](#rangeslider) — Fluent styled RangeSlider.
- [RoundButton](#roundbutton) — Fluent styled RoundButton.
- [ScrollBar](#scrollbar) — Fluent styled ScrollBar.
- [ScrollIndicator](#scrollindicator) — Fluent styled ScrollIndicator.
- [ScrollView](#scrollview) — Fluent styled ScrollView.
- [Slider](#slider) — Fluent styled Slider.
- [SpinBox](#spinbox) — Fluent styled SpinBox.
- [SplitView](#splitview) — Fluent styled SplitView.
- [StackView](#stackview) — Fluent styled StackView.
- [SwipeDelegate](#swipedelegate) — Fluent styled SwipeDelegate.
- [SwipeView](#swipeview) — Fluent styled SwipeView.
- [Switch](#switch) — Fluent styled Switch.
- [SwitchDelegate](#switchdelegate) — Fluent styled SwitchDelegate.
- [TabBar](#tabbar) — Fluent styled TabBar.
- [TabButton](#tabbutton) — Fluent styled TabButton.
- [TextArea](#textarea) — Fluent styled TextArea.
- [TextField](#textfield) — Fluent styled TextField.
- [ToolBar](#toolbar) — Fluent styled ToolBar.
- [ToolButton](#toolbutton) — Fluent styled ToolButton.
- [ToolSeparator](#toolseparator) — Fluent styled ToolSeparator.
- [ToolTip](#tooltip) — Fluent styled ToolTip.
- [TreeViewDelegate](#treeviewdelegate) — Fluent styled TreeViewDelegate.
- [Tumbler](#tumbler) — Fluent styled Tumbler.
- [VerticalHeaderView](#verticalheaderview) — Fluent styled VerticalHeaderView.

## Components

### Module `QWinUI3.Extras`

#### AccentButton

Always-accent primary CTA with optional Fluent symbol.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AccentButton.qml`

```qml
AccentButton {
    text: qsTr("Save")
    symbol: FluentIcons.Save
    onClicked: save()
}
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `iconSize: real` — Icon size in px
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme

</details>

#### AcrylicSurface

Frosted pane; keep translucent under system Mica/Acrylic.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AcrylicSurface.qml`

```qml
AcrylicSurface {
    elevated: true
    // children…
}
```

<details><summary>Properties</summary>

- `elevated: bool` — Stronger elevation / card tint
- `bordered: bool` — Draw a border when true
- `showLuminantEdge: bool` — Show luminant edge highlight
- `cornerRadius: real` — Corner radius
- `tintColor: color` — Tint overlay color
- `frostOpacity: real` — Frost overlay opacity

</details>

#### ActionCard

Clickable card with symbol, title, description, and chevron.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ActionCard.qml`

```qml
ActionCard {
    title: qsTr("Accounts")
    description: qsTr("Manage profiles")
    onClicked: open()
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `glyphColor: color` — Glyph color
- `glyphBackground: color` — Glyph plate background
- `showChevron: bool` — Show trailing chevron
- `badgeVisible: bool` — Show avatar badge
- `badgeValue: int` — Numeric badge value (-1 hides count)
- `badgeText: string` — Badge caption
- `badgeSeverity: int` — Badge severity
- `effectiveGlyph: string` — Resolved glyph string

</details>

#### AnnotatedScrollBar

Scroll area with a value label on the vertical scrollbar.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml`

```qml
AnnotatedScrollBar {
    // flickable children…
}
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `contentWidth: alias` — Flickable content width
- `contentHeight: alias` — Flickable content height
- `contentX: alias` — Flickable content X
- `contentY: alias` — Flickable content Y
- `flickable: alias` — Inner Flickable
- `labels: var` — Optional map from scroll position (0..1) → label. Empty → percentage.
- `labelFormat: string` — Format string / function for scrollbar label
- `alwaysShowLabel: bool` — Keep scrollbar label visible
- `scrollPosition: real` — Normalized scroll position
- `currentLabel: string` — Label for the current value

</details>

#### AppBarButton

CommandBar icon button with label position overrides.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AppBarButton.qml`

```qml
AppBarButton {
    text: qsTr("Add")
    symbol: FluentIcons.Add
}
```

<details><summary>Properties</summary>

- `labelPosition: string` — Override CommandBar.defaultLabelPosition when set (bottom | right | collapsed)
- `effectiveLabelPosition: string` — Resolved label position

</details>

#### AppBarSeparator

Thin separator for CommandBar / AppBar rows.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AppBarSeparator.qml`

```qml
AppBarSeparator { }
```

<details><summary>Properties</summary>

- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `thickness: real` — Donut ring thickness
- `separatorColor: color` — Separator color
- `margin: real` — Outer margin

</details>

#### AppBarToggleButton

Checkable AppBarButton for CommandBar.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AppBarToggleButton.qml`

```qml
AppBarToggleButton {
    text: qsTr("Pin")
    checkable: true
}
```

<details><summary>Properties</summary>

- `labelPosition: string` — bottom | right | collapsed
- `effectiveLabelPosition: string` — Resolved label position

</details>

#### ArcGauge

Open-arc dashboard gauge with center value and thresholds.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ArcGauge.qml`

```qml
ArcGauge { value: 64; minimum: 0; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `strokeWidth: real` — Stroke thickness in px
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `showValue: bool` — Show numeric value label
- `showMinMax: bool` — Show min/max labels
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `cx: real` — Center X
- `cy: real` — Center Y
- `radius: real` — Corner radius

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`

</details>

<details><summary>Methods</summary>

- `clampSnap(v)`
- `setValue(v)`
- `setValueFromNorm(n)`
- `normFromPoint(px, py, cx, cy)`

</details>

#### AreaChart

Filled area chart with legend and hover crosshair.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AreaChart.qml`

```qml
AreaChart { values: [1, 3, 2, 5] }
```

<details><summary>Properties</summary>

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `showGrid: bool` — Show chart grid
- `stacked: bool` — Stack series instead of overlay
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `maxPoints: int` — Max points before LOD kicks in
- `lodFactor: real` — Level-of-detail downsample factor
- `autoLod: bool` — Auto-enable LOD for large series
- `gridColor: color` — Grid line color
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `hoverLineX: real` — Hover crosshair X
- `hoverMarkers: var` — Hover marker descriptors
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `sourcePointCount: int` — Raw point count before LOD
- `drawnPointCount: int` — Points drawn after LOD
- `isEmpty: bool` — True when there is no data
- `plotL: real` — Plot left inset
- `plotT: real` — Plot top inset
- `plotW: real` — Plot width
- `plotH: real` — Plot height
- `lo: real` — Computed axis minimum

</details>

<details><summary>Methods</summary>

- `invalidateLod()`
- `sourcePointCountEstimate()`
- `ensureLod(budget)`
- `playReveal()`
- `requestRedraw()`
- `onDataChanged()`

</details>

#### AutoSuggestBox

Text field with filtered suggestion popup.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AutoSuggestBox.qml`

```qml
AutoSuggestBox {
    placeholderText: qsTr("Suggest")
    model: items
    onSuggestionChosen: (item) => apply(item)
}
```

<details><summary>Properties</summary>

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `model: var` — Data model / item list for this control
- `suggestionModel: var` — Filtered suggestion rows
- `clearButtonVisible: bool` — Show clear affordance
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `queryIcon: string` — Search glyph fallback string
- `updateTextOnSelect: bool` — Write selection into the text field
- `textMemberPath: string` — Object field used as display text
- `isSuggestionListOpen: bool` — Suggestion popup open state
- `header: string` — Header label above the control
- `effectiveQueryIcon: string` — Resolved search glyph
- `host: var` — Host item for popup anchoring

</details>

<details><summary>Signals</summary>

- `suggestionChosen(var item)`
- `querySubmitted(string query)`
- `accepted(string text)`
- `cleared()`

</details>

<details><summary>Methods</summary>

- `focusField()`
- `displayTextFor(item)`
- `refreshSuggestions()`
- `clear()`

</details>

#### AvatarGroup

Overlapping PersonPicture stack with overflow count.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/AvatarGroup.qml`

```qml
AvatarGroup { model: [{ displayName: "A" }, { displayName: "B" }] }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `size: real` — Diameter or box size in px
- `overlap: real` — Avatar stack overlap in px
- `maxVisible: int` — Max visible items before overflow
- `showOverflowCount: bool` — Show +N overflow chip
- `layoutDirection: int` — Qt layout direction
- `overflowCount: int` — Hidden avatar count
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `personClicked(int index, var item)`
- `overflowClicked()`

</details>

#### BarChart

Vertical bar chart with reveal animation.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/BarChart.qml`

```qml
BarChart { values: [4, 2, 7, 3] }
```

<details><summary>Properties</summary>

- `values: var` — Numeric values array
- `bars: var` — Bar descriptors
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `barRadius: real` — Bar corner radius
- `barGap: real` — Gap between bars
- `showBaseline: bool` — Show zero baseline
- `showValueLabels: bool` — Show value labels on bars
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `valueUnit: string` — Unit appended to value text
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `gap: real` — Gap between items
- `padL: real` — Left padding

</details>

<details><summary>Signals</summary>

- `barClicked(int index, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`

</details>

#### BlankWindow

Empty ShellWindow client — declare UI as children.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/BlankWindow.qml`

```qml
BlankWindow {
    title: qsTr("App")
    Label { anchors.centerIn: parent; text: "Hello" }
}
```

#### BreadcrumbBar

Path trail; model items raise itemClicked.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/BreadcrumbBar.qml`

```qml
BreadcrumbBar {
    model: [{ title: "Home" }, { title: "Docs" }]
    onItemClicked: (index) => navigate(index)
}
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `maxVisibleItems: int` — Collapse middle crumbs when count exceeds this (0 = show all)
- `lastItemClickable: bool` — WinUI: current/last crumb is usually non-interactive
- `separatorSymbol: var` — Breadcrumb separator FluentIcons symbol
- `separatorGlyph: string` — Breadcrumb separator glyph string
- `effectiveSeparatorGlyph: string` — Resolved separator glyph
- `visibleModel: var` — Visible (non-overflow) crumbs
- `overflowModel: var` — Overflow crumb items
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `itemClicked(int index)`
- `itemInvoked(int index)`

</details>

<details><summary>Methods</summary>

- `crumbTitle(data)`
- `crumbIcon(data)`
- `isCurrent(index)`
- `isClickable(entry)`

</details>

#### BulletChart

Compact KPI bullet (ranges + performance + target).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/BulletChart.qml`

```qml
BulletChart { value: 70; target: 80; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `target: real` — Anchor item for placement
- `maximum: real` — Maximum value
- `minimum: real` — Minimum value
- `ranges: var` — Bullet qualitative ranges
- `rangeColors: var` — Colors for bullet ranges
- `label: string` — Field label
- `unit: string` — Value unit label (%, rpm, …)
- `valuePrecision: int` — Digits after decimal for value text
- `showValueText: bool` — Show value as text
- `showTarget: bool` — Show target marker
- `showTargetDelta: bool` — Show delta vs target
- `targetMet: bool` — True when value meets target
- `targetDelta: real` — Value minus target
- `formattedValue: string` — Formatted value string
- `formattedDelta: string` — Formatted target delta text
- `index: int`
- `modelData: var`
- `prev: real` — Previous animated value
- `cur: real` — Current animated value

</details>

<details><summary>Methods</summary>

- `setValue(v)`
- `bandColor(index)`

</details>

#### CalendarDatePicker

Date field with calendar flyout.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/CalendarDatePicker.qml`

```qml
CalendarDatePicker { selectedDate: new Date() }
```

<details><summary>Properties</summary>

- `selectedDate: date` — Currently selected date
- `calendarOpen: bool` — Calendar flyout open
- `isOpen: alias` — Open / visible state
- `dateFormat: string` — Display date format
- `showTodayButton: bool` — Show Today button in calendar
- `header: string` — Header label above the control
- `placeholderText: string` — Placeholder when empty
- `minDate: date` — Minimum selectable date
- `maxDate: date` — Maximum selectable date
- `hasMinDate: bool` — True when minDate is set
- `hasMaxDate: bool` — True when maxDate is set

</details>

<details><summary>Signals</summary>

- `dateChosen(date date)`

</details>

<details><summary>Methods</summary>

- `isDateAllowed(d)`

</details>

#### ChartCard

Title/subtitle chrome around a chart child.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ChartCard.qml`

```qml
ChartCard {
    title: qsTr("Revenue")
    LineChart { values: series }
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `footer: string` — Footer text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `animated: bool` — Play enter / reveal animation
- `elevated: bool` — Stronger elevation / card tint
- `bordered: bool` — Draw a border when true
- `headerActions: alias` — Trailing header actions slot
- `content: alias` — Content slot / children host
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### ChartLegend

Fluent legend for series/slices.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ChartLegend.qml`

```qml
ChartLegend { items: [{ label: "A", color: Theme.accent }] }
```

<details><summary>Properties</summary>

- `items: var` — Item list / children model
- `hoverIndex: int` — Hovered item index
- `selectedIndex: int` — Selected index alias
- `interactive: bool` — Enable hover / click interaction
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `showValue: bool` — Show numeric value label
- `header: string` — Header label above the control
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `itemClicked(int index)`
- `itemHovered(int index)`

</details>

<details><summary>Methods</summary>

- `select(index)`
- `clearSelection()`

</details>

#### Chip

Compact selectable tag; optional close affordance.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Chip.qml`

```qml
Chip {
    text: qsTr("Tag")
    closable: true
    onCloseClicked: remove()
}
```

<details><summary>Properties</summary>

- `closable: bool` — Shows a trailing close affordance
- `isCloseButtonVisible: alias` — Alias of closable
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `avatarText: string` — Initials / short avatar text instead of an icon
- `appearance: string` — filled | outline
- `chipSize: string` — small | medium
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

<details><summary>Signals</summary>

- `closeClicked()`

</details>

#### ChipGroup

Horizontal chip group for filters / single select.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ChipGroup.qml`

```qml
ChipGroup { model: ["All", "Open"]; currentIndex: 0 }
```

<details><summary>Properties</summary>

- `model: alias` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `exclusive: bool` — Single-select when true
- `selectionMode: string` — single | multiple | none
- `selectedIndexes: var` — Multi-select indexes
- `maxSelected: int` — Max selected chips when not exclusive
- `chipSpacing: real` — Spacing between chips
- `chipSize: string` — small | medium
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `selectionChanged()`
- `itemClicked(int index)`

</details>

<details><summary>Methods</summary>

- `isSelected(index)`
- `clearSelection()`
- `select(index)`
- `toggleIndex(index)`

</details>

#### ColorPicker

Spectrum + RGB/Hex color editor.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ColorPicker.qml`

```qml
ColorPicker { selectedColor: "#005FB8" }
```

<details><summary>Properties</summary>

- `selectedColor: color` — Currently selected color
- `hue: real` — Hue 0..360
- `saturation: real` — Saturation 0..1
- `value: real` — Current value
- `showAlpha: bool` — Show alpha channel editor
- `alpha: real` — Alpha 0..1
- `colorModel: int` — rgb | hsv | hex editor mode
- `isColorSpectrumVisible: bool` — Show color spectrum
- `isColorPreviewVisible: bool` — Show color preview swatch
- `isColorChannelTextInputVisible: bool` — Show channel text inputs

</details>

<details><summary>Signals</summary>

- `colorChosen(color color)`

</details>

<details><summary>Methods</summary>

- `copyHex()`
- `clamp01(x)`
- `hsvToRgb(h, s, v)`
- `rgbToHsv(r, g, b)`
- `hsvToColor(h, s, v, a)`
- `hexString(c)`
- `byteHex(n)`
- `parseHex(text)`
- `applyHsv(emitSignal)`
- `syncFromColor(c, emitSignal)`
- `syncInputsFromColor()`
- `commitRgbFields()`
- `commitHsvFields()`

</details>

#### ColorPickerButton

Color swatch button that opens ColorPicker.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ColorPickerButton.qml`

```qml
ColorPickerButton { selectedColor: Theme.accent }
```

<details><summary>Properties</summary>

- `selectedColor: color` — Currently selected color
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `showAlpha: bool` — Show alpha channel editor
- `showHexLabel: bool` — Show hex text on the button
- `flyoutPlacement: int` — MenuFlyout placement
- `hexText: string` — Formatted hex color text

</details>

<details><summary>Signals</summary>

- `colorChosen(color color)`

</details>

<details><summary>Methods</summary>

- `hex2(n)`
- `open()`
- `close()`

</details>

#### CommandBar

Primary/secondary command row (AppBar host).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/CommandBar.qml`

```qml
CommandBar {
    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
}
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `primaryCommands: alias` — Primary command host
- `overflowMenu: alias` — Overflow Menu for secondary commands
- `overflowItems: var` — [{ text: string, triggered: function() }] — MenuItem cannot parent to Menu in Qt 6
- `secondaryCommands: alias` — Secondary command host
- `barSpacing: real` — Spacing between commands
- `isOpen: bool` — Open / visible state
- `defaultLabelPosition: string` — Default AppBar label position
- `closedDisplayMode: string` — How labels show when closed
- `isMoreButtonVisible: bool` — Show overflow (…) button
- `isToggleButtonVisible: bool` — Show toggle / more button
- `effectiveLabelPosition: string` — Resolved label position
- `modelData: var`

</details>

<details><summary>Signals</summary>

- `opening()`
- `closing()`
- `opened()`
- `closed()`
- `moreButtonClicked()`

</details>

<details><summary>Methods</summary>

- `open()`
- `close()`
- `toggle()`

</details>

#### CommandBarFlyout

Popup CommandBar with primary + secondary commands.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/CommandBarFlyout.qml`

```qml
CommandBarFlyout {
    AppBarButton { text: qsTr("Share") }
}
```

<details><summary>Properties</summary>

- `primaryCommands: alias` — Primary command host
- `secondaryCommands: alias` — Secondary command host
- `primaryData: alias` — Primary commands slot
- `secondaryData: alias` — Secondary commands slot
- `isOpen: bool` — Open / visible state
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `target: Item` — Anchor item for placement
- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `showSecondary: bool` — Show secondary command list

</details>

<details><summary>Methods</summary>

- `showAt(item, preferredPlacement)`
- `show()`
- `hide()`
- `openFlyout()`
- `closeFlyout()`

</details>

#### CompactOverlayShellWindow

Always-on-top compact overlay shell.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/CompactOverlayShellWindow.qml`

```qml
CompactOverlayShellWindow { title: qsTr("Now playing") }
```

#### ContentCard

Surface card with title, subtitle, symbol, and body slot.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ContentCard.qml`

```qml
ContentCard {
    title: qsTr("Card")
    Label { text: qsTr("Body") }
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `headerIcon: string` — Header icon glyph
- `footer: alias` — Footer text
- `isClickable: bool` — Emit clicked when activated
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

</details>

<details><summary>Signals</summary>

- `clicked()`

</details>

<details><summary>Methods</summary>

- `fitChildren()`
- `fitFooter()`

</details>

#### ContentDialog

Modal dialog with primary / secondary / close actions.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ContentDialog.qml`

```qml
ContentDialog {
    title: qsTr("Confirm")
    primaryButtonText: qsTr("OK")
    closeButtonText: qsTr("Cancel")
}
// prefer dialog.show() → ContentDialogQueue
```

<details><summary>Properties</summary>

- `primaryButtonText: string` — Primary action label (accent); empty hides the button
- `secondaryButtonText: string` — Optional middle action; empty hides
- `closeButtonText: string` — Dismiss / cancel label; empty hides
- `isPrimaryDefault: bool` — Prefer defaultButton; isPrimaryDefault kept for compatibility
- `defaultButton: string` — WinUI DefaultButton: primary | secondary | close | none
- `isPrimaryButtonEnabled: bool` — Enable primary button
- `isSecondaryButtonEnabled: bool` — Enable secondary button
- `isCloseButtonEnabled: bool` — Enable close button
- `isOpen: alias` — Bindable open state (alias of visible)

</details>

<details><summary>Signals</summary>

- `primaryClicked()`
- `secondaryClicked()`
- `closeClicked()`

</details>

<details><summary>Methods</summary>

- `show()`
- `hide()`
- `openQueued()`
- `activateDefault()`
- `syncBody()`

</details>

#### ContentDialogQueue

Singleton queue so ContentDialogs open one at a time.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ContentDialogQueue.qml`

```qml
ContentDialogQueue.show(dialog)
ContentDialogQueue.cancel(dialog)
ContentDialogQueue.replaceCurrent(other)
```

<details><summary>Properties</summary>

- `pendingCount: int` — Dialogs waiting in the queue
- `busy: bool` — Busy status constant

</details>

<details><summary>Methods</summary>

- `enqueue(dialog)`
- `show(dialog)`
- `cancel(dialog)`
- `clearQueue()`
- `replaceCurrent(dialog)`

</details>

#### CopyButton

Copies textToCopy and flashes a success glyph.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/CopyButton.qml`

```qml
CopyButton { textToCopy: code }
```

<details><summary>Properties</summary>

- `textToCopy: string` — Clipboard payload to copy
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `idleGlyph: string` — Glyph before copy succeeds
- `doneGlyph: string` — Glyph shown after copy
- `feedbackMs: int` — Success feedback duration in ms
- `copied: bool` — Emitted after a successful copy
- `iconOnly: bool` — Hide text; show glyph only

</details>

<details><summary>Signals</summary>

- `copyCompleted(string text)`
- `copyFailed()`

</details>

<details><summary>Methods</summary>

- `copy(optionalText)`

</details>

#### DatePicker

Date selectors (year / month / day).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/DatePicker.qml`

```qml
DatePicker { }
```

<details><summary>Properties</summary>

- `year: int` — Selected year
- `month: int` — Selected month 1..12
- `day: int` — Selected day of month
- `minYear: int` — Minimum selectable year
- `maxYear: int` — Maximum selectable year
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `header: string` — Header label above the control
- `placeholderText: string` — Placeholder when empty
- `dateFormat: string` — yyyy-MM-dd | MM/dd/yyyy | dd/MM/yyyy
- `selectedDate: date` — Currently selected date
- `displayText: string` — Text shown to the user
- `daysInMonth: int` — Days in the selected month

</details>

<details><summary>Signals</summary>

- `dateChosen(int year, int month, int day)`

</details>

<details><summary>Methods</summary>

- `syncSelectedDateFromParts()`
- `clampDay()`
- `applyFromTumblers()`
- `syncTumblers()`

</details>

#### DialogShellWindow

ShellWindow with dialog paradigm flags.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/DialogShellWindow.qml`

```qml
DialogShellWindow {
    title: qsTr("Confirm")
    width: 440; height: 280
}
```

#### DockPanel

Dock children Top/Bottom/Left/Right/Fill.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/DockPanel.qml`

```qml
DockPanel {
    Rectangle { DockPanel.dock: DockPanel.Top; height: 40 }
    Rectangle { DockPanel.dock: DockPanel.Fill }
}
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `lastChildFill: bool` — WinUI LastChildFill: last non-edge child fills the remaining region
- `paddingEdges: int` — Edge paddings
- `childCount: int` — Number of children

</details>

<details><summary>Methods</summary>

- `dockOf(item)`
- `relayout()`

</details>

#### DonutChart

Donut chart with hover and legend.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/DonutChart.qml`

```qml
DonutChart { slices: [{ value: 3, label: "A" }] }
```

<details><summary>Properties</summary>

- `slices: var` — Pie/donut slice descriptors
- `thickness: real` — Donut ring thickness
- `showCenterLabel: bool` — Show center label in donut
- `centerText: string` — Donut center primary text
- `centerSubText: string` — Donut center secondary text
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `startAngle: real` — Arc start angle in degrees
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `total: real` — Sum of segment values
- `cx: real` — Center X
- `cy: real` — Center Y
- `outer: real` — Donut outer radius
- `inner: real` — Donut inner radius
- `arcs: var` — Arc path descriptors

</details>

<details><summary>Signals</summary>

- `sliceClicked(int index, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`

</details>

#### DropDownButton

Button that opens a MenuFlyout of actions.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/DropDownButton.qml`

```qml
DropDownButton {
    text: qsTr("Options")
    MenuFlyoutItem { text: qsTr("A") }
}
```

<details><summary>Properties</summary>

- `menu: alias` — Attached / owned Menu
- `menuData: alias` — Menu children slot
- `highlighted: bool` — Emphasized / selected chrome
- `flyoutPlacement: int` — MenuFlyout placement
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `isOpen: alias` — Open / visible state
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `menuOpen: bool` — Menu currently open
- `hasSolidStroke: bool` — Draw solid stroke chrome
- `hasGradientStroke: bool` — Draw gradient stroke chrome
- `topStroke: color` — Top edge stroke width
- `bottomStroke: color` — Bottom edge stroke width
- `inset: bool` — Content inset

</details>

<details><summary>Methods</summary>

- `open()`
- `close()`
- `showMenu()`

</details>

#### EmptyState

Placeholder illustration + title + optional action.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/EmptyState.qml`

```qml
EmptyState {
    title: qsTr("Nothing here")
    description: qsTr("Try another filter.")
}
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `title: string` — Primary title text
- `message: string` — Body / message text
- `actionText: string` — Optional action button label
- `secondaryActionText: string` — Secondary action button label
- `compact: bool` — Compact layout density
- `bordered: bool` — Draw a border when true
- `glyphColor: color` — Glyph color
- `showGlyph: bool` — Show leading glyph
- `effectiveGlyph: string` — Resolved glyph string

</details>

<details><summary>Signals</summary>

- `actionClicked()`
- `secondaryActionClicked()`

</details>

#### Expander

Collapsible header with expandable content.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Expander.qml`

```qml
Expander {
    header: qsTr("Details")
    Label { text: qsTr("Body") }
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `expanded: bool` — Expanded state
- `isExpanded: alias` — Alias of expanded
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerIcon: var` — Header icon glyph
- `expandDirection: string` — WinUI ExpandDirection: down | up
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

</details>

<details><summary>Signals</summary>

- `expanding()`
- `collapsing()`

</details>

#### FlipView

Page carousel with optional navigation buttons.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/FlipView.qml`

```qml
FlipView { model: pages }
```

<details><summary>Properties</summary>

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

</details>

<details><summary>Signals</summary>

- `selectionChanged(int index)`
- `currentIndexChangedByUser(int index)`

</details>

<details><summary>Methods</summary>

- `goNext()`
- `goPrevious()`
- `onCurrentIndexChanged()`

</details>

#### Flyout

Light-dismiss popup anchored to a target.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Flyout.qml`

```qml
Flyout {
    target: button
    Label { text: qsTr("Details") }
}
```

<details><summary>Properties</summary>

- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `target: Item` — Anchor item for placement
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isOpen: bool` — Open / visible state
- `title: string` — Primary title text
- `contentData: alias` — Default children / content slot

</details>

<details><summary>Methods</summary>

- `showAt(item, place)`
- `show()`
- `hide()`
- `reposition()`

</details>

#### FontIcon

FluentIcons glyph as Text.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/FontIcon.qml`

```qml
FontIcon { symbol: FluentIcons.Home; font.pixelSize: 16 }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `icon: var` — Icon glyph or source
- `glyph: string` — Fluent glyph drawn in the button
- `fontSize: real` — Font size in px
- `iconColor: color` — Icon color
- `mirrorGlyph: bool` — Mirror glyph for RTL
- `fontWeight: int` — Font weight
- `toolTipText: string` — Tooltip text
- `accessibleName: string` — Accessible name override
- `effectiveGlyph: string` — Resolved glyph string

</details>

#### GridTile

Icon + title tile for launchers / galleries.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/GridTile.qml`

```qml
GridTile { title: qsTr("Photos"); symbol: FluentIcons.Photo }
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `source: url` — Image / media source
- `tileWidth: real` — Tile width
- `tileHeight: real` — Tile height
- `isSelected: alias` — Selected state
- `badgeText: string` — Badge caption
- `badgeVisible: bool` — Show avatar badge
- `effectiveGlyph: string` — Resolved glyph string

</details>

#### HeaderedContentControl

Labeled content host.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/HeaderedContentControl.qml`

```qml
HeaderedContentControl { header: qsTr("Section"); Label { text: "…" } }
```

<details><summary>Properties</summary>

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerComponent: Component` — Header Component
- `headerPlacement: string` — top | left
- `contentData: alias` — Default children / content slot
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### HeaderedTextBox

TextBox with header and description.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/HeaderedTextBox.qml`

```qml
HeaderedTextBox { header: qsTr("Name"); placeholderText: qsTr("Required") }
```

<details><summary>Properties</summary>

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `clearButtonVisible: bool` — Show clear affordance
- `characterLimit: int` — Soft character counter limit
- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `echoMode: alias` — TextField echo mode
- `readOnly: alias` — Read-only when true
- `isReadOnly: alias` — Alias of readOnly
- `maximumLength: alias` — Hard maximum text length
- `validator: alias` — Optional input validator
- `inputMethodHints: alias` — Qt input method hints
- `acceptableInput: alias` — Acceptable Input
- `field: alias` — Inner text field
- `hasError: bool` — True when validation failed
- `characterCount: int` — Character Count
- `overLimit: bool` — Over Limit

</details>

<details><summary>Signals</summary>

- `accepted()`
- `editingFinished()`
- `textEdited()`
- `cleared()`

</details>

<details><summary>Methods</summary>

- `clear()`
- `focusField()`

</details>

#### HeatmapChart

Heatmap matrix chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/HeatmapChart.qml`

```qml
HeatmapChart { values: matrix }
```

<details><summary>Properties</summary>

- `values: var` — Numeric values array
- `rowLabels: var` — Heatmap row labels
- `columnLabels: var` — Heatmap column labels
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `cellGap: real` — Gap between heatmap cells
- `cellRadius: real` — Heatmap cell corner radius
- `animated: bool` — Play enter / reveal animation
- `interactive: bool` — Enable hover / click interaction
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverRow: int` — Hovered heatmap row index
- `hoverCol: int` — Hover Col
- `lowColor: color` — Low Color
- `highColor: color` — High Color
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `labelW: real` — Label column width
- `labelH: real` — Label H
- `cellW: real` — Cell W
- `cellH: real` — Cell H
- `rows: int` — Grid row count
- `cols: int` — Cols

</details>

<details><summary>Signals</summary>

- `cellClicked(int row, int col, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`
- `clearHover()`
- `lerpColor(a, b, t)`

</details>

#### HorizontalBarChart

Horizontal bar chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/HorizontalBarChart.qml`

```qml
HorizontalBarChart { values: [3, 5, 2] }
```

<details><summary>Properties</summary>

- `values: var` — Numeric values array
- `bars: var` — Bar descriptors
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `barRadius: real` — Bar corner radius
- `barGap: real` — Gap between bars
- `showBaseline: bool` — Show zero baseline
- `showLabels: bool` — Show item labels
- `showValueLabels: bool` — Show value labels on bars
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `valueUnit: string` — Unit appended to value text
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `padT: real` — Top padding
- `labelW: real` — Label column width

</details>

<details><summary>Signals</summary>

- `barClicked(int index, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`

</details>

#### HyperlinkButton

Link-styled button.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/HyperlinkButton.qml`

```qml
HyperlinkButton { text: qsTr("Learn more"); onClicked: Qt.openUrlExternally(url) }
```

<details><summary>Properties</summary>

- `url: url` — Url
- `navigateUri: alias` — Navigate Uri
- `underlineStyle: string` — always | onHover | never
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `visited: bool` — Visited
- `showExternalGlyph: bool` — Show External Glyph
- `navigateMode: string` — "external" opens the URL; "signal" only emits clicked / navigateRequested
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

<details><summary>Signals</summary>

- `navigateRequested(url target)`

</details>

#### IconButton

Icon-only button helper.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/IconButton.qml`

```qml
IconButton { symbol: FluentIcons.Add }
```

#### IconicButton

Base icon + label button used by AppBar*.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/IconicButton.qml`

```qml
IconicButton { text: qsTr("Action"); symbol: FluentIcons.Add }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `iconSize: real` — Icon size in px
- `toolTipText: string` — Tooltip text
- `badgeVisible: bool` — Show avatar badge
- `badgeValue: int` — Numeric badge value (-1 hides count)
- `badgeText: string` — Badge caption
- `badgeMaxValue: int` — Badge max before +
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### InfoBadge

Count / status / glyph badge.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/InfoBadge.qml`

```qml
InfoBadge { value: 3; severity: informational }
```

<details><summary>Properties</summary>

- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `attention: int` — Attention severity constant
- `neutral: int` — Neutral severity constant
- `severity: int` — informational | success | warning | error | attention | neutral
- `value: int` — Numeric count; shown when text/symbol are empty (clamped by maxValue)
- `text: string` — Explicit badge label (wins over value)
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `maxValue: int` — Clamp / overflow threshold for counts
- `badgeColor: color` — Badge fill color
- `textColor: color` — Badge / content text color
- `severityName: string` — Severity as string name
- `effectiveIconGlyph: string` — Resolved glyph string
- `dot: bool` — Dot
- `hideWhenEmpty: bool` — Hide when value/text empty
- `displayText: string` — Text shown to the user
- `isEmpty: bool` — True when there is no data
- `isOpen: bool` — Open / visible state

</details>

<details><summary>Methods</summary>

- `setSeverityName(name)`
- `bump()`

</details>

#### InfoBar

Inline severity banner with optional action.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/InfoBar.qml`

```qml
InfoBar {
    title: qsTr("Saved")
    message: qsTr("All changes stored.")
    severity: InfoBar.Success
}
```

<details><summary>Properties</summary>

- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `severity: int` — Status severity enum
- `title: string` — Primary title text
- `message: string` — Body / message text
- `isOpen: bool` — Open / visible state
- `closable: bool` — Shows a close affordance when true
- `isClosable: alias` — Alias of closable
- `showIcon: bool` — Show leading status icon
- `isIconVisible: alias` — Show leading status icon
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `actionText: string` — Optional action button label
- `action: alias` — Custom action slot
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `severityName: string` — Convenience string: "informational" | "success" | "warning" | "error"

</details>

<details><summary>Signals</summary>

- `closeClicked()`
- `actionClicked()`
- `closed()`
- `opened()`

</details>

<details><summary>Methods</summary>

- `open()`
- `close()`
- `setSeverityName(name)`

</details>

#### InfoBarHost

Stacks InfoBars in a host region.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/InfoBarHost.qml`

```qml
InfoBarHost { id: bars }
// bars.enqueue({ title: "Hi", severity: InfoBar.Informational })
```

<details><summary>Properties</summary>

- `maxVisible: int` — Max visible items before overflow
- `count: int` — Item count
- `openCount: int` — Open Count

</details>

<details><summary>Methods</summary>

- `closeAll()`
- `clearAll()`
- `openAll()`

</details>

#### KeyChordVisual

Renders Ctrl+K style shortcuts as KeyVisuals.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/KeyChordVisual.qml`

```qml
KeyChordVisual { shortcut: "Ctrl+Shift+P" }
```

<details><summary>Properties</summary>

- `shortcut: string` — Raw accelerator string: "Ctrl+Shift+P" or multi-stroke "Ctrl+K, Ctrl+S"
- `keys: var` — Explicit key labels; when set, overrides shortcut parsing.
- `size: string` — Diameter or box size in px
- `emphasized: bool` — Emphasized chrome
- `separator: string` — Separator
- `keySpacing: real` — Key Spacing
- `toolTipText: string` — Tooltip text
- `chordText: string` — Chord Text
- `modelData: var`
- `index: int`

</details>

#### KeyVisual

Single keyboard key chrome.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/KeyVisual.qml`

```qml
KeyVisual { keyText: "Ctrl" }
```

<details><summary>Properties</summary>

- `keyText: string` — Display label for the key (e.g. "Ctrl", "P", "Esc").
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `size: string` — "small" | "medium" | "large"
- `emphasized: bool` — Emphasized chrome
- `toolTipText: string` — Tooltip text
- `minWidth: real` — Min Width
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### LinearGauge

Horizontal/vertical track gauge with thresholds.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/LinearGauge.qml`

```qml
LinearGauge { value: 42; minimum: 0; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `trackThickness: real` — Track thickness in px
- `showValue: bool` — Show numeric value label
- `showTicks: bool` — Show tick marks
- `showMinMax: bool` — Show min/max labels
- `tickCount: int` — Major tick count
- `showThumb: bool` — Show draggable thumb
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — When true, low values map to caution/critical (battery-style).
- `horizontal: bool` — Horizontal orientation when true
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`

</details>

<details><summary>Methods</summary>

- `clampSnap(v)`
- `setValue(v)`
- `setValueFromNorm(n)`

</details>

#### LineChart

Multi-series line/area chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/LineChart.qml`

```qml
LineChart { values: [1, 4, 2, 6] }
```

<details><summary>Properties</summary>

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `showGrid: bool` — Show chart grid
- `showArea: bool` — Fill area under the line
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `maxPoints: int` — Max points before LOD kicks in
- `lodFactor: real` — Level-of-detail downsample factor
- `autoLod: bool` — Auto-enable LOD for large series
- `strokeWidth: real` — Stroke thickness in px
- `gridColor: color` — Grid line color
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `hoverX: real` — Hover X
- `hoverY: real` — Hover Y
- `hoverLineX: real` — Hover crosshair X
- `hoverMarkers: var` — Hover marker descriptors
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `sourcePointCount: int` — LOD diagnostics
- `drawnPointCount: int` — Points drawn after LOD
- `isEmpty: bool` — True when there is no data
- `plotL: real` — Cache last paint metrics for hover hit-testing
- `plotT: real` — Plot top inset

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `sourcePointCountEstimate()`
- `invalidateLod()`
- `ensureLod(budget)`
- `requestRedraw()`
- `onDataChanged()`
- `clearHover()`

</details>

#### ListTile

List row: leading, title, subtitle, trailing.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ListTile.qml`

```qml
ListTile {
    title: qsTr("Item")
    subtitle: qsTr("Detail")
    symbol: FluentIcons.Document
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `description: alias` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `leading: alias` — Leading content slot
- `trailing: alias` — Trailing slot
- `showChevron: bool` — Show trailing chevron
- `isSelected: bool` — Selected state
- `effectiveGlyph: string` — Resolved glyph string

</details>

#### MenuFlyout

Elevated Menu with showAt / isOpen helpers.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MenuFlyout.qml`

```qml
MenuFlyout {
    MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }
}
```

<details><summary>Properties</summary>

- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isOpen: bool` — Open / visible state
- `title: string` — Primary title text

</details>

<details><summary>Methods</summary>

- `openMenu()`
- `closeMenu()`
- `showAt(targetItem, offsetX, offsetY)`
- `hide()`

</details>

#### MenuFlyoutHeader

Non-interactive MenuFlyout section header.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MenuFlyoutHeader.qml`

```qml
MenuFlyoutHeader { text: qsTr("Recent") }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### MenuFlyoutItem

Menu row with glyph and accelerator text.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MenuFlyoutItem.qml`

```qml
MenuFlyoutItem { text: qsTr("Paste"); keyboardAcceleratorText: "Ctrl+V" }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `keyboardAcceleratorText: string` — Accelerator caption (Ctrl+C)
- `keyVisualAccelerator: bool` — When true, render accelerator as KeyChordVisual chrome instead of plain text.
- `iconColor: color` — Icon color
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### MenuFlyoutSeparator

MenuFlyout divider.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MenuFlyoutSeparator.qml`

```qml
MenuFlyoutSeparator { }
```

#### MenuStatusWindow

TitleBar + MenuBar + content + StatusBar shell.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MenuStatusWindow.qml`

```qml
MenuStatusWindow {
    menusInTitleBar: true
    Menu { title: qsTr("File") }
    content: Label { text: "Body" }
    statusText: qsTr("Ready")
}
```

<details><summary>Properties</summary>

- `menus: alias` — Declare Menu { } children here
- `statusText: alias` — StatusBar left text
- `statusBar: alias` — StatusBar instance
- `shellMenuBar: alias` — Shell MenuBar instance
- `content: alias` — Main client area
- `statusProgress: alias` — StatusBar progress 0..1
- `statusProgressIndeterminate: alias` — StatusBar indeterminate progress
- `statusCenter: alias` — StatusBar center slot
- `statusRight: alias` — StatusBar right slot
- `menusInTitleBar: bool` — Embed MenuBar in the title chrome instead of a strip below it

</details>

<details><summary>Methods</summary>

- `addMenu(menu)`
- `clearMenus()`
- `onImplicitWidthChanged()`
- `onCountChanged()`

</details>

#### MetadataControl

Stacked or flowed label/value metadata block.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MetadataControl.qml`

```qml
MetadataControl {
    MetadataItem { label: qsTr("Author"); value: "Ada" }
}
```

<details><summary>Properties</summary>

- `items: alias` — Item list / children model
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `itemSpacing: real` — Item Spacing
- `header: string` — Header label above the control
- `paddingEdges: int` — Edge paddings

</details>

<details><summary>Methods</summary>

- `syncChildren()`

</details>

#### MetadataItem

One label/value pair for MetadataControl.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MetadataItem.qml`

```qml
MetadataItem { label: qsTr("Size"); value: "12 KB" }
```

<details><summary>Properties</summary>

- `label: string` — Field label
- `value: string` — Current value
- `secondary: string` — Secondary value line
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `valueColor: color` — Value Color
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### MeterBar

Multi-segment stacked meter (e.g. disk usage).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MeterBar.qml`

```qml
MeterBar { segments: [{ value: 40, color: Theme.accent }] }
```

<details><summary>Properties</summary>

- `segments: var` — Meter / stacked segment descriptors
- `maximum: real` — Maximum value
- `trackHeight: real` — Meter track height
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `hoverIndex: int` — Hovered item index
- `header: string` — Header label above the control
- `showRemaining: bool` — Show remaining segment
- `remainingLabel: string` — Label for remaining segment
- `remainingColor: color` — Color for remaining segment
- `showTotal: bool` — Show total column
- `total: real` — Sum of segment values
- `remaining: real` — Remaining
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `segmentClicked(int index, real value)`

</details>

#### MultiSelectComboBox

Combo that keeps the popup open for multi-select.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/MultiSelectComboBox.qml`

```qml
MultiSelectComboBox { model: items; selectedIndexes: [0, 2] }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `placeholderText: string` — Placeholder when empty
- `header: string` — Header label above the control
- `menuOpen: bool` — Menu currently open
- `isOpen: alias` — Open / visible state
- `selectedItems: var` — Selected Items
- `displayText: string` — Text shown to the user

</details>

<details><summary>Signals</summary>

- `selectionChanged(var selected)`

</details>

<details><summary>Methods</summary>

- `toggleAt(index)`
- `ensureObjectModel()`
- `selectAll()`
- `clearSelection()`

</details>

#### NavigationView

WinUI NavigationView with pane modes and page stack.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/NavigationView.qml`

```qml
NavigationView {
    anchors.fill: parent
    paneDisplayMode: "auto"
    model: navModel
    isPaneSearchEnabled: true
    pageModule: "MyApp"
}
```

<details><summary>Properties</summary>

- `model: var` — Navigation items: [{ type, key, title, icon|symbol, children?, badge?, badgeValue? }]
- `currentIndex: int` — Selected index
- `paneOpen: bool` — Expanded pane when true (left / leftMinimal); compact modes force false
- `paneWidth: real` — Expanded pane width
- `paneCompactWidth: real` — Compact pane width
- `headerText: string` — Pane header title text
- `footerText: string` — Footer row label
- `footerSymbol: var` — Footer FluentIcons symbol
- `footerIcon: string` — Footer glyph string fallback
- `footerComponent: string` — Page component name loaded for the footer row (e.g. "SettingsPage")
- `pageModule: string` — QML import URI used to resolve page components
- `footerSelected: bool` — True when footer row is selected
- `paneDisplayMode: string` — WinUI PaneDisplayMode: left | leftCompact | leftMinimal | top | auto
- `autoCompactThreshold: real` — Width below which auto mode uses leftCompact
- `isBackButtonVisible: bool` — Show back button
- `isBackEnabled: bool` — Enable back button
- `isPaneSearchEnabled: bool` — Shows SearchBox at the top of the pane when open
- `paneSearchText: string` — Pane SearchBox text
- `paneSearchModel: var` — Suggestion model for pane SearchBox: [{ title, key?, component? }]
- `paneHeader: alias` — Custom pane header slot
- `paneFooter: alias` — Custom pane footer slot
- `isReorderable: bool` — Drag rows to reorder top-level model entries
- `hostContent: bool` — Shell host: show `content:` instead of StackView page loading (NavigationWindow).
- `content: alias` — Content slot / children host
- `effectiveFooterIcon: string` — Resolved footer icon
- `resolvedPaneMode: string` — Effective pane mode after auto
- `expandedMap: var` — groupKey -> bool; missing means expanded
- `currentKey: string` — Selected nav key (supports "group/0" child paths)

</details>

<details><summary>Signals</summary>

- `footerClicked()`
- `itemClicked(int index)`
- `pageOpened(string name)`
- `backRequested()`
- `paneSearchActivated(string text)`
- `paneSearchTextEdited(string text)`
- `modelReordered(var model)`

</details>

<details><summary>Methods</summary>

- `moveNavItem(fromIndex, toIndex)`
- `isGroupExpanded(key)`
- `rebuildNavModel()`
- `setGroupExpanded(key, expanded)`
- `selectionAnchorItem()`

</details>

#### NavigationWindow

ShellWindow hosting NavigationView + content.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/NavigationWindow.qml`

```qml
NavigationWindow {
    title: qsTr("App")
    paneDisplayMode: "left"
    navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
    content: Label { text: "Hello" }
}
```

<details><summary>Properties</summary>

- `paneOpen: alias` — Navigation pane expanded
- `paneWidth: alias` — Expanded pane width
- `paneHeaderText: alias` — NavigationWindow pane header text
- `paneDisplayMode: alias` — left | leftCompact | leftMinimal | top | auto
- `currentKey: alias` — Selected navigation key
- `content: alias` — Content slot / children host
- `navModel: alias` — NavigationView model
- `isBackEnabled: alias` — Enable back button
- `isPaneBackButtonVisible: alias` — Show back in the pane
- `isPaneSearchEnabled: alias` — Show pane SearchBox
- `paneSearchText: alias` — Pane SearchBox text
- `paneSearchModel: alias` — Pane search suggestion model
- `paneHeader: alias` — Custom pane header slot
- `paneFooter: alias` — Custom pane footer slot
- `footerText: alias` — Footer row label
- `footerSymbol: alias` — Footer FluentIcons symbol
- `footerIcon: alias` — Footer glyph string fallback
- `footerComponent: alias` — Footer page component

</details>

<details><summary>Signals</summary>

- `navActivated(var item)`
- `footerClicked()`
- `paneSearchActivated(string text)`

</details>

<details><summary>Methods</summary>

- `onBackRequested()`
- `onFooterClicked()`
- `onPaneSearchActivated(text)`
- `clearNav()`
- `addNavItem(item)`
- `addNavGroup(group)`
- `selectNavKey(key)`

</details>

#### NumberBox

Numeric spin/edit with validation.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/NumberBox.qml`

```qml
NumberBox { value: 10; minimum: 0; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `largeChange: real` — WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl
- `decimals: int` — Decimals
- `prefix: string` — Prefix
- `suffix: string` — Suffix
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `placeholderText: string` — Placeholder when empty
- `inputInvalid: bool` — Input Invalid
- `spinButtonPlacementMode: string` — WinUI SpinButtonPlacementMode: "inline" | "compact" | "hidden"
- `validationMode: string` — WinUI ValidationMode: "invalidInputOverValue" | "disabled"
- `acceptWheel: bool` — Accept Wheel
- `hasError: bool` — True when validation failed

</details>

<details><summary>Signals</summary>

- `valueModified()`

</details>

<details><summary>Methods</summary>

- `clamp(v)`
- `format(v)`
- `bump(delta)`
- `flashInvalid()`
- `focusField()`
- `commitText()`

</details>

#### PasswordBox

Password field with reveal toggle.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/PasswordBox.qml`

```qml
PasswordBox { placeholderText: qsTr("Password") }
```

<details><summary>Properties</summary>

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `maximumLength: alias` — Hard maximum text length
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `clearButtonVisible: bool` — Show clear affordance
- `passwordRevealMode: string` — WinUI PasswordRevealMode: peek | hidden | visible
- `revealPassword: bool` — Reveal Password
- `revealButtonVisible: bool` — Reveal Button Visible
- `echoMode: alias` — TextField echo mode
- `field: alias` — Inner text field
- `hasError: bool` — True when validation failed

</details>

<details><summary>Signals</summary>

- `accepted()`
- `cleared()`

</details>

<details><summary>Methods</summary>

- `clear()`
- `focusField()`

</details>

#### PersonPicture

Avatar from image or initials.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/PersonPicture.qml`

```qml
PersonPicture { displayName: "Ada"; size: 48 }
```

<details><summary>Properties</summary>

- `displayName: string` — Person / avatar display name
- `imageSource: url` — Image URL
- `size: real` — Diameter or box size in px
- `profileColor: color` — Fallback avatar fill
- `badgeVisible: bool` — Show avatar badge
- `badgeColor: color` — Badge fill color
- `badgeSymbol: var` — Badge Symbol
- `badgeGlyph: string` — Badge Glyph
- `badgeSeverity: int` — Badge severity
- `badgeValue: int` — WinUI-style count / text overlay (takes precedence over glyph when set)
- `badgeText: string` — Badge caption
- `badgeMaxValue: int` — Badge max before +
- `selected: bool` — Selected state
- `initials: string` — Initials

</details>

#### PieChart

Pie chart with legend.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/PieChart.qml`

```qml
PieChart { slices: [{ value: 1, label: "A" }] }
```

<details><summary>Properties</summary>

- `slices: var` — Pie/donut slice descriptors
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `startAngle: real` — Arc start angle in degrees
- `padAngle: real` — Padding angle between pie slices
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `total: real` — Sum of segment values
- `cx: real` — Center X
- `cy: real` — Center Y
- `radius: real` — Corner radius
- `arcs: var` — Arc path descriptors

</details>

<details><summary>Signals</summary>

- `sliceClicked(int index, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`

</details>

#### PipsPager

Dot pager for carousels.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/PipsPager.qml`

```qml
PipsPager { count: 5; currentIndex: 2 }
```

<details><summary>Properties</summary>

- `count: int` — Item count
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `wrap: bool` — Wrap children to next line
- `previousButtonVisibility: string` — WinUI ButtonVisibility: "visible" | "visibleOnPointerOver" | "collapsed"
- `nextButtonVisibility: string` — Next Button Visibility
- `glyph: string` — Fluent glyph drawn in the button
- `index: int`

</details>

<details><summary>Signals</summary>

- `currentIndexEdited(int index)`
- `selectionChanged(int index)`

</details>

<details><summary>Methods</summary>

- `goNext()`
- `goPrevious()`
- `select(index)`

</details>

#### Pivot

Header tabs with sliding underline and pages.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Pivot.qml`

```qml
Pivot { model: ["Overview", "Details"] }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `keyboardNavigationEnabled: bool` — Keyboard Navigation Enabled
- `modelData: var`
- `index: int`
- `hasPage: bool` — Has Page

</details>

<details><summary>Signals</summary>

- `currentIndexChangedByUser(int index)`
- `selectionChanged(int index)`

</details>

<details><summary>Methods</summary>

- `selectIndex(index)`

</details>

#### ProgressButton

Button with inline determinate/indeterminate fill.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ProgressButton.qml`

```qml
ProgressButton { text: qsTr("Upload"); progress: 0.4 }
```

<details><summary>Properties</summary>

- `progress: real` — 0..1 progress (determinate)
- `indeterminate: bool` — Show indeterminate animation when true
- `isIndeterminate: alias` — Alias of indeterminate
- `showProgress: bool` — Show progress indicator
- `showPercentage: bool` — Show Percentage
- `progressState: string` — idle | progressing | completed | error
- `progressingText: string` — Progressing Text
- `completedText: string` — Completed Text
- `errorText: string` — Error Text
- `percentage: real` — Value as 0..100 percentage
- `displayText: string` — Text shown to the user
- `innerRadius: real` — Inner Radius
- `innerWidth: real` — Inner Width

</details>

<details><summary>Signals</summary>

- `progressCompleted()`
- `progressFailed()`

</details>

<details><summary>Methods</summary>

- `setProgress(value)`
- `reset()`
- `start(indeterminateMode)`
- `complete()`
- `fail()`

</details>

#### ProgressRing

Circular progress / busy ring.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ProgressRing.qml`

```qml
ProgressRing { indeterminate: true }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `indeterminate: bool` — Show indeterminate animation when true
- `isActive: bool` — WinUI-style: Active sweeps; Paused holds a partial arc without spinning
- `strokeWidth: real` — Stroke thickness in px
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `showValue: bool` — Show numeric value label
- `valueLabel: string` — Optional value caption
- `size: real` — Diameter or box size in px
- `spinning: bool` — True while indeterminate ring spins
- `progressSweep: real` — Determinate arc sweep degrees
- `formattedValue: string` — Formatted value string
- `radius: real` — Corner radius
- `spinAngle: real` — Indeterminate spin angle
- `animatedSweep: real` — Animated Sweep

</details>

#### RadarChart

Radar / spider chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RadarChart.qml`

```qml
RadarChart { values: [3, 5, 2, 4]; axes: ["A","B","C","D"] }
```

<details><summary>Properties</summary>

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `axes: var` — Axis labels
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `levels: int` — Levels
- `filled: bool` — Fill under line / area
- `showLabels: bool` — Show item labels
- `animated: bool` — Play enter / reveal animation
- `interactive: bool` — Enable hover / click interaction
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverSeries: int` — Hovered series index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`
- `clearHover()`
- `point(i, norm)`

</details>

#### RadialGauge

Circular gauge with needle and zones.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RadialGauge.qml`

```qml
RadialGauge { value: 72; minimum: 0; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `strokeWidth: real` — Stroke thickness in px
- `showValue: bool` — Show numeric value label
- `unit: string` — Value unit label (%, rpm, …)
- `title: string` — Primary title text
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `tickCount: int` — Major tick count
- `trackColor: color` — Track / remaining color
- `fillColor: color` — Primary fill / progress color
- `showNeedle: bool` — Show needle indicator
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `normalized: real` — Normalized
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `radius: real` — Corner radius

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`

</details>

<details><summary>Methods</summary>

- `setValue(v)`
- `setValueFromNorm(n)`
- `normFromPoint(px, py)`

</details>

#### RadioButtons

Grouped RadioButton list from a model.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RadioButtons.qml`

```qml
RadioButtons { header: qsTr("Choice"); model: ["A", "B"] }
```

<details><summary>Properties</summary>

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `horizontal: bool` — Horizontal orientation when true
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `selected(int index, var item)`
- `selectionChanged(int index)`

</details>

<details><summary>Methods</summary>

- `select(index)`

</details>

#### RadioMenuFlyoutItem

Exclusive radio MenuFlyout item.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RadioMenuFlyoutItem.qml`

```qml
RadioMenuFlyoutItem { text: qsTr("Option") }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `keyboardAcceleratorText: string` — Accelerator caption (Ctrl+C)
- `keyVisualAccelerator: bool` — Show KeyVisual for accelerator
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### RatingControl

Star rating; stepSize supports halves.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RatingControl.qml`

```qml
RatingControl { value: 3.5; stepSize: 0.5 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `placeholderValue: real` — Shown when value unset
- `maxRating: int` — Maximum star count
- `readOnly: bool` — Read-only when true
- `isReadOnly: alias` — Alias of readOnly
- `isClearEnabled: bool` — Allow clearing the rating
- `stepSize: real` — 1 = whole, 0.5 = half, 0.1 / 0.25 = fine-grained mouse pick
- `previewEnabled: bool` — Preview value on hover
- `previewValue: real` — Hovered preview value
- `caption: string` — Caption under / beside the value
- `index: int`
- `fill: real` — Fill
- `isPlaceholder: bool` — Is Placeholder
- `didDrag: bool` — Did Drag
- `pressValue: real` — Press Value

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`

</details>

<details><summary>Methods</summary>

- `clampValue(v)`
- `valueFromPos(x)`
- `commitValue(next)`

</details>

#### RefreshContainer

Pull-to-refresh host for flickable content.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RefreshContainer.qml`

```qml
RefreshContainer {
    onRefreshRequested: reload()
    ListView { /* … */ }
}
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `contentWidth: alias` — Flickable content width
- `contentHeight: alias` — Flickable content height
- `contentX: alias` — Flickable content X
- `contentY: alias` — Flickable content Y
- `flickable: alias` — Inner Flickable
- `refreshing: bool` — True while a refresh is in progress
- `isRefreshing: alias` — True while refreshing
- `pullToRefreshEnabled: bool` — Enable pull-to-refresh gesture
- `isEnabled: alias` — Is Enabled
- `pullThreshold: real` — Pull distance before refresh fires
- `refreshText: string` — Text shown while pulling
- `refreshingText: string` — Text shown while refreshing
- `pullText: string` — Pull Text
- `spinAngle: real` — Indeterminate spin angle

</details>

<details><summary>Signals</summary>

- `refreshRequested()`

</details>

<details><summary>Methods</summary>

- `endRefresh()`
- `beginRefresh()`

</details>

#### RelativePanel

Constraint-based relative layout.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/RelativePanel.qml`

```qml
RelativePanel {
    // children with RelativePanel.* attached props
}
```

<details><summary>Properties</summary>

- `panelSpacing: real` — Panel Spacing
- `paddingEdges: int` — Edge paddings

</details>

<details><summary>Methods</summary>

- `isPanel(ref)`
- `leftEdge(ref)`
- `rightEdge(ref)`
- `topEdge(ref)`
- `bottomEdge(ref)`
- `centerX(ref)`
- `centerY(ref)`
- `preferredWidth(item)`
- `preferredHeight(item)`
- `has(item, name)`
- `relayout()`

</details>

#### ScatterChart

Scatter / bubble chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ScatterChart.qml`

```qml
ScatterChart { points: [{ x: 1, y: 2 }] }
```

<details><summary>Properties</summary>

- `points: var` — Scatter points
- `values: var` — Numeric values array
- `minimumX: real` — X-axis minimum
- `maximumX: real` — X-axis maximum
- `minimumY: real` — Y-axis minimum
- `maximumY: real` — Y-axis maximum
- `pointRadius: real` — Scatter point radius
- `showGrid: bool` — Show chart grid
- `showTrendLine: bool` — Show trend line
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `maxPoints: int` — Max points before LOD kicks in
- `autoLod: bool` — Auto-enable LOD for large series
- `lodFactor: real` — Level-of-detail downsample factor
- `gridColor: color` — Grid line color
- `pointColor: color` — Point Color
- `trendColor: color` — Trend Color
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `sourcePointCount: int` — Raw point count before LOD
- `drawnPointCount: int` — Points drawn after LOD
- `isEmpty: bool` — True when there is no data
- `screenPts: var` — Screen Pts
- `padL: real` — Pad L

</details>

<details><summary>Signals</summary>

- `pointClicked(int index, real x, real y)`

</details>

<details><summary>Methods</summary>

- `invalidateLod()`
- `ensureLod(binsX, binsY)`
- `playReveal()`
- `requestRedraw()`
- `clearHover()`
- `onDataChanged()`

</details>

#### SearchBox

Search field with suggestion list.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SearchBox.qml`

```qml
SearchBox {
    placeholderText: qsTr("Search")
    model: suggestions
    onSuggestionChosen: (item) => open(item)
}
```

<details><summary>Properties</summary>

- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `clearButtonVisible: bool` — Show clear affordance
- `symbol: var` — FluentIcons symbol or leave empty to use queryIcon glyph
- `queryIcon: string` — Search glyph fallback string
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `model: var` — Full suggestion catalog; filtered into suggestionModel while typing
- `suggestionModel: var` — Filtered suggestion rows
- `updateTextOnSelect: bool` — When true, choosing a suggestion writes display text into the field
- `textMemberPath: string` — Object field used as display text (fallback: title | text | name)
- `isSuggestionListOpen: bool` — Suggestion popup open state
- `effectiveQueryIcon: string` — Resolved search glyph

</details>

<details><summary>Signals</summary>

- `accepted(string text)`
- `querySubmitted(string query)`
- `suggestionChosen(var item)`
- `cleared()`

</details>

<details><summary>Methods</summary>

- `focusField()`
- `displayTextFor(item)`
- `refreshSuggestions()`
- `clear()`
- `submitQuery()`

</details>

#### SegmentedControl

Mutually exclusive segment buttons.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SegmentedControl.qml`

```qml
SegmentedControl {
    model: ["Day", "Week", "Month"]
    currentIndex: 0
}
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `stretch: bool` — Stretch factor / stretch pip
- `equalWidth: bool` — Equal Width
- `modelData: var`
- `index: int`
- `segmentIndex: int` — Active segment index

</details>

<details><summary>Signals</summary>

- `selected(int index, var item)`
- `selectionChanged(int index)`

</details>

<details><summary>Methods</summary>

- `select(index)`
- `itemAt(index)`
- `moveIndicator(instant)`
- `syncIndicatorIfIdle()`
- `nextEnabled(from, delta)`

</details>

#### SegmentedGauge

Segmented progress / capacity gauge.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SegmentedGauge.qml`

```qml
SegmentedGauge { value: 3; maximum: 5 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `segmentCount: int` — Number of gauge segments
- `gapDegrees: real` — Gap between segments in degrees
- `strokeWidth: real` — Stroke thickness in px
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `showValue: bool` — Show numeric value label
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `startAngle: real` — Arc start angle in degrees
- `fillMode: string` — discrete | partial — partial fills the leading segment proportionally
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `filledExact: real` — Filled Exact
- `filledSegments: int` — Filled Segments

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`
- `segmentClicked(int index)`

</details>

<details><summary>Methods</summary>

- `clampSnap(v)`
- `setValue(v)`
- `setSegment(index)`

</details>

#### SelectorBar

Compact horizontal item selector.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SelectorBar.qml`

```qml
SelectorBar { model: ["All", "Unread"]; currentIndex: 0 }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `selectionStyle: string` — "pill" (filled accent) or "underline"
- `modelData: var`
- `index: int`
- `segmentIndex: int` — Active segment index
- `contentRow: alias` — Content Row

</details>

<details><summary>Signals</summary>

- `selected(int index, var item)`

</details>

<details><summary>Methods</summary>

- `select(index)`
- `itemAt(index)`
- `targetGeometry(index)`
- `moveIndicator(instant)`
- `syncIndicatorIfIdle()`

</details>

#### SettingsCard

Settings row: icon, title, description, action.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SettingsCard.qml`

```qml
SettingsCard {
    title: qsTr("Dark mode")
    action: Switch { checked: Theme.dark; onToggled: Theme.dark = checked }
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerIcon: var` — Header icon glyph
- `action: alias` — Custom action slot
- `content: alias` — Content slot / children host
- `interactive: bool` — Enable hover / click interaction
- `showChevron: bool` — Show trailing chevron
- `effectiveHeaderIcon: string` — Resolved header icon

</details>

<details><summary>Signals</summary>

- `clicked()`

</details>

#### SettingsExpander

Expandable settings group.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SettingsExpander.qml`

```qml
SettingsExpander {
    title: qsTr("Advanced")
    SettingsCard { title: qsTr("Option") }
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerIcon: var` — Header icon glyph
- `expanded: bool` — Expanded state
- `isExpanded: alias` — Alias of expanded
- `expandDirection: string` — WinUI ExpandDirection: down | up
- `action: alias` — Custom action slot
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

</details>

<details><summary>Signals</summary>

- `expanding()`
- `collapsing()`

</details>

#### ShellWindow

Independent ApplicationWindow + WindowChrome host.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ShellWindow.qml`

```qml
ShellWindow {
    title: qsTr("App")
    symbol: FluentIcons.Home
}
```

<details><summary>Properties</summary>

- `subtitle: alias` — Secondary subtitle text
- `symbol: alias` — FluentIcons symbol (preferred over iconGlyph)
- `chrome: alias` — WindowChrome / PlatformTitleBar host
- `showPaneToggle: bool` — Show navigation pane toggle
- `searchEnabled: alias` — Enable title-bar search
- `isBackButtonVisible: alias` — Show back button
- `isBackButtonEnabled: alias` — Enable back button
- `leftHeader: alias` — WinUI LeftHeader slot
- `titleBarContent: alias` — Extra title-bar middle content (e.g. MenuBar when menusInTitleBar)
- `rightHeader: alias` — WinUI RightHeader slot
- `searchText: alias` — Title-bar search field text
- `searchModel: alias` — Title-bar search suggestions
- `backdrop: int` — WindowHelper.Backdrop*
- `preferredHeightOption: int` — WindowHelper.TitleBarHeightStandard | TitleBarHeightTall
- `presenter: int` — WindowHelper.Presenter*
- `paradigm: int` — WindowHelper.Paradigm*
- `isAlwaysOnTop: bool` — Keep window above others
- `extendsContentIntoTitleBar: bool` — Custom frame / extend content
- `showCaptionButtons: bool` — Show min/max/close
- `showMinimize: bool` — Show minimize caption button
- `showMaximize: bool` — Show maximize caption button
- `showClose: bool` — Show close caption button
- `captionButtonBackground: color` — AppWindowTitleBar-style caption colors (empty = Theme defaults).
- `captionButtonHover: color` — Caption button hover fill
- `captionButtonPressed: color` — Caption button pressed fill
- `captionButtonForeground: color` — Caption button glyph color
- `captionCloseHover: color` — Close button hover fill
- `captionClosePressed: color` — Close button pressed fill

</details>

<details><summary>Signals</summary>

- `paneToggleRequested()`
- `backRequested()`
- `searchActivated(var item)`
- `searchTextEdited(string text)`

</details>

#### Shimmer

Skeleton shimmer placeholder.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Shimmer.qml`

```qml
Shimmer { width: 200; height: 12 }
```

<details><summary>Properties</summary>

- `cornerRadius: real` — Corner radius
- `active: bool` — Active state
- `isActive: alias` — Active / animating state
- `shape: int` — Shape
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `baseColor: color` — Base Color
- `sheenColor: color` — Sheen Color
- `direction: int` — Qt.Horizontal | Qt.Vertical

</details>

#### Sparkline

Inline mini line chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Sparkline.qml`

```qml
Sparkline { values: [1, 3, 2, 5, 4] }
```

<details><summary>Properties</summary>

- `values: var` — Numeric values array
- `strokeColor: color` — Stroke color
- `fillColor: color` — Primary fill / progress color
- `strokeWidth: real` — Stroke thickness in px
- `filled: bool` — Fill under line / area
- `showEndMarker: bool` — Show end-point marker
- `animated: bool` — Play enter / reveal animation
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `revealProgress: real` — 0..1 reveal animation progress
- `caption: string` — Caption under / beside the value
- `showDelta: bool` — Show delta vs first point
- `lastValue: real` — Last Value
- `firstValue: real` — First Value
- `delta: real` — Delta
- `deltaPositive: bool` — Delta Positive

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `X(i)`
- `Y(v)`

</details>

#### SplitButton

Primary action + chevron menu.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SplitButton.qml`

```qml
SplitButton {
    text: qsTr("Open")
    MenuFlyoutItem { text: qsTr("Open with…") }
}
```

<details><summary>Properties</summary>

- `menu: alias` — Attached / owned Menu
- `menuData: alias` — Menu children slot
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `flyoutPlacement: int` — MenuFlyout placement
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `isOpen: alias` — Open / visible state
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `accented: bool` — Use accent chrome
- `anyHovered: bool` — True if any child is hovered
- `anyDown: bool` — True if any child is pressed

</details>

<details><summary>Signals</summary>

- `primaryClicked()`

</details>

<details><summary>Methods</summary>

- `showMenu()`
- `closeMenu()`

</details>

#### StackedBarChart

Stacked bar chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/StackedBarChart.qml`

```qml
StackedBarChart { series: [{ values: [1, 2] }] }
```

<details><summary>Properties</summary>

- `series: var` — Chart series array
- `categories: var` — Category labels for bars
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `barRadius: real` — Bar corner radius
- `barGap: real` — Gap between bars
- `showBaseline: bool` — Show zero baseline
- `showLegend: bool` — Show chart legend
- `showCategoryLabels: bool` — Show category axis labels
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverCategory: int` — Hover Category
- `hoverSeries: int` — Hovered series index
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `padL: real` — Left padding
- `padB: real` — Bottom padding
- `catCount: int` — Cat Count

</details>

<details><summary>Signals</summary>

- `categoryClicked(int categoryIndex)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`

</details>

#### StackPanel

Simple stack layout (orientation + spacing).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/StackPanel.qml`

```qml
StackPanel { orientation: Qt.Vertical }
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `paddingEdges: int` — Edge paddings
- `alignment: int` — Cross-axis alignment: Horizontal → vertical align; Vertical → horizontal align
- `layoutDirection: int` — Qt layout direction
- `stretchChildren: bool` — When true (default for Vertical), stretch children along the cross axis to host size
- `childCount: int` — Number of children

</details>

<details><summary>Methods</summary>

- `childWidth(c)`
- `childHeight(c)`
- `relayout()`

</details>

#### StatusBar

Window status strip with progress and slots.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/StatusBar.qml`

```qml
StatusBar {
    text: qsTr("Ready")
    progress: 0.4
}
```

<details><summary>Properties</summary>

- `text: string` — Display / input text
- `leftContent: alias` — Left Content
- `centerContent: alias` — Center Content
- `content: alias` — Content slot / children host
- `rightContent: alias` — Right Content
- `progress: real` — 0..1 shows determinate bar; <0 hides; NaN-safe. Set indeterminate for busy.
- `progressIndeterminate: bool` — Progress Indeterminate

</details>

#### StatusDot

Colored status indicator dot.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/StatusDot.qml`

```qml
StatusDot { severity: success }
```

<details><summary>Properties</summary>

- `offline: int` — Offline status constant
- `available: int` — Available status constant
- `away: int` — Away status constant
- `busy: int` — Busy status constant
- `unknown: int` — Unknown status constant
- `status: int` — Current status enum
- `pulse: bool` — Animate a pulse when true
- `size: real` — Diameter or box size in px
- `label: string` — Field label
- `showLabel: bool` — Show text label beside the dot
- `statusName: string` — Status Name
- `statusColor: color` — Status Color

</details>

#### StepBar

Horizontal step / wizard progress.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/StepBar.qml`

```qml
StepBar { model: ["Cart", "Ship", "Pay"]; currentIndex: 1 }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `orientation: string` — horizontal | vertical
- `isInteractive: bool` — Alias of interactive
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `stepActivated(int index)`

</details>

<details><summary>Methods</summary>

- `next()`
- `previous()`
- `goTo(index)`

</details>

#### SwipeAction

Action revealed by SwipeControl.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SwipeAction.qml`

```qml
SwipeAction { text: qsTr("Delete"); onTriggered: remove() }
```

<details><summary>Properties</summary>

- `text: string` — Display / input text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `color: color` — Color
- `textColor: color` — Badge / content text color
- `leading: bool` — Leading content slot
- `effectiveGlyph: string` — Resolved glyph string

</details>

<details><summary>Signals</summary>

- `clicked()`

</details>

#### SwipeControl

Swipe-to-reveal actions on content.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SwipeControl.qml`

```qml
SwipeControl {
    SwipeAction { text: qsTr("Delete") }
    ListTile { title: qsTr("Row") }
}
```

<details><summary>Properties</summary>

- `closed: int` — Swipe content closed
- `leftOpen: int` — Left actions revealed
- `rightOpen: int` — Right actions revealed
- `content: alias` — Content slot / children host
- `leftActions: alias` — Actions on the left
- `rightActions: alias` — Actions on the right
- `actionWidth: real` — Width of each swipe action
- `revealThreshold: real` — Drag distance to snap open
- `isOpen: bool` — Open / visible state
- `openMode: int` — single | multiple reveal mode
- `maxLeftReveal: real` — Max Left Reveal
- `maxRightReveal: real` — Max Right Reveal

</details>

<details><summary>Signals</summary>

- `opened(int mode)`
- `closed()`

</details>

<details><summary>Methods</summary>

- `close()`
- `openLeft()`
- `openRight()`

</details>

#### SwitchCase

Case child for SwitchPresenter.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SwitchCase.qml`

```qml
SwitchCase { value: "a"; Label { text: "A" } }
```

<details><summary>Properties</summary>

- `value: var` — Current value
- `active: bool` — Active state
- `contentData: alias` — Default children / content slot

</details>

#### SwitchPresenter

Shows the SwitchCase matching value.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/SwitchPresenter.qml`

```qml
SwitchPresenter {
    value: mode
    SwitchCase { value: "a"; Label { text: "A" } }
}
```

<details><summary>Properties</summary>

- `value: var` — Current value
- `animated: bool` — Play enter / reveal animation
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `cases: alias` — Cases

</details>

<details><summary>Signals</summary>

- `caseChanged(var value, int index)`

</details>

<details><summary>Methods</summary>

- `valuesEqual(a, b)`
- `select(index)`
- `applyValue()`
- `setCaseActive(ch, on)`
- `syncWidths()`

</details>

#### TabView

Closeable / reorderable tabs.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TabView.qml`

```qml
TabView {
    model: tabs
    onCloseRequested: (index) => remove(index)
}
```

<details><summary>Properties</summary>

- `model: var` — model items: { title, content, icon? } or string title with empty content
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `closable: bool` — Shows a close affordance when true
- `isClosable: alias` — Alias of closable
- `tabsReorderable: bool` — Allow dragging tabs to reorder
- `canReorderTabs: alias` — Alias of tabsReorderable
- `tabWidthMode: string` — Tab width mode
- `isAddTabButtonVisible: bool` — Show add-tab button
- `tabCount: int` — Tab Count
- `modelData: var`
- `index: int`
- `tabIndex: int` — Tab Index
- `dragActive: bool` — Drag Active

</details>

<details><summary>Signals</summary>

- `tabCloseRequested(int index)`
- `currentIndexChangedByUser(int index)`
- `selectionChanged(int index)`
- `tabMoved(int from, int to)`
- `addTabButtonClicked()`

</details>

<details><summary>Methods</summary>

- `addTab(item)`
- `closeTab(index)`
- `moveTab(from, to)`
- `tabIndexAtContentX(x)`
- `tabItemAt(index)`

</details>

#### TeachingTip

Anchored tip with title, subtitle, and actions.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TeachingTip.qml`

```qml
TeachingTip { target: btn; title: qsTr("Tip"); subtitle: qsTr("Hint") }
```

<details><summary>Properties</summary>

- `target: Item` — Anchor item for placement
- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `actionText: string` — Optional action button label
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `isOpen: bool` — Open / visible state
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isCloseButtonVisible: bool` — Alias of closable
- `preferredPlacement: int` — Preferred flyout placement
- `effectivePlacement: int` — Effective Placement
- `heroContent: alias` — Hero Content
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

<details><summary>Signals</summary>

- `actionClicked()`
- `closedByUser()`

</details>

<details><summary>Methods</summary>

- `reanchor()`

</details>

#### TextBlock

Fluent typography styles (title, body, caption…).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TextBlock.qml`

```qml
TextBlock { text: qsTr("Title"); style: title }
```

<details><summary>Properties</summary>

- `caption: int` — Caption under / beside the value
- `body: int` — Body style
- `bodyStrong: int` — Body strong style
- `subtitle: int` — Secondary subtitle text
- `title: int` — Primary title text
- `titleLarge: int` — Title large style
- `display: int` — Display typography style
- `text: string` — Display / input text
- `style: int` — Typography style token
- `isTextSelectionEnabled: bool` — WinUI IsTextSelectionEnabled — uses TextEdit when true (Label has no selectByMouse)
- `textTrimming: string` — none | characterEllipsis | wordEllipsis
- `maxLines: int` — Max Lines
- `color: color` — Color
- `styleName: string` — Style Name

</details>

<details><summary>Methods</summary>

- `setStyleName(name)`

</details>

#### Timeline

Vertical event timeline.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Timeline.qml`

```qml
Timeline { model: events }
```

<details><summary>Properties</summary>

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `railWidth: real` — Rail Width
- `nodeSize: real` — Node Size
- `isInteractive: bool` — Alias of interactive
- `modelData: var`
- `index: int`
- `isLast: bool` — Is Last
- `isActive: bool` — Active / animating state
- `nodeColor: color` — Node Color

</details>

<details><summary>Signals</summary>

- `itemClicked(int index)`
- `selectionChanged(int index)`

</details>

<details><summary>Methods</summary>

- `select(index)`
- `next()`
- `previous()`

</details>

#### TimePicker

Hour / minute (and period) selectors.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TimePicker.qml`

```qml
TimePicker { }
```

<details><summary>Properties</summary>

- `hour: int` — Hour
- `minute: int` — Minute
- `isAm: bool` — Is Am
- `use24Hour: bool` — Use24 Hour
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `header: string` — Header label above the control
- `minuteIncrement: int` — WinUI MinuteIncrement — e.g. 1, 5, 15
- `clockIdentifier: string` — WinUI ClockIdentifier (read-only mirror of use24Hour)
- `minuteModel: var` — Minute Model
- `displayHour: int` — Display Hour
- `displayText: string` — Text shown to the user

</details>

<details><summary>Signals</summary>

- `timeChosen(int hour, int minute)`

</details>

<details><summary>Methods</summary>

- `snapMinute(m)`
- `applyFromTumblers()`

</details>

#### TitleBar

WinUI TitleBar content chrome (not caption buttons).

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TitleBar.qml`

```qml
TitleBar {
    title: qsTr("App")
    subtitle: qsTr("Optional")
    symbol: FluentIcons.Home
}
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `iconSource: url` — Image icon when symbol / iconGlyph are empty
- `symbol: var` — FluentIcons value (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `searchText: alias` — Title-bar search field text
- `searchModel: var` — Suggestion rows for the built-in search field
- `searchEnabled: bool` — When true and content slot is empty, show built-in catalog search (Gallery default).
- `isBackButtonVisible: bool` — Show back button
- `isBackButtonEnabled: bool` — Enable back button
- `isPaneToggleButtonVisible: bool` — Show navigation pane toggle
- `embedded: bool` — Hosted inside PlatformTitleBar / WindowChrome (hides local acrylic plate)
- `useSystemMove: bool` — Use Window.startSystemMove for caption drag
- `trailingReserve: real` — Extra right inset when caption buttons are drawn outside this item
- `dragWindow: var` — Window used for system move
- `preferredHeight: real` — WinUI TitleBarHeightOption — Standard 32 / Tall 48 (from PlatformTitleBar).
- `effectiveIconGlyph: string` — Resolved glyph string
- `hasContentChildren: bool` — Content slot has children
- `showBuiltInSearch: bool` — Show built-in search field
- `leftHeader: alias` — WinUI LeftHeader slot
- `content: alias` — WinUI Content slot (replaces built-in search when set)
- `rightHeader: alias` — WinUI RightHeader — also the default children slot for trailing actions.
- `trailing: alias` — Trailing slot
- `glyph: string` — Fluent glyph drawn in the button

</details>

<details><summary>Signals</summary>

- `searchActivated(var item)`
- `searchTextEdited(string text)`
- `backRequested()`
- `paneToggleRequested()`

</details>

<details><summary>Methods</summary>

- `clientExcludeRectsFor(window)`
- `pushRect(gx, gy, w, h)`
- `pushItem(item)`
- `pushHostContent(host)`

</details>

#### Toast

Transient toast item.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/Toast.qml`

```qml
Toast { title: qsTr("Saved"); message: qsTr("OK") }
```

<details><summary>Properties</summary>

- `title: string` — Primary title text
- `message: string` — Body / message text
- `severity: int` — Status severity enum
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `isOpen: bool` — Open / visible state
- `actionText: string` — Optional action button label
- `showProgress: bool` — Show progress indicator
- `pauseOnHover: bool` — Pause On Hover
- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `severityName: string` — Severity as string name

</details>

<details><summary>Signals</summary>

- `actionClicked()`
- `closed()`

</details>

<details><summary>Methods</summary>

- `show(msg, sev)`
- `open()`
- `close()`
- `hide()`

</details>

#### ToastHost

Hosts stacked Toasts.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ToastHost.qml`

```qml
ToastHost { id: toasts }
// toasts.show({ title: "Done", message: "OK" })
```

<details><summary>Properties</summary>

- `maxVisible: int` — Max visible items before overflow
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `newestOnTop: bool` — Newest On Top
- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `count: int` — Item count
- `index: int`
- `key: string`
- `message: string` — Body / message text
- `severity: int` — Status severity enum
- `title: string` — Primary title text
- `actionText: string` — Optional action button label

</details>

<details><summary>Signals</summary>

- `toastClosed(string message)`
- `toastActionClicked(string message)`

</details>

<details><summary>Methods</summary>

- `show(message, severity, title, actionText)`
- `info(message, title, actionText)`
- `successToast(message, title, actionText)`
- `warningToast(message, title, actionText)`
- `errorToast(message, title, actionText)`
- `clear()`

</details>

#### ToggleButton

Checkable button with Fluent chrome.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ToggleButton.qml`

```qml
ToggleButton { text: qsTr("Bold"); checkable: true }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `iconSize: real` — Icon size in px
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `accented: bool` — Use accent chrome

</details>

#### ToggleMenuFlyoutItem

Checkable MenuFlyout item.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ToggleMenuFlyoutItem.qml`

```qml
ToggleMenuFlyoutItem { text: qsTr("Wrap") }
```

<details><summary>Properties</summary>

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `keyboardAcceleratorText: string` — Accelerator caption (Ctrl+C)
- `keyVisualAccelerator: bool` — Show KeyVisual for accelerator
- `effectiveIconGlyph: string` — Resolved glyph string

</details>

#### ToggleSplitButton

Toggle primary + menu SplitButton.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ToggleSplitButton.qml`

```qml
ToggleSplitButton { text: qsTr("Format") }
```

<details><summary>Properties</summary>

- `menu: alias` — Attached / owned Menu
- `menuData: alias` — Menu children slot
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `flyoutPlacement: int` — MenuFlyout placement
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `isOpen: alias` — Open / visible state
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `accented: bool` — Use accent chrome
- `anyHovered: bool` — True if any child is hovered
- `anyDown: bool` — True if any child is pressed

</details>

<details><summary>Signals</summary>

- `primaryClicked()`

</details>

<details><summary>Methods</summary>

- `showMenu()`
- `closeMenu()`

</details>

#### TokenizingTextBox

Token chips + text input.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TokenizingTextBox.qml`

```qml
TokenizingTextBox {
    model: tokens
    placeholderText: qsTr("Add…")
}
```

<details><summary>Properties</summary>

- `text: alias` — Display / input text
- `tokens: var` — Current token list
- `suggestionModel: var` — Filtered suggestion rows
- `placeholderText: string` — Placeholder when empty
- `suggestionsOpen: bool` — Suggestion popup open
- `isOpen: alias` — Open / visible state
- `maxTokens: int` — Maximum number of tokens
- `allowDuplicates: bool` — Allow duplicate tokens
- `tokenDelimiters: string` — Characters that commit a token
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `hasError: bool` — True when validation failed
- `tokenCount: int` — Number of tokens
- `filteredSuggestions: var` — Filtered Suggestions
- `index: int`
- `modelData: var`

</details>

<details><summary>Signals</summary>

- `tokenAdded(string token)`
- `tokenRemoved(string token, int index)`
- `accepted(string token)`
- `querySubmitted(string token)`
- `cleared()`

</details>

<details><summary>Methods</summary>

- `focusField()`
- `clear()`
- `addToken(value)`
- `removeToken(index)`

</details>

#### ToolShellWindow

ShellWindow with tool paradigm.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ToolShellWindow.qml`

```qml
ToolShellWindow { title: qsTr("Inspector"); width: 320; height: 480 }
```

#### TwoPaneView

Responsive dual-pane layout.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/TwoPaneView.qml`

```qml
TwoPaneView {
    pane1: Rectangle { }
    pane2: Rectangle { }
}
```

<details><summary>Properties</summary>

- `pane1: Item` — First pane content
- `pane2: Item` — Second pane content
- `panePriorityWidth: real` — Pane Priority Width
- `pane1Length: alias` — Pane1 Length
- `minWideWidth: real` — Min Wide Width
- `preferredMode: int` — Preferred Mode
- `panePriority: int` — Pane Priority
- `mode: int` — Mode
- `singlePaneIndex: int` — Single Pane Index
- `modeName: string` — Mode Name

</details>

<details><summary>Methods</summary>

- `showPane1()`
- `showPane2()`
- `toggleSinglePane()`
- `swapPanes()`
- `reparentPanes()`
- `layoutPanes()`

</details>

#### UniformGrid

Even cell grid.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/UniformGrid.qml`

```qml
UniformGrid { columns: 3 }
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `rows: int` — Grid row count
- `columns: int` — Grid column count
- `rowSpacing: real` — Row Spacing
- `columnSpacing: real` — Column Spacing
- `cellWidth: real` — Cell Width
- `cellHeight: real` — Cell Height
- `layoutDirection: int` — Qt layout direction
- `cellSpacing: real` — Cell Spacing
- `childCount: int` — Number of children

</details>

<details><summary>Methods</summary>

- `visibleChildren()`
- `relayout()`

</details>

#### WaterfallChart

Waterfall chart.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/WaterfallChart.qml`

```qml
WaterfallChart { values: [10, -3, 5] }
```

<details><summary>Properties</summary>

- `steps: var` — Waterfall step descriptors
- `values: var` — Numeric values array
- `showConnector: bool` — Show connectors between steps
- `showLabels: bool` — Show item labels
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `totalColor: color` — Waterfall total bar color
- `showTotal: bool` — Show total column
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `valueUnit: string` — Unit appended to value text
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `padL: real` — Left padding
- `count: int` — Item count

</details>

<details><summary>Signals</summary>

- `stepClicked(int index, real value)`

</details>

<details><summary>Methods</summary>

- `playReveal()`
- `requestRedraw()`
- `clearHover()`
- `Y(v)`

</details>

#### WrapPanel

Flow / wrap layout.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/WrapPanel.qml`

```qml
WrapPanel {
    Repeater { model: 8; Chip { text: modelData } }
}
```

<details><summary>Properties</summary>

- `contentData: alias` — Default children / content slot
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `itemWidth: real` — Item Width
- `itemHeight: real` — Item Height
- `paddingEdges: int` — Edge paddings
- `layoutDirection: int` — Qt layout direction
- `childCount: int` — Number of children

</details>

#### ZoneGauge

Gauge with colored zones.

`import QWinUI3.Extras` · `src/extras/QWinUI3/Extras/ZoneGauge.qml`

```qml
ZoneGauge { value: 55; minimum: 0; maximum: 100 }
```

<details><summary>Properties</summary>

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `strokeWidth: real` — Stroke thickness in px
- `showNeedle: bool` — Show needle indicator
- `showValue: bool` — Show numeric value label
- `showTicks: bool` — Show tick marks
- `tickCount: int` — Major tick count
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `zones: var` — Colored gauge zones
- `percentage: real` — Value as 0..100 percentage
- `activeZoneIndex: int` — Active Zone Index
- `activeZoneLabel: string` — Active Zone Label
- `activeZoneColor: color` — Active Zone Color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `radius: real` — Corner radius
- `modelData: var`
- `index: int`

</details>

<details><summary>Signals</summary>

- `valueEdited(real value)`

</details>

<details><summary>Methods</summary>

- `zoneColor(z, index)`
- `clampSnap(v)`
- `setValue(v)`
- `setValueFromNorm(n)`
- `normFromPoint(px, py)`

</details>

### Module `QWinUI3.Platform`

#### CompactOverlayWindow

StandardWindow compact overlay presenter.

`import QWinUI3.Platform` · `src/platform/QWinUI3/Platform/CompactOverlayWindow.qml`

```qml
CompactOverlayWindow { title: qsTr("Overlay") }
```

#### DialogWindow

StandardWindow dialog paradigm.

`import QWinUI3.Platform` · `src/platform/QWinUI3/Platform/DialogWindow.qml`

```qml
DialogWindow { title: qsTr("Dialog") }
```

#### PlatformTitleBar

Caption buttons + drag region + TitleBar host.

`import QWinUI3.Platform` · `src/platform/QWinUI3/Platform/PlatformTitleBar.qml`

```qml
PlatformTitleBar {
    targetWindow: window
    TitleBar { embedded: true; title: qsTr("App") }
}
```

<details><summary>Properties</summary>

- `targetWindow: var` — Window this chrome is attached to
- `showCaptionButtons: bool` — Show caption buttons
- `showMinimize: bool` — Show minimize
- `showMaximize: bool` — Show maximize
- `showClose: bool` — Show close
- `preferredHeightOption: int` — Title bar height option
- `useNativeChrome: bool` — Use native NC hit-testing
- `resolvedCaptionHeight: real` — Resolved caption button height
- `titleContent: alias` — Title content slot
- `captionHeight: real` — Caption button row height
- `chromeBackground: color` — AppWindowTitleBar theming (WinUI caption button / chrome colors).
- `chromeInactive: bool` — Inactive chrome styling
- `buttonBackground: color` — Caption button rest fill
- `buttonHover: color` — Caption button hover fill
- `buttonPressed: color` — Caption button pressed fill
- `buttonForeground: color` — Caption button foreground
- `closeHover: color` — Close hover fill
- `closePressed: color` — Close pressed fill

</details>

<details><summary>Methods</summary>

- `reportHitTest()`
- `screenRect(item)`

</details>

#### StandardWindow

Platform ApplicationWindow + PlatformTitleBar host.

`import QWinUI3.Platform` · `src/platform/QWinUI3/Platform/StandardWindow.qml`

```qml
StandardWindow {
    title: qsTr("Gallery")
    backdrop: WindowHelper.BackdropSolid
}
```

<details><summary>Properties</summary>

- `paradigm: int` — Window paradigm
- `backdrop: int` — Backdrop kind
- `presenter: int` — Presenter kind
- `preferredHeightOption: int` — Title bar height option
- `autoInstall: bool` — Auto-apply WindowHelper chrome on complete
- `showCaptionButtons: bool` — Show caption buttons
- `showMinimize: bool` — Show minimize
- `showMaximize: bool` — Show maximize
- `showClose: bool` — Show close
- `isAlwaysOnTop: bool` — Always on top
- `extendsContentIntoTitleBar: bool` — Documents frameless / custom chrome (WinUI ExtendsContentIntoTitleBar).
- `chrome: alias` — WindowChrome / PlatformTitleBar host

</details>

<details><summary>Methods</summary>

- `applyChrome()`
- `setPresenterKind(kind)`
- `onDarkChanged()`
- `onCornerPreferenceChanged()`

</details>

#### ToolWindow

StandardWindow tool paradigm.

`import QWinUI3.Platform` · `src/platform/QWinUI3/Platform/ToolWindow.qml`

```qml
ToolWindow { title: qsTr("Tool") }
```

### Module `QWinUI3.Theme`

#### Theme

Fluent color / type / motion token singleton.

`import QWinUI3.Theme` · `src/theme/QWinUI3/Theme/Theme.qml`

```qml
Theme.dark = true
Theme.followSystemAccessibility = true
```

<details><summary>Properties</summary>

- `dark: bool` — Dark color scheme when true
- `reducedMotion: bool` — Collapse Theme.duration() animations when true
- `highContrast: bool` — When true, strengthen borders/focus for high-contrast / accessibility themes.
- `followSystemAccessibility: bool` — When true, Gallery/apps should copy WindowHelper system a11y into the flags above.
- `accent: color` — Fluent / WinUI 3 system accent (matches FluentWinUI3 defaults)
- `accentLight1: color` — Lighter accent step
- `accentDark1: color` — Darker accent step
- `textPrimary: color` — Primary text brush
- `textSecondary: color` — Secondary text brush
- `textDisabled: color` — Disabled text brush
- `textOnAccent: color` — Text on accent fill
- `textOnAccentSecondary: color` — Secondary text on accent fill
- `fillControl: color` — Control fills — WinUI ControlFillColor*
- `fillControlSecondary: color` — Control fill (hover)
- `fillControlTertiary: color` — Control fill (pressed)
- `fillControlDisabled: color` — Control fill (disabled)
- `fillAccent: color` — Accent fill
- `fillAccentSecondary: color` — Accent fill (hover)
- `fillAccentTertiary: color` — Accent fill (pressed)
- `fillSubtle: color` — Subtle hover/press wash
- `fillSubtleSecondary: color` — Subtle secondary wash
- `fillSubtleTertiary: color` — Subtle tertiary wash
- `strokeControl: color` — Strokes — ControlStrokeColor*
- `strokeControlStrong: color` — Strong control border
- `strokeControlOnAccent: color` — Stroke Control On Accent
- `focusOuter: color` — Focus ring outer color
- `focusInner: color` — Focus ring inner color
- `strokeCard: color` — Card border stroke

</details>

<details><summary>Methods</summary>

- `duration(ms)`
- `controlFill(hovered, pressed, disabled)`
- `accentFill(hovered, pressed, disabled)`

</details>

### Module `QtQuick.Controls.QWinUI3`

#### ApplicationWindow

Fluent ApplicationWindow chrome defaults.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ApplicationWindow.qml`

```qml
ApplicationWindow { title: qsTr("App") }
```

#### BusyIndicator

Fluent styled BusyIndicator.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/BusyIndicator.qml`

```qml
BusyIndicator { running: true }
```

<details><summary>Properties</summary>

- `stroke: real` — Stroke width for dial arc
- `radius: real` — Corner radius
- `spinAngle: real` — Indeterminate spin angle
- `pulseOpacity: real` — Pulse Opacity

</details>

#### Button

Fluent styled Button.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Button.qml`

```qml
Button { text: qsTr("OK"); onClicked: accept() }
```

<details><summary>Properties</summary>

- `accented: bool` — Use accent chrome
- `lightScheme: bool` — True in light theme
- `hasSolidStroke: bool` — Draw solid stroke chrome
- `hasGradientStroke: bool` — Draw gradient stroke chrome
- `topStroke: color` — WinUI ControlStrokeDefault / Secondary — keep soft, not StrongStroke
- `bottomStroke: color` — Bottom edge stroke width
- `inset: bool` — Content inset

</details>

#### CheckBox

Fluent styled CheckBox.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/CheckBox.qml`

```qml
CheckBox { text: qsTr("Remember"); checked: true }
```

#### CheckDelegate

Fluent styled CheckDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/CheckDelegate.qml`

```qml
CheckDelegate { text: qsTr("Option") }
```

#### ComboBox

Fluent styled ComboBox.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ComboBox.qml`

```qml
ComboBox { model: ["A", "B"] }
```

<details><summary>Properties</summary>

- `lightScheme: bool` — True in light theme
- `modelData: var`
- `index: int`
- `selected: bool` — Selected state
- `hasSolidStroke: bool` — Draw solid stroke chrome
- `hasGradientStroke: bool` — Draw gradient stroke chrome
- `topStroke: color` — Top edge stroke width
- `bottomStroke: color` — Bottom edge stroke width
- `inset: bool` — Content inset

</details>

#### DayOfWeekRow

Fluent styled DayOfWeekRow.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/DayOfWeekRow.qml`

```qml
DayOfWeekRow { }
```

<details><summary>Properties</summary>

- `shortName: string`

</details>

#### DelayButton

Fluent styled DelayButton.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/DelayButton.qml`

```qml
DelayButton { text: qsTr("Hold") }
```

#### Dial

Fluent styled Dial.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Dial.qml`

```qml
Dial { from: 0; to: 100; value: 30 }
```

<details><summary>Properties</summary>

- `title: string` — Title text
- `unit: string` — Value unit label (%, rpm, …)
- `showValue: bool` — Show numeric value label
- `valuePrecision: int` — Digits after decimal for value text
- `tickCount: int` — Number of ticks
- `showTicks: bool` — Show tick marks
- `formattedValue: string` — Formatted value string
- `stroke: real` — Stroke width for dial arc
- `r: real` — R
- `index: int`
- `t: real` — Normalized 0..1 parameter
- `angDeg: real` — Angle in degrees
- `ang: real` — Angle in degrees
- `rr: real` — Resolved radius

</details>

#### Dialog

Fluent styled Dialog.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Dialog.qml`

```qml
Dialog { title: qsTr("Hi"); standardButtons: Dialog.Ok }
```

#### DialogButtonBox

Fluent styled DialogButtonBox.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/DialogButtonBox.qml`

```qml
DialogButtonBox { standardButtons: Dialog.Ok | Dialog.Cancel }
```

#### Drawer

Fluent styled Drawer.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Drawer.qml`

```qml
Drawer { // content }
```

#### Frame

Fluent styled Frame.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Frame.qml`

```qml
Frame { // children }
```

#### GroupBox

Fluent styled GroupBox.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/GroupBox.qml`

```qml
GroupBox { title: qsTr("Options") }
```

#### HorizontalHeaderView

Fluent styled HorizontalHeaderView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/HorizontalHeaderView.qml`

```qml
HorizontalHeaderView { }
```

<details><summary>Properties</summary>

- `model: var` — Data model

</details>

#### ItemDelegate

Fluent styled ItemDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ItemDelegate.qml`

```qml
ItemDelegate { text: qsTr("Row") }
```

#### Label

Fluent styled Label.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Label.qml`

```qml
Label { text: qsTr("Hello") }
```

#### Menu

Fluent styled Menu.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Menu.qml`

```qml
Menu { MenuItem { text: qsTr("Copy") } }
```

#### MenuBar

Fluent styled MenuBar.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/MenuBar.qml`

```qml
MenuBar { Menu { title: qsTr("File") } }
```

#### MenuBarItem

Fluent styled MenuBarItem.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/MenuBarItem.qml`

```qml
MenuBarItem { text: qsTr("File") }
```

#### MenuItem

Fluent styled MenuItem.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/MenuItem.qml`

```qml
MenuItem { text: qsTr("Paste") }
```

#### MenuSeparator

Fluent styled MenuSeparator.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/MenuSeparator.qml`

```qml
MenuSeparator { }
```

#### MonthGrid

Fluent styled MonthGrid.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/MonthGrid.qml`

```qml
MonthGrid { }
```

<details><summary>Properties</summary>

- `selectedDate: date` — Selected date
- `model: var` — Data model
- `inMonth: bool` — In Month
- `isToday: bool` — Is Today
- `isSelected: bool` — Selected state

</details>

<details><summary>Methods</summary>

- `sameDay(a, b)`

</details>

#### Page

Fluent styled Page.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Page.qml`

```qml
Page { title: qsTr("Home") }
```

#### PageIndicator

Fluent styled PageIndicator.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/PageIndicator.qml`

```qml
PageIndicator { count: 3; currentIndex: 0 }
```

<details><summary>Properties</summary>

- `index: int`
- `active: bool` — Active state

</details>

#### Pane

Fluent styled Pane.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Pane.qml`

```qml
Pane { // children }
```

#### Popup

Fluent styled Popup chrome.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Popup.qml`

```qml
Popup { modal: true; // content }
```

#### ProgressBar

Fluent styled ProgressBar.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ProgressBar.qml`

```qml
ProgressBar { value: 0.4; from: 0; to: 1 }
```

#### RadioButton

Fluent styled RadioButton.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/RadioButton.qml`

```qml
RadioButton { text: qsTr("Option"); checked: true }
```

#### RadioDelegate

Fluent styled RadioDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/RadioDelegate.qml`

```qml
RadioDelegate { text: qsTr("Option") }
```

#### RangeSlider

Fluent styled RangeSlider.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/RangeSlider.qml`

```qml
RangeSlider { from: 0; to: 100; first.value: 20; second.value: 80 }
```

<details><summary>Properties</summary>

- `diameter: real` — Diameter in px

</details>

#### RoundButton

Fluent styled RoundButton.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/RoundButton.qml`

```qml
RoundButton { text: "+" }
```

#### ScrollBar

Fluent styled ScrollBar.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ScrollBar.qml`

```qml
ScrollBar { }
```

#### ScrollIndicator

Fluent styled ScrollIndicator.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ScrollIndicator.qml`

```qml
ScrollIndicator { }
```

#### ScrollView

Fluent styled ScrollView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ScrollView.qml`

```qml
ScrollView { Label { text: longText } }
```

#### Slider

Fluent styled Slider.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Slider.qml`

```qml
Slider { from: 0; to: 100; value: 40 }
```

<details><summary>Properties</summary>

- `diameter: real` — Diameter in px

</details>

#### SpinBox

Fluent styled SpinBox.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/SpinBox.qml`

```qml
SpinBox { from: 0; to: 99; value: 1 }
```

#### SplitView

Fluent styled SplitView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/SplitView.qml`

```qml
SplitView { orientation: Qt.Horizontal }
```

#### StackView

Fluent styled StackView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/StackView.qml`

```qml
StackView { initialItem: homePage }
```

#### SwipeDelegate

Fluent styled SwipeDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/SwipeDelegate.qml`

```qml
SwipeDelegate { text: qsTr("Row") }
```

#### SwipeView

Fluent styled SwipeView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/SwipeView.qml`

```qml
SwipeView { // pages }
```

#### Switch

Fluent styled Switch.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Switch.qml`

```qml
Switch { checked: Theme.dark; onToggled: Theme.dark = checked }
```

#### SwitchDelegate

Fluent styled SwitchDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/SwitchDelegate.qml`

```qml
SwitchDelegate { text: qsTr("Option") }
```

#### TabBar

Fluent styled TabBar.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/TabBar.qml`

```qml
TabBar { TabButton { text: qsTr("One") } }
```

#### TabButton

Fluent styled TabButton.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/TabButton.qml`

```qml
TabButton { text: qsTr("Tab") }
```

#### TextArea

Fluent styled TextArea.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/TextArea.qml`

```qml
TextArea { placeholderText: qsTr("Notes") }
```

#### TextField

Fluent styled TextField.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/TextField.qml`

```qml
TextField { placeholderText: qsTr("Name") }
```

#### ToolBar

Fluent styled ToolBar.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ToolBar.qml`

```qml
ToolBar { ToolButton { text: qsTr("A") } }
```

#### ToolButton

Fluent styled ToolButton.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ToolButton.qml`

```qml
ToolButton { text: qsTr("Edit") }
```

#### ToolSeparator

Fluent styled ToolSeparator.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ToolSeparator.qml`

```qml
ToolSeparator { }
```

#### ToolTip

Fluent styled ToolTip.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/ToolTip.qml`

```qml
ToolTip { text: qsTr("Hint") }
```

#### TreeViewDelegate

Fluent styled TreeViewDelegate.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/TreeViewDelegate.qml`

```qml
TreeViewDelegate { }
```

<details><summary>Properties</summary>

- `row: int`
- `model: var` — Data model

</details>

#### Tumbler

Fluent styled Tumbler.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/Tumbler.qml`

```qml
Tumbler { model: 12 }
```

<details><summary>Properties</summary>

- `modelData: var`
- `index: int`

</details>

#### VerticalHeaderView

Fluent styled VerticalHeaderView.

`import QtQuick.Controls.QWinUI3` · `src/style/QWinUI3/VerticalHeaderView.qml`

```qml
VerticalHeaderView { }
```

<details><summary>Properties</summary>

- `model: var` — Data model

</details>

## Internal / support

- `ChartUtils` (`QWinUI3.Extras`) — LOD helpers for large chart series.
- `ShellWindowSupport` (`QWinUI3.Extras`) — Shared install/presenter glue for ShellWindow.
- `WindowChrome` (`QWinUI3.Extras`) — PlatformTitleBar + TitleBar bundle for shells.
- `FocusStroke` (`QtQuick.Controls.QWinUI3`) — Focus ring helper.
- `SelectionPip` (`QtQuick.Controls.QWinUI3`) — Navigation selection pip indicator.
- `CaptionButton` (`QWinUI3.Platform`) — Native-chrome caption min/max/close button.
- `WindowResizeBorder` (`QWinUI3.Platform`) — Non-native resize hit edges.
- `ElevatedChrome` (`QWinUI3.Theme`) — Shared elevated shadow/border chrome.
- `IconSource` (`QWinUI3.Theme`) — Resolve FluentIcons symbol or glyph string.

---
*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*
