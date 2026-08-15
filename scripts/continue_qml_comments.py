#!/usr/bin/env python3
"""Continue filling missing // comments on public QML APIs."""
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

HINTS = {
    "textToCopy": "Clipboard payload to copy",
    "idleGlyph": "Glyph before copy succeeds",
    "doneGlyph": "Glyph shown after copy",
    "feedbackMs": "Success feedback duration in ms",
    "copied": "Emitted after a successful copy",
    "iconOnly": "Hide text; show glyph only",
    "hue": "Hue 0..360",
    "saturation": "Saturation 0..1",
    "alpha": "Alpha 0..1",
    "colorModel": "rgb | hsv | hex editor mode",
    "isColorSpectrumVisible": "Show color spectrum",
    "isColorPreviewVisible": "Show color preview swatch",
    "isColorChannelTextInputVisible": "Show channel text inputs",
    "isHexInputVisible": "Show hex input",
    "spectrumShape": "Spectrum shape variant",
    "valueChannel": "Which channel the slider edits",
    "plotL": "Plot left inset",
    "plotT": "Plot top inset",
    "plotW": "Plot width",
    "plotH": "Plot height",
    "lo": "Computed axis minimum",
    "hi": "Computed axis maximum",
    "year": "Selected year",
    "month": "Selected month 1..12",
    "day": "Selected day of month",
    "minYear": "Minimum selectable year",
    "maxYear": "Maximum selectable year",
    "daysInMonth": "Days in the selected month",
    "dateFormat": "Display date format",
    "showTodayButton": "Show Today button in calendar",
    "minDate": "Minimum selectable date",
    "maxDate": "Maximum selectable date",
    "hasMinDate": "True when minDate is set",
    "hasMaxDate": "True when maxDate is set",
    "separatorSymbol": "Breadcrumb separator FluentIcons symbol",
    "separatorGlyph": "Breadcrumb separator glyph string",
    "effectiveSeparatorGlyph": "Resolved separator glyph",
    "visibleModel": "Visible (non-overflow) crumbs",
    "overflowModel": "Overflow crumb items",
    "fontSize": "Font size in px",
    "mirrorGlyph": "Mirror glyph for RTL",
    "fontWeight": "Font weight",
    "accessibleName": "Accessible name override",
    "secondaryActionText": "Secondary action button label",
    "compact": "Compact layout density",
    "showGlyph": "Show leading glyph",
    "secondaryActionClicked": "Secondary action clicked",
    "isToggleButtonVisible": "Show toggle / more button",
    "opening": "True while opening",
    "closing": "True while closing",
    "moreButtonClicked": "Overflow more button clicked",
    "targetDelta": "Value minus target",
    "formattedDelta": "Formatted target delta text",
    "prev": "Previous animated value",
    "cur": "Current animated value",
    "showOverflowCount": "Show +N overflow chip",
    "personClicked": "Avatar clicked",
    "overflowClicked": "Overflow chip clicked",
    "overflowCount": "Hidden avatar count",
    "source": "Image / media source",
    "tileWidth": "Tile width",
    "tileHeight": "Tile height",
    "buttonsVisible": "Show next/prev buttons",
    "isButtonsVisible": "Alias of buttonsVisible",
    "isIndicatorVisible": "Show page indicator",
    "primaryData": "Primary commands slot",
    "secondaryData": "Secondary commands slot",
    "showSecondary": "Show secondary command list",
    "exclusive": "Single-select when true",
    "maxSelected": "Max selected chips when not exclusive",
    "chipSpacing": "Spacing between chips",
    "outer": "Donut outer radius",
    "inner": "Donut inner radius",
    "showHexLabel": "Show hex text on the button",
    "hexText": "Formatted hex color text",
    "separatorColor": "Separator color",
    "margin": "Outer margin",
    "pendingCount": "Dialogs waiting in the queue",
    "isClickable": "Emit clicked when activated",
    "largeSeriesThreshold": "Point count that triggers LOD",
    "itemHovered": "Emitted when a legend item is hovered",
    "headerActions": "Trailing header actions slot",
    "gap": "Gap between items",
    "host": "Host item for popup anchoring",
    "angDeg": "Angle in degrees",
    "sampled": "Downsampled series values",
    "t": "Normalized 0..1 parameter",
    "rr": "Resolved radius",
    "segmentIndex": "Active segment index",
    "busy": "Queue has an active dialog",
    "time": "Selected time",
    "hour": "Hour",
    "minute": "Minute",
    "second": "Second",
    "period": "AM/PM period",
    "clockFormat": "12 | 24 hour clock",
    "minuteIncrement": "Minute step",
    "selectedTime": "Selected time value",
    "luminance": "Luminance 0..1",
    "valueNorm": "Normalized 0..1 value",
    "dragEnabled": "Allow pointer drag to change value",
    "snapToTicks": "Snap thumb to ticks",
    "majorTickCount": "Number of major ticks",
    "minorTickCount": "Minor ticks between majors",
    "showZones": "Show colored zones",
    "zoneModel": "Zone descriptors",
    "needleColor": "Needle color",
    "needleWidth": "Needle width",
    "centerDot": "Show center hub",
    "readout": "Value readout text",
    "formatValue": "Value formatter callback",
    "emptyTitle": "Empty-state title",
    "emptyMessage": "Empty-state message",
    "loading": "Loading state",
    "error": "Error state / severity",
    "retryText": "Retry action label",
    "retryClicked": "Retry clicked",
}

SKIP = {"index", "modelData"}
PROP = re.compile(
    r"^(\s*)((?:readonly\s+|default\s+|required\s+)*property\s+"
    r"(?:alias\s+)?[\w.<>,\s]+?\s+)(\w+)\b"
)
SIG = re.compile(r"^(\s*)(signal\s+)(\w+)\b")


def humanize(name: str) -> str:
    words = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", name).replace("_", " ")
    return words[:1].upper() + words[1:] if words else name


def annotate(use_fallback: bool) -> tuple[int, int]:
    inserted = changed = 0
    for d in DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            lines = path.read_text(encoding="utf-8").splitlines()
            out: list[str] = []
            file_changed = False
            limit = 800 if path.name == "Theme.qml" else 280
            for i, line in enumerate(lines):
                prev = out[-1] if out else ""
                m = PROP.match(line) or SIG.match(line)
                if m and i < limit and not prev.strip().startswith("//"):
                    name = m.group(3)
                    if not (
                        name.startswith("_")
                        or name in SKIP
                        or "required " in m.group(2)
                    ):
                        hint = HINTS.get(name)
                        if not hint and use_fallback:
                            hint = humanize(name)
                        if hint:
                            out.append(f"{m.group(1)}// {hint}")
                            inserted += 1
                            file_changed = True
                out.append(line)
            if file_changed:
                path.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")
                changed += 1
    return inserted, changed


def remaining() -> tuple[int, int]:
    props = files = 0
    for d in DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            lines = path.read_text(encoding="utf-8").splitlines()
            u = 0
            for i, line in enumerate(lines[:280]):
                m = PROP.match(line) or SIG.match(line)
                if not m:
                    continue
                name = m.group(3)
                if name.startswith("_") or name in SKIP or "required " in m.group(2):
                    continue
                prev = lines[i - 1].strip() if i else ""
                if not prev.startswith("//"):
                    u += 1
            if u:
                files += 1
                props += u
    return props, files


if __name__ == "__main__":
    a, b = annotate(False)
    print(f"hint pass: {a} comments in {b} files")
    a, b = annotate(True)
    print(f"fallback pass: {a} comments in {b} files")
    p, f = remaining()
    print(f"remaining undoc (excl index/modelData): {p} in {f} files")
