# SIL Keyman Core

This product links [SIL Keyman Core](https://github.com/keymanapp/keyman/tree/master/core)
(`libkeymancore`) under the MIT License. Sources are **vendored in this repository** at
[`third_party/keyman`](../third_party/keyman) (`core/` + `common/` only — not the full
Keyman monorepo UI). A copy of the upstream MIT text is at
[`third_party/keyman/LICENSE.md`](../third_party/keyman/LICENSE.md).

Layout packs are community `.kmx` files from
[keymanapp/keyboards](https://github.com/keymanapp/keyboards) (MIT), shipped under
`src/extras/QWinUI3/Extras/keyboards/`. Named subset (1.71 + 1.75): `basic_kbdus`,
`basic_kbduk`, `basic_kbdgr`, `basic_kbdfr`, `basic_kbdes`, `basic_kbdit`,
`basic_kbdpo`, `basic_kbdpl`, `basic_kbdsw`, `basic_kbdtuq`, `basic_kbdru`,
`basic_kbda1`. Re-fetch packs: `python scripts/fetch_keyman_keyboards.py`.

Upstream license: https://github.com/keymanapp/keyman/blob/master/LICENSE.md

To refresh Core from upstream (maintainers): `python scripts/fetch_keyman_core.py`
(writes a sparse tree; keep `QWINUI3_FETCH_KEYMAN` as a fallback if the vendored
tree is deleted).
