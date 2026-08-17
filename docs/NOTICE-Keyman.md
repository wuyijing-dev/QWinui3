# SIL Keyman Core

This product links [SIL Keyman Core](https://github.com/keymanapp/keyman/tree/master/core)
(`libkeymancore`) under the MIT License. Sources are fetched at build time into
`third_party/keyman` (not the full Keyman monorepo UI). Layout packs are community
`.kmx` files from [keymanapp/keyboards](https://github.com/keymanapp/keyboards) (MIT).
Shipped named subset (1.71 + 1.75): `basic_kbdus`, `basic_kbduk`, `basic_kbdgr`,
`basic_kbdfr`, `basic_kbdes`, `basic_kbdit`, `basic_kbdpo`, `basic_kbdpl`,
`basic_kbdsw`, `basic_kbdtuq`, `basic_kbdru`, `basic_kbda1`. Re-fetch:
`python scripts/fetch_keyman_keyboards.py`.

Upstream license: https://github.com/keymanapp/keyman/blob/master/LICENSE.md
