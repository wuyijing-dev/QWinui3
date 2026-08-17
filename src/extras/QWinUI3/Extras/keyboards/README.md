# Keyman layout packs + in-app IME tables

Compiled `.kmx` from [keymanapp/keyboards](https://github.com/keymanapp/keyboards)
(**MIT**). Re-fetch the named subset with:

```bat
python scripts/fetch_keyman_keyboards.py
```

## Shipped Keyman packs (direct layouts)

| Layout id | `.kmx` | Notes |
|-----------|--------|-------|
| en-US | `basic_kbdus` | 1.71 |
| en-GB | `basic_kbduk` | **1.75** |
| de-DE | `basic_kbdgr` | 1.71 |
| fr-FR | `basic_kbdfr` | 1.71 |
| es-ES | `basic_kbdes` | 1.71 |
| it-IT | `basic_kbdit` | **1.75** |
| pt-PT | `basic_kbdpo` | **1.75** |
| pl-PL | `basic_kbdpl` | **1.75** |
| sv-SE | `basic_kbdsw` | **1.75** |
| tr-TR | `basic_kbdtuq` | **1.75** Turkish-Q |
| ru-RU | `basic_kbdru` | 1.71 |
| ar | `basic_kbda1` | 1.71 Arabic-101; RTL |

This is a **named** subset — not every community keyboard.

## In-app IME (not Keyman IMX)

Pinyin tables: [NOTICE-pinyin.md](../../../../../docs/NOTICE-pinyin.md).

| Layout id | Engine | Notes |
|-----------|--------|-------|
| zh-Hans | `PinyinLexicon` | MIT pinyin-data |
| ja-JP | `RomajiKana` | Hepburn map — not a word lexicon |
| ko-KR | `HangulComposer` | Unicode syllables — not a hangul dictionary |

UI chrome stays in `OnScreenKeyboard.qml`.

## Bring your own `.kmx` (direct layouts only)

1. Drop a MIT `.kmx` in this folder.
2. Add it to `qt_add_resources` in `../CMakeLists.txt` (`qwinui3_keyman_keyboards`).
3. Map a layout id → filename in `KeyboardEngine` (`kLayoutIds` + `kmxResource` + label).

CJK candidates are **not** Keyman IMX / DLL packs.
