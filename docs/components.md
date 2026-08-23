# QWinUI3 component API

Library **v2.80**. Generated from CMake ``QML_FILES`` + C++ ``QML_ELEMENT`` types (`scripts/generate_component_docs.py`).
Each control has its own page under `docs/components/`.

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
python scripts/generate_component_docs.py --skip-python
```

**317** public · **14** internal · **210** with Gallery demos · Hub: [docs home](index.md).

## By module

### `QWinUI3.Extras`

- [AccentButton](components/AccentButton.md) — Accent-colored CTA with optional Fluent symbol (2.66 A1 appearances). · Gallery
- [AcrylicSurface](components/AcrylicSurface.md) — Frosted pane; keep translucent under system Mica/Acrylic. · Gallery
- [ActionCard](components/ActionCard.md) — Clickable card with symbol, title, description, and chevron. · Gallery
- [AnimatedIcon](components/AnimatedIcon.md) — Thin state glyph swap (1.53). Not Lottie / WinUI AnimatedIcon parity. · Gallery
- [AnnotatedScrollBar](components/AnnotatedScrollBar.md) — Scroll area with a value label on the vertical scrollbar. · Gallery
- [AppBarButton](components/AppBarButton.md) — CommandBar icon button with label position overrides. · Gallery
- [AppBarPreset](components/AppBarPreset.md) — semantic alias of CommandBarPreset for product shells.
- [AppBarSeparator](components/AppBarSeparator.md) — Thin separator for CommandBar / AppBar rows. · Gallery
- [AppBarToggleButton](components/AppBarToggleButton.md) — Checkable AppBarButton for CommandBar. · Gallery
- [ArcGauge](components/ArcGauge.md) — Open-arc dashboard gauge with center value and thresholds. · Gallery
- [AreaChart](components/AreaChart.md) — Filled area chart with legend and hover crosshair. · Gallery
- [AutomotiveCluster](components/AutomotiveCluster.md) — Composed vehicle instrument cluster. · Gallery
- [AutoSuggestBox](components/AutoSuggestBox.md) — Text field with filtered suggestion popup. · Gallery
- [AvatarGroup](components/AvatarGroup.md) — Overlapping PersonPicture stack with overflow count. · Gallery
- [BandChart](components/BandChart.md) — High/low envelope with an optional mid line. · Gallery
- [BarChart](components/BarChart.md) — Vertical bar chart with reveal animation. · Gallery
- [BatteryGauge](components/BatteryGauge.md) — Battery silhouette with charge fill and optional charging bolt. · Gallery
- [BlankWindow](components/BlankWindow.md) — Empty ShellWindow client — declare UI as children.
- [BoostGauge](components/BoostGauge.md) — Turbo vacuum / boost with zero at center-left of the scale. · Gallery
- [BoxPlotChart](components/BoxPlotChart.md) — Tukey box-and-whisker groups. · Gallery
- [BreadcrumbBar](components/BreadcrumbBar.md) — Path trail; model items raise itemClicked. · Gallery
- [BulletChart](components/BulletChart.md) — Compact KPI bullet (ranges + performance + target). · Gallery
- [CalendarDatePicker](components/CalendarDatePicker.md) — Date field with calendar flyout. · Gallery
- [CalendarView](components/CalendarView.md) — month grid for scheduling / booking surfaces (2.31). · Gallery
- [CandlestickChart](components/CandlestickChart.md) — OHLC candlesticks for professional price series. · Gallery
- [ChartCard](components/ChartCard.md) — Title/subtitle chrome around a chart child. · Gallery
- [ChartEmptyState](components/ChartEmptyState.md) — Fluent empty / loading / error placeholder for ChartCard (2.65).
- [ChartLegend](components/ChartLegend.md) — Fluent legend for series/slices.
- [ChartSeries](components/ChartSeries.md) — Dense numeric series owned in C++ for million-point charts. · Gallery · C++
- [Chip](components/Chip.md) — Compact selectable tag; optional close affordance. · Gallery
- [ChipGroup](components/ChipGroup.md) — Horizontal chip group for filters / single select. · Gallery
- [ColorPicker](components/ColorPicker.md) — Spectrum + RGB/Hex color editor. · Gallery
- [ColorPickerButton](components/ColorPickerButton.md) — Color swatch button that opens ColorPicker. · Gallery
- [ComboChart](components/ComboChart.md) — Bars plus an overlay line (volume vs price). · Gallery
- [CommandBar](components/CommandBar.md) — Primary/secondary command row (AppBar host). · Gallery
- [CommandBarFlyout](components/CommandBarFlyout.md) — Popup CommandBar with primary + secondary commands. · Gallery
- [CommandBarKeyHints](components/CommandBarKeyHints.md) — show keyboardAcceleratorText hints from AppBarButton children.
- [CommandBarPreset](components/CommandBarPreset.md) — product default preset to avoid “looks broken” combos.
- [CommandPalette](components/CommandPalette.md) — Ctrl+K style command launcher (fuzzy filter + keyboard). · Gallery
- [CommandRegistry](components/CommandRegistry.md) — Scoped command store for CommandPalette auto-discovery.
- [CompactOverlayShellWindow](components/CompactOverlayShellWindow.md) — Always-on-top compact overlay shell.
- [CompassGauge](components/CompassGauge.md) — Heading / bearing compass (0–360°, wraparound). · Gallery
- [ConfirmWithReason](components/ConfirmWithReason.md) — ContentDialog with a required reason field (2.79).
- [ConnectedAnimation](components/ConnectedAnimation.md) — Shared-element style morph between two items (same window). · Gallery
- [ConnectedAnimationService](components/ConnectedAnimationService.md) — Register shared-element keys and play list→detail morphs. · singleton
- [ContentCard](components/ContentCard.md) — Surface card with title, subtitle, symbol, and body slot. · Gallery
- [ContentDialog](components/ContentDialog.md) — Modal dialog with primary / secondary / close actions. · Gallery
- [ContentDialogQueue](components/ContentDialogQueue.md) — Singleton queue so ContentDialogs open one at a time. · singleton
- [ContentThemeTransition](components/ContentThemeTransition.md) — Cross-fade + slight horizontal shift when swapping content.
- [ContextMenuAtItem](components/ContextMenuAtItem.md) — helper to open a MenuFlyout from item + mouse.
- [CoolantGauge](components/CoolantGauge.md) — Automotive C–H coolant temperature. · Gallery
- [CopyButton](components/CopyButton.md) — Copies textToCopy and flashes a success glyph. · Gallery
- [CylinderGauge](components/CylinderGauge.md) — Isometric cylinder level. · Gallery
- [DashboardShell](components/DashboardShell.md) — Opinionated dashboard layout host (2.65 Wave A).
- [DataTable](components/DataTable.md) — Fluent virtualizing table with sort, filter, resize, and keyboard. · Gallery
- [DataTableFilterOverlay](components/DataTableFilterOverlay.md) — lightweight filter UI for DataTable.
- [DatePicker](components/DatePicker.md) — Date selectors (year / month / day). · Gallery
- [DetailRow](components/DetailRow.md) — Compact label / value row for forms and settings summaries.
- [DialogShellWindow](components/DialogShellWindow.md) — ShellWindow with dialog paradigm flags.
- [DigitGauge](components/DigitGauge.md) — Seven-segment numeric readout. · Gallery
- [DockPanel](components/DockPanel.md) — Dock children Top/Bottom/Left/Right/Fill. · Gallery
- [DonutChart](components/DonutChart.md) — Donut chart with hover and legend. · Gallery
- [DropDownButton](components/DropDownButton.md) — Button that opens a MenuFlyout of actions. · Gallery
- [DualRingGauge](components/DualRingGauge.md) — Two independent concentric KPI rings. · Gallery
- [DumbbellChart](components/DumbbellChart.md) — Before/after pairs on a shared category axis. · Gallery
- [EmptyState](components/EmptyState.md) — Placeholder illustration + title + optional action. · Gallery
- [EntranceThemeTransition](components/EntranceThemeTransition.md) — WinUI-style page / section entrance (fade + rise + scale). · Gallery
- [ErrorBarChart](components/ErrorBarChart.md) — Mean (or value) with ± error whiskers. · Gallery
- [ErrorBoundary](components/ErrorBoundary.md) — Recovery UI for failed page / session loads (2.75).
- [Expander](components/Expander.md) — Collapsible header with expandable content. · Gallery
- [FeedbackSeverity](components/FeedbackSeverity.md) — Shared severity palette + glyphs for InfoBar / Toast / TeachingTip (2.70 A7). · singleton
- [FileDropZone](components/FileDropZone.md) — Drag-and-drop target with Fluent empty chrome. · Gallery
- [FileTree](components/FileTree.md) — Explorer-style folder tree + file metadata table (2.06). · Gallery
- [FlipView](components/FlipView.md) — Page carousel with optional navigation buttons. · Gallery
- [Flyout](components/Flyout.md) — Light-dismiss popup anchored to a target. · Gallery
- [FlyoutKeyboardFocusTrap](components/FlyoutKeyboardFocusTrap.md) — restore keyboard focus after MenuFlyout closes.
- [FontIcon](components/FontIcon.md) — FluentIcons glyph as Text. · Gallery
- [FormLayout](components/FormLayout.md) — Vertical form stack that collects field errorMessage values.
- [FormSection](components/FormSection.md) — Collapsible field group for FormLayout (2.67 D2).
- [FuelGauge](components/FuelGauge.md) — Empty/full arc with E–F marks. · Gallery
- [FunnelChart](components/FunnelChart.md) — Conversion funnel from stage values. · Gallery
- [GearIndicator](components/GearIndicator.md) — PRNDS / manual gear readout for a cluster. · Gallery
- [GeometryAndPrefsGuard](components/GeometryAndPrefsGuard.md) — Warn when ThemeAppearanceSettings.persist=false may surprise users.
- [GMeterGauge](components/GMeterGauge.md) — Lateral / longitudinal G-force plot. · Gallery
- [GridTile](components/GridTile.md) — Icon + title tile for launchers / galleries. · Gallery
- [HeaderedComboBox](components/HeaderedComboBox.md) — ComboBox with header, description, and FormLayout binding. · Gallery
- [HeaderedContentControl](components/HeaderedContentControl.md) — Labeled content host. · Gallery
- [HeaderedTextBox](components/HeaderedTextBox.md) — TextBox with header and description. · Gallery
- [HeatmapChart](components/HeatmapChart.md) — Heatmap matrix chart. · Gallery
- [HistogramChart](components/HistogramChart.md) — Frequency bins from a numeric series. · Gallery
- [HorizontalBarChart](components/HorizontalBarChart.md) — Horizontal bar chart. · Gallery
- [HyperlinkButton](components/HyperlinkButton.md) — Link-styled button. · Gallery
- [IconButton](components/IconButton.md) — Icon-only button helper. · Gallery
- [IconicButton](components/IconicButton.md) — Base icon + label button used by AppBar* / IconButton. · Gallery
- [ImeCandidateBar](components/ImeCandidateBar.md) — Win11-style in-app IME candidate strip (1.74).
- [InfoBadge](components/InfoBadge.md) — Count / status / glyph badge. · Gallery
- [InfoBar](components/InfoBar.md) — Inline severity banner with optional action and Content slot. · Gallery
- [InfoBarHost](components/InfoBarHost.md) — Stacks InfoBars in a host region. · Gallery
- [InfoButton](components/InfoButton.md) — Icon button that opens a TeachingTip. · Gallery
- [ItemsRepeater](components/ItemsRepeater.md) — Thin WinUI-style virtualizing repeater over ListView. · Gallery
- [ItemsView](components/ItemsView.md) — ListView recipe: sections, selection, context MenuFlyout, EmptyState. · Gallery
- [ItemsViewEmptyStateHelper](components/ItemsViewEmptyStateHelper.md) — unify emptyTitle/emptyMessage for filtered lists.
- [ItemsWrapGrid](components/ItemsWrapGrid.md) — model-driven variable-size wrap layout (2.24). · Gallery
- [KeyChordVisual](components/KeyChordVisual.md) — Renders Ctrl+K style shortcuts as KeyVisuals.
- [KeyVisual](components/KeyVisual.md) — Single keyboard key chrome. · Gallery
- [KpiTile](components/KpiTile.md) — Compact dashboard KPI tile with optional delta and spark trend. · Gallery
- [LedRingGauge](components/LedRingGauge.md) — Circular LED / peak-hold ring. · Gallery
- [LinearGauge](components/LinearGauge.md) — Horizontal/vertical track gauge with thresholds. · Gallery
- [LineChart](components/LineChart.md) — Multi-series line/area chart. · Gallery
- [ListDetailsView](components/ListDetailsView.md) — Master–detail recipe on TwoPaneView. · Gallery
- [ListTile](components/ListTile.md) — List row: leading, title, subtitle, trailing. · Gallery
- [LollipopChart](components/LollipopChart.md) — Stem-and-marker chart (compact bar alternative). · Gallery
- [MaskedTextField](components/MaskedTextField.md) — Simple input mask for phone / ID-style patterns (2.71). · Gallery
- [MediaPlayerElement](components/MediaPlayerElement.md) — Fluent shell around Qt Multimedia MediaPlayer / VideoOutput. · Gallery
- [MenuFlyout](components/MenuFlyout.md) — Elevated Menu with showAt / isOpen helpers. · Gallery
- [MenuFlyoutAutoMaxHeight](components/MenuFlyoutAutoMaxHeight.md) — menu max-height computed from host overlay size.
- [MenuFlyoutHeader](components/MenuFlyoutHeader.md) — Non-interactive MenuFlyout section header.
- [MenuFlyoutItem](components/MenuFlyoutItem.md) — Menu row with glyph and accelerator text. · Gallery
- [MenuFlyoutPresenter](components/MenuFlyoutPresenter.md) — product-friendly wrapper for MenuFlyout.
- [MenuFlyoutSeparator](components/MenuFlyoutSeparator.md) — MenuFlyout divider.
- [MenuFlyoutSnapshotModel](components/MenuFlyoutSnapshotModel.md) — Freeze dynamic menu label values at open time.
- [MenuStatusWindow](components/MenuStatusWindow.md) — TitleBar + MenuBar + content + StatusBar shell.
- [MetadataControl](components/MetadataControl.md) — Stacked or flowed label/value metadata block. · Gallery
- [MetadataItem](components/MetadataItem.md) — One label/value pair for MetadataControl.
- [MeterBar](components/MeterBar.md) — Multi-segment stacked meter (e.g. disk usage). · Gallery
- [MetricCompareRow](components/MetricCompareRow.md) — Side-by-side KpiTile row with a shared period caption (2.65).
- [MultiSelectComboBox](components/MultiSelectComboBox.md) — Combo that keeps the popup open for multi-select. · Gallery
- [NavigationView](components/NavigationView.md) — WinUI NavigationView with pane modes and page stack. · Gallery
- [NavigationWindow](components/NavigationWindow.md) — ShellWindow hosting NavigationView + content.
- [NotificationBridge](components/NotificationBridge.md) — Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal). · Gallery
- [NotificationCenter](components/NotificationCenter.md) — In-app notification drawer with grouping (2.27 / 2.63 / 2.70). · Gallery
- [NumberBox](components/NumberBox.md) — Numeric spin/edit with validation (WinUI AcceptsExpression / IsWrapEnabled). · Gallery
- [OdometerGauge](components/OdometerGauge.md) — Total and trip distance. · Gallery
- [OfflineBanner](components/OfflineBanner.md) — InfoBar bound to WindowHelper.isOnline (2.78).
- [OnScreenKeyboard](components/OnScreenKeyboard.md) — Windows 11 touch keyboard parity (1.82). · Gallery
- [OnScreenKeyboardWindow](components/OnScreenKeyboardWindow.md) — floating Win11-style OSK (1.83).
- [OperationRetry](components/OperationRetry.md) — Attempt / retry helpers with exponential backoff (2.78).
- [OskHandwritingPad](components/OskHandwritingPad.md) — Zinnia CLI handwriting panel (Windows + Linux).
- [OskPanelButton](components/OskPanelButton.md) — compact action chip for OSK auxiliary panels.
- [OskSettingsFlyout](components/OskSettingsFlyout.md) — Win11-style keyboard settings (size, voice/handwriting, user lexicon).
- [OskVoiceBar](components/OskVoiceBar.md) — cross-platform speech-to-text strip (Windows System.Speech / Linux whisper|vosk).
- [PagerControl](components/PagerControl.md) — Numbered page navigation (prev / numbers / next). · Gallery
- [ParetoChart](components/ParetoChart.md) — Ranked bars plus cumulative percent line. · Gallery
- [PasswordBox](components/PasswordBox.md) — Password field with reveal toggle. · Gallery
- [PermissionGate](components/PermissionGate.md) — Show/enable children by role (2.71). · Gallery
- [PersonPicture](components/PersonPicture.md) — Avatar from image or initials (WinUI IsGroup / BadgeImageSource). · Gallery
- [PieChart](components/PieChart.md) — Pie chart with legend. · Gallery
- [PipsPager](components/PipsPager.md) — Dot pager for carousels. · Gallery
- [Pivot](components/Pivot.md) — Header tabs with sliding underline and pages. · Gallery
- [PolarAreaChart](components/PolarAreaChart.md) — Coxcomb / polar-area sectors (radius encodes value). · Gallery
- [PressureGauge](components/PressureGauge.md) — Industrial needle with green / caution / red zones. · Gallery
- [ProgressButton](components/ProgressButton.md) — Button with inline determinate/indeterminate fill. · Gallery
- [ProgressRing](components/ProgressRing.md) — Circular progress / busy ring (WinUI Minimum / Maximum / IsActive). · Gallery
- [QuarterGauge](components/QuarterGauge.md) — 90° dashboard quadrant meter. · Gallery
- [RadarChart](components/RadarChart.md) — Radar / spider chart. · Gallery
- [RadialGauge](components/RadialGauge.md) — Toolkit-style circular needle gauge (CommunityToolkit.WinUI.Controls.RadialGauge). · Gallery
- [RadioButtons](components/RadioButtons.md) — Grouped radio options from a model (WinUI RadioButtons). · Gallery
- [RadioMenuFlyoutItem](components/RadioMenuFlyoutItem.md) — Exclusive radio MenuFlyout item.
- [RatingControl](components/RatingControl.md) — Star rating; stepSize supports halves (WinUI InitialSetValue / ItemInfo). · Gallery
- [RatingStars](components/RatingStars.md) — semantic star-rating wrapper around RatingControl.
- [RecentFiles](components/RecentFiles.md) — Persist recent paths in Settings + shell recent docs (2.77). · Gallery
- [RefreshContainer](components/RefreshContainer.md) — Pull-to-refresh host for flickable content. · Gallery
- [RelativePanel](components/RelativePanel.md) — Constraint-based relative layout. · Gallery
- [RepositionThemeTransition](components/RepositionThemeTransition.md) — Animate this item when its layout x/y change.
- [RichEdit](components/RichEdit.md) — Fluent rich-text editor for mail / template / long notes (2.61). · Gallery
- [RightClickAnchorHelper](components/RightClickAnchorHelper.md) — compute global anchor point for right-click menus.
- [RingGauge](components/RingGauge.md) — Closed-ring dashboard gauge with center value and thresholds. · Gallery
- [ScatterChart](components/ScatterChart.md) — Scatter / bubble chart. · Gallery
- [SearchBox](components/SearchBox.md) — Search field with suggestion list. · Gallery
- [SearchBoxRecipe](components/SearchBoxRecipe.md) — standard SearchBox preset for product apps.
- [SegmentedControl](components/SegmentedControl.md) — Mutually exclusive segment buttons. · Gallery
- [SegmentedGauge](components/SegmentedGauge.md) — Segmented progress / capacity gauge. · Gallery
- [SelectorBar](components/SelectorBar.md) — Compact horizontal item selector. · Gallery
- [SemanticZoom](components/SemanticZoom.md) — Shared-selection dual view (grid ↔ index) for contacts / albums (2.62). · Gallery
- [SensitiveField](components/SensitiveField.md) — Masked field with reveal toggle for tokens / secrets (2.79).
- [SessionRestore](components/SessionRestore.md) — Persist window geometry + nav page + table scroll/selection (2.70 D8).
- [SessionTimeout](components/SessionTimeout.md) — Idle timer with warning + timeout signals (2.72).
- [SettingsCard](components/SettingsCard.md) — Settings row: icon, title, description, action (Toolkit ContentAlignment). · Gallery
- [SettingsComboCard](components/SettingsComboCard.md) — SettingsCard with a built-in ComboBox action.
- [SettingsExpander](components/SettingsExpander.md) — Expandable settings group. · Gallery
- [SettingsGroup](components/SettingsGroup.md) — Section header + card stack for settings pages. · Gallery
- [SettingsSliderCard](components/SettingsSliderCard.md) — SettingsCard with a built-in value Slider action.
- [SettingsToggleCard](components/SettingsToggleCard.md) — Convenience alias for SettingsCard { toggle: true }.
- [SettingsView](components/SettingsView.md) — Scrollable settings host (title + padded column).
- [ShellWindow](components/ShellWindow.md) — Independent ApplicationWindow + WindowChrome host.
- [Shimmer](components/Shimmer.md) — Skeleton shimmer placeholder. · Gallery
- [Skeleton](components/Skeleton.md) — Form / table loading placeholder composed of Shimmer lines (2.70 B6).
- [Sparkline](components/Sparkline.md) — Inline mini line chart. · Gallery
- [SpeedometerGauge](components/SpeedometerGauge.md) — Vehicle speed needle (km/h or mph). · Gallery
- [SplitButton](components/SplitButton.md) — Primary action + chevron menu. · Gallery
- [StackedBarChart](components/StackedBarChart.md) — Stacked bar chart. · Gallery
- [StackPanel](components/StackPanel.md) — Simple stack layout (orientation + spacing). · Gallery
- [StandardTitleChrome](components/StandardTitleChrome.md) — PlatformTitleBar + TitleBar with WinUI header slots.
- [StatusBar](components/StatusBar.md) — Window status strip with progress and slots. · Gallery
- [StatusDot](components/StatusDot.md) — Colored status indicator dot. · Gallery
- [StepBar](components/StepBar.md) — Horizontal step / wizard progress. · Gallery
- [SunburstChart](components/SunburstChart.md) — Two-level nested rings. · Gallery
- [SwipeAction](components/SwipeAction.md) — Action revealed by SwipeControl.
- [SwipeControl](components/SwipeControl.md) — Swipe-to-reveal actions on content. · Gallery
- [SwitchCase](components/SwitchCase.md) — Case child for SwitchPresenter.
- [SwitchPresenter](components/SwitchPresenter.md) — Shows the SwitchCase matching value. · Gallery
- [TabView](components/TabView.md) — Closeable / reorderable / tear-out tabs. · Gallery
- [TabViewDropHub](components/TabViewDropHub.md) — same-process registry so torn-out tabs can dock back. · singleton
- [TabViewTearOutWindow](components/TabViewTearOutWindow.md) — Host window for a torn-out TabView tab.
- [TachometerGauge](components/TachometerGauge.md) — RPM-style needle with a redline band. · Gallery
- [TankGauge](components/TankGauge.md) — Vertical / horizontal tank / reservoir level gauge. · Gallery
- [TeachingTip](components/TeachingTip.md) — Anchored tip with title, subtitle, content, and actions. · Gallery
- [TelltaleBar](components/TelltaleBar.md) — Cluster warning / indicator lamps. · Gallery
- [TextBlock](components/TextBlock.md) — Fluent typography styles (title, body, caption…). · Gallery
- [ThemeAppearanceSettings](components/ThemeAppearanceSettings.md) — Drop-in SettingsGroup for Theme knobs (1.69).
- [ThemePersistenceCard](components/ThemePersistenceCard.md) — Product-friendly wrapper for ThemeAppearanceSettings.
- [ThemePrefs](components/ThemePrefs.md) — Persist Theme knobs via QtCore Settings (1.69). · Gallery
- [ThemeSyncCard](components/ThemeSyncCard.md) — Summarize ThemeSync vs ThemePrefs vs persist:false semantics.
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
- [ToolbarOverflowInspector](components/ToolbarOverflowInspector.md) — show live overflow configuration + diagnostics.
- [ToolShellWindow](components/ToolShellWindow.md) — ShellWindow with tool paradigm.
- [TpmsGauge](components/TpmsGauge.md) — Four-corner tire pressure. · Gallery
- [TreeDataGrid](components/TreeDataGrid.md) — hierarchical multi-column grid with sort + filter (2.21). · Gallery
- [TreemapChart](components/TreemapChart.md) — Nested slice-and-dice treemap. · Gallery
- [TwoPaneView](components/TwoPaneView.md) — Responsive dual-pane layout. · Gallery
- [UnifiedSearchSurface](components/UnifiedSearchSurface.md) — unify TitleBar search + Navigation pane search + custom middle search
- [UniformGrid](components/UniformGrid.md) — Even cell grid. · Gallery
- [ValidationSummary](components/ValidationSummary.md) — Lists form-level validation errors (pairs with FormLayout).
- [ViolinChart](components/ViolinChart.md) — Density violin from sample groups. · Gallery
- [VoltageGauge](components/VoltageGauge.md) — 12 V vehicle electrical system. · Gallery
- [VuMeter](components/VuMeter.md) — Linear LED / peak-hold meter (audio, signal, load). · Gallery
- [WaffleChart](components/WaffleChart.md) — 10×10 part-to-whole grid. · Gallery
- [WaterfallChart](components/WaterfallChart.md) — Waterfall chart. · Gallery
- [WindowMessageBus](components/WindowMessageBus.md) — Process-local typed channels between windows (2.72). · singleton
- [Wizard](components/Wizard.md) — Multi-step flow host (StepBar + content + Back/Next). · Gallery
- [WrapPanel](components/WrapPanel.md) — Flow / wrap layout. · Gallery
- [ZoneGauge](components/ZoneGauge.md) — Gauge with colored zones. · Gallery

### `QWinUI3.Platform`

- [CompactOverlayWindow](components/CompactOverlayWindow.md) — StandardWindow compact overlay presenter.
- [DialogWindow](components/DialogWindow.md) — StandardWindow dialog paradigm.
- [FilePicker](components/FilePicker.md) — Native open/save/folder dialogs for QML (no QtQuick.Dialogs). · Gallery · C++ · singleton
- [FrameStatsBadge](components/FrameStatsBadge.md) — compact FPS readout for StandardTitleChrome.rightHeader (PlatformTitleBar slot before caption buttons — not TitleBar.rightHeader).
- [FrameStatsMonitor](components/FrameStatsMonitor.md) — FPS / frame-time / RHI readout for Gallery and retail diagnostics (singleton). · Gallery · C++ · singleton
- [FrameStatsOverlay](components/FrameStatsOverlay.md) — floating FPS badge when not using the title-bar slot.
- [PlatformCapability](components/PlatformCapability.md) — Runtime feature probe (2.67 F1). · singleton
- [PlatformTitleBar](components/PlatformTitleBar.md) — Caption buttons + drag region + TitleBar host.
- [SingleInstance](components/SingleInstance.md) — Opt-in primary/secondary guard (2.74). · C++
- [StandardWindow](components/StandardWindow.md) — Platform ApplicationWindow + PlatformTitleBar host.
- [ThemeSync](components/ThemeSync.md) — Copy OS accessibility / color scheme into Theme knobs.
- [ToolWindow](components/ToolWindow.md) — StandardWindow tool paradigm.
- [TrayIcon](components/TrayIcon.md) — System tray icon + balloon / notify-send bridge. · Gallery · C++
- [WebView2Host](components/WebView2Host.md) — HWND-backed Edge WebView2 under a QQuickItem (Windows only). · Gallery · C++
- [WindowHelper](components/WindowHelper.md) — Platform chrome, backdrop, DPI, and geometry helpers (singleton). · Gallery · C++ · singleton
- [WindowShellContentClip](components/WindowShellContentClip.md) — inset / clip helper for Linux client-shell bottom corners.
- [WindowShellDecoration](components/WindowShellDecoration.md) — Linux / Wayland client shell: DWM-like shadow + rounded frame.

### `QWinUI3.Theme`

- [FluentIcons](components/FluentIcons.md) — Segoe Fluent Icons character class — FluentIcons.Save, FluentIcons.Copy, … Full glyph lists: FluentIconsCatalog singleton (PropertyMap hides child props). · Gallery · C++ · singleton
- [FluentIconsCatalog](components/FluentIconsCatalog.md) — Iconography catalog — separate QML singleton (not on QQmlPropertyMap). · Gallery · C++ · singleton
- [PointerCursor](components/PointerCursor.md) — Hover cursor affordance for styled controls (2.66 M8).
- [Theme](components/Theme.md) — Fluent color / type / motion token singleton. · singleton
- [ThemeFonts](components/ThemeFonts.md) — icon/mono registration + WinUI LanguageFont-style UI stacks. · Gallery · C++ · singleton

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
- [AppBarPreset](components/AppBarPreset.md) — `QWinUI3.Extras`
- [AppBarSeparator](components/AppBarSeparator.md) — `QWinUI3.Extras`
- [AppBarToggleButton](components/AppBarToggleButton.md) — `QWinUI3.Extras`
- [ColorPickerButton](components/ColorPickerButton.md) — `QWinUI3.Extras`
- [CommandBar](components/CommandBar.md) — `QWinUI3.Extras`
- [CommandBarFlyout](components/CommandBarFlyout.md) — `QWinUI3.Extras`
- [CommandBarKeyHints](components/CommandBarKeyHints.md) — `QWinUI3.Extras`
- [CommandBarPreset](components/CommandBarPreset.md) — `QWinUI3.Extras`
- [CommandPalette](components/CommandPalette.md) — `QWinUI3.Extras`
- [CopyButton](components/CopyButton.md) — `QWinUI3.Extras`
- [DropDownButton](components/DropDownButton.md) — `QWinUI3.Extras`
- [HyperlinkButton](components/HyperlinkButton.md) — `QWinUI3.Extras`
- [IconButton](components/IconButton.md) — `QWinUI3.Extras`
- [IconicButton](components/IconicButton.md) — `QWinUI3.Extras`
- [InfoButton](components/InfoButton.md) — `QWinUI3.Extras`
- [OskPanelButton](components/OskPanelButton.md) — `QWinUI3.Extras`
- [ProgressButton](components/ProgressButton.md) — `QWinUI3.Extras`
- [RadioButtons](components/RadioButtons.md) — `QWinUI3.Extras`
- [SplitButton](components/SplitButton.md) — `QWinUI3.Extras`
- [ToggleButton](components/ToggleButton.md) — `QWinUI3.Extras`
- [ToggleSplitButton](components/ToggleSplitButton.md) — `QWinUI3.Extras`

### Charts & gauges

- [ArcGauge](components/ArcGauge.md) — `QWinUI3.Extras`
- [AreaChart](components/AreaChart.md) — `QWinUI3.Extras`
- [AutomotiveCluster](components/AutomotiveCluster.md) — `QWinUI3.Extras`
- [BandChart](components/BandChart.md) — `QWinUI3.Extras`
- [BarChart](components/BarChart.md) — `QWinUI3.Extras`
- [BatteryGauge](components/BatteryGauge.md) — `QWinUI3.Extras`
- [BoostGauge](components/BoostGauge.md) — `QWinUI3.Extras`
- [BoxPlotChart](components/BoxPlotChart.md) — `QWinUI3.Extras`
- [BulletChart](components/BulletChart.md) — `QWinUI3.Extras`
- [CandlestickChart](components/CandlestickChart.md) — `QWinUI3.Extras`
- [ChartCard](components/ChartCard.md) — `QWinUI3.Extras`
- [ChartLegend](components/ChartLegend.md) — `QWinUI3.Extras`
- [ChartSeries](components/ChartSeries.md) — `QWinUI3.Extras`
- [CompassGauge](components/CompassGauge.md) — `QWinUI3.Extras`
- [CoolantGauge](components/CoolantGauge.md) — `QWinUI3.Extras`
- [CylinderGauge](components/CylinderGauge.md) — `QWinUI3.Extras`
- [DigitGauge](components/DigitGauge.md) — `QWinUI3.Extras`
- [DonutChart](components/DonutChart.md) — `QWinUI3.Extras`
- [DualRingGauge](components/DualRingGauge.md) — `QWinUI3.Extras`
- [DumbbellChart](components/DumbbellChart.md) — `QWinUI3.Extras`
- [ErrorBarChart](components/ErrorBarChart.md) — `QWinUI3.Extras`
- [FuelGauge](components/FuelGauge.md) — `QWinUI3.Extras`
- [FunnelChart](components/FunnelChart.md) — `QWinUI3.Extras`
- [GMeterGauge](components/GMeterGauge.md) — `QWinUI3.Extras`
- [GearIndicator](components/GearIndicator.md) — `QWinUI3.Extras`
- [HeatmapChart](components/HeatmapChart.md) — `QWinUI3.Extras`
- [HistogramChart](components/HistogramChart.md) — `QWinUI3.Extras`
- [HorizontalBarChart](components/HorizontalBarChart.md) — `QWinUI3.Extras`
- [KpiTile](components/KpiTile.md) — `QWinUI3.Extras`
- [LedRingGauge](components/LedRingGauge.md) — `QWinUI3.Extras`
- [LineChart](components/LineChart.md) — `QWinUI3.Extras`
- [LinearGauge](components/LinearGauge.md) — `QWinUI3.Extras`
- [LollipopChart](components/LollipopChart.md) — `QWinUI3.Extras`
- [OdometerGauge](components/OdometerGauge.md) — `QWinUI3.Extras`
- [ParetoChart](components/ParetoChart.md) — `QWinUI3.Extras`
- [PieChart](components/PieChart.md) — `QWinUI3.Extras`
- [PolarAreaChart](components/PolarAreaChart.md) — `QWinUI3.Extras`
- [PressureGauge](components/PressureGauge.md) — `QWinUI3.Extras`
- [QuarterGauge](components/QuarterGauge.md) — `QWinUI3.Extras`
- [RadarChart](components/RadarChart.md) — `QWinUI3.Extras`
- [RingGauge](components/RingGauge.md) — `QWinUI3.Extras`
- [ScatterChart](components/ScatterChart.md) — `QWinUI3.Extras`
- [SegmentedGauge](components/SegmentedGauge.md) — `QWinUI3.Extras`
- [Sparkline](components/Sparkline.md) — `QWinUI3.Extras`
- [SpeedometerGauge](components/SpeedometerGauge.md) — `QWinUI3.Extras`
- [StackedBarChart](components/StackedBarChart.md) — `QWinUI3.Extras`
- [SunburstChart](components/SunburstChart.md) — `QWinUI3.Extras`
- [TachometerGauge](components/TachometerGauge.md) — `QWinUI3.Extras`
- [TankGauge](components/TankGauge.md) — `QWinUI3.Extras`
- [TelltaleBar](components/TelltaleBar.md) — `QWinUI3.Extras`
- [ThermometerGauge](components/ThermometerGauge.md) — `QWinUI3.Extras`
- [TpmsGauge](components/TpmsGauge.md) — `QWinUI3.Extras`
- [ViolinChart](components/ViolinChart.md) — `QWinUI3.Extras`
- [VoltageGauge](components/VoltageGauge.md) — `QWinUI3.Extras`
- [VuMeter](components/VuMeter.md) — `QWinUI3.Extras`
- [WaffleChart](components/WaffleChart.md) — `QWinUI3.Extras`
- [WaterfallChart](components/WaterfallChart.md) — `QWinUI3.Extras`
- [ZoneGauge](components/ZoneGauge.md) — `QWinUI3.Extras`

### Collections & data

- [AvatarGroup](components/AvatarGroup.md) — `QWinUI3.Extras`
- [Chip](components/Chip.md) — `QWinUI3.Extras`
- [ChipGroup](components/ChipGroup.md) — `QWinUI3.Extras`
- [DataTable](components/DataTable.md) — `QWinUI3.Extras`
- [DataTableFilterOverlay](components/DataTableFilterOverlay.md) — `QWinUI3.Extras`
- [DetailRow](components/DetailRow.md) — `QWinUI3.Extras`
- [FileTree](components/FileTree.md) — `QWinUI3.Extras`
- [GridTile](components/GridTile.md) — `QWinUI3.Extras`
- [ItemsRepeater](components/ItemsRepeater.md) — `QWinUI3.Extras`
- [ItemsView](components/ItemsView.md) — `QWinUI3.Extras`
- [ItemsViewEmptyStateHelper](components/ItemsViewEmptyStateHelper.md) — `QWinUI3.Extras`
- [ItemsWrapGrid](components/ItemsWrapGrid.md) — `QWinUI3.Extras`
- [ListDetailsView](components/ListDetailsView.md) — `QWinUI3.Extras`
- [ListTile](components/ListTile.md) — `QWinUI3.Extras`
- [PersonPicture](components/PersonPicture.md) — `QWinUI3.Extras`
- [Timeline](components/Timeline.md) — `QWinUI3.Extras`
- [TreeDataGrid](components/TreeDataGrid.md) — `QWinUI3.Extras`
- [TreemapChart](components/TreemapChart.md) — `QWinUI3.Extras`

### Date & time

- [CalendarDatePicker](components/CalendarDatePicker.md) — `QWinUI3.Extras`
- [CalendarView](components/CalendarView.md) — `QWinUI3.Extras`
- [DatePicker](components/DatePicker.md) — `QWinUI3.Extras`
- [ImeCandidateBar](components/ImeCandidateBar.md) — `QWinUI3.Extras`
- [SessionTimeout](components/SessionTimeout.md) — `QWinUI3.Extras`
- [TimePicker](components/TimePicker.md) — `QWinUI3.Extras`

### Dialogs & flyouts

- [Flyout](components/Flyout.md) — `QWinUI3.Extras`
- [InfoBar](components/InfoBar.md) — `QWinUI3.Extras`
- [InfoBarHost](components/InfoBarHost.md) — `QWinUI3.Extras`
- [MenuFlyout](components/MenuFlyout.md) — `QWinUI3.Extras`
- [MenuFlyoutAutoMaxHeight](components/MenuFlyoutAutoMaxHeight.md) — `QWinUI3.Extras`
- [MenuFlyoutHeader](components/MenuFlyoutHeader.md) — `QWinUI3.Extras`
- [MenuFlyoutItem](components/MenuFlyoutItem.md) — `QWinUI3.Extras`
- [MenuFlyoutPresenter](components/MenuFlyoutPresenter.md) — `QWinUI3.Extras`
- [MenuFlyoutSeparator](components/MenuFlyoutSeparator.md) — `QWinUI3.Extras`
- [MenuFlyoutSnapshotModel](components/MenuFlyoutSnapshotModel.md) — `QWinUI3.Extras`
- [OskSettingsFlyout](components/OskSettingsFlyout.md) — `QWinUI3.Extras`
- [TeachingTip](components/TeachingTip.md) — `QWinUI3.Extras`
- [Toast](components/Toast.md) — `QWinUI3.Extras`
- [ToastHost](components/ToastHost.md) — `QWinUI3.Extras`
- [ToggleMenuFlyoutItem](components/ToggleMenuFlyoutItem.md) — `QWinUI3.Extras`

### Input & forms

- [AutoSuggestBox](components/AutoSuggestBox.md) — `QWinUI3.Extras`
- [ColorPicker](components/ColorPicker.md) — `QWinUI3.Extras`
- [ComboChart](components/ComboChart.md) — `QWinUI3.Extras`
- [ContentDialog](components/ContentDialog.md) — `QWinUI3.Extras`
- [ContentDialogQueue](components/ContentDialogQueue.md) — `QWinUI3.Extras`
- [ContextMenuAtItem](components/ContextMenuAtItem.md) — `QWinUI3.Extras`
- [FlyoutKeyboardFocusTrap](components/FlyoutKeyboardFocusTrap.md) — `QWinUI3.Extras`
- [FormLayout](components/FormLayout.md) — `QWinUI3.Extras`
- [FormSection](components/FormSection.md) — `QWinUI3.Extras`
- [HeaderedComboBox](components/HeaderedComboBox.md) — `QWinUI3.Extras`
- [HeaderedContentControl](components/HeaderedContentControl.md) — `QWinUI3.Extras`
- [HeaderedTextBox](components/HeaderedTextBox.md) — `QWinUI3.Extras`
- [MaskedTextField](components/MaskedTextField.md) — `QWinUI3.Extras`
- [MultiSelectComboBox](components/MultiSelectComboBox.md) — `QWinUI3.Extras`
- [NumberBox](components/NumberBox.md) — `QWinUI3.Extras`
- [OnScreenKeyboard](components/OnScreenKeyboard.md) — `QWinUI3.Extras`
- [PasswordBox](components/PasswordBox.md) — `QWinUI3.Extras`
- [RadialGauge](components/RadialGauge.md) — `QWinUI3.Extras`
- [RadioMenuFlyoutItem](components/RadioMenuFlyoutItem.md) — `QWinUI3.Extras`
- [RatingControl](components/RatingControl.md) — `QWinUI3.Extras`
- [RatingStars](components/RatingStars.md) — `QWinUI3.Extras`
- [SearchBox](components/SearchBox.md) — `QWinUI3.Extras`
- [SearchBoxRecipe](components/SearchBoxRecipe.md) — `QWinUI3.Extras`
- [SettingsComboCard](components/SettingsComboCard.md) — `QWinUI3.Extras`
- [SettingsSliderCard](components/SettingsSliderCard.md) — `QWinUI3.Extras`
- [SwitchCase](components/SwitchCase.md) — `QWinUI3.Extras`
- [SwitchPresenter](components/SwitchPresenter.md) — `QWinUI3.Extras`
- [TextBlock](components/TextBlock.md) — `QWinUI3.Extras`
- [TokenizingTextBox](components/TokenizingTextBox.md) — `QWinUI3.Extras`
- [UnifiedSearchSurface](components/UnifiedSearchSurface.md) — `QWinUI3.Extras`
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
- [ThemeAppearanceSettings](components/ThemeAppearanceSettings.md) — `QWinUI3.Extras`
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
- [ThemePersistenceCard](components/ThemePersistenceCard.md) — `QWinUI3.Extras`
- [ThemePrefs](components/ThemePrefs.md) — `QWinUI3.Extras`
- [ThemeSyncCard](components/ThemeSyncCard.md) — `QWinUI3.Extras`

### Navigation

- [BreadcrumbBar](components/BreadcrumbBar.md) — `QWinUI3.Extras`
- [NavigationView](components/NavigationView.md) — `QWinUI3.Extras`
- [PagerControl](components/PagerControl.md) — `QWinUI3.Extras`
- [PipsPager](components/PipsPager.md) — `QWinUI3.Extras`
- [Pivot](components/Pivot.md) — `QWinUI3.Extras`
- [SelectorBar](components/SelectorBar.md) — `QWinUI3.Extras`
- [TabView](components/TabView.md) — `QWinUI3.Extras`
- [TabViewDropHub](components/TabViewDropHub.md) — `QWinUI3.Extras`

### Other

- [AnimatedIcon](components/AnimatedIcon.md) — `QWinUI3.Extras`
- [AnnotatedScrollBar](components/AnnotatedScrollBar.md) — `QWinUI3.Extras`
- [CommandRegistry](components/CommandRegistry.md) — `QWinUI3.Extras`
- [ConfirmWithReason](components/ConfirmWithReason.md) — `QWinUI3.Extras`
- [ErrorBoundary](components/ErrorBoundary.md) — `QWinUI3.Extras`
- [Expander](components/Expander.md) — `QWinUI3.Extras`
- [FeedbackSeverity](components/FeedbackSeverity.md) — `QWinUI3.Extras`
- [FlipView](components/FlipView.md) — `QWinUI3.Extras`
- [GeometryAndPrefsGuard](components/GeometryAndPrefsGuard.md) — `QWinUI3.Extras`
- [KeyChordVisual](components/KeyChordVisual.md) — `QWinUI3.Extras`
- [KeyVisual](components/KeyVisual.md) — `QWinUI3.Extras`
- [MetadataControl](components/MetadataControl.md) — `QWinUI3.Extras`
- [MetadataItem](components/MetadataItem.md) — `QWinUI3.Extras`
- [MetricCompareRow](components/MetricCompareRow.md) — `QWinUI3.Extras`
- [OfflineBanner](components/OfflineBanner.md) — `QWinUI3.Extras`
- [OperationRetry](components/OperationRetry.md) — `QWinUI3.Extras`
- [OskHandwritingPad](components/OskHandwritingPad.md) — `QWinUI3.Extras`
- [OskVoiceBar](components/OskVoiceBar.md) — `QWinUI3.Extras`
- [PermissionGate](components/PermissionGate.md) — `QWinUI3.Extras`
- [RecentFiles](components/RecentFiles.md) — `QWinUI3.Extras`
- [RefreshContainer](components/RefreshContainer.md) — `QWinUI3.Extras`
- [RichEdit](components/RichEdit.md) — `QWinUI3.Extras`
- [RightClickAnchorHelper](components/RightClickAnchorHelper.md) — `QWinUI3.Extras`
- [SegmentedControl](components/SegmentedControl.md) — `QWinUI3.Extras`
- [SemanticZoom](components/SemanticZoom.md) — `QWinUI3.Extras`
- [SensitiveField](components/SensitiveField.md) — `QWinUI3.Extras`
- [SessionRestore](components/SessionRestore.md) — `QWinUI3.Extras`
- [Skeleton](components/Skeleton.md) — `QWinUI3.Extras`
- [StandardTitleChrome](components/StandardTitleChrome.md) — `QWinUI3.Extras`
- [SwipeAction](components/SwipeAction.md) — `QWinUI3.Extras`
- [SwipeControl](components/SwipeControl.md) — `QWinUI3.Extras`
- [ToolbarOverflowInspector](components/ToolbarOverflowInspector.md) — `QWinUI3.Extras`
- [Wizard](components/Wizard.md) — `QWinUI3.Extras`

### Platform

- [CompactOverlayWindow](components/CompactOverlayWindow.md) — `QWinUI3.Platform`
- [DialogWindow](components/DialogWindow.md) — `QWinUI3.Platform`
- [FilePicker](components/FilePicker.md) — `QWinUI3.Platform`
- [FrameStatsBadge](components/FrameStatsBadge.md) — `QWinUI3.Platform`
- [FrameStatsMonitor](components/FrameStatsMonitor.md) — `QWinUI3.Platform`
- [FrameStatsOverlay](components/FrameStatsOverlay.md) — `QWinUI3.Platform`
- [PlatformCapability](components/PlatformCapability.md) — `QWinUI3.Platform`
- [PlatformTitleBar](components/PlatformTitleBar.md) — `QWinUI3.Platform`
- [SingleInstance](components/SingleInstance.md) — `QWinUI3.Platform`
- [StandardWindow](components/StandardWindow.md) — `QWinUI3.Platform`
- [ThemeSync](components/ThemeSync.md) — `QWinUI3.Platform`
- [ToolWindow](components/ToolWindow.md) — `QWinUI3.Platform`
- [TrayIcon](components/TrayIcon.md) — `QWinUI3.Platform`
- [WebView2Host](components/WebView2Host.md) — `QWinUI3.Platform`
- [WindowHelper](components/WindowHelper.md) — `QWinUI3.Platform`
- [WindowShellContentClip](components/WindowShellContentClip.md) — `QWinUI3.Platform`
- [WindowShellDecoration](components/WindowShellDecoration.md) — `QWinUI3.Platform`

### Shells & windows

- [BlankWindow](components/BlankWindow.md) — `QWinUI3.Extras`
- [CompactOverlayShellWindow](components/CompactOverlayShellWindow.md) — `QWinUI3.Extras`
- [DashboardShell](components/DashboardShell.md) — `QWinUI3.Extras`
- [DialogShellWindow](components/DialogShellWindow.md) — `QWinUI3.Extras`
- [MenuStatusWindow](components/MenuStatusWindow.md) — `QWinUI3.Extras`
- [NavigationWindow](components/NavigationWindow.md) — `QWinUI3.Extras`
- [OnScreenKeyboardWindow](components/OnScreenKeyboardWindow.md) — `QWinUI3.Extras`
- [ShellWindow](components/ShellWindow.md) — `QWinUI3.Extras`
- [TabViewTearOutWindow](components/TabViewTearOutWindow.md) — `QWinUI3.Extras`
- [TitleBar](components/TitleBar.md) — `QWinUI3.Extras`
- [ToolShellWindow](components/ToolShellWindow.md) — `QWinUI3.Extras`
- [WindowMessageBus](components/WindowMessageBus.md) — `QWinUI3.Extras`

### Status & feedback

- [ChartEmptyState](components/ChartEmptyState.md) — `QWinUI3.Extras`
- [EmptyState](components/EmptyState.md) — `QWinUI3.Extras`
- [InfoBadge](components/InfoBadge.md) — `QWinUI3.Extras`
- [MeterBar](components/MeterBar.md) — `QWinUI3.Extras`
- [NotificationBridge](components/NotificationBridge.md) — `QWinUI3.Extras`
- [NotificationCenter](components/NotificationCenter.md) — `QWinUI3.Extras`
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

- [FluentIcons](components/FluentIcons.md) — `QWinUI3.Theme`
- [FluentIconsCatalog](components/FluentIconsCatalog.md) — `QWinUI3.Theme`
- [PointerCursor](components/PointerCursor.md) — `QWinUI3.Theme`
- [Theme](components/Theme.md) — `QWinUI3.Theme`
- [ThemeFonts](components/ThemeFonts.md) — `QWinUI3.Theme`

## Internal / support

- [ChartUtils](components/ChartUtils.md) (`QWinUI3.Extras`) — LOD helpers for large chart series.
- [GaugeDragLayer](components/GaugeDragLayer.md) (`QWinUI3.Extras`) — Maps drags anywhere on the gauge control into coordSpace (face / canvas / track).
- [GaugeUtils](components/GaugeUtils.md) (`QWinUI3.Extras`) — Shared pointer → value helpers for interactive gauges.
- [KeyboardEngine](components/KeyboardEngine.md) (`QWinUI3.Extras`) — Keyman layouts + in-app IME + optional Windows system-wide inject (1.82). Not Qt Virtual Keyboard. CJK is not Keyman IMX. Japanese stays romaji→kana (no MIT kanji lexicon; JMDict is CC-BY-SA). systemWide (opt-in, Windows SendInput) injects into the focused desktop app.
- [OskHandwritingService](components/OskHandwritingService.md) (`QWinUI3.Extras`) — process handwriting for OSK (Windows + Linux). No helper processes. Windows: Ink recognizer COM. Both: Zinnia shared library when a model is present.
- [OskSpeechService](components/OskSpeechService.md) (`QWinUI3.Extras`) — process speech-to-text for OSK (Windows + Linux). No helper processes. Windows: SAPI in-proc recognizer. Optional Vosk shared library on both OSes.
- [ShellWindowSupport](components/ShellWindowSupport.md) (`QWinUI3.Extras`) — Shared install/presenter glue for ShellWindow.
- [WindowChrome](components/WindowChrome.md) (`QWinUI3.Extras`) — PlatformTitleBar + TitleBar bundle for shells.
- [CaptionButton](components/CaptionButton.md) (`QWinUI3.Platform`) — Native-chrome caption min/max/close button.
- [WindowResizeBorder](components/WindowResizeBorder.md) (`QWinUI3.Platform`) — Non-native resize hit edges.
- [ElevatedChrome](components/ElevatedChrome.md) (`QWinUI3.Theme`) — Shared elevated shadow/border chrome (WinUI-style soft shadow).
- [FocusStroke](components/FocusStroke.md) (`QWinUI3.Theme`) — Dual-ring keyboard focus chrome (WinUI / Fluent).
- [IconSource](components/IconSource.md) (`QWinUI3.Theme`) — Resolve FluentIcons symbol or glyph string.
- [SelectionPip](components/SelectionPip.md) (`QtQuick.Controls.QWinUI3`) — Navigation selection pip indicator.

---
*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*
