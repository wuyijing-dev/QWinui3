# OSK voice & handwriting (in-process libraries)

Speech and handwriting run **inside the Gallery / app process**. There is **no** `whisper-cli`, `arecord`, `zinnia_character`, or PowerShell helper.

We **do not train** a net from scratch. We load **existing pretrained models / OS recognizers**:

| Feature | Preferred library (neural / ML) | Built-in fallback |
|---------|----------------------------------|-------------------|
| **Voice** | [Vosk](https://alphacephei.com/vosk/) (`libvosk`) — Kaldi DNN acoustic model | Windows **SAPI** in-proc recognizer |
| **Handwriting** | [Zinnia](https://github.com/taku910/zinnia) (`libzinnia`) — SVM character model | Windows **Ink** recognizer (language pack) |

**Platforms:** Windows + Linux. macOS: not wired.

---

## Voice (Vosk)

Drop the **shared library** and a **model directory** next to the executable, or set:

```text
QWINUI3_VOSK_LIB    path to libvosk.so / libvosk.dll
QWINUI3_VOSK_MODEL  path to a Vosk model folder (e.g. vosk-model-small-cn-0.22)
```

Also accepted: `<appDir>/vosk-model/`.

Microphone capture uses **Qt Multimedia** (`QAudioSource`) in-process — not `arecord`.

On Windows, if Vosk is not present, the mic key uses **SAPI dictation** (install a speech language pack). No PowerShell.

Tap **Listen**, speak, tap **Stop**. Text is committed through `KeyboardEngine.commitText`.

---

## Handwriting (Zinnia)

```text
QWINUI3_ZINNIA_LIB    path to libzinnia.so / zinnia.dll
QWINUI3_ZINNIA_MODEL  path to a Zinnia .model file (e.g. handwriting-zh_CN.model)
```

Also accepted: `<appDir>/handwriting-zh_CN.model`.

On Windows, if Zinnia is not present, recognition uses **Windows Ink** (install a handwriting language pack for Chinese).

Open **Settings → Handwriting**, draw, tap **Recognize**, pick a candidate.

---

## Pinyin learning

`OskUserLexicon` stores local word-frequency in `QSettings` (`QWinUI3/OskUserLexicon`). Cleared from **Settings → Clear learned words**. Boosts candidate order only — no cloud sync.

---

## Related

- [on-screen-keyboard.md](on-screen-keyboard.md) — core OSK / IME
- [osk-in-apps-258.md](osk-in-apps-258.md) — dock + floating recipe
