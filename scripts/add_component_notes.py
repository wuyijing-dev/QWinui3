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
