#!/usr/bin/env python3
"""Rewrite weak camelCase-split API comments with meaningful descriptions.

Only replaces a comment when it exactly matches humanize(apiName).
Then re-run: python scripts/generate_component_docs.py
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIRS = [
    ROOT / "src/extras/QWinUI3/Extras",
    ROOT / "src/style/QWinUI3",
    ROOT / "src/platform/QWinUI3/Platform",
    ROOT / "src/theme/QWinUI3/Theme",
]

HINTS: dict[str, str] = {
    "playReveal": "Play entrance reveal animation",
    "requestRedraw": "Request chart / canvas redraw",
    "select": "Select item by index",
    "focusField": "Move keyboard focus to the text field",
    "clear": "Clear text or selection",
    "clearAll": "Clear all items",
    "clearHover": "Clear hovered item state",
    "clearMenus": "Dismiss open menus",
    "clearNav": "Clear navigation model",
    "clearQueue": "Drop queued dialogs without dismissing the current one",
    "clearSelection": "Clear the current selection",
    "close": "Close / dismiss",
    "closeAll": "Close all open items",
    "closeFlyout": "Dismiss the flyout",
    "closeMenu": "Dismiss the menu",
    "closeTab": "Close tab at index",
    "open": "Open / show",
    "show": "Show the control",
    "hide": "Hide the control",
    "showAt": "Show anchored at the given point or item",
    "showMenu": "Open the associated menu",
    "relayout": "Recompute layout",
    "clampSnap": "Clamp and snap a value to the valid range",
    "setValue": "Set value (clamped / snapped)",
    "setValueFromNorm": "Set value from a normalized 0..1 input",
    "invalidateLod": "Invalidate level-of-detail cache",
    "ensureLod": "Build LOD samples for the given budget",
    "displayTextFor": "Display text for a model item",
    "refreshSuggestions": "Rebuild suggestion list from text",
    "pointColor": "Color for a series point",
    "pointX": "X coordinate for a series point",
    "pointY": "Y coordinate for a series point",
    "applyFromTumblers": "Commit tumbler selection into the value",
    "goNext": "Navigate to the next page / item",
    "goPrevious": "Navigate to the previous page / item",
    "goTo": "Navigate to the given index",
    "setSeverityName": "Set severity from a string name",
    "ready": "True when the control is ready",
    "has": "True when the named case / key exists",
    "itemAt": "Item at the given index",
    "moveIndicator": "Move selection indicator to index",
    "applyChrome": "Apply window chrome / backdrop",
    "hasSolidStroke": "True when a solid stroke is configured",
    "hasGradientStroke": "True when a gradient stroke is configured",
    "topStroke": "Top edge stroke color",
    "bottomStroke": "Bottom edge stroke color",
    "next": "Advance to next",
    "previous": "Go to previous",
    "crumbTitle": "Title text for a breadcrumb item",
    "crumbIcon": "Icon for a breadcrumb item",
    "isCurrent": "True when this crumb is the current page",
    "isClickable": "Emit clicked when activated",
    "bandColor": "Color for a qualitative band",
    "isDateAllowed": "True when the date is within selectable bounds",
    "asNumber": "Coerce input to number with fallback",
    "valueCount": "Number of values in the series input",
    "extents": "Min/max extents of a value series",
    "extentsXY": "X/Y extents of a point series",
    "copyHex": "Copy the current color hex to the clipboard",
    "clamp01": "Clamp to 0..1",
    "clamp": "Clamp to the valid range",
    "clampDay": "Clamp day into the current month",
    "clampValue": "Clamp value into min..max",
    "hsvToRgb": "Convert HSV to RGB components",
    "hsvToColor": "Convert HSV to a QColor",
    "rgbToHsv": "Convert RGB to HSV components",
    "hexString": "Format color as #RRGGBB[AA]",
    "byteHex": "Format a 0..255 channel as two hex digits",
    "parseHex": "Parse a hex color string",
    "acceptWheel": "Handle mouse-wheel value changes",
    "acceptableInput": "True when typed input is valid",
    "activateDefault": "Activate the default button / action",
    "addMenu": "Append a menu to the title-bar menus",
    "addNavGroup": "Append a navigation group",
    "addNavItem": "Append a navigation item",
    "addTab": "Append a tab",
    "addTabButtonClicked": "Emitted when the add-tab button is clicked",
    "addToken": "Insert a token from text",
    "animatedSweep": "Animated sweep angle for gauges",
    "antialiasing": "Enable antialiased drawing",
    "applyValue": "Commit the pending value",
    "badgeGlyph": "Badge Fluent glyph string",
    "badgeSymbol": "Badge FluentIcons symbol",
    "baseColor": "Base / track color",
    "beginRefresh": "Start a pull-to-refresh cycle",
    "endRefresh": "End a pull-to-refresh cycle",
    "blurMax": "Maximum blur radius",
    "bodyHeight": "Body content height",
    "borderColor": "Border color",
    "borderWidth": "Border width in px",
    "bottomEdge": "Bottom edge anchor",
    "bump": "Nudge value by one step",
    "caseChanged": "Emitted when the active SwitchPresenter case changes",
    "cases": "Named case content map",
    "catCount": "Category count",
    "categoryClicked": "Emitted when a category is clicked",
    "cellClicked": "Emitted when a cell is clicked",
    "cellH": "Cell height",
    "cellHeight": "Cell height",
    "cellSpacing": "Spacing between cells",
    "cellW": "Cell width",
    "cellWidth": "Cell width",
    "centerContent": "Center content slot",
    "centerX": "Center X in local coords",
    "centerY": "Center Y in local coords",
    "cx": "Center X",
    "cy": "Center Y",
    "characterCount": "Character count of the text",
    "childHeight": "Child item height",
    "childWidth": "Child item width",
    "chordText": "Keyboard chord display text",
    "closedByUser": "True when the user dismissed the dialog",
    "color": "Primary color",
    "cols": "Column count",
    "columnSpacing": "Horizontal spacing between columns",
    "commitText": "Commit edited text",
    "commitValue": "Commit the edited value",
    "complete": "Mark the step / task complete",
    "completedText": "Text shown when complete",
    "contentCenterY": "Animated content center Y",
    "contentRow": "Content row container",
    "contentYForIndex": "contentY that scrolls index into view",
    "copy": "Copy to clipboard",
    "copyCompleted": "Emitted after a successful copy",
    "copyFailed": "Emitted when copy fails",
    "currentContentY": "Current Flickable contentY",
    "currentIndexEdited": "Emitted when currentIndex changes via user edit",
    "decimals": "Decimal places for formatting",
    "delta": "Delta from target / previous",
    "deltaPositive": "True when delta is positive",
    "didDrag": "True after a drag gesture",
    "displayHour": "Hour shown in the current clock format",
    "dockOf": "Dock edge for a child",
    "dot": "Dot / pip indicator",
    "dragActive": "True while a drag is in progress",
    "drawSweep": "Draw the gauge sweep arc",
    "eased": "Eased 0..1 animation progress",
    "edgeResize": "Enable edge resize grips",
    "editingFinished": "Emitted when editing finishes",
    "effectivePlacement": "Resolved flyout placement",
    "elevated": "Use elevated chrome",
    "elevation": "Elevation level",
    "enqueue": "Enqueue a dialog / toast",
    "ensureObjectModel": "Ensure model is an ObjectModel",
    "equalWidth": "Force equal-width segments",
    "errorText": "Error message text",
    "errorToast": "Show an error toast",
    "fail": "Mark the operation failed",
    "fill": "Fill color / fill factor",
    "filledExact": "Exactly filled segment count",
    "filledSegments": "Filled segment count",
    "filteredSuggestions": "Suggestions matching the query",
    "firstValue": "First series value",
    "flashInvalid": "Flash invalid-input feedback",
    "flyoutGroupKey": "Group key for exclusive flyouts",
    "flyoutHovered": "True while the flyout is hovered",
    "format": "Format / formatter callback",
    "frameRadius": "Frame corner radius",
    "fullyFilled": "True when all segments are filled",
    "glyphColor": "Glyph / icon color",
    "headerComponent": "Optional header component",
    "heroContent": "Hero content slot",
    "hex2": "Two-digit hex for a channel",
    "highColor": "High-zone color",
    "hour": "Selected hour",
    "hoverCategory": "Hovered category index",
    "hoverCol": "Hovered column index",
    "hoverX": "Pointer X while hovered",
    "hoverY": "Pointer Y while hovered",
    "inMonth": "True when the day is in the displayed month",
    "info": "Show an informational toast / tip",
    "initials": "Initials shown when no image",
    "innerRadius": "Inner radius",
    "innerSize": "Inner size",
    "innerWidth": "Inner width",
    "inputInvalid": "True when input fails validation",
    "isAm": "True in AM for 12-hour clock",
    "isEnabled": "Enabled state alias",
    "isLast": "True for the last item",
    "isPanel": "True when rendered as a panel",
    "isPartial": "True for a partially filled segment",
    "isPlaceholder": "True when showing placeholder",
    "isRawGlyph": "True when iconGlyph is a raw glyph (not a symbol name)",
    "isSelected": "True when this item is selected",
    "isToday": "True when the day is today",
    "itemHeight": "Item height",
    "itemSpacing": "Spacing between items",
    "itemWidth": "Item width",
    "keySpacing": "Spacing between keys",
    "keyboardNavigationEnabled": "Allow arrow-key navigation",
    "label": "Field / series label",
    "labelH": "Label area height",
    "lastValue": "Last series value",
    "layoutPanes": "Recompute TwoPaneView pane layout",
    "leftContent": "Leading content slot",
    "leftEdge": "Left edge anchor",
    "lerpColor": "Linearly interpolate two colors",
    "levels": "Discrete level descriptors",
    "lookupName": "Resolve a Fluent icon name",
    "lowColor": "Low-zone color",
    "maxLeftReveal": "Max left swipe reveal width",
    "maxLines": "Maximum wrapped line count",
    "maxRightReveal": "Max right swipe reveal width",
    "minWideWidth": "Minimum width for wide layout",
    "minWidth": "Minimum width",
    "minute": "Selected minute",
    "minuteModel": "Minute tumbler model",
    "mode": "Display / interaction mode",
    "modeName": "Human-readable mode name",
    "moveRetries": "Retry count when moving a window",
    "moveTab": "Move a tab from/to index",
    "moveTo": "Move to the given index / position",
    "navActivated": "Emitted when a nav item is activated",
    "navigateRequested": "Emitted to request navigation",
    "navigateUri": "Navigate to a URI",
    "newestOnTop": "Stack newest items on top",
    "nextButtonVisibility": "Visibility of the next button",
    "nextEnabled": "True when next is available",
    "nodeColor": "Node / marker color",
    "nodeSize": "Node / marker size",
    "normFromPoint": "Normalize a pointer position to 0..1",
    "normFromValue": "Normalize a value to 0..1",
    "normalized": "Normalized 0..1 value",
    "onBackRequested": "Forward NavigationView back request",
    "onCornerPreferenceChanged": "React to corner preference changes",
    "onCountChanged": "React to count changes",
    "onCurrentIndexChanged": "React to currentIndex changes",
    "onDarkChanged": "React to Theme.dark changes",
    "onFooterClicked": "Forward footer click",
    "onImplicitWidthChanged": "React to implicitWidth changes",
    "onPaneSearchActivated": "Forward pane search activation",
    "openAll": "Expand / open all items",
    "openCount": "Number of open items",
    "openFlyout": "Open the flyout",
    "openLeft": "Reveal left swipe actions",
    "openMenu": "Open the menu",
    "openQueued": "Open the next queued dialog",
    "openRight": "Reveal right swipe actions",
    "outerSize": "Outer size",
    "overLimit": "True when over the max limit",
    "padL": "Left padding / plot inset",
    "padT": "Top padding / plot inset",
    "pane1Length": "Primary pane length",
    "panePriority": "Which pane takes priority when collapsing",
    "panePriorityWidth": "Width threshold for pane priority",
    "panelSpacing": "Spacing between panels",
    "partialAmount": "Partial fill amount 0..1",
    "pauseOnHover": "Pause auto-advance while hovered",
    "pendingFlyoutAnchor": "Anchor item for a pending flyout",
    "pendingFlyoutKey": "Key for a pending flyout",
    "plotL": "Plot left inset",
    "plotT": "Plot top inset",
    "plotW": "Plot width",
    "plotH": "Plot height",
    "pointClicked": "Emitted when a chart point is clicked",
    "pointCount": "Number of points",
    "preferredHeight": "Preferred height hint",
    "preferredMode": "Preferred display mode",
    "preferredWidth": "Preferred width hint",
    "prefix": "Leading text prefix",
    "pressValue": "Value captured on press",
    "prev": "Previous animated value",
    "previousEnabled": "True when previous is available",
    "progressCompleted": "Emitted when progress reaches completion",
    "progressFailed": "Emitted when progress fails",
    "progressIndeterminate": "Show indeterminate progress",
    "progressingText": "Text while progress is running",
    "pullText": "Pull-to-refresh prompt text",
    "pulseOpacity": "Pulse animation opacity",
    "pushHostContent": "Push content into the host",
    "pushItem": "Push an item onto the stack",
    "pushRect": "Push a rectangle into hit-test clientRects",
    "r": "Radius",
    "railWidth": "Track / rail width",
    "reanchor": "Recompute popup anchor",
    "remaining": "Remaining count / time",
    "removeToken": "Remove a token",
    "reparentPanes": "Reparent TwoPaneView panes for mode",
    "reportHitTest": "Report title-bar hit-test layout to WindowHelper",
    "reposition": "Reposition the popup / flyout",
    "reset": "Reset to defaults",
    "revealButtonVisible": "Show password reveal button",
    "revealPassword": "True while password is revealed",
    "rightContent": "Trailing content slot",
    "rightEdge": "Right edge anchor",
    "rowSpacing": "Vertical spacing between rows",
    "sameDay": "True when two dates are the same calendar day",
    "screenPts": "Points in screen coordinates",
    "segSweep": "Segment sweep angle",
    "selectAll": "Select all items",
    "selectIndex": "Select by index",
    "selectedItems": "Currently selected items",
    "separator": "Separator item / glyph",
    "setCaseActive": "Activate a SwitchPresenter case by name",
    "setPresenterKind": "Set AppWindow presenter kind",
    "setProgress": "Set progress 0..1",
    "setStyleName": "Set style by name",
    "shadowBlur": "Shadow blur radius",
    "shadowOpacity": "Shadow opacity",
    "shape": "Shape variant",
    "sheenColor": "Sheen / highlight color",
    "showExternalGlyph": "Show external-link glyph",
    "showPane1": "Show primary pane",
    "showPane2": "Show secondary pane",
    "showPercentage": "Show percentage readout",
    "singlePaneIndex": "Which pane is shown in single-pane mode",
    "snapMinute": "Snap minutes to the increment",
    "sourcePointCountEstimate": "Estimated source point count before LOD",
    "start": "Start animation / operation",
    "statusColor": "Status indicator color",
    "statusName": "Status name string",
    "stepActivated": "Emitted when a step is activated",
    "stepClicked": "Emitted when a step is clicked",
    "styleName": "Current style name",
    "submitQuery": "Submit the search query",
    "successToast": "Show a success toast",
    "suffix": "Trailing text suffix",
    "swapPanes": "Swap primary / secondary panes",
    "syncChildren": "Synchronize child item state",
    "syncIndicatorIfIdle": "Sync selection indicator when idle",
    "syncSelectedDateFromParts": "Rebuild selected date from Y/M/D parts",
    "syncTumblers": "Sync tumbler positions to the value",
    "tabCount": "Number of tabs",
    "tabIndex": "Tab index in the model",
    "tabIndexAtContentX": "Tab index under a contentX",
    "targetGeometry": "Target geometry for placement",
    "textEdited": "Emitted while text is being edited",
    "timeChosen": "Emitted when a time is chosen",
    "toPascalCase": "Convert an identifier to PascalCase",
    "toastActionClicked": "Emitted when a toast action is clicked",
    "toastClosed": "Emitted when a toast is closed",
    "toggle": "Toggle checked / expanded state",
    "toggleAt": "Toggle item at index",
    "toggleIndex": "Toggle selection at index",
    "toggleSinglePane": "Toggle single-pane mode",
    "topEdge": "Top edge anchor",
    "travel": "Absolute travel distance for the pip",
    "trendColor": "Trend / delta color",
    "url": "URL / source URL",
    "use24Hour": "Use 24-hour clock",
    "valueColor": "Value / series color",
    "valueFromPos": "Map a pointer position to a value",
    "valueModified": "Emitted when the value is modified by the user",
    "valuesEqual": "True when two values compare equal",
    "visibleChildren": "Currently visible child items",
    "visited": "True when the step was visited",
    "visualHeight": "Current visual height (stretch / animation)",
    "warningToast": "Show a warning toast",
    "zFrom": "Zone / arc start Z",
    "zStart": "Zone / arc start angle",
    "zSweep": "Zone / arc sweep angle",
    "zTo": "Zone / arc end Z",
    "footer": "Footer text",
    "appearance": "filled | outline appearance",
    "chipSize": "small | medium chip size",
    "activeZoneColor": "Color of the active gauge zone",
    "activeZoneIndex": "Index of the active gauge zone",
    "activeZoneLabel": "Label of the active gauge zone",
    "makeCloud": "Build a soft cloud brush / fill path",
    "palette": "Resolve a chart palette color by index",
    "withAlpha": "Return color with overridden alpha",
    "formatNumber": "Format a number for axis / tooltip text",
    "lerp": "Linear interpolate between two numbers",
    "applyHsv": "Apply HSV channels to selectedColor",
    "commitRgbFields": "Commit RGB text fields into selectedColor",
    "commitHsvFields": "Commit HSV text fields into selectedColor",
    "selectNavKey": "Forward selection to the hosted NavigationView",
    "syncWidths": "Sync SwitchPresenter case widths",
    "tabItemAt": "Tab item at the given index",
    "snapTo": "Snap the selection pip instantly",
    "animateTo": "Animate the selection pip to the target",
}

PROP = re.compile(
    r"^(\s*)((?:readonly\s+|default\s+|required\s+)*property\s+"
    r"(?:alias\s+)?[\w.<>,\s]+?\s+)(\w+)\b"
)
SIG = re.compile(r"^(\s*)(signal\s+)(\w+)\b")
FUNC = re.compile(r"^(\s*)(function\s+)(\w+)\b")
COMMENT = re.compile(r"^(\s*)//\s*(.+?)\s*$")


def humanize(name: str) -> str:
    words = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", name).replace("_", " ")
    return (words[:1].upper() + words[1:]) if words else name


def smart_hint(name: str) -> str | None:
    if name in HINTS:
        return HINTS[name]
    if name.startswith("is") and len(name) > 2 and name[2].isupper():
        return f"True when {humanize(name[2:]).lower()}"
    if name.startswith("has") and len(name) > 3 and name[3].isupper():
        return f"True when {humanize(name[3:]).lower()} is present / set"
    if name.startswith("show") and len(name) > 4 and name[4].isupper():
        return f"Show {humanize(name[4:]).lower()}"
    if name.startswith("hide") and len(name) > 4 and name[4].isupper():
        return f"Hide {humanize(name[4:]).lower()}"
    if name.startswith("set") and len(name) > 3 and name[3].isupper():
        return f"Set {humanize(name[3:]).lower()}"
    if name.startswith("get") and len(name) > 3 and name[3].isupper():
        return f"Get {humanize(name[3:]).lower()}"
    if name.endswith("Clicked"):
        return f"Emitted when {humanize(name[:-7]).lower()} is clicked"
    if name.endswith("Changed"):
        return f"Emitted when {humanize(name[:-7]).lower()} changes"
    if name.endswith("Requested"):
        return f"Emitted to request {humanize(name[:-9]).lower()}"
    if name.endswith("Color"):
        return f"{humanize(name[:-5])} color"
    if name.endswith("Width"):
        return f"{humanize(name[:-5])} width"
    if name.endswith("Height"):
        return f"{humanize(name[:-6])} height"
    if name.endswith("Count"):
        return f"{humanize(name[:-5])} count"
    if name.endswith("Index"):
        return f"{humanize(name[:-5])} index"
    if name.endswith("Model"):
        return f"{humanize(name[:-5])} model"
    if name.endswith("Text"):
        return f"{humanize(name[:-4])} text"
    if name.endswith("Enabled"):
        return f"True when {humanize(name[:-7]).lower()} is enabled"
    if name.endswith("Visible"):
        return f"True when {humanize(name[:-7]).lower()} is visible"
    return None


def main() -> None:
    replaced = files = still = 0
    for d in DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            lines = path.read_text(encoding="utf-8").splitlines()
            changed = False
            for i, line in enumerate(lines):
                cm = COMMENT.match(line)
                if not cm:
                    continue
                nxt = lines[i + 1] if i + 1 < len(lines) else ""
                m = PROP.match(nxt) or SIG.match(nxt) or FUNC.match(nxt)
                if not m:
                    continue
                name = m.group(3)
                if name.startswith("_"):
                    continue
                comment = cm.group(2).strip()
                if comment != humanize(name):
                    continue
                hint = smart_hint(name)
                if not hint or hint == comment:
                    still += 1
                    continue
                lines[i] = f"{cm.group(1)}// {hint}"
                replaced += 1
                changed = True
            if changed:
                path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
                files += 1
                print(f"POLISH {path.relative_to(ROOT)}")
    print(f"Replaced {replaced} comments in {files} files; still-humanize {still}")


if __name__ == "__main__":
    main()
