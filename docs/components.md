# QWinUI3 component API

Generated from **QML source comments** by regex (`scripts/generate_component_docs.py`).
Each control has its **own** markdown under [`docs/components/`](components/).
Edit the `// Name — …` + indented usage block in each `.qml` file, then re-run the script.

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

Public components: **179**. Shell overview: [`docs/window-shells.md`](window-shells.md). Platform chrome: [`docs/window-helper.md`](window-helper.md).

## Index

### `QWinUI3.Extras`

- [AccentButton](components/AccentButton.md) — Always-accent primary CTA with optional Fluent symbol.
- [AcrylicSurface](components/AcrylicSurface.md) — Frosted pane; keep translucent under system Mica/Acrylic.
- [ActionCard](components/ActionCard.md) — Clickable card with symbol, title, description, and chevron.
- [AnnotatedScrollBar](components/AnnotatedScrollBar.md) — Scroll area with a value label on the vertical scrollbar.
- [AppBarButton](components/AppBarButton.md) — CommandBar icon button with label position overrides.
- [AppBarSeparator](components/AppBarSeparator.md) — Thin separator for CommandBar / AppBar rows.
- [AppBarToggleButton](components/AppBarToggleButton.md) — Checkable AppBarButton for CommandBar.
- [ArcGauge](components/ArcGauge.md) — Open-arc dashboard gauge with center value and thresholds.
- [AreaChart](components/AreaChart.md) — Filled area chart with legend and hover crosshair.
- [AutoSuggestBox](components/AutoSuggestBox.md) — Text field with filtered suggestion popup.
- [AvatarGroup](components/AvatarGroup.md) — Overlapping PersonPicture stack with overflow count.
- [BarChart](components/BarChart.md) — Vertical bar chart with reveal animation.
- [BlankWindow](components/BlankWindow.md) — Empty ShellWindow client — declare UI as children.
- [BreadcrumbBar](components/BreadcrumbBar.md) — Path trail; model items raise itemClicked.
- [BulletChart](components/BulletChart.md) — Compact KPI bullet (ranges + performance + target).
- [CalendarDatePicker](components/CalendarDatePicker.md) — Date field with calendar flyout.
- [ChartCard](components/ChartCard.md) — Title/subtitle chrome around a chart child.
- [ChartLegend](components/ChartLegend.md) — Fluent legend for series/slices.
- [Chip](components/Chip.md) — Compact selectable tag; optional close affordance.
- [ChipGroup](components/ChipGroup.md) — Horizontal chip group for filters / single select.
- [ColorPicker](components/ColorPicker.md) — Spectrum + RGB/Hex color editor.
- [ColorPickerButton](components/ColorPickerButton.md) — Color swatch button that opens ColorPicker.
- [CommandBar](components/CommandBar.md) — Primary/secondary command row (AppBar host).
- [CommandBarFlyout](components/CommandBarFlyout.md) — Popup CommandBar with primary + secondary commands.
- [CompactOverlayShellWindow](components/CompactOverlayShellWindow.md) — Always-on-top compact overlay shell.
- [ContentCard](components/ContentCard.md) — Surface card with title, subtitle, symbol, and body slot.
- [ContentDialog](components/ContentDialog.md) — Modal dialog with primary / secondary / close actions.
- [ContentDialogQueue](components/ContentDialogQueue.md) — Singleton queue so ContentDialogs open one at a time.
- [CopyButton](components/CopyButton.md) — Copies textToCopy and flashes a success glyph.
- [DatePicker](components/DatePicker.md) — Date selectors (year / month / day).
- [DialogShellWindow](components/DialogShellWindow.md) — ShellWindow with dialog paradigm flags.
- [DockPanel](components/DockPanel.md) — Dock children Top/Bottom/Left/Right/Fill.
- [DonutChart](components/DonutChart.md) — Donut chart with hover and legend.
- [DropDownButton](components/DropDownButton.md) — Button that opens a MenuFlyout of actions.
- [EmptyState](components/EmptyState.md) — Placeholder illustration + title + optional action.
- [Expander](components/Expander.md) — Collapsible header with expandable content.
- [FlipView](components/FlipView.md) — Page carousel with optional navigation buttons.
- [Flyout](components/Flyout.md) — Light-dismiss popup anchored to a target.
- [FontIcon](components/FontIcon.md) — FluentIcons glyph as Text.
- [GridTile](components/GridTile.md) — Icon + title tile for launchers / galleries.
- [HeaderedContentControl](components/HeaderedContentControl.md) — Labeled content host.
- [HeaderedTextBox](components/HeaderedTextBox.md) — TextBox with header and description.
- [HeatmapChart](components/HeatmapChart.md) — Heatmap matrix chart.
- [HorizontalBarChart](components/HorizontalBarChart.md) — Horizontal bar chart.
- [HyperlinkButton](components/HyperlinkButton.md) — Link-styled button.
- [IconButton](components/IconButton.md) — Icon-only button helper.
- [IconicButton](components/IconicButton.md) — Base icon + label button used by AppBar*.
- [InfoBadge](components/InfoBadge.md) — Count / status / glyph badge.
- [InfoBar](components/InfoBar.md) — Inline severity banner with optional action.
- [InfoBarHost](components/InfoBarHost.md) — Stacks InfoBars in a host region.
- [KeyChordVisual](components/KeyChordVisual.md) — Renders Ctrl+K style shortcuts as KeyVisuals.
- [KeyVisual](components/KeyVisual.md) — Single keyboard key chrome.
- [LinearGauge](components/LinearGauge.md) — Horizontal/vertical track gauge with thresholds.
- [LineChart](components/LineChart.md) — Multi-series line/area chart.
- [ListTile](components/ListTile.md) — List row: leading, title, subtitle, trailing.
- [MenuFlyout](components/MenuFlyout.md) — Elevated Menu with showAt / isOpen helpers.
- [MenuFlyoutHeader](components/MenuFlyoutHeader.md) — Non-interactive MenuFlyout section header.
- [MenuFlyoutItem](components/MenuFlyoutItem.md) — Menu row with glyph and accelerator text.
- [MenuFlyoutSeparator](components/MenuFlyoutSeparator.md) — MenuFlyout divider.
- [MenuStatusWindow](components/MenuStatusWindow.md) — TitleBar + MenuBar + content + StatusBar shell.
- [MetadataControl](components/MetadataControl.md) — Stacked or flowed label/value metadata block.
- [MetadataItem](components/MetadataItem.md) — One label/value pair for MetadataControl.
- [MeterBar](components/MeterBar.md) — Multi-segment stacked meter (e.g. disk usage).
- [MultiSelectComboBox](components/MultiSelectComboBox.md) — Combo that keeps the popup open for multi-select.
- [NavigationView](components/NavigationView.md) — WinUI NavigationView with pane modes and page stack.
- [NavigationWindow](components/NavigationWindow.md) — ShellWindow hosting NavigationView + content.
- [NumberBox](components/NumberBox.md) — Numeric spin/edit with validation.
- [PasswordBox](components/PasswordBox.md) — Password field with reveal toggle.
- [PersonPicture](components/PersonPicture.md) — Avatar from image or initials.
- [PieChart](components/PieChart.md) — Pie chart with legend.
- [PipsPager](components/PipsPager.md) — Dot pager for carousels.
- [Pivot](components/Pivot.md) — Header tabs with sliding underline and pages.
- [ProgressButton](components/ProgressButton.md) — Button with inline determinate/indeterminate fill.
- [ProgressRing](components/ProgressRing.md) — Circular progress / busy ring.
- [RadarChart](components/RadarChart.md) — Radar / spider chart.
- [RadialGauge](components/RadialGauge.md) — Circular gauge with needle and zones.
- [RadioButtons](components/RadioButtons.md) — Grouped RadioButton list from a model.
- [RadioMenuFlyoutItem](components/RadioMenuFlyoutItem.md) — Exclusive radio MenuFlyout item.
- [RatingControl](components/RatingControl.md) — Star rating; stepSize supports halves.
- [RefreshContainer](components/RefreshContainer.md) — Pull-to-refresh host for flickable content.
- [RelativePanel](components/RelativePanel.md) — Constraint-based relative layout.
- [ScatterChart](components/ScatterChart.md) — Scatter / bubble chart.
- [SearchBox](components/SearchBox.md) — Search field with suggestion list.
- [SegmentedControl](components/SegmentedControl.md) — Mutually exclusive segment buttons.
- [SegmentedGauge](components/SegmentedGauge.md) — Segmented progress / capacity gauge.
- [SelectorBar](components/SelectorBar.md) — Compact horizontal item selector.
- [SettingsCard](components/SettingsCard.md) — Settings row: icon, title, description, action.
- [SettingsExpander](components/SettingsExpander.md) — Expandable settings group.
- [ShellWindow](components/ShellWindow.md) — Independent ApplicationWindow + WindowChrome host.
- [Shimmer](components/Shimmer.md) — Skeleton shimmer placeholder.
- [Sparkline](components/Sparkline.md) — Inline mini line chart.
- [SplitButton](components/SplitButton.md) — Primary action + chevron menu.
- [StackedBarChart](components/StackedBarChart.md) — Stacked bar chart.
- [StackPanel](components/StackPanel.md) — Simple stack layout (orientation + spacing).
- [StatusBar](components/StatusBar.md) — Window status strip with progress and slots.
- [StatusDot](components/StatusDot.md) — Colored status indicator dot.
- [StepBar](components/StepBar.md) — Horizontal step / wizard progress.
- [SwipeAction](components/SwipeAction.md) — Action revealed by SwipeControl.
- [SwipeControl](components/SwipeControl.md) — Swipe-to-reveal actions on content.
- [SwitchCase](components/SwitchCase.md) — Case child for SwitchPresenter.
- [SwitchPresenter](components/SwitchPresenter.md) — Shows the SwitchCase matching value.
- [TabView](components/TabView.md) — Closeable / reorderable tabs.
- [TeachingTip](components/TeachingTip.md) — Anchored tip with title, subtitle, and actions.
- [TextBlock](components/TextBlock.md) — Fluent typography styles (title, body, caption…).
- [Timeline](components/Timeline.md) — Vertical event timeline.
- [TimePicker](components/TimePicker.md) — Hour / minute (and period) selectors.
- [TitleBar](components/TitleBar.md) — WinUI TitleBar content chrome (not caption buttons).
- [Toast](components/Toast.md) — Transient toast item.
- [ToastHost](components/ToastHost.md) — Hosts stacked Toasts.
- [ToggleButton](components/ToggleButton.md) — Checkable button with Fluent chrome.
- [ToggleMenuFlyoutItem](components/ToggleMenuFlyoutItem.md) — Checkable MenuFlyout item.
- [ToggleSplitButton](components/ToggleSplitButton.md) — Toggle primary + menu SplitButton.
- [TokenizingTextBox](components/TokenizingTextBox.md) — Token chips + text input.
- [ToolShellWindow](components/ToolShellWindow.md) — ShellWindow with tool paradigm.
- [TwoPaneView](components/TwoPaneView.md) — Responsive dual-pane layout.
- [UniformGrid](components/UniformGrid.md) — Even cell grid.
- [WaterfallChart](components/WaterfallChart.md) — Waterfall chart.
- [WrapPanel](components/WrapPanel.md) — Flow / wrap layout.
- [ZoneGauge](components/ZoneGauge.md) — Gauge with colored zones.

### `QWinUI3.Platform`

- [CompactOverlayWindow](components/CompactOverlayWindow.md) — StandardWindow compact overlay presenter.
- [DialogWindow](components/DialogWindow.md) — StandardWindow dialog paradigm.
- [PlatformTitleBar](components/PlatformTitleBar.md) — Caption buttons + drag region + TitleBar host.
- [StandardWindow](components/StandardWindow.md) — Platform ApplicationWindow + PlatformTitleBar host.
- [ToolWindow](components/ToolWindow.md) — StandardWindow tool paradigm.

### `QWinUI3.Theme`

- [Theme](components/Theme.md) — Fluent color / type / motion token singleton.

### `QtQuick.Controls.QWinUI3`

- [ApplicationWindow](components/ApplicationWindow.md) — Fluent ApplicationWindow chrome defaults.
- [BusyIndicator](components/BusyIndicator.md) — Fluent styled BusyIndicator.
- [Button](components/Button.md) — Fluent Button with WinUI stroke / fill / focus chrome.
- [CheckBox](components/CheckBox.md) — Fluent styled CheckBox.
- [CheckDelegate](components/CheckDelegate.md) — Fluent styled CheckDelegate.
- [ComboBox](components/ComboBox.md) — Fluent ComboBox with rotating chevron indicator.
- [DayOfWeekRow](components/DayOfWeekRow.md) — Fluent styled DayOfWeekRow.
- [DelayButton](components/DelayButton.md) — Fluent styled DelayButton.
- [Dial](components/Dial.md) — Fluent Dial with WinUI arc track and accent thumb.
- [Dialog](components/Dialog.md) — Fluent styled Dialog.
- [DialogButtonBox](components/DialogButtonBox.md) — Fluent styled DialogButtonBox.
- [Drawer](components/Drawer.md) — Fluent styled Drawer.
- [Frame](components/Frame.md) — Fluent styled Frame.
- [GroupBox](components/GroupBox.md) — Fluent styled GroupBox.
- [HorizontalHeaderView](components/HorizontalHeaderView.md) — Fluent styled HorizontalHeaderView.
- [ItemDelegate](components/ItemDelegate.md) — Fluent styled ItemDelegate.
- [Label](components/Label.md) — Fluent styled Label.
- [Menu](components/Menu.md) — Fluent styled Menu.
- [MenuBar](components/MenuBar.md) — Fluent styled MenuBar.
- [MenuBarItem](components/MenuBarItem.md) — Fluent styled MenuBarItem.
- [MenuItem](components/MenuItem.md) — Fluent styled MenuItem.
- [MenuSeparator](components/MenuSeparator.md) — Fluent styled MenuSeparator.
- [MonthGrid](components/MonthGrid.md) — Fluent calendar month grid for DatePicker / CalendarDatePicker.
- [Page](components/Page.md) — Fluent styled Page.
- [PageIndicator](components/PageIndicator.md) — Fluent styled PageIndicator.
- [Pane](components/Pane.md) — Fluent styled Pane.
- [Popup](components/Popup.md) — Fluent styled Popup chrome.
- [ProgressBar](components/ProgressBar.md) — Fluent styled ProgressBar.
- [RadioButton](components/RadioButton.md) — Fluent styled RadioButton.
- [RadioDelegate](components/RadioDelegate.md) — Fluent styled RadioDelegate.
- [RangeSlider](components/RangeSlider.md) — Fluent styled RangeSlider.
- [RoundButton](components/RoundButton.md) — Fluent styled RoundButton.
- [ScrollBar](components/ScrollBar.md) — Fluent styled ScrollBar.
- [ScrollIndicator](components/ScrollIndicator.md) — Fluent styled ScrollIndicator.
- [ScrollView](components/ScrollView.md) — Fluent styled ScrollView.
- [Slider](components/Slider.md) — Fluent styled Slider.
- [SpinBox](components/SpinBox.md) — Fluent styled SpinBox.
- [SplitView](components/SplitView.md) — Fluent styled SplitView.
- [StackView](components/StackView.md) — Fluent styled StackView.
- [SwipeDelegate](components/SwipeDelegate.md) — Fluent styled SwipeDelegate.
- [SwipeView](components/SwipeView.md) — Fluent styled SwipeView.
- [Switch](components/Switch.md) — Fluent styled Switch.
- [SwitchDelegate](components/SwitchDelegate.md) — Fluent styled SwitchDelegate.
- [TabBar](components/TabBar.md) — Fluent styled TabBar.
- [TabButton](components/TabButton.md) — Fluent styled TabButton.
- [TextArea](components/TextArea.md) — Fluent styled TextArea.
- [TextField](components/TextField.md) — Fluent styled TextField.
- [ToolBar](components/ToolBar.md) — Fluent styled ToolBar.
- [ToolButton](components/ToolButton.md) — Fluent styled ToolButton.
- [ToolSeparator](components/ToolSeparator.md) — Fluent styled ToolSeparator.
- [ToolTip](components/ToolTip.md) — Fluent styled ToolTip.
- [TreeViewDelegate](components/TreeViewDelegate.md) — Fluent TreeView row with chevron expand / indent.
- [Tumbler](components/Tumbler.md) — Fluent styled Tumbler.
- [VerticalHeaderView](components/VerticalHeaderView.md) — Fluent styled VerticalHeaderView.

## Internal / support

- [ChartUtils](components/ChartUtils.md) (`QWinUI3.Extras`) — LOD helpers for large chart series.
- [ShellWindowSupport](components/ShellWindowSupport.md) (`QWinUI3.Extras`) — Shared install/presenter glue for ShellWindow.
- [WindowChrome](components/WindowChrome.md) (`QWinUI3.Extras`) — PlatformTitleBar + TitleBar bundle for shells.
- [FocusStroke](components/FocusStroke.md) (`QtQuick.Controls.QWinUI3`) — Focus ring helper.
- [SelectionPip](components/SelectionPip.md) (`QtQuick.Controls.QWinUI3`) — Navigation selection pip indicator.
- [CaptionButton](components/CaptionButton.md) (`QWinUI3.Platform`) — Native-chrome caption min/max/close button.
- [WindowResizeBorder](components/WindowResizeBorder.md) (`QWinUI3.Platform`) — Non-native resize hit edges.
- [ElevatedChrome](components/ElevatedChrome.md) (`QWinUI3.Theme`) — Shared elevated shadow/border chrome.
- [IconSource](components/IconSource.md) (`QWinUI3.Theme`) — Resolve FluentIcons symbol or glyph string.

---
*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*
