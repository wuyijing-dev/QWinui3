# Licensing (MIT + GPL-3.0)

QWinUI3 uses a **split license** so the Fluent **foundation** stays permissive while
**advanced composites** remain copyleft.

See also [ROADMAP.md](../ROADMAP.md) for release/version policy.

---

## Quick pick

| You ship… | License you must follow |
|-----------|-------------------------|
| **Theme + Style only** (`QT_QUICK_CONTROLS_STYLE=QWinUI3`) | **MIT** |
| **Theme + Style + Platform** (tokens + styled controls + `StandardWindow` / `Bootstrap`) | **MIT** |
| **Extras** (`import QWinUI3.Extras`) or **Gallery** | **GPL-3.0-or-later** on your app (Extras is GPL) |
| **MIT modules + Extras** | **GPL-3.0** applies to the combined work (Extras is GPL; MIT deps are compatible) |

---

## MIT modules (permissive)

| Module | CMake target | What it covers |
|--------|--------------|----------------|
| **Theme** | `qwinui3_theme` | `QWinUI3.Theme` — colors, typography, spacing, `FluentIcons`, theme sync |
| **Style** | `qwinui3_style` | Fluent chrome for standard `QtQuick.Controls` (Button, TextField, Slider, …) |
| **Platform** | `qwinui3_platform` | `QWinUI3.Platform` — `StandardWindow`, title chrome, `WindowHelper`, `Bootstrap` |
| **Compat** | `qwinui3_qtcompat` | Internal Qt version shims (linked by the modules above) |

**License text:** [LICENSE-MIT](../LICENSE-MIT)  
**Per-module copy:** `src/theme/…/LICENSE`, `src/style/…/LICENSE`, `src/platform/…/LICENSE`

---

## GPL-3.0 modules (copyleft)

| Module | CMake target | What it covers |
|--------|--------------|----------------|
| **Extras** | `qwinui3_extras` | All of `QWinUI3.Extras` — NavigationView, DataTable, ContentDialog, charts,
gauges, settings cards, CommandPalette, TeachingTip, RichEdit, OSK panel, shell
windows beyond Platform bootstrap, etc. |
| **Gallery** | `qwinui3_gallery` | Reference demo application |

**License text:** [LICENSE-GPL](../LICENSE-GPL) (same as [COPYING](../COPYING))  
**Per-module copy:** `src/extras/QWinUI3/Extras/LICENSE`

If your product imports **Extras**, plan for **GPL-3.0 compliance** (source
availability, license notices, reciprocal licensing of the combined work).

---

## Packaging presets

| Preset | Modules | Typical license footprint |
|--------|---------|---------------------------|
| `core` / `theme`+`style` | Theme, Style (+ Platform via style link) | **MIT** |
| `shell` | Theme, Style, Platform | **MIT** |
| `all` / `full` | Theme, Style, Platform, Extras | **GPL** if you use Extras QML types |

`python scripts/package_release_libs.py --preset shell` → MIT-friendly kit.  
`--preset all` → includes GPL **Extras** DLL/QML.

---

## Third-party

| Component | Location | License |
|-----------|----------|---------|
| Keyman Core | `third_party/keyman/` | MIT — [NOTICE-Keyman.md](NOTICE-Keyman.md) |
| Pinyin lexicon | `src/extras/…/pinyin_*.tsv` | MIT — [NOTICE-pinyin.md](NOTICE-pinyin.md) |
| WinSymbols3 font | `src/theme/…/fonts/` | MIT — bundled `LICENSE-WinSymbols3.txt` |

---

## FAQ

**Can I use only styled Button/TextField in a closed-source app?**  
Yes — **Style + Theme** (and **Platform** if you use `StandardWindow`) are **MIT**.

**Does NavigationView require GPL?**  
Yes — it lives in **Extras** (`QWinUI3.Extras`).

**What changed from LGPL-3.0?**  
Through **2.64**, releases were labeled LGPL-3.0 for the whole kit. **Master** now uses the split above; [LICENSE](../LICENSE) is the index.

**Qt runtime?**  
Qt itself is **LGPL-3.0 / commercial**. Deploy with `windeployqt` / `linuxdeploy`
and strip GPL Qt add-ons per [packaging-consumer.md](packaging-consumer.md).
