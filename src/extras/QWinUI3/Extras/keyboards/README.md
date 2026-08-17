# Keyman layout packs + in-app IME tables

Compiled `.kmx` from [keymanapp/keyboards](https://github.com/keymanapp/keyboards)
(shipped subset: `basic_kbdus`, `basic_kbdgr`, `basic_kbdfr`, `basic_kbdes`,
`basic_kbdru`, `basic_kbda1`).

Pinyin tables: [NOTICE-pinyin.md](../../../../../docs/NOTICE-pinyin.md).

| Layout id | Engine | Notes |
|-----------|--------|-------|
| en-US … ar | SIL Keyman Core | Bundled `.kmx` above |
| zh-Hans | `PinyinLexicon` | MIT pinyin-data — not Keyman IMX |
| ja-JP | `RomajiKana` | Hepburn map — not a word lexicon |
| ko-KR | `HangulComposer` | Unicode syllables — not a hangul dictionary |

UI chrome stays in `OnScreenKeyboard.qml`.

## Bring your own `.kmx` (direct layouts only)

1. Drop a MIT `.kmx` in this folder.
2. Add it to `qt_add_resources` in `../CMakeLists.txt` (`qwinui3_keyman_keyboards`).
3. Map a layout id → filename in `KeyboardEngine` (`kLayoutIds` + `kmxResource` + label).

CJK candidates are **not** Keyman IMX / DLL packs.
