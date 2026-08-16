# QWinUI3 component API

Library **v1.09**. Generated from QML source comments (`scripts/generate_component_docs.py`).
Each control has its own page under `docs/components/`.

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

**208** public · **10** internal · **151** with Gallery demos · Hub: [docs home](index.md).

## By module

### `QWinUI3.Extras`

- [AccentButton](components/AccentButton.md) — Always-accent primary CTA with optional Fluent symbol. · Gallery
- [AcrylicSurface](components/AcrylicSurface.md) — Frosted pane; keep translucent under system Mica/Acrylic. · Gallery
- [ActionCard](components/ActionCard.md) — Clickable card with symbol, title, description, and chevron. · Gallery
- [AnnotatedScrollBar](components/AnnotatedScrollBar.md) — Scroll area with a value label on the vertical scrollbar. · Gallery
- [AppBarButton](components/AppBarButton.md) — CommandBar icon button with label position overrides. · Gallery
- [AppBarSeparator](components/AppBarSeparator.md) — Thin separator for CommandBar / AppBar rows. · Gallery
- [AppBarToggleButton](components/AppBarToggleButton.md) — Checkable AppBarButton for CommandBar. · Gallery
- [ArcGauge](components/ArcGauge.md) — Open-arc dashboard gauge with center value and thresholds. · Gallery
- [AreaChart](components/AreaChart.md) — Filled area chart with legend and hover crosshair. · Gallery
- [AutoSuggestBox](components/AutoSuggestBox.md) — Text field with filtered suggestion popup. · Gallery
- [AvatarGroup](components/AvatarGroup.md) — Overlapping PersonPicture stack with overflow count. · Gallery
- [BarChart](components/BarChart.md) — Vertical bar chart with reveal animation. · Gallery
- [BlankWindow](components/BlankWindow.md) — Empty ShellWindow client — declare UI as children.
- [BreadcrumbBar](components/BreadcrumbBar.md) — Path trail; model items raise itemClicked. · Gallery
- [BulletChart](components/BulletChart.md) — Compact KPI bullet (ranges + performance + target). · Gallery
- [CalendarDatePicker](components/CalendarDatePicker.md) — Date field with calendar flyout. · Gallery
- [ChartCard](components/ChartCard.md) — Title/subtitle chrome around a chart child. · Gallery
- [ChartLegend](components/ChartLegend.md) — Fluent legend for series/slices.
- [Chip](components/Chip.md) — Compact selectable tag; optional close affordance. · Gallery
- [ChipGroup](components/ChipGroup.md) — Horizontal chip group for filters / single select. · Gallery
- [ColorPicker](components/ColorPicker.md) — Spectrum + RGB/Hex color editor. · Gallery
- [ColorPickerButton](components/ColorPickerButton.md) — Color swatch button that opens ColorPicker. · Gallery
- [CommandBar](components/CommandBar.md) — Primary/secondary command row (AppBar host). · Gallery
- [CommandBarFlyout](components/CommandBarFlyout.md) — Popup CommandBar with primary + secondary commands. · Gallery
- [CommandPalette](components/CommandPalette.md) — Ctrl+K style command launcher (fuzzy filter + keyboard). · Gallery
- [CompactOverlayShellWindow](components/CompactOverlayShellWindow.md) — Always-on-top compact overlay shell.
- [ConnectedAnimation](components/ConnectedAnimation.md) — Shared-element style morph between two items (same window). · Gallery
- [ConnectedAnimationService](components/ConnectedAnimationService.md) — Register shared-element keys and play list→detail morphs.
- [ContentCard](components/ContentCard.md) — Surface card with title, subtitle, symbol, and body slot. · Gallery
- [ContentDialog](components/ContentDialog.md) — Modal dialog with primary / secondary / close actions. · Gallery
- [ContentDialogQueue](components/ContentDialogQueue.md) — Singleton queue so ContentDialogs open one at a time.
- [ContentThemeTransition](components/ContentThemeTransition.md) — Cross-fade + slight horizontal shift when swapping content.
- [CopyButton](components/CopyButton.md) — Copies textToCopy and flashes a success glyph. · Gallery
- [DataTable](components/DataTable.md) — Fluent virtualizing table with sort, filter, resize, and keyboard. · Gallery
- [DatePicker](components/DatePicker.md) — Date selectors (year / month / day). · Gallery
- [DetailRow](components/DetailRow.md) — Compact label / value row for forms and settings summaries.
- [DialogShellWindow](components/DialogShellWindow.md) — ShellWindow with dialog paradigm flags.
- [DockPanel](components/DockPanel.md) — Dock children Top/Bottom/Left/Right/Fill. · Gallery
- [DonutChart](components/DonutChart.md) — Donut chart with hover and legend. · Gallery
- [DropDownButton](components/DropDownButton.md) — Button that opens a MenuFlyout of actions. · Gallery
- [EmptyState](components/EmptyState.md) — Placeholder illustration + title + optional action. · Gallery
- [EntranceThemeTransition](components/EntranceThemeTransition.md) — WinUI-style page / section entrance (fade + rise + scale). · Gallery
- [Expander](components/Expander.md) — Collapsible header with expandable content. · Gallery
- [FileDropZone](components/FileDropZone.md) — Drag-and-drop target with Fluent empty chrome. · Gallery
- [FlipView](components/FlipView.md) — Page carousel with optional navigation buttons. · Gallery
- [Flyout](components/Flyout.md) — Light-dismiss popup anchored to a target. · Gallery
- [FontIcon](components/FontIcon.md) — FluentIcons glyph as Text. · Gallery
- [FormLayout](components/FormLayout.md) — Vertical form stack that collects field errorMessage values.
- [GridTile](components/GridTile.md) — Icon + title tile for launchers / galleries. · Gallery
- [HeaderedComboBox](components/HeaderedComboBox.md) — ComboBox with header, description, and FormLayout binding. · Gallery
- [HeaderedContentControl](components/HeaderedContentControl.md) — Labeled content host. · Gallery
- [HeaderedTextBox](components/HeaderedTextBox.md) — TextBox with header and description. · Gallery
- [HeatmapChart](components/HeatmapChart.md) — Heatmap matrix chart. · Gallery
- [HorizontalBarChart](components/HorizontalBarChart.md) — Horizontal bar chart. · Gallery
- [HyperlinkButton](components/HyperlinkButton.md) — Link-styled button. · Gallery
- [IconButton](components/IconButton.md) — Icon-only button helper. · Gallery
- [IconicButton](components/IconicButton.md) — Base icon + label button used by AppBar* / IconButton. · Gallery
- [InfoBadge](components/InfoBadge.md) — Count / status / glyph badge. · Gallery
- [InfoBar](components/InfoBar.md) — Inline severity banner with optional action and Content slot. · Gallery
- [InfoBarHost](components/InfoBarHost.md) — Stacks InfoBars in a host region. · Gallery
- [InfoButton](components/InfoButton.md) — Icon button that opens a TeachingTip. · Gallery
- [ItemsRepeater](components/ItemsRepeater.md) — Thin WinUI-style virtualizing repeater over ListView. · Gallery
- [ItemsView](components/ItemsView.md) — ListView recipe: sections, selection, context MenuFlyout, EmptyState. · Gallery
- [KeyChordVisual](components/KeyChordVisual.md) — Renders Ctrl+K style shortcuts as KeyVisuals.
- [KeyVisual](components/KeyVisual.md) — Single keyboard key chrome. · Gallery
- [KpiTile](components/KpiTile.md) — Compact dashboard KPI tile with optional delta and spark trend. · Gallery
- [LinearGauge](components/LinearGauge.md) — Horizontal/vertical track gauge with thresholds. · Gallery
- [LineChart](components/LineChart.md) — Multi-series line/area chart. · Gallery
- [ListDetailsView](components/ListDetailsView.md) — Master–detail recipe on TwoPaneView. · Gallery
- [ListTile](components/ListTile.md) — List row: leading, title, subtitle, trailing. · Gallery
- [MediaPlayerElement](components/MediaPlayerElement.md) — Fluent shell around Qt Multimedia MediaPlayer / VideoOutput. · Gallery
- [MenuFlyout](components/MenuFlyout.md) — Elevated Menu with showAt / isOpen helpers. · Gallery
- [MenuFlyoutHeader](components/MenuFlyoutHeader.md) — Non-interactive MenuFlyout section header.
- [MenuFlyoutItem](components/MenuFlyoutItem.md) — Menu row with glyph and accelerator text. · Gallery
- [MenuFlyoutSeparator](components/MenuFlyoutSeparator.md) — MenuFlyout divider.
- [MenuStatusWindow](components/MenuStatusWindow.md) — TitleBar + MenuBar + content + StatusBar shell.
- [MetadataControl](components/MetadataControl.md) — Stacked or flowed label/value metadata block. · Gallery
- [MetadataItem](components/MetadataItem.md) — One label/value pair for MetadataControl.
- [MeterBar](components/MeterBar.md) — Multi-segment stacked meter (e.g. disk usage). · Gallery
- [MultiSelectComboBox](components/MultiSelectComboBox.md) — Combo that keeps the popup open for multi-select. · Gallery
- [NavigationView](components/NavigationView.md) — WinUI NavigationView with pane modes and page stack. · Gallery
- [NavigationWindow](components/NavigationWindow.md) — ShellWindow hosting NavigationView + content.
- [NotificationBridge](components/NotificationBridge.md) — Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal). · Gallery
- [NumberBox](components/NumberBox.md) — Numeric spin/edit with validation (WinUI AcceptsExpression / IsWrapEnabled). · Gallery
- [PagerControl](components/PagerControl.md) — Numbered page navigation (prev / numbers / next). · Gallery
- [PasswordBox](components/PasswordBox.md) — Password field with reveal toggle. · Gallery
- [PersonPicture](components/PersonPicture.md) — Avatar from image or initials (WinUI IsGroup / BadgeImageSource). · Gallery
- [PieChart](components/PieChart.md) — Pie chart with legend. · Gallery
- [PipsPager](components/PipsPager.md) — Dot pager for carousels. · Gallery
- [Pivot](components/Pivot.md) — Header tabs with sliding underline and pages. · Gallery
- [ProgressButton](components/ProgressButton.md) — Button with inline determinate/indeterminate fill. · Gallery
- [ProgressRing](components/ProgressRing.md) — Circular progress / busy ring (WinUI Minimum / Maximum / IsActive). · Gallery
- [RadarChart](components/RadarChart.md) — Radar / spider chart. · Gallery
- [RadialGauge](components/RadialGauge.md) — Toolkit-style circular needle gauge (CommunityToolkit.WinUI.Controls.RadialGauge). · Gallery
- [RadioButtons](components/RadioButtons.md) — Grouped radio options from a model (WinUI RadioButtons). · Gallery
- [RadioMenuFlyoutItem](components/RadioMenuFlyoutItem.md) — Exclusive radio MenuFlyout item.
- [RatingControl](components/RatingControl.md) — Star rating; stepSize supports halves (WinUI InitialSetValue / ItemInfo). · Gallery
- [RefreshContainer](components/RefreshContainer.md) — Pull-to-refresh host for flickable content. · Gallery
- [RelativePanel](components/RelativePanel.md) — Constraint-based relative layout. · Gallery
- [RepositionThemeTransition](components/RepositionThemeTransition.md) — Animate this item when its layout x/y change.
- [RingGauge](components/RingGauge.md) — Closed-ring dashboard gauge with center value and thresholds. · Gallery
- [ScatterChart](components/ScatterChart.md) — Scatter / bubble chart. · Gallery
- [SearchBox](components/SearchBox.md) — Search field with suggestion list. · Gallery
- [SegmentedControl](components/SegmentedControl.md) — Mutually exclusive segment buttons. · Gallery
- [SegmentedGauge](components/SegmentedGauge.md) — Segmented progress / capacity gauge. · Gallery
- [SelectorBar](components/SelectorBar.md) — Compact horizontal item selector. · Gallery
- [SettingsCard](components/SettingsCard.md) — Settings row: icon, title, description, action (Toolkit ContentAlignment). · Gallery
- [SettingsComboCard](components/SettingsComboCard.md) — SettingsCard with a built-in ComboBox action.
- [SettingsExpander](components/SettingsExpander.md) — Expandable settings group. · Gallery
- [SettingsGroup](components/SettingsGroup.md) — Section header + card stack for settings pages. · Gallery
- [SettingsSliderCard](components/SettingsSliderCard.md) — SettingsCard with a built-in value Slider action.
- [SettingsToggleCard](components/SettingsToggleCard.md) — Convenience alias for SettingsCard { toggle: true }.
- [SettingsView](components/SettingsView.md) — Scrollable settings host (title + padded column).
- [ShellWindow](components/ShellWindow.md) — Independent ApplicationWindow + WindowChrome host.
- [Shimmer](components/Shimmer.md) — Skeleton shimmer placeholder. · Gallery
- [Sparkline](components/Sparkline.md) — Inline mini line chart. · Gallery
- [SplitButton](components/SplitButton.md) — Primary action + chevron menu. · Gallery
- [StackedBarChart](components/StackedBarChart.md) — Stacked bar chart. · Gallery
- [StackPanel](components/StackPanel.md) — Simple stack layout (orientation + spacing). · Gallery
- [StatusBar](components/StatusBar.md) — Window status strip with progress and slots. · Gallery
- [StatusDot](components/StatusDot.md) — Colored status indicator dot. · Gallery
- [StepBar](components/StepBar.md) — Horizontal step / wizard progress. · Gallery
- [SwipeAction](components/SwipeAction.md) — Action revealed by SwipeControl.
- [SwipeControl](components/SwipeControl.md) — Swipe-to-reveal actions on content. · Gallery
- [SwitchCase](components/SwitchCase.md) — Case child for SwitchPresenter.
- [SwitchPresenter](components/SwitchPresenter.md) — Shows the SwitchCase matching value. · Gallery
- [TabView](components/TabView.md) — Closeable / reorderable / tear-out tabs. · Gallery
- [TabViewTearOutWindow](components/TabViewTearOutWindow.md) — Host window for a torn-out TabView tab.
- [TankGauge](components/TankGauge.md) — Vertical / horizontal tank / reservoir level gauge. · Gallery
- [TeachingTip](components/TeachingTip.md) — Anchored tip with title, subtitle, content, and actions. · Gallery
- [TextBlock](components/TextBlock.md) — Fluent typography styles (title, body, caption…). · Gallery
- [ThermometerGauge](components/ThermometerGauge.md) — Classic bulb + stem temperature / level gauge. · Gallery
- [Timeline](components/Timeline.md) — Vertical event timeline. · Gallery
- [TimePicker](components/TimePicker.md) — Hour / minute (and period) selectors. · Gallery
- [TitleBar](components/TitleBar.md) — WinUI TitleBar content chrome (not caption buttons). · Gallery
- [Toast](components/Toast.md) — Transient toast item. · Gallery
- [ToastHost](components/ToastHost.md) — Hosts stacked Toasts with WinUI-style corner placement. · Gallery
- [ToggleButton](components/ToggleButton.md) — Checkable button with Fluent chrome. · Gallery
- [ToggleMenuFlyoutItem](components/ToggleMenuFlyoutItem.md) — Checkable MenuFlyout item.
- [ToggleSplitButton](components/ToggleSplitButton.md) — Toggle primary + menu SplitButton. · Gallery
- [TokenizingTextBox](components/TokenizingTextBox.md) — Token chips + text input. · Gallery
- [ToolShellWindow](components/ToolShellWindow.md) — ShellWindow with tool paradigm.
- [TwoPaneView](components/TwoPaneView.md) — Responsive dual-pane layout. · Gallery
- [UniformGrid](components/UniformGrid.md) — Even cell grid. · Gallery
- [ValidationSummary](components/ValidationSummary.md) — Lists form-level validation errors (pairs with FormLayout).
- [WaterfallChart](components/WaterfallChart.md) — Waterfall chart. · Gallery
- [WrapPanel](components/WrapPanel.md) — Flow / wrap layout. · Gallery
- [ZoneGauge](components/ZoneGauge.md) — Gauge with colored zones. · Gallery

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
- [BusyIndicator](components/BusyIndicator.md) — Fluent styled BusyIndicator. · Gallery
- [Button](components/Button.md) — Fluent Button with WinUI stroke / fill / focus chrome. · Gallery
- [CheckBox](components/CheckBox.md) — Fluent styled CheckBox. · Gallery
- [CheckDelegate](components/CheckDelegate.md) — Fluent styled CheckDelegate.
- [ComboBox](components/ComboBox.md) — Fluent ComboBox with rotating chevron indicator. · Gallery
- [DayOfWeekRow](components/DayOfWeekRow.md) — Fluent styled DayOfWeekRow.
- [DelayButton](components/DelayButton.md) — Fluent styled DelayButton.
- [Dial](components/Dial.md) — Fluent Dial with WinUI arc track and accent thumb. · Gallery
- [Dialog](components/Dialog.md) — Fluent styled Dialog. · Gallery
- [DialogButtonBox](components/DialogButtonBox.md) — Fluent styled DialogButtonBox.
- [Drawer](components/Drawer.md) — Fluent styled Drawer. · Gallery
- [Frame](components/Frame.md) — Fluent styled Frame. · Gallery
- [GroupBox](components/GroupBox.md) — Fluent styled GroupBox. · Gallery
- [HorizontalHeaderView](components/HorizontalHeaderView.md) — Fluent styled HorizontalHeaderView.
- [ItemDelegate](components/ItemDelegate.md) — Fluent styled ItemDelegate.
- [Label](components/Label.md) — Fluent styled Label. · Gallery
- [Menu](components/Menu.md) — Fluent styled Menu. · Gallery
- [MenuBar](components/MenuBar.md) — Fluent styled MenuBar. · Gallery
- [MenuBarItem](components/MenuBarItem.md) — Fluent styled MenuBarItem.
- [MenuItem](components/MenuItem.md) — Fluent styled MenuItem.
- [MenuSeparator](components/MenuSeparator.md) — Fluent styled MenuSeparator.
- [MonthGrid](components/MonthGrid.md) — Fluent calendar month grid for DatePicker / CalendarDatePicker.
- [Page](components/Page.md) — Fluent styled Page.
- [PageIndicator](components/PageIndicator.md) — Fluent styled PageIndicator. · Gallery
- [Pane](components/Pane.md) — Fluent styled Pane. · Gallery
- [Popup](components/Popup.md) — Fluent styled Popup chrome.
- [ProgressBar](components/ProgressBar.md) — Fluent styled ProgressBar (WinUI ShowError / ShowPaused). · Gallery
- [RadioButton](components/RadioButton.md) — Fluent styled RadioButton. · Gallery
- [RadioDelegate](components/RadioDelegate.md) — Fluent styled RadioDelegate.
- [RangeSlider](components/RangeSlider.md) — Fluent styled RangeSlider. · Gallery
- [RoundButton](components/RoundButton.md) — Fluent styled RoundButton.
- [ScrollBar](components/ScrollBar.md) — Fluent styled ScrollBar. · Gallery
- [ScrollIndicator](components/ScrollIndicator.md) — Fluent styled ScrollIndicator.
- [ScrollView](components/ScrollView.md) — Fluent styled ScrollView.
- [Slider](components/Slider.md) — Fluent styled Slider. · Gallery
- [SpinBox](components/SpinBox.md) — Fluent styled SpinBox. · Gallery
- [SplitView](components/SplitView.md) — Fluent styled SplitView. · Gallery
- [StackView](components/StackView.md) — Fluent styled StackView. · Gallery
- [SwipeDelegate](components/SwipeDelegate.md) — Fluent styled SwipeDelegate. · Gallery
- [SwipeView](components/SwipeView.md) — Fluent styled SwipeView. · Gallery
- [Switch](components/Switch.md) — Fluent styled Switch (WinUI ToggleSwitch OnContent / OffContent). · Gallery
- [SwitchDelegate](components/SwitchDelegate.md) — Fluent styled SwitchDelegate.
- [TabBar](components/TabBar.md) — Fluent styled TabBar. · Gallery
- [TabButton](components/TabButton.md) — Fluent styled TabButton.
- [TextArea](components/TextArea.md) — Fluent styled TextArea. · Gallery
- [TextField](components/TextField.md) — Fluent styled TextField. · Gallery
- [ToolBar](components/ToolBar.md) — Fluent styled ToolBar. · Gallery
- [ToolButton](components/ToolButton.md) — Fluent styled ToolButton.
- [ToolSeparator](components/ToolSeparator.md) — Fluent styled ToolSeparator.
- [ToolTip](components/ToolTip.md) — Fluent styled ToolTip. · Gallery
- [TreeViewDelegate](components/TreeViewDelegate.md) — Fluent TreeView row with chevron expand / indent.
- [Tumbler](components/Tumbler.md) — Fluent styled Tumbler. · Gallery
- [VerticalHeaderView](components/VerticalHeaderView.md) — Fluent styled VerticalHeaderView.

## By category

### Buttons & commands

- [AccentButton](components/AccentButton.md) — `QWinUI3.Extras`
- [AppBarButton](components/AppBarButton.md) — `QWinUI3.Extras`
- [AppBarSeparator](components/AppBarSeparator.md) — `QWinUI3.Extras`
- [AppBarToggleButton](components/AppBarToggleButton.md) — `QWinUI3.Extras`
- [ColorPickerButton](components/ColorPickerButton.md) — `QWinUI3.Extras`
- [CommandBar](components/CommandBar.md) — `QWinUI3.Extras`
- [CommandBarFlyout](components/CommandBarFlyout.md) — `QWinUI3.Extras`
- [CommandPalette](components/CommandPalette.md) — `QWinUI3.Extras`
- [CopyButton](components/CopyButton.md) — `QWinUI3.Extras`
- [DropDownButton](components/DropDownButton.md) — `QWinUI3.Extras`
- [HyperlinkButton](components/HyperlinkButton.md) — `QWinUI3.Extras`
- [IconButton](components/IconButton.md) — `QWinUI3.Extras`
- [IconicButton](components/IconicButton.md) — `QWinUI3.Extras`
- [InfoButton](components/InfoButton.md) — `QWinUI3.Extras`
- [ProgressButton](components/ProgressButton.md) — `QWinUI3.Extras`
- [RadioButtons](components/RadioButtons.md) — `QWinUI3.Extras`
- [SplitButton](components/SplitButton.md) — `QWinUI3.Extras`
- [ToggleButton](components/ToggleButton.md) — `QWinUI3.Extras`
- [ToggleSplitButton](components/ToggleSplitButton.md) — `QWinUI3.Extras`

### Charts & gauges

- [ArcGauge](components/ArcGauge.md) — `QWinUI3.Extras`
- [AreaChart](components/AreaChart.md) — `QWinUI3.Extras`
- [BarChart](components/BarChart.md) — `QWinUI3.Extras`
- [BulletChart](components/BulletChart.md) — `QWinUI3.Extras`
- [ChartCard](components/ChartCard.md) — `QWinUI3.Extras`
- [ChartLegend](components/ChartLegend.md) — `QWinUI3.Extras`
- [DonutChart](components/DonutChart.md) — `QWinUI3.Extras`
- [HeatmapChart](components/HeatmapChart.md) — `QWinUI3.Extras`
- [HorizontalBarChart](components/HorizontalBarChart.md) — `QWinUI3.Extras`
- [KpiTile](components/KpiTile.md) — `QWinUI3.Extras`
- [LineChart](components/LineChart.md) — `QWinUI3.Extras`
- [LinearGauge](components/LinearGauge.md) — `QWinUI3.Extras`
- [PieChart](components/PieChart.md) — `QWinUI3.Extras`
- [RadarChart](components/RadarChart.md) — `QWinUI3.Extras`
- [RingGauge](components/RingGauge.md) — `QWinUI3.Extras`
- [ScatterChart](components/ScatterChart.md) — `QWinUI3.Extras`
- [SegmentedGauge](components/SegmentedGauge.md) — `QWinUI3.Extras`
- [Sparkline](components/Sparkline.md) — `QWinUI3.Extras`
- [StackedBarChart](components/StackedBarChart.md) — `QWinUI3.Extras`
- [TankGauge](components/TankGauge.md) — `QWinUI3.Extras`
- [ThermometerGauge](components/ThermometerGauge.md) — `QWinUI3.Extras`
- [WaterfallChart](components/WaterfallChart.md) — `QWinUI3.Extras`
- [ZoneGauge](components/ZoneGauge.md) — `QWinUI3.Extras`

### Collections & data

- [AvatarGroup](components/AvatarGroup.md) — `QWinUI3.Extras`
- [Chip](components/Chip.md) — `QWinUI3.Extras`
- [ChipGroup](components/ChipGroup.md) — `QWinUI3.Extras`
- [DataTable](components/DataTable.md) — `QWinUI3.Extras`
- [DetailRow](components/DetailRow.md) — `QWinUI3.Extras`
- [GridTile](components/GridTile.md) — `QWinUI3.Extras`
- [ItemsRepeater](components/ItemsRepeater.md) — `QWinUI3.Extras`
- [ItemsView](components/ItemsView.md) — `QWinUI3.Extras`
- [ListDetailsView](components/ListDetailsView.md) — `QWinUI3.Extras`
- [ListTile](components/ListTile.md) — `QWinUI3.Extras`
- [PersonPicture](components/PersonPicture.md) — `QWinUI3.Extras`
- [Timeline](components/Timeline.md) — `QWinUI3.Extras`

### Date & time

- [CalendarDatePicker](components/CalendarDatePicker.md) — `QWinUI3.Extras`
- [DatePicker](components/DatePicker.md) — `QWinUI3.Extras`
- [TimePicker](components/TimePicker.md) — `QWinUI3.Extras`

### Dialogs & flyouts

- [Flyout](components/Flyout.md) — `QWinUI3.Extras`
- [InfoBar](components/InfoBar.md) — `QWinUI3.Extras`
- [InfoBarHost](components/InfoBarHost.md) — `QWinUI3.Extras`
- [MenuFlyout](components/MenuFlyout.md) — `QWinUI3.Extras`
- [MenuFlyoutHeader](components/MenuFlyoutHeader.md) — `QWinUI3.Extras`
- [MenuFlyoutItem](components/MenuFlyoutItem.md) — `QWinUI3.Extras`
- [MenuFlyoutSeparator](components/MenuFlyoutSeparator.md) — `QWinUI3.Extras`
- [TeachingTip](components/TeachingTip.md) — `QWinUI3.Extras`
- [Toast](components/Toast.md) — `QWinUI3.Extras`
- [ToastHost](components/ToastHost.md) — `QWinUI3.Extras`
- [ToggleMenuFlyoutItem](components/ToggleMenuFlyoutItem.md) — `QWinUI3.Extras`

### Input & forms

- [AutoSuggestBox](components/AutoSuggestBox.md) — `QWinUI3.Extras`
- [ColorPicker](components/ColorPicker.md) — `QWinUI3.Extras`
- [ContentDialog](components/ContentDialog.md) — `QWinUI3.Extras`
- [ContentDialogQueue](components/ContentDialogQueue.md) — `QWinUI3.Extras`
- [FormLayout](components/FormLayout.md) — `QWinUI3.Extras`
- [HeaderedComboBox](components/HeaderedComboBox.md) — `QWinUI3.Extras`
- [HeaderedContentControl](components/HeaderedContentControl.md) — `QWinUI3.Extras`
- [HeaderedTextBox](components/HeaderedTextBox.md) — `QWinUI3.Extras`
- [MultiSelectComboBox](components/MultiSelectComboBox.md) — `QWinUI3.Extras`
- [NumberBox](components/NumberBox.md) — `QWinUI3.Extras`
- [PasswordBox](components/PasswordBox.md) — `QWinUI3.Extras`
- [RadialGauge](components/RadialGauge.md) — `QWinUI3.Extras`
- [RadioMenuFlyoutItem](components/RadioMenuFlyoutItem.md) — `QWinUI3.Extras`
- [RatingControl](components/RatingControl.md) — `QWinUI3.Extras`
- [SearchBox](components/SearchBox.md) — `QWinUI3.Extras`
- [SettingsComboCard](components/SettingsComboCard.md) — `QWinUI3.Extras`
- [SettingsSliderCard](components/SettingsSliderCard.md) — `QWinUI3.Extras`
- [SwitchCase](components/SwitchCase.md) — `QWinUI3.Extras`
- [SwitchPresenter](components/SwitchPresenter.md) — `QWinUI3.Extras`
- [TextBlock](components/TextBlock.md) — `QWinUI3.Extras`
- [TokenizingTextBox](components/TokenizingTextBox.md) — `QWinUI3.Extras`
- [UniformGrid](components/UniformGrid.md) — `QWinUI3.Extras`
- [ValidationSummary](components/ValidationSummary.md) — `QWinUI3.Extras`

### Layout

- [AcrylicSurface](components/AcrylicSurface.md) — `QWinUI3.Extras`
- [ActionCard](components/ActionCard.md) — `QWinUI3.Extras`
- [ContentCard](components/ContentCard.md) — `QWinUI3.Extras`
- [DockPanel](components/DockPanel.md) — `QWinUI3.Extras`
- [RelativePanel](components/RelativePanel.md) — `QWinUI3.Extras`
- [SettingsCard](components/SettingsCard.md) — `QWinUI3.Extras`
- [SettingsExpander](components/SettingsExpander.md) — `QWinUI3.Extras`
- [SettingsGroup](components/SettingsGroup.md) — `QWinUI3.Extras`
- [SettingsToggleCard](components/SettingsToggleCard.md) — `QWinUI3.Extras`
- [SettingsView](components/SettingsView.md) — `QWinUI3.Extras`
- [StackPanel](components/StackPanel.md) — `QWinUI3.Extras`
- [TwoPaneView](components/TwoPaneView.md) — `QWinUI3.Extras`
- [WrapPanel](components/WrapPanel.md) — `QWinUI3.Extras`

### Media & platform

- [ConnectedAnimation](components/ConnectedAnimation.md) — `QWinUI3.Extras`
- [ConnectedAnimationService](components/ConnectedAnimationService.md) — `QWinUI3.Extras`
- [ContentThemeTransition](components/ContentThemeTransition.md) — `QWinUI3.Extras`
- [EntranceThemeTransition](components/EntranceThemeTransition.md) — `QWinUI3.Extras`
- [FileDropZone](components/FileDropZone.md) — `QWinUI3.Extras`
- [FontIcon](components/FontIcon.md) — `QWinUI3.Extras`
- [MediaPlayerElement](components/MediaPlayerElement.md) — `QWinUI3.Extras`
- [RepositionThemeTransition](components/RepositionThemeTransition.md) — `QWinUI3.Extras`

### Navigation

- [BreadcrumbBar](components/BreadcrumbBar.md) — `QWinUI3.Extras`
- [NavigationView](components/NavigationView.md) — `QWinUI3.Extras`
- [PagerControl](components/PagerControl.md) — `QWinUI3.Extras`
- [PipsPager](components/PipsPager.md) — `QWinUI3.Extras`
- [Pivot](components/Pivot.md) — `QWinUI3.Extras`
- [SelectorBar](components/SelectorBar.md) — `QWinUI3.Extras`
- [TabView](components/TabView.md) — `QWinUI3.Extras`

### Other

- [AnnotatedScrollBar](components/AnnotatedScrollBar.md) — `QWinUI3.Extras`
- [Expander](components/Expander.md) — `QWinUI3.Extras`
- [FlipView](components/FlipView.md) — `QWinUI3.Extras`
- [KeyChordVisual](components/KeyChordVisual.md) — `QWinUI3.Extras`
- [KeyVisual](components/KeyVisual.md) — `QWinUI3.Extras`
- [MetadataControl](components/MetadataControl.md) — `QWinUI3.Extras`
- [MetadataItem](components/MetadataItem.md) — `QWinUI3.Extras`
- [RefreshContainer](components/RefreshContainer.md) — `QWinUI3.Extras`
- [SegmentedControl](components/SegmentedControl.md) — `QWinUI3.Extras`
- [SwipeAction](components/SwipeAction.md) — `QWinUI3.Extras`
- [SwipeControl](components/SwipeControl.md) — `QWinUI3.Extras`

### Platform

- [CompactOverlayWindow](components/CompactOverlayWindow.md) — `QWinUI3.Platform`
- [DialogWindow](components/DialogWindow.md) — `QWinUI3.Platform`
- [PlatformTitleBar](components/PlatformTitleBar.md) — `QWinUI3.Platform`
- [StandardWindow](components/StandardWindow.md) — `QWinUI3.Platform`
- [ToolWindow](components/ToolWindow.md) — `QWinUI3.Platform`

### Shells & windows

- [BlankWindow](components/BlankWindow.md) — `QWinUI3.Extras`
- [CompactOverlayShellWindow](components/CompactOverlayShellWindow.md) — `QWinUI3.Extras`
- [DialogShellWindow](components/DialogShellWindow.md) — `QWinUI3.Extras`
- [MenuStatusWindow](components/MenuStatusWindow.md) — `QWinUI3.Extras`
- [NavigationWindow](components/NavigationWindow.md) — `QWinUI3.Extras`
- [ShellWindow](components/ShellWindow.md) — `QWinUI3.Extras`
- [TabViewTearOutWindow](components/TabViewTearOutWindow.md) — `QWinUI3.Extras`
- [TitleBar](components/TitleBar.md) — `QWinUI3.Extras`
- [ToolShellWindow](components/ToolShellWindow.md) — `QWinUI3.Extras`

### Status & feedback

- [EmptyState](components/EmptyState.md) — `QWinUI3.Extras`
- [InfoBadge](components/InfoBadge.md) — `QWinUI3.Extras`
- [MeterBar](components/MeterBar.md) — `QWinUI3.Extras`
- [NotificationBridge](components/NotificationBridge.md) — `QWinUI3.Extras`
- [ProgressRing](components/ProgressRing.md) — `QWinUI3.Extras`
- [Shimmer](components/Shimmer.md) — `QWinUI3.Extras`
- [StatusBar](components/StatusBar.md) — `QWinUI3.Extras`
- [StatusDot](components/StatusDot.md) — `QWinUI3.Extras`
- [StepBar](components/StepBar.md) — `QWinUI3.Extras`

### Styled controls

- [ApplicationWindow](components/ApplicationWindow.md) — `QtQuick.Controls.QWinUI3`
- [BusyIndicator](components/BusyIndicator.md) — `QtQuick.Controls.QWinUI3`
- [Button](components/Button.md) — `QtQuick.Controls.QWinUI3`
- [CheckBox](components/CheckBox.md) — `QtQuick.Controls.QWinUI3`
- [CheckDelegate](components/CheckDelegate.md) — `QtQuick.Controls.QWinUI3`
- [ComboBox](components/ComboBox.md) — `QtQuick.Controls.QWinUI3`
- [DayOfWeekRow](components/DayOfWeekRow.md) — `QtQuick.Controls.QWinUI3`
- [DelayButton](components/DelayButton.md) — `QtQuick.Controls.QWinUI3`
- [Dial](components/Dial.md) — `QtQuick.Controls.QWinUI3`
- [Dialog](components/Dialog.md) — `QtQuick.Controls.QWinUI3`
- [DialogButtonBox](components/DialogButtonBox.md) — `QtQuick.Controls.QWinUI3`
- [Drawer](components/Drawer.md) — `QtQuick.Controls.QWinUI3`
- [Frame](components/Frame.md) — `QtQuick.Controls.QWinUI3`
- [GroupBox](components/GroupBox.md) — `QtQuick.Controls.QWinUI3`
- [HorizontalHeaderView](components/HorizontalHeaderView.md) — `QtQuick.Controls.QWinUI3`
- [ItemDelegate](components/ItemDelegate.md) — `QtQuick.Controls.QWinUI3`
- [Label](components/Label.md) — `QtQuick.Controls.QWinUI3`
- [Menu](components/Menu.md) — `QtQuick.Controls.QWinUI3`
- [MenuBar](components/MenuBar.md) — `QtQuick.Controls.QWinUI3`
- [MenuBarItem](components/MenuBarItem.md) — `QtQuick.Controls.QWinUI3`
- [MenuItem](components/MenuItem.md) — `QtQuick.Controls.QWinUI3`
- [MenuSeparator](components/MenuSeparator.md) — `QtQuick.Controls.QWinUI3`
- [MonthGrid](components/MonthGrid.md) — `QtQuick.Controls.QWinUI3`
- [Page](components/Page.md) — `QtQuick.Controls.QWinUI3`
- [PageIndicator](components/PageIndicator.md) — `QtQuick.Controls.QWinUI3`
- [Pane](components/Pane.md) — `QtQuick.Controls.QWinUI3`
- [Popup](components/Popup.md) — `QtQuick.Controls.QWinUI3`
- [ProgressBar](components/ProgressBar.md) — `QtQuick.Controls.QWinUI3`
- [RadioButton](components/RadioButton.md) — `QtQuick.Controls.QWinUI3`
- [RadioDelegate](components/RadioDelegate.md) — `QtQuick.Controls.QWinUI3`
- [RangeSlider](components/RangeSlider.md) — `QtQuick.Controls.QWinUI3`
- [RoundButton](components/RoundButton.md) — `QtQuick.Controls.QWinUI3`
- [ScrollBar](components/ScrollBar.md) — `QtQuick.Controls.QWinUI3`
- [ScrollIndicator](components/ScrollIndicator.md) — `QtQuick.Controls.QWinUI3`
- [ScrollView](components/ScrollView.md) — `QtQuick.Controls.QWinUI3`
- [Slider](components/Slider.md) — `QtQuick.Controls.QWinUI3`
- [SpinBox](components/SpinBox.md) — `QtQuick.Controls.QWinUI3`
- [SplitView](components/SplitView.md) — `QtQuick.Controls.QWinUI3`
- [StackView](components/StackView.md) — `QtQuick.Controls.QWinUI3`
- [SwipeDelegate](components/SwipeDelegate.md) — `QtQuick.Controls.QWinUI3`
- [SwipeView](components/SwipeView.md) — `QtQuick.Controls.QWinUI3`
- [Switch](components/Switch.md) — `QtQuick.Controls.QWinUI3`
- [SwitchDelegate](components/SwitchDelegate.md) — `QtQuick.Controls.QWinUI3`
- [TabBar](components/TabBar.md) — `QtQuick.Controls.QWinUI3`
- [TabButton](components/TabButton.md) — `QtQuick.Controls.QWinUI3`
- [TextArea](components/TextArea.md) — `QtQuick.Controls.QWinUI3`
- [TextField](components/TextField.md) — `QtQuick.Controls.QWinUI3`
- [ToolBar](components/ToolBar.md) — `QtQuick.Controls.QWinUI3`
- [ToolButton](components/ToolButton.md) — `QtQuick.Controls.QWinUI3`
- [ToolSeparator](components/ToolSeparator.md) — `QtQuick.Controls.QWinUI3`
- [ToolTip](components/ToolTip.md) — `QtQuick.Controls.QWinUI3`
- [TreeViewDelegate](components/TreeViewDelegate.md) — `QtQuick.Controls.QWinUI3`
- [Tumbler](components/Tumbler.md) — `QtQuick.Controls.QWinUI3`
- [VerticalHeaderView](components/VerticalHeaderView.md) — `QtQuick.Controls.QWinUI3`

### Theme

- [Theme](components/Theme.md) — `QWinUI3.Theme`

## Internal / support

- [ChartUtils](components/ChartUtils.md) (`QWinUI3.Extras`) — LOD helpers for large chart series.
- [ShellWindowSupport](components/ShellWindowSupport.md) (`QWinUI3.Extras`) — Shared install/presenter glue for ShellWindow.
- [WindowChrome](components/WindowChrome.md) (`QWinUI3.Extras`) — PlatformTitleBar + TitleBar bundle for shells.
- [SelectionPip](components/SelectionPip.md) (`QtQuick.Controls.QWinUI3`) — Navigation selection pip indicator.
- [CaptionButton](components/CaptionButton.md) (`QWinUI3.Platform`) — Native-chrome caption min/max/close button.
- [WindowResizeBorder](components/WindowResizeBorder.md) (`QWinUI3.Platform`) — Non-native resize hit edges.
- [ElevatedChrome](components/ElevatedChrome.md) (`QWinUI3.Theme`) — Shared elevated shadow/border chrome (WinUI-style soft shadow).
- [ElevatedChrome_Simple](components/ElevatedChrome_Simple.md) (`QWinUI3.Theme`) — fallback when QtQuick.Effects is unavailable. Same public API as ElevatedChrome.qml (MultiEffect build); soft shadow omitted.
- [FocusStroke](components/FocusStroke.md) (`QWinUI3.Theme`) — Dual-ring keyboard focus chrome (WinUI / Fluent).
- [IconSource](components/IconSource.md) (`QWinUI3.Theme`) — Resolve FluentIcons symbol or glyph string.

---
*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*
