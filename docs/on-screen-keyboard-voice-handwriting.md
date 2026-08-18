# OSK voice & handwriting (cross-platform)

Optional **speech-to-text** and **handwriting** panels for `OnScreenKeyboard`. No custom neural nets — system/SDK/CLI only.

**Platforms:** Windows + Linux. macOS: not wired (backend returns `none`).

---

## Voice input

| OS | Backend | Setup |
|----|---------|--------|
| **Windows** | `System.Speech` (PowerShell helper) | Install a speech language pack; mic permission |
| **Linux** | `whisper-cli` **or** `vosk-transcriber` | Set env vars below + `alsa-utils` (`arecord`) |

### Linux environment

```bash
# Option A — Whisper
export QWINUI3_WHISPER_CLI=/usr/bin/whisper-cli   # optional; default: whisper-cli on PATH
export QWINUI3_WHISPER_MODEL=/path/to/ggml-base.bin

# Option B — Vosk
export QWINUI3_VOSK_BIN=/usr/bin/vosk-transcriber  # optional
export QWINUI3_VOSK_MODEL=/path/to/vosk-model-small-cn-0.22
```

Open **Settings → Voice** on the OSK, or tap the **mic** key. Recognized text is committed through `KeyboardEngine.commitText`.

---

## Handwriting input

| OS | Backend | Setup |
|----|---------|--------|
| **Windows / Linux** | [Zinnia](https://github.com/taku910/zinnia) CLI (`zinnia_character`) | Model file + optional binary path |

```bash
export QWINUI3_ZINNIA_MODEL=/path/to/handwriting-zh_CN.model
export QWINUI3_ZINNIA_BIN=/usr/bin/zinnia_character   # optional
```

Bundled lookup: `<appDir>/handwriting-zh_CN.model` if present.

Open **Settings → Handwriting**, draw strokes, tap **Recognize**, pick a candidate.

---

## Pinyin learning

`OskUserLexicon` stores local word-frequency in `QSettings` (`QWinUI3/OskUserLexicon`). Cleared from **Settings → Clear learned words**. Boosts candidate order only — no cloud sync.

---

## Related

- [on-screen-keyboard.md](on-screen-keyboard.md) — core OSK / IME
- [osk-in-apps-258.md](osk-in-apps-258.md) — dock + floating recipe
