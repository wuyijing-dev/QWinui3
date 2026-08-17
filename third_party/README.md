# Third-party sources

| Path | In git clone? | License | Notes |
|------|---------------|---------|-------|
| `keyman/` | **Yes** (vendored) | MIT | SIL Keyman Core only (`core/` + `common/`). See [NOTICE-Keyman.md](../docs/NOTICE-Keyman.md). Refresh: `python scripts/fetch_keyman_core.py` then re-copy. |
| `webview2/` | **No** (gitignored) | Microsoft | NuGet SDK extract (~80 MB). Run `scripts/fetch_webview2.ps1` on Windows when building `WebView2Host`. |

Layout `.kmx` packs and pinyin tables live under `src/extras/QWinUI3/Extras/keyboards/` (also in clone).
