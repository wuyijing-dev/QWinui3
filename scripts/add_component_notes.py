#!/usr/bin/env python3
"""Append // @notes blocks to important QML headers (if missing)."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_component_docs import RE_HEADER_BLOCK  # noqa: E402

NOTES: dict[str, str] = {
    "NavigationView": """\
@notes
  model entries: type "item"|"group"|"header"; groups use children[].
  pageModule + component names load StackView pages (unless hostContent).
  paneDisplayMode auto switches left/leftCompact by width.
  leftMinimal overlays content with a light-dismiss scrim.
  Prefer selectKey / openPage over mutating currentIndex alone.
""",
    "ContentDialog": """\
@notes
  Prefer show() → ContentDialogQueue so dialogs open one-at-a-time.
  Empty primary/secondary/closeButtonText hides that button.
  defaultButton: primary | secondary | close | none (or isPrimaryDefault).
  Body: put content as children (moved into the dialog body slot).
""",
    "ShellWindow": """\
@notes
  ApplicationWindow + WindowChrome; does not subclass StandardWindow.
  Use BlankWindow / NavigationWindow / MenuStatusWindow / DialogShellWindow /
  ToolShellWindow / CompactOverlayShellWindow for common layouts.
  Title-bar slots: leftHeader, titleBarContent, rightHeader, menusInTitleBar.
  Backdrop / paradigm via WindowHelper (see docs/window-helper.md).
""",
    "TabView": """\
@notes
  model items: { title, content, icon? } or a string title.
  closable tabs emit closeRequested / tabCloseRequested — remove from model yourself.
  tabsReorderable enables drag reorder (tabMoved).
  addTab / closeTab / moveTab mutate the model helpers.
""",
    "Flyout": """\
@notes
  Light-dismiss Popup anchored to target (preferredPlacement / placement).
  Call show() / showAt(item, place) / hide(); reposition() after layout changes.
  Put body as children; optional title / subtitle chrome.
""",
    "InfoBar": """\
@notes
  Inline severity banner: informational | success | warning | error.
  open()/close() or bind isOpen; optional actionText → actionClicked.
  Prefer InfoBarHost.info/success/warning/error for stacked toasts-like banners.
""",
    "TeachingTip": """\
@notes
  Anchored tip Popup; set target + title/subtitle (+ optional actionText).
  Call open()/close(); reanchor() after the target moves.
  isLightDismissEnabled controls outside-click dismiss.
""",
    "ColorPicker": """\
@notes
  Edits selectedColor via spectrum + RGB/HSV/hex fields.
  copyHex() writes #RRGGBB to the clipboard.
  Bind selectedColor; channel props (hue/saturation/value/alpha) stay in sync.
""",
    "TitleBar": """\
@notes
  WinUI-style title bar for ShellWindow / WindowChrome.
  preferredHeightOption: standard (32) or tall (48) via WindowHelper.
  Caption hit-test uses screen-logical rects (mapToGlobal) so maximize/fullscreen
  caption buttons stay clickable.
""",
    "TwoPaneView": """\
@notes
  Dual-pane layout with wide / tall / single modes.
  panePriority + minWideWidth control collapse; swapPanes / toggleSinglePane.
  Put Pane1 / Pane2 content via pane1 / pane2 aliases (or children APIs).
""",
    "AutoSuggestBox": """\
@notes
  Text field + filtered suggestion popup (model / text / suggestionChosen).
  Call focusField() / clear(); refreshSuggestions() after model changes.
""",
    "ContentDialogQueue": """\
@notes
  Singleton queue for ContentDialog.show().
  show / enqueue, cancel, clearQueue, replaceCurrent; pendingCount / busy.
""",
    "NumberBox": """\
@notes
  Numeric TextField with spin buttons / wheel / validation.
  Bind value; spinButtonPlacement and validationMode control UX.
  valueChanged / validationError for feedback.
""",
    "MenuStatusWindow": """\
@notes
  ShellWindow with menusInTitleBar + multi-segment StatusBar.
  Put Menu items in menus; status via StatusBar segments / statusText.
""",
    "NavigationWindow": """\
@notes
  ShellWindow hosting NavigationView with hostContent.
  Wire navModel / paneDisplayMode; content goes in the NavigationView content slot.
""",
    # --- charts ---
    "LineChart": """\
@notes
  Prefer series: [{ name, values, color? }] or a flat values: number[].
  Large series use LOD (invalidateLod / ensureLod); call requestRedraw after data changes.
  playReveal() replays the enter animation; clearHover() resets crosshair.
""",
    "AreaChart": """\
@notes
  Filled area under the line; same series/values + LOD APIs as LineChart.
  interactive enables hover crosshair; showLegend toggles ChartLegend.
""",
    "BarChart": """\
@notes
  Vertical bars from values or series; playReveal() for enter animation.
  category labels via categories / labels; interactive for hover/click.
""",
    "HorizontalBarChart": """\
@notes
  Horizontal bars; same data shape as BarChart (values / series / categories).
""",
    "StackedBarChart": """\
@notes
  Stacked series segments per category; series items supply stacked values.
""",
    "PieChart": """\
@notes
  Slices from values or { label, value, color? } items; donut via innerRadius.
  interactive emits slice hover/click; showLegend for ChartLegend.
""",
    "DonutChart": """\
@notes
  PieChart with a hollow center (inner/outer radius); center label optional.
""",
    "ScatterChart": """\
@notes
  points: [{ x, y, color? }] or separate xValues/yValues.
  LOD helpers for large point counts; requestRedraw after updates.
""",
    "RadarChart": """\
@notes
  Polar axes from categories + series values (one value per spoke).
""",
    "HeatmapChart": """\
@notes
  2D matrix / cells model; cellClicked for selection.
  colorScale maps value -> color; show axes labels as needed.
""",
    "WaterfallChart": """\
@notes
  values are signed deltas; total/connector styling via chart props.
""",
    "Sparkline": """\
@notes
  Compact inline sparkline; values: number[]; minimal chrome, no axes by default.
""",
    "BulletChart": """\
@notes
  KPI bullet: qualitative bands + performance value + target marker.
  setValue(v) clamps into range; bandColor(index) for band fills.
""",
    "ChartLegend": """\
@notes
  items: [{ label, color, selected? }]; select(index) / itemHovered for interaction.
""",
    "ChartCard": """\
@notes
  Title/subtitle chrome around a chart child; put the chart as content.
""",
    "ChartUtils": """\
@notes
  Internal helpers: downsample, extents, palette, formatNumber (used by chart controls).
""",
    # --- gauges ---
    "ArcGauge": """\
@notes
  Open-arc gauge; bind value/minimum/maximum; setValue clamps+snaps.
  thresholds / zones for colored ranges; readout via formatValue.
""",
    "RadialGauge": """\
@notes
  Full/partial radial needle gauge; zones via zoneModel; dragEnabled for input.
""",
    "LinearGauge": """\
@notes
  Horizontal/vertical bar gauge; same value/min/max + zone patterns as radial.
""",
    "ZoneGauge": """\
@notes
  Gauge with explicit colored zones; activeZoneIndex/Color/Label track the needle.
""",
    "SegmentedGauge": """\
@notes
  Discrete segment fill (progress pills); value vs maximum segment count.
""",
    # --- forms / input ---
    "SearchBox": """\
@notes
  Search field + suggestion popup (model / text).
  Signals: querySubmitted, suggestionChosen, cleared; helpers: focusField, clear, submitQuery.
""",
    "TokenizingTextBox": """\
@notes
  Token chips + trailing TextField; tokens: string[].
  addToken / removeToken / clear; suggestionModel for popup picks.
""",
    "HeaderedTextBox": """\
@notes
  Label + TextField pair; header/headerPlacement and text/placeholderText aliases.
""",
    "PasswordBox": """\
@notes
  Password TextField with reveal glyph; revealPassword / revealButtonVisible.
""",
    "DatePicker": """\
@notes
  Tumbler date picker; selectedDate or year/month/day parts.
  Accept commits; minDate/maxDate bound the range.
""",
    "TimePicker": """\
@notes
  Tumbler time picker; selectedTime + clockFormat 12|24; minuteIncrement.
""",
    "CalendarDatePicker": """\
@notes
  Text field + calendar flyout (MonthGrid); selectedDate with min/max bounds.
""",
    "MultiSelectComboBox": """\
@notes
  ComboBox with multi-check selection; selectedIndexes / selectedItems.
  exclusive mode behaves like a normal combo.
""",
    "Chip": """\
@notes
  Compact tag; closable emits closeClicked; appearance filled|outline.
""",
    "ChipGroup": """\
@notes
  Chip row from model; exclusive or multi (maxSelected); select(index).
""",
    "RatingControl": """\
@notes
  Star rating; value / maxRating; isReadOnly disables input.
""",
    "ProgressButton": """\
@notes
  Button that shows determinate/indeterminate progress while busy.
  setProgress / progressCompleted / progressFailed.
""",
    # --- command / overlay ---
    "CommandBar": """\
@notes
  Primary + secondary AppBar command row; overflow via secondary commands.
""",
    "CommandBarFlyout": """\
@notes
  Popup CommandBar; open at a target like Flyout.
""",
    "SplitButton": """\
@notes
  Primary click + chevron MenuFlyout; put MenuFlyoutItem children for the menu half.
""",
    "ToggleSplitButton": """\
@notes
  Checkable SplitButton; checked toggles the primary half.
""",
    "DropDownButton": """\
@notes
  Button that opens a MenuFlyout of children items.
""",
    "BreadcrumbBar": """\
@notes
  Path trail from model [{ title, icon? }]; itemClicked(index); overflow collapses.
""",
    "InfoBadge": """\
@notes
  Dot / value / glyph badge; severity styles the fill; value < 0 may hide digits.
""",
    "Toast": """\
@notes
  Transient toast content; prefer ToastHost.info/success/warning/error helpers.
""",
    "ToastHost": """\
@notes
  Stack host for Toast; info/success/warning/error enqueue helpers.
""",
    "SwipeControl": """\
@notes
  Content + left/right SwipeAction reveal; openLeft/openRight/close.
""",
    "RefreshContainer": """\
@notes
  Pull-to-refresh wrapper; onRefreshRequested then endRefresh() when done.
""",
    "FlipView": """\
@notes
  Paged swipe view; currentIndex + buttonsVisible / isIndicatorVisible.
""",
    "PipsPager": """\
@notes
  Dot pager synced to a FlipView / SwipeView currentIndex.
""",
    "Pivot": """\
@notes
  Tab-like pivot headers + content; model or PivotItem children.
""",
    "SegmentedControl": """\
@notes
  Exclusive segment buttons from model; currentIndex selection.
""",
    "SelectorBar": """\
@notes
  Horizontal selector tabs; model + currentIndex (nav-style underlines).
""",
    "StepBar": """\
@notes
  Step indicator; model of steps, currentIndex; stepClicked when interactive.
""",
    "Timeline": """\
@notes
  Vertical timeline of events; model items with title/time/description.
""",
    "Expander": """\
@notes
  Header + expandable content; expanded / expand/collapse.
""",
    "SettingsCard": """\
@notes
  Settings row card with symbol, title, description, and trailing content slot.
""",
    "SettingsExpander": """\
@notes
  Expander styled as a settings group; header + nested SettingsCard children.
""",
    "EmptyState": """\
@notes
  Placeholder for empty lists; title/message + optional action.
""",
    "MenuFlyout": """\
@notes
  Menu-styled Flyout; host MenuFlyoutItem / Separator / Header children.
""",
    "WindowChrome": """\
@notes
  Internal title-bar chrome for ShellWindow (caption + header slots).
""",
    "CopyButton": """\
@notes
  Copies textToCopy (or copy(text)); flashes doneGlyph; copyCompleted/copyFailed.
""",
    "ColorPickerButton": """\
@notes
  Swatch button that opens ColorPicker; bind selectedColor.
""",
    "PersonPicture": """\
@notes
  Avatar from source image or displayName initials.
""",
    "AvatarGroup": """\
@notes
  Overlapping PersonPicture stack; maxVisible + overflowCount chip.
""",
    "RadioButtons": """\
@notes
  Grouped RadioButton column from model; selectedIndex.
""",
    "SwitchPresenter": """\
@notes
  Shows one SwitchCase child by currentCase / setCaseActive(name).
""",
    "MeterBar": """\
@notes
  Segmented meter / progress levels; value within minimum..maximum.
""",
    "ProgressRing": """\
@notes
  Circular progress; indeterminate or value 0..1.
""",
    "StatusDot": """\
@notes
  Presence dot; status available|busy|away|offline (or custom color).
""",
    "TextBlock": """\
@notes
  Themed text helper (style/weight tokens); prefer for Fluent type ramps.
""",
    "FontIcon": """\
@notes
  FluentIcons symbol / glyph text; fontSize for px size.
""",
    "HyperlinkButton": """\
@notes
  Link-styled button; navigateUri + optional external glyph.
""",
    "ActionCard": """\
@notes
  Clickable settings-style card with chevron; onClicked for navigation.
""",
    "ContentCard": """\
@notes
  Surface card with title/subtitle/symbol and body slot.
""",
    "GridTile": """\
@notes
  Icon + title tile for grids; onClicked.
""",
    "ListTile": """\
@notes
  List row tile with leading symbol and trailing slot.
""",
    "RelativePanel": """\
@notes
  Constraint layout via RelativePanel.* attached properties on children.
""",
    "StackPanel": """\
@notes
  Simple stack/flow panel with orientation + spacing.
""",
    "UniformGrid": """\
@notes
  Even cell grid; columns / rows + cellSpacing.
""",
    "DockPanel": """\
@notes
  Dock children to edges (DockPanel.dock attached); last child fills.
""",
    "WrapPanel": """\
@notes
  Wrapping flow of children; itemSpacing / orientation.
""",
}


def commentize_notes(block: str) -> str:
    lines = []
    for line in block.strip("\n").splitlines():
        s = line.strip()
        if not s:
            lines.append("//")
        elif s.startswith("@"):
            lines.append("// " + s)
        else:
            lines.append("//   " + s)
    return "\n".join(lines)


def main() -> None:
    dirs = [
        ROOT / "src/extras/QWinUI3/Extras",
        ROOT / "src/platform/QWinUI3/Platform",
    ]
    n = 0
    for d in dirs:
        for path in sorted(d.glob("*.qml")):
            if path.stem not in NOTES:
                continue
            text = path.read_text(encoding="utf-8")
            if "@notes" in text.split("\n", 80)[0:80] or "\n// @notes\n" in text[:2500]:
                # already has notes near header
                if "// @notes" in text[:3000]:
                    print(f"SKIP {path.relative_to(ROOT)}")
                    continue
            m = RE_HEADER_BLOCK.match(text)
            if not m:
                print(f"NOHDR {path.relative_to(ROOT)}")
                continue
            header = m.group("header").rstrip("\n")
            notes = commentize_notes(NOTES[path.stem])
            new_header = header + "\n//\n" + notes + "\n"
            new_text = text[: m.start("header")] + new_header + text[m.end("header") :]
            path.write_text(new_text, encoding="utf-8", newline="\n")
            print(f"NOTES {path.relative_to(ROOT)}")
            n += 1
    print(f"Added notes to {n} files")


if __name__ == "__main__":
    main()
