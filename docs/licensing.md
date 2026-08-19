# Licensing (Apache-2.0)

QWinUI3 (Theme, Style, Platform, Extras, Gallery, and examples) is licensed under
the **[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)**.

You may use the kit in proprietary products: include `LICENSE` (and `NOTICE`
when redistributing), keep attribution, and respect the patent grant/termination
terms. There is **no copyleft** requirement on your application.

See also [ROADMAP.md](../ROADMAP.md) for release/version policy.

---

## Files

| File | Role |
|------|------|
| [LICENSE](../LICENSE) | Apache License 2.0 |
| [NOTICE](../NOTICE) | Attribution / third-party notices |

---

## Modules

| Module | CMake target | License |
|--------|--------------|---------|
| **Theme** | `qwinui3_theme` | Apache-2.0 |
| **Style** | `qwinui3_style` | Apache-2.0 |
| **Platform** | `qwinui3_platform` | Apache-2.0 |
| **Compat** | `qwinui3_qtcompat` | Apache-2.0 |
| **Extras** | `qwinui3_extras` | Apache-2.0 |
| **Gallery** | `qwinui3_gallery` | Apache-2.0 |

---

## Third-party

| Component | Location | License |
|-----------|----------|---------|
| Keyman Core | `third_party/keyman/` | MIT — [NOTICE-Keyman.md](NOTICE-Keyman.md) |
| Pinyin lexicon | `src/extras/…/pinyin_*.tsv` | MIT — [NOTICE-pinyin.md](NOTICE-pinyin.md) |
| WinSymbols3 font | `src/theme/…/fonts/` | MIT — bundled `LICENSE-WinSymbols3.txt` |

These remain under their upstream licenses. They are compatible with Apache-2.0
redistribution when you keep the notices.

---

## FAQ

**Can I use NavigationView / DataTable / charts in a closed-source app?**  
Yes. The whole QWinUI3 tree is Apache-2.0.

**What changed from LGPL / MIT+GPL?**  
Through **2.64**, releases were labeled LGPL-3.0. A short MIT+GPL split lived on
`master` and was replaced by **Apache-2.0** for the entire kit.

**Qt runtime?**  
Qt itself is **LGPL-3.0 / commercial**. Deploy with `windeployqt` / `linuxdeploy`
and strip GPL Qt add-ons (Virtual Keyboard, Charts, WebEngine, …) per
[packaging-consumer.md](packaging-consumer.md). Apache-2.0 on QWinUI3 does not
relicense Qt.
