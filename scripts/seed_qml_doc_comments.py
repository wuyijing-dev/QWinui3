#!/usr/bin/env python3
"""One-shot: write // summary + usage comments INTO QML sources.

The doc generator (`generate_component_docs.py`) only regex-reads those comments
and writes one markdown file per component under `docs/components/`.
Run this when adding a new control or refreshing stub headers:

  python scripts/seed_qml_doc_comments.py
  python scripts/seed_qml_doc_comments.py --only Chip,AccentButton
  python scripts/generate_component_docs.py --lint
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

SCAN_DIRS = [
    ROOT / "src" / "extras" / "QWinUI3" / "Extras",
    ROOT / "src" / "style" / "QWinUI3",
    ROOT / "src" / "platform" / "QWinUI3" / "Platform",
    ROOT / "src" / "theme" / "QWinUI3" / "Theme",
]

# name -> (summary, usage_qml)
SEEDS: dict[str, tuple[str, str]] = {
    "AccentButton": (
        "Always-accent primary CTA with optional Fluent symbol.",
        'AccentButton {\n    text: qsTr("Save")\n    symbol: FluentIcons.Save\n    onClicked: save()\n}',
    ),
    "AcrylicSurface": (
        "Frosted pane; keep translucent under system Mica/Acrylic.",
        "AcrylicSurface {\n    elevated: true\n    // children…\n}",
    ),
    "ActionCard": (
        "Clickable card with symbol, title, description, and chevron.",
        'ActionCard {\n    title: qsTr("Accounts")\n    description: qsTr("Manage profiles")\n    onClicked: open()\n}',
    ),
    "AnnotatedScrollBar": (
        "Scroll area with a value label on the vertical scrollbar.",
        'AnnotatedScrollBar {\n    id: scroll\n    anchors.fill: parent\n    labels: ["Intro", "Body", "End"]\n    Column {\n        width: scroll.flickable.width\n        Repeater { model: 40; Label { text: "Row " + (index + 1); height: 36 } }\n    }\n}',
    ),
    "AppBarButton": (
        "CommandBar icon button with label position overrides.",
        'AppBarButton {\n    text: qsTr("Add")\n    symbol: FluentIcons.Add\n}',
    ),
    "AppBarSeparator": (
        "Thin separator for CommandBar / AppBar rows.",
        "AppBarSeparator { }",
    ),
    "AppBarToggleButton": (
        "Checkable AppBarButton for CommandBar.",
        'AppBarToggleButton {\n    text: qsTr("Pin")\n    checkable: true\n}',
    ),
    "ArcGauge": (
        "Open-arc dashboard gauge with center value and thresholds.",
        "ArcGauge { value: 64; minimum: 0; maximum: 100 }",
    ),
    "AreaChart": (
        "Filled area chart with legend and hover crosshair.",
        "AreaChart { values: [1, 3, 2, 5] }",
    ),
    "AutoSuggestBox": (
        "Text field with filtered suggestion popup.",
        'AutoSuggestBox {\n    placeholderText: qsTr("Suggest")\n    model: items\n    onSuggestionChosen: (item) => apply(item)\n}',
    ),
    "AvatarGroup": (
        "Overlapping PersonPicture stack with overflow count.",
        'AvatarGroup { model: [{ displayName: "A" }, { displayName: "B" }] }',
    ),
    "BarChart": (
        "Vertical bar chart with reveal animation.",
        "BarChart { values: [4, 2, 7, 3] }",
    ),
    "BlankWindow": (
        "Empty ShellWindow client — declare UI as children.",
        'BlankWindow {\n    title: qsTr("App")\n    Label { anchors.centerIn: parent; text: "Hello" }\n}',
    ),
    "BreadcrumbBar": (
        "Path trail; model items raise itemClicked.",
        'BreadcrumbBar {\n    model: [{ title: "Home" }, { title: "Docs" }]\n    onItemClicked: (index) => navigate(index)\n}',
    ),
    "BulletChart": (
        "Compact KPI bullet (ranges + performance + target).",
        "BulletChart { value: 70; target: 80; maximum: 100 }",
    ),
    "CalendarDatePicker": (
        "Date field with calendar flyout.",
        "CalendarDatePicker { selectedDate: new Date() }",
    ),
    "ChartCard": (
        "Title/subtitle chrome around a chart child.",
        'ChartCard {\n    title: qsTr("Revenue")\n    LineChart { values: series }\n}',
    ),
    "ChartLegend": (
        "Fluent legend for series/slices.",
        'ChartLegend { items: [{ label: "A", color: Theme.accent }] }',
    ),
    "ChartUtils": (
        "LOD helpers for large chart series.",
        "ChartUtils.downsample(values, maxPoints)",
    ),
    "Chip": (
        "Compact selectable tag; optional close affordance.",
        'Chip {\n    text: qsTr("Tag")\n    closable: true\n    onCloseClicked: remove()\n}',
    ),
    "ChipGroup": (
        "Horizontal chip group for filters / single select.",
        'ChipGroup { model: ["All", "Open"]; currentIndex: 0 }',
    ),
    "ColorPicker": (
        "Spectrum + RGB/Hex color editor.",
        'ColorPicker { selectedColor: "#005FB8" }',
    ),
    "ColorPickerButton": (
        "Color swatch button that opens ColorPicker.",
        "ColorPickerButton { selectedColor: Theme.accent }",
    ),
    "CommandBar": (
        "Primary/secondary command row (AppBar host).",
        'CommandBar {\n    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }\n}',
    ),
    "CommandBarFlyout": (
        "Popup CommandBar with primary + secondary commands.",
        "CommandBarFlyout {\n    AppBarButton { text: qsTr(\"Share\") }\n}",
    ),
    "CompactOverlayShellWindow": (
        "Always-on-top compact overlay shell.",
        'CompactOverlayShellWindow { title: qsTr("Now playing") }',
    ),
    "ContentCard": (
        "Surface card with title, subtitle, symbol, and body slot.",
        'ContentCard {\n    title: qsTr("Card")\n    Label { text: qsTr("Body") }\n}',
    ),
    "ContentDialog": (
        "Modal dialog with primary / secondary / close actions.",
        'ContentDialog {\n    title: qsTr("Confirm")\n    primaryButtonText: qsTr("OK")\n    closeButtonText: qsTr("Cancel")\n}\n// prefer dialog.show() → ContentDialogQueue',
    ),
    "ContentDialogQueue": (
        "Singleton queue so ContentDialogs open one at a time.",
        "ContentDialogQueue.show(dialog)\nContentDialogQueue.cancel(dialog)\nContentDialogQueue.replaceCurrent(other)",
    ),
    "CopyButton": (
        "Copies textToCopy and flashes a success glyph.",
        "CopyButton { textToCopy: code }",
    ),
    "DatePicker": ("Date selectors (year / month / day).", "DatePicker { }"),
    "DialogShellWindow": (
        "ShellWindow with dialog paradigm flags.",
        'DialogShellWindow {\n    title: qsTr("Confirm")\n    width: 440; height: 280\n}',
    ),
    "DockPanel": (
        "Dock children Top/Bottom/Left/Right/Fill.",
        "DockPanel {\n    Rectangle { DockPanel.dock: DockPanel.Top; height: 40 }\n    Rectangle { DockPanel.dock: DockPanel.Fill }\n}",
    ),
    "DonutChart": ("Donut chart with hover and legend.", 'DonutChart { slices: [{ value: 3, label: "A" }] }'),
    "DropDownButton": (
        "Button that opens a MenuFlyout of actions.",
        'DropDownButton {\n    text: qsTr("Options")\n    MenuFlyoutItem { text: qsTr("A") }\n}',
    ),
    "EmptyState": (
        "Placeholder illustration + title + optional action.",
        'EmptyState {\n    title: qsTr("Nothing here")\n    description: qsTr("Try another filter.")\n}',
    ),
    "Expander": (
        "Collapsible header with expandable content.",
        'Expander {\n    header: qsTr("Details")\n    Label { text: qsTr("Body") }\n}',
    ),
    "FlipView": ("Page carousel with optional navigation buttons.", "FlipView { model: pages }"),
    "Flyout": (
        "Light-dismiss popup anchored to a target.",
        'Flyout {\n    target: button\n    Label { text: qsTr("Details") }\n}',
    ),
    "FontIcon": ("FluentIcons glyph as Text.", "FontIcon { symbol: FluentIcons.Home; font.pixelSize: 16 }"),
    "GridTile": (
        "Icon + title tile for launchers / galleries.",
        'GridTile { title: qsTr("Photos"); symbol: FluentIcons.Photo }',
    ),
    "HeaderedContentControl": (
        "Labeled content host.",
        'HeaderedContentControl { header: qsTr("Section"); Label { text: "…" } }',
    ),
    "HeaderedTextBox": (
        "TextBox with header and description.",
        'HeaderedTextBox { header: qsTr("Name"); placeholderText: qsTr("Required") }',
    ),
    "HeatmapChart": ("Heatmap matrix chart.", "HeatmapChart { values: matrix }"),
    "HorizontalBarChart": ("Horizontal bar chart.", "HorizontalBarChart { values: [3, 5, 2] }"),
    "HyperlinkButton": (
        "Link-styled button.",
        'HyperlinkButton { text: qsTr("Learn more"); onClicked: Qt.openUrlExternally(url) }',
    ),
    "IconButton": ("Icon-only button helper.", 'IconButton { symbol: FluentIcons.Add }'),
    "IconicButton": (
        "Base icon + label button used by AppBar*.",
        'IconicButton { text: qsTr("Action"); symbol: FluentIcons.Add }',
    ),
    "InfoBadge": ("Count / status / glyph badge.", "InfoBadge { value: 3; severity: informational }"),
    "InfoBar": (
        "Inline severity banner with optional action.",
        'InfoBar {\n    title: qsTr("Saved")\n    message: qsTr("All changes stored.")\n    severity: InfoBar.Success\n}',
    ),
    "InfoBarHost": (
        "Stacks InfoBars in a host region.",
        'InfoBarHost { id: bars }\n// bars.enqueue({ title: "Hi", severity: InfoBar.Informational })',
    ),
    "KeyChordVisual": (
        "Renders Ctrl+K style shortcuts as KeyVisuals.",
        'KeyChordVisual { shortcut: "Ctrl+Shift+P" }',
    ),
    "KeyVisual": ("Single keyboard key chrome.", 'KeyVisual { keyText: "Ctrl" }'),
    "LinearGauge": (
        "Horizontal/vertical track gauge with thresholds.",
        "LinearGauge { value: 42; minimum: 0; maximum: 100 }",
    ),
    "LineChart": ("Multi-series line/area chart.", "LineChart { values: [1, 4, 2, 6] }"),
    "ListTile": (
        "List row: leading, title, subtitle, trailing.",
        'ListTile {\n    title: qsTr("Item")\n    subtitle: qsTr("Detail")\n    symbol: FluentIcons.Document\n}',
    ),
    "MenuFlyout": (
        "Elevated Menu with showAt / isOpen helpers.",
        'MenuFlyout {\n    MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }\n}',
    ),
    "MenuFlyoutHeader": ("Non-interactive MenuFlyout section header.", 'MenuFlyoutHeader { text: qsTr("Recent") }'),
    "MenuFlyoutItem": (
        "Menu row with glyph and accelerator text.",
        'MenuFlyoutItem { text: qsTr("Paste"); keyboardAcceleratorText: "Ctrl+V" }',
    ),
    "MenuFlyoutSeparator": ("MenuFlyout divider.", "MenuFlyoutSeparator { }"),
    "MenuStatusWindow": (
        "TitleBar + MenuBar + content + StatusBar shell.",
        'MenuStatusWindow {\n    menusInTitleBar: true\n    Menu { title: qsTr("File") }\n    content: Label { text: "Body" }\n    statusText: qsTr("Ready")\n}',
    ),
    "MetadataControl": (
        "Stacked or flowed label/value metadata block.",
        'MetadataControl {\n    MetadataItem { label: qsTr("Author"); value: "Ada" }\n}',
    ),
    "MetadataItem": (
        "One label/value pair for MetadataControl.",
        'MetadataItem { label: qsTr("Size"); value: "12 KB" }',
    ),
    "MeterBar": (
        "Multi-segment stacked meter (e.g. disk usage).",
        "MeterBar { segments: [{ value: 40, color: Theme.accent }] }",
    ),
    "MultiSelectComboBox": (
        "Combo that keeps the popup open for multi-select.",
        "MultiSelectComboBox { model: items; selectedIndexes: [0, 2] }",
    ),
    "NavigationView": (
        "WinUI NavigationView with pane modes and page stack.",
        'NavigationView {\n    anchors.fill: parent\n    paneDisplayMode: "auto"\n    model: navModel\n    isPaneSearchEnabled: true\n    pageModule: "MyApp"\n}',
    ),
    "NavigationWindow": (
        "ShellWindow hosting NavigationView + content.",
        'NavigationWindow {\n    title: qsTr("App")\n    paneDisplayMode: "left"\n    navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]\n    content: Label { text: "Hello" }\n}',
    ),
    "NumberBox": (
        "Numeric spin/edit with validation.",
        'NumberBox { value: 10; minimum: 0; maximum: 100 }',
    ),
    "PasswordBox": ("Password field with reveal toggle.", 'PasswordBox { placeholderText: qsTr("Password") }'),
    "PersonPicture": ("Avatar from image or initials.", 'PersonPicture { displayName: "Ada"; size: 48 }'),
    "PieChart": ("Pie chart with legend.", 'PieChart { slices: [{ value: 1, label: "A" }] }'),
    "PipsPager": ("Dot pager for carousels.", "PipsPager { count: 5; currentIndex: 2 }"),
    "Pivot": ("Header tabs with sliding underline and pages.", 'Pivot { model: ["Overview", "Details"] }'),
    "ProgressButton": (
        "Button with inline determinate/indeterminate fill.",
        'ProgressButton { text: qsTr("Upload"); progress: 0.4 }',
    ),
    "ProgressRing": ("Circular progress / busy ring.", "ProgressRing { indeterminate: true }"),
    "RadarChart": ("Radar / spider chart.", "RadarChart { values: [3, 5, 2, 4]; axes: [\"A\",\"B\",\"C\",\"D\"] }"),
    "RadialGauge": ("Circular gauge with needle and zones.", "RadialGauge { value: 72; minimum: 0; maximum: 100 }"),
    "RadioButtons": (
        "Grouped RadioButton list from a model.",
        'RadioButtons { header: qsTr("Choice"); model: ["A", "B"] }',
    ),
    "RadioMenuFlyoutItem": ("Exclusive radio MenuFlyout item.", 'RadioMenuFlyoutItem { text: qsTr("Option") }'),
    "RatingControl": ("Star rating; stepSize supports halves.", "RatingControl { value: 3.5; stepSize: 0.5 }"),
    "RefreshContainer": (
        "Pull-to-refresh host for flickable content.",
        "RefreshContainer {\n    onRefreshRequested: reload()\n    ListView { /* … */ }\n}",
    ),
    "RelativePanel": ("Constraint-based relative layout.", "RelativePanel {\n    // children with RelativePanel.* attached props\n}"),
    "ScatterChart": ("Scatter / bubble chart.", "ScatterChart { points: [{ x: 1, y: 2 }] }"),
    "SearchBox": (
        "Search field with suggestion list.",
        'SearchBox {\n    placeholderText: qsTr("Search")\n    model: suggestions\n    onSuggestionChosen: (item) => open(item)\n}',
    ),
    "SegmentedControl": (
        "Mutually exclusive segment buttons.",
        'SegmentedControl {\n    model: ["Day", "Week", "Month"]\n    currentIndex: 0\n}',
    ),
    "SegmentedGauge": ("Segmented progress / capacity gauge.", "SegmentedGauge { value: 3; maximum: 5 }"),
    "SelectorBar": (
        "Compact horizontal item selector.",
        'SelectorBar { model: ["All", "Unread"]; currentIndex: 0 }',
    ),
    "SettingsCard": (
        "Settings row: icon, title, description, action.",
        'SettingsCard {\n    title: qsTr("Dark mode")\n    action: Switch { checked: Theme.dark; onToggled: Theme.dark = checked }\n}',
    ),
    "SettingsExpander": (
        "Expandable settings group.",
        'SettingsExpander {\n    title: qsTr("Advanced")\n    SettingsCard { title: qsTr("Option") }\n}',
    ),
    "ShellWindow": (
        "Independent ApplicationWindow + WindowChrome host.",
        'ShellWindow {\n    title: qsTr("App")\n    symbol: FluentIcons.Home\n}',
    ),
    "ShellWindowSupport": (
        "Shared install/presenter glue for ShellWindow.",
        "ShellWindowSupport { targetWindow: root; autoInstall: true }",
    ),
    "Shimmer": ("Skeleton shimmer placeholder.", "Shimmer { width: 200; height: 12 }"),
    "Sparkline": ("Inline mini line chart.", "Sparkline { values: [1, 3, 2, 5, 4] }"),
    "SplitButton": (
        "Primary action + chevron menu.",
        'SplitButton {\n    text: qsTr("Open")\n    MenuFlyoutItem { text: qsTr("Open with…") }\n}',
    ),
    "StackedBarChart": ("Stacked bar chart.", "StackedBarChart { series: [{ values: [1, 2] }] }"),
    "StackPanel": ("Simple stack layout (orientation + spacing).", "StackPanel { orientation: Qt.Vertical }"),
    "StatusBar": (
        "Window status strip with progress and slots.",
        'StatusBar {\n    text: qsTr("Ready")\n    progress: 0.4\n}',
    ),
    "StatusDot": ("Colored status indicator dot.", "StatusDot { severity: success }"),
    "StepBar": (
        "Horizontal step / wizard progress.",
        'StepBar { model: ["Cart", "Ship", "Pay"]; currentIndex: 1 }',
    ),
    "SwipeAction": ("Action revealed by SwipeControl.", 'SwipeAction { text: qsTr("Delete"); onTriggered: remove() }'),
    "SwipeControl": (
        "Swipe-to-reveal actions on content.",
        'SwipeControl {\n    SwipeAction { text: qsTr("Delete") }\n    ListTile { title: qsTr("Row") }\n}',
    ),
    "SwitchCase": ("Case child for SwitchPresenter.", 'SwitchCase { value: "a"; Label { text: "A" } }'),
    "SwitchPresenter": (
        "Shows the SwitchCase matching value.",
        'SwitchPresenter {\n    value: mode\n    SwitchCase { value: "a"; Label { text: "A" } }\n}',
    ),
    "TabView": (
        "Closeable / reorderable tabs.",
        "TabView {\n    model: tabs\n    onCloseRequested: (index) => remove(index)\n}",
    ),
    "TeachingTip": (
        "Anchored tip with title, subtitle, and actions.",
        'TeachingTip { target: btn; title: qsTr("Tip"); subtitle: qsTr("Hint") }',
    ),
    "TextBlock": ("Fluent typography styles (title, body, caption…).", 'TextBlock { text: qsTr("Title"); style: title }'),
    "TimePicker": ("Hour / minute (and period) selectors.", "TimePicker { }"),
    "Timeline": ("Vertical event timeline.", 'Timeline { model: events }'),
    "TitleBar": (
        "WinUI TitleBar content chrome (not caption buttons).",
        'TitleBar {\n    title: qsTr("App")\n    subtitle: qsTr("Optional")\n    symbol: FluentIcons.Home\n}',
    ),
    "Toast": ("Transient toast item.", 'Toast { title: qsTr("Saved"); message: qsTr("OK") }'),
    "ToastHost": (
        "Hosts stacked Toasts.",
        'ToastHost { id: toasts }\n// toasts.show({ title: "Done", message: "OK" })',
    ),
    "ToggleButton": ("Checkable button with Fluent chrome.", 'ToggleButton { text: qsTr("Bold"); checkable: true }'),
    "ToggleMenuFlyoutItem": ("Checkable MenuFlyout item.", 'ToggleMenuFlyoutItem { text: qsTr("Wrap") }'),
    "ToggleSplitButton": (
        "Toggle primary + menu SplitButton.",
        'ToggleSplitButton { text: qsTr("Format") }',
    ),
    "TokenizingTextBox": (
        "Token chips + text input.",
        'TokenizingTextBox {\n    model: tokens\n    placeholderText: qsTr("Add…")\n}',
    ),
    "ToolShellWindow": (
        "ShellWindow with tool paradigm.",
        'ToolShellWindow { title: qsTr("Inspector"); width: 320; height: 480 }',
    ),
    "TwoPaneView": (
        "Responsive dual-pane layout.",
        "TwoPaneView {\n    pane1: Rectangle { }\n    pane2: Rectangle { }\n}",
    ),
    "UniformGrid": ("Even cell grid.", "UniformGrid { columns: 3 }"),
    "WaterfallChart": ("Waterfall chart.", "WaterfallChart { values: [10, -3, 5] }"),
    "WindowChrome": (
        "PlatformTitleBar + TitleBar bundle for shells.",
        'WindowChrome { targetWindow: root; title: qsTr("App") }',
    ),
    "WrapPanel": ("Flow / wrap layout.", "WrapPanel {\n    Repeater { model: 8; Chip { text: modelData } }\n}"),
    "ZoneGauge": ("Gauge with colored zones.", "ZoneGauge { value: 55; minimum: 0; maximum: 100 }"),
    "StandardWindow": (
        "Platform ApplicationWindow + PlatformTitleBar host.",
        'StandardWindow {\n    title: qsTr("Gallery")\n    backdrop: WindowHelper.BackdropSolid\n}',
    ),
    "DialogWindow": ("StandardWindow dialog paradigm.", 'DialogWindow { title: qsTr("Dialog") }'),
    "ToolWindow": ("StandardWindow tool paradigm.", 'ToolWindow { title: qsTr("Tool") }'),
    "CompactOverlayWindow": (
        "StandardWindow compact overlay presenter.",
        'CompactOverlayWindow { title: qsTr("Overlay") }',
    ),
    "PlatformTitleBar": (
        "Caption buttons + drag region + TitleBar host.",
        'PlatformTitleBar {\n    targetWindow: window\n    TitleBar { embedded: true; title: qsTr("App") }\n}',
    ),
    "CaptionButton": ("Native-chrome caption min/max/close button.", 'CaptionButton { glyph: FluentIcons.ChromeClose }'),
    "WindowResizeBorder": ("Non-native resize hit edges.", "WindowResizeBorder { targetWindow: root }"),
    "Theme": (
        "Fluent color / type / motion token singleton.",
        "Theme.dark = true\nTheme.followSystemAccessibility = true",
    ),
    "ElevatedChrome": ("Shared elevated shadow/border chrome.", "ElevatedChrome { anchors.fill: parent }"),
    "IconSource": ("Resolve FluentIcons symbol or glyph string.", 'IconSource.resolve(symbol, iconGlyph)'),
    # Style (Qt Quick Controls)
    "Button": ("Fluent styled Button.", 'Button { text: qsTr("OK"); onClicked: accept() }'),
    "CheckBox": ("Fluent styled CheckBox.", 'CheckBox { text: qsTr("Remember"); checked: true }'),
    "RadioButton": ("Fluent styled RadioButton.", 'RadioButton { text: qsTr("Option"); checked: true }'),
    "Switch": ("Fluent styled Switch.", "Switch { checked: Theme.dark; onToggled: Theme.dark = checked }"),
    "Slider": ("Fluent styled Slider.", "Slider { from: 0; to: 100; value: 40 }"),
    "RangeSlider": ("Fluent styled RangeSlider.", "RangeSlider { from: 0; to: 100; first.value: 20; second.value: 80 }"),
    "ComboBox": ("Fluent styled ComboBox.", 'ComboBox { model: ["A", "B"] }'),
    "SpinBox": ("Fluent styled SpinBox.", "SpinBox { from: 0; to: 99; value: 1 }"),
    "TextField": ("Fluent styled TextField.", 'TextField { placeholderText: qsTr("Name") }'),
    "TextArea": ("Fluent styled TextArea.", 'TextArea { placeholderText: qsTr("Notes") }'),
    "ProgressBar": ("Fluent styled ProgressBar.", "ProgressBar { value: 0.4; from: 0; to: 1 }"),
    "BusyIndicator": ("Fluent styled BusyIndicator.", "BusyIndicator { running: true }"),
    "Dial": ("Fluent styled Dial.", "Dial { from: 0; to: 100; value: 30 }"),
    "Menu": ("Fluent styled Menu.", 'Menu { MenuItem { text: qsTr("Copy") } }'),
    "MenuItem": ("Fluent styled MenuItem.", 'MenuItem { text: qsTr("Paste") }'),
    "MenuBar": ("Fluent styled MenuBar.", 'MenuBar { Menu { title: qsTr("File") } }'),
    "Popup": ("Fluent styled Popup chrome.", "Popup { modal: true; // content }"),
    "Dialog": ("Fluent styled Dialog.", 'Dialog { title: qsTr("Hi"); standardButtons: Dialog.Ok }'),
    "ToolTip": ("Fluent styled ToolTip.", 'ToolTip { text: qsTr("Hint") }'),
    "TabBar": ("Fluent styled TabBar.", "TabBar { TabButton { text: qsTr(\"One\") } }"),
    "TabButton": ("Fluent styled TabButton.", 'TabButton { text: qsTr("Tab") }'),
    "ScrollBar": ("Fluent styled ScrollBar.", "ScrollBar { }"),
    "ScrollView": ("Fluent styled ScrollView.", "ScrollView { Label { text: longText } }"),
    "StackView": ("Fluent styled StackView.", "StackView { initialItem: homePage }"),
    "SwipeView": ("Fluent styled SwipeView.", "SwipeView { // pages }"),
    "Page": ("Fluent styled Page.", 'Page { title: qsTr("Home") }'),
    "Pane": ("Fluent styled Pane.", "Pane { // children }"),
    "Frame": ("Fluent styled Frame.", "Frame { // children }"),
    "GroupBox": ("Fluent styled GroupBox.", 'GroupBox { title: qsTr("Options") }'),
    "Label": ("Fluent styled Label.", 'Label { text: qsTr("Hello") }'),
    "ToolBar": ("Fluent styled ToolBar.", "ToolBar { ToolButton { text: qsTr(\"A\") } }"),
    "ToolButton": ("Fluent styled ToolButton.", 'ToolButton { text: qsTr("Edit") }'),
    "RoundButton": ("Fluent styled RoundButton.", 'RoundButton { text: "+" }'),
    "DelayButton": ("Fluent styled DelayButton.", 'DelayButton { text: qsTr("Hold") }'),
    "ItemDelegate": ("Fluent styled ItemDelegate.", 'ItemDelegate { text: qsTr("Row") }'),
    "SwitchDelegate": ("Fluent styled SwitchDelegate.", 'SwitchDelegate { text: qsTr("Option") }'),
    "CheckDelegate": ("Fluent styled CheckDelegate.", 'CheckDelegate { text: qsTr("Option") }'),
    "RadioDelegate": ("Fluent styled RadioDelegate.", 'RadioDelegate { text: qsTr("Option") }'),
    "SwipeDelegate": ("Fluent styled SwipeDelegate.", 'SwipeDelegate { text: qsTr("Row") }'),
    "TreeViewDelegate": ("Fluent styled TreeViewDelegate.", "TreeViewDelegate { }"),
    "ApplicationWindow": ("Fluent ApplicationWindow chrome defaults.", 'ApplicationWindow { title: qsTr("App") }'),
    "Drawer": ("Fluent styled Drawer.", "Drawer { // content }"),
    "SplitView": ("Fluent styled SplitView.", "SplitView { orientation: Qt.Horizontal }"),
    "PageIndicator": ("Fluent styled PageIndicator.", "PageIndicator { count: 3; currentIndex: 0 }"),
    "Tumbler": ("Fluent styled Tumbler.", 'Tumbler { model: 12 }'),
    "MonthGrid": ("Fluent styled MonthGrid.", "MonthGrid { }"),
    "DayOfWeekRow": ("Fluent styled DayOfWeekRow.", "DayOfWeekRow { }"),
    "HorizontalHeaderView": ("Fluent styled HorizontalHeaderView.", "HorizontalHeaderView { }"),
    "VerticalHeaderView": ("Fluent styled VerticalHeaderView.", "VerticalHeaderView { }"),
    "MenuBarItem": ("Fluent styled MenuBarItem.", 'MenuBarItem { text: qsTr("File") }'),
    "MenuSeparator": ("Fluent styled MenuSeparator.", "MenuSeparator { }"),
    "DialogButtonBox": ("Fluent styled DialogButtonBox.", "DialogButtonBox { standardButtons: Dialog.Ok | Dialog.Cancel }"),
    "ScrollIndicator": ("Fluent styled ScrollIndicator.", "ScrollIndicator { }"),
    "ToolSeparator": ("Fluent styled ToolSeparator.", "ToolSeparator { }"),
    "FocusStroke": ("Focus ring helper.", "FocusStroke { anchors.fill: parent; visible: control.visualFocus }"),
    "SelectionPip": ("Navigation selection pip indicator.", "SelectionPip { }"),
}


def find_insert_index(lines: list[str]) -> int:
    last = 0
    for i, line in enumerate(lines):
        s = line.strip()
        if s.startswith("pragma ") or s.startswith("import "):
            last = i + 1
    return last


def strip_doc_header(lines: list[str], start: int) -> tuple[list[str], int]:
    i = start
    while i < len(lines) and not lines[i].strip():
        i += 1
    if i >= len(lines) or not lines[i].strip().startswith("//"):
        return lines, start
    j = i
    while j < len(lines):
        s = lines[j].strip()
        if s.startswith("//"):
            j += 1
            continue
        if s == "":
            j += 1
            break
        break
    return lines[:i] + lines[j:], i


def format_header(name: str, summary: str, usage: str) -> list[str]:
    out = [f"// {name} — {summary}", "//"]
    for line in usage.splitlines():
        out.append("//   " + line if line.strip() else "//")
    out.append("")
    return out


def seed_file(path: Path, force: bool = False) -> bool:
    name = path.stem
    if name not in SEEDS:
        return False
    summary, usage = SEEDS[name]
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    insert = find_insert_index(lines)
    lines2, insert = strip_doc_header(lines, insert)
    header = format_header(name, summary, usage)
    new_lines = lines2[:insert] + header + lines2[insert:]
    new_text = "\n".join(new_lines) + ("\n" if text.endswith("\n") or True else "")
    if new_text == text and not force:
        return False
    path.write_text(new_text, encoding="utf-8", newline="\n")
    return True


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--only", type=str, default="", help="Comma-separated component names")
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()
    only = {x.strip() for x in args.only.split(",") if x.strip()} if args.only else set()

    changed = 0
    missing_seed = []
    for d in SCAN_DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            if only and path.stem not in only:
                continue
            if path.stem not in SEEDS:
                missing_seed.append(path)
                continue
            if seed_file(path, force=args.force):
                print(f"SEED {path.relative_to(ROOT)}")
                changed += 1
    print(f"Seeded {changed} file(s)")
    if missing_seed and not only:
        print(f"No seed for {len(missing_seed)} file(s) (left unchanged):", file=sys.stderr)
        for p in missing_seed[:20]:
            print(f"  {p.relative_to(ROOT)}", file=sys.stderr)
        if len(missing_seed) > 20:
            print(f"  … +{len(missing_seed) - 20} more", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
