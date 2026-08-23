# KeyboardEngine

Keyman layouts + in-app IME + optional Windows system-wide inject (1.82). Not Qt Virtual Keyboard. CJK is not Keyman IMX. Japanese stays romaji→kana (no MIT kanji lexicon; JMDict is CC-BY-SA). systemWide (opt-in, Windows SendInput) injects into the focused desktop app.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KeyboardEngine.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/KeyboardEngine.h)

**Category:** Input & forms · **Library:** v2.81 · **C++ type**

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `backend` | `QString` | — |
| `layoutId` | `QString` | — |
| `layoutLabel` | `QString` | — |
| `layoutIndex` | `int` | — |
| `layoutIds` | `QStringList` | — |
| `layoutLabels` | `QStringList` | — |
| `rtl` | `bool` | — |
| `pinyin` | `bool` | — |
| `japanese` | `bool` | — |
| `korean` | `bool` | — |
| `hasTarget` | `bool` | — |
| `composing` | `bool` | — |
| `preedit` | `QString` | — |
| `candidates` | `QStringList` | — |
| `pagedCandidates` | `QStringList` | — |
| `candidateGroups` | `QVariantList` | — |
| `candidatePage` | `int` | — |
| `candidatePageCount` | `int` | — |
| `ctrlLatched` | `bool` | — |
| `altLatched` | `bool` | — |
| `winLatched` | `bool` | — |
| `hardwareInput` | `bool` | — |
| `systemWide` | `bool` | — |
| `supportsSystemWide` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `hasTargetChanged()` | — |
| `layoutIdChanged()` | — |
| `composeChanged()` | — |
| `hardwareInputChanged()` | — |
| `systemWideChanged()` | — |
| `modifiersChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `watch(QObject *window)` | — |
| `rememberTarget()` | — |
| `restoreFocus()` | — |
| `cycleLayout()` | — |
| `commitText(const QString &text)` | — |
| `processVk(int vk, bool shift)` | — |
| `previewVk(int vk, bool shift) const)` | — |
| `backspace()` | — |
| `enterKey()` | — |
| `tabKey()` | — |
| `pickCandidate(int indexOnPage)` | — |
| `pickCandidateWord(const QString &word)` | — |
| `nextCandidatePage()` | — |
| `prevCandidatePage()` | — |
| `confirmCompose()` | — |
| `cancelCompose()` | — |
| `navigateKey(int qtKey)` | — |
| `pasteClipboard()` | — |
| `clipboardText() const)` | — |
| `toggleModifier(const QString &name)` | — |
| `clearModifiers()` | — |
| `clearUserLexicon()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
