# Pinyin lexicon (MIT)

In-app pinyin tables are generated from:

- [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data) (MIT) → `pinyin_lexicon.tsv`
- [mozillazg/phrase-pinyin-data](https://github.com/mozillazg/phrase-pinyin-data) (MIT) → `pinyin_words.tsv`

Regenerate (not a CMake step):

```
python scripts/gen_pinyin_lexicon.py path/to/pinyin.txt path/to/phrase-pinyin.txt
```

**1.76:** phrases up to 6 characters; runtime prefix lookup so partial romanization can surface full phrases.

This is **not** Microsoft Pinyin and **not** Keyman IMX (`cs_pinyin`). Candidate chrome is `ImeCandidateBar.qml`.
