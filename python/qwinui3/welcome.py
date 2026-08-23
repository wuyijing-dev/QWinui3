"""Terminal welcome splash for Python consumers (mirrors C++ WelcomeBanner)."""

from __future__ import annotations

import os
import sys
import time


def _env_truthy(name: str) -> bool:
    return os.environ.get(name, "").strip().lower() in {"1", "true", "yes", "on"}


_PRINTED = False

_PALETTES = (
    ("\033[38;5;39m", "\033[38;5;67m", "\033[38;5;159m", "\033[38;5;214m"),
    ("\033[38;5;141m", "\033[38;5;98m", "\033[38;5;183m", "\033[38;5;218m"),
    ("\033[38;5;43m", "\033[38;5;29m", "\033[38;5;120m", "\033[38;5;185m"),
    ("\033[38;5;208m", "\033[38;5;166m", "\033[38;5;223m", "\033[38;5;229m"),
    ("\033[38;5;205m", "\033[38;5;162m", "\033[38;5;218m", "\033[38;5;117m"),
)

_TIPS = (
    "Tip: NavigationWindow + Theme.dark — shell in under a minute",
    "Tip: Prefer docs/stable-api.md types in shipping apps",
    "Tip: FormLayout.beginValidate / endValidate for async rules",
    "Tip: PlatformCapability.mica before assuming Win11 materials",
    "Tip: DataTable reuseItems + maxFilterResults at 10k+ rows",
    "Tip: Theme.motion.ms(\"fast\") — honor Theme.reducedMotion",
    "Tip: examples/first-app before copying Gallery sources",
    "Tip: QWINUI3_NO_BANNER=1 quiets this splash",
)

_RESET = "\033[0m"
_BOLD = "\033[1m"
_INNER = 58

_WORDMARK = (
    "  ██████╗ ██╗    ██╗██╗███╗   ██╗██╗   ██╗██╗██████╗",
    " ██╔═══██╗██║    ██║██║████╗  ██║██║   ██║██║╚════██╗",
    " ██║   ██║██║ █╗ ██║██║██╔██╗ ██║██║   ██║██║ █████╔╝",
    " ██║▄▄ ██║██║███╗██║██║██║╚██╗██║╚██╗ ██╔╝██║ ╚═══██╗",
    " ╚██████╔╝╚███╔███╔╝██║██║ ╚████║ ╚████╔╝ ██║██████╔╝",
    "  ╚══▀▀═╝  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═════╝",
)


def _pad(s: str, width: int = _INNER) -> str:
    if len(s) > width:
        return s[: width - 1] + "…"
    return s.ljust(width)


def _enable_windows_ansi() -> None:
    if sys.platform != "win32":
        return
    try:
        import ctypes

        kernel32 = ctypes.windll.kernel32  # type: ignore[attr-defined]
        kernel32.SetConsoleOutputCP(65001)
        kernel32.SetConsoleCP(65001)
        handle = kernel32.GetStdHandle(-12)  # STD_ERROR_HANDLE
        mode = ctypes.c_uint32()
        if kernel32.GetConsoleMode(handle, ctypes.byref(mode)) == 0:
            return
        kernel32.SetConsoleMode(handle, mode.value | 0x0004)  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
    except Exception:
        pass


def print_welcome_banner(*, version: str = "dev", qt: str = "", support: str = "") -> None:
    """One-shot colorful welcome banner on stderr."""
    global _PRINTED
    if _PRINTED or _env_truthy("QWINUI3_NO_BANNER") or _env_truthy("QWINUI3_QUIET"):
        return
    _PRINTED = True
    _enable_windows_ansi()

    now = int(time.time() * 1000)
    accent, dim, bright, warn = _PALETTES[now // 1000 % len(_PALETTES)]
    tip = _TIPS[(now // 17) % len(_TIPS)]
    qt = qt or "?"
    support = support or "Qt 6.5+"

    def row(body: str) -> str:
        return f"{dim}  │ {_RESET}{body}{dim} │{_RESET}\n"

    lines = [
        "",
        f"{dim}{_BOLD}  ╭──────────────────────────────────────────────────────────╮{_RESET}",
        (
            f"{dim}  │ {_RESET}\033[38;5;203m●{_RESET} \033[38;5;221m●{_RESET} \033[38;5;114m●{_RESET}  "
            f"{bright}{_BOLD}QWinUI3{_RESET}{dim}                                       │{_RESET}"
        ),
        f"{dim}  │ ──────────────────────────────────────────────────────── │{_RESET}",
        row(f"{bright}{_pad('')}{_RESET}"),
    ]
    for wm in _WORDMARK:
        lines.append(row(f"{accent}{_BOLD}{_pad(wm)}{_RESET}"))
    lines.append(row(f"{bright}{_pad('')}{_RESET}"))
    lines.append(row(f"{bright}{_pad('Fluent · WinUI-style controls for Qt Quick')}{_RESET}"))
    lines.append(
        row(f"{warn}{_BOLD}{_pad(f'v{version}  ·  Qt {qt}  ·  {support}')}{_RESET}")
    )
    lines.append(row(f"{bright}{_pad('')}{_RESET}"))
    tip_body = tip if len(tip) <= _INNER - 2 else tip[: _INNER - 3] + "…"
    tip_body = tip_body.ljust(_INNER - 2)
    lines.append(f"{dim}  │ {_RESET}{warn}▸ {_RESET}{bright}{tip_body}{_RESET}{dim} │{_RESET}")
    lines.append(f"{dim}{_BOLD}  ╰──────────────────────────────────────────────────────────╯{_RESET}")
    lines.append("")
    sys.stderr.write("\n".join(lines) + "\n")
    sys.stderr.flush()
