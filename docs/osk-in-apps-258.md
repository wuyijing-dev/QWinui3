# OSK / IME in apps (2.58)

Targeted fixes for **embedded dock**, **focus return**, and **IME routing in real forms** — building on **1.84** floating host and Gallery soak.

Related: [on-screen-keyboard.md](on-screen-keyboard.md) · [forms.md](forms.md) · [accessibility.md](accessibility.md) · [planning/friction-log.md](planning/friction-log.md) (**FL-017**)

---

## Goal

Product apps need the touch keyboard **inside the window** (footer dock), not only as a floating Gallery demo. Authors hit three recurring failures: **no copy-ready dock recipe**, **focus lost after closing chrome**, and **IME candidates clipped in scroll forms**. **2.58** closes the top three with small Extras fixes + a consumer example.

---

## Top 3 footguns (fixed in 2.58)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | Dock types nowhere / layout resets | Separate `KeyboardEngine` per host | **`sharedEngine`** on **`OnScreenKeyboard`** — one engine for dock + scroll |
| **2** | Field loses focus after Close / settings | Dock chrome does not restore editor | **`captureFocusReturn()`** / **`restoreFocusReturn()`** + **`KeyboardEngine.restoreFocus()`** |
| **3** | Pinyin bar hidden under dock in long forms | Candidates only inline in keyboard column | **`candidateBarPlacement: "floating"`** + **`AnnotatedScrollBar.imeEngine`** scroll hint |

**Out:** Promote OSK to stable (**2.01** gate); system-wide SendInput beyond **1.83** limits; Qt Virtual Keyboard.

---

## Deliverables

| Item | Location |
|------|----------|
| Shared engine | **`OnScreenKeyboard.sharedEngine`** |
| Focus return | **`captureFocusReturn()`** · **`restoreFocusReturn()`** · **`KeyboardEngine.restoreFocus()`** |
| Candidate placement | **`ImeCandidateBar.placement`** · **`OnScreenKeyboard.candidateBarPlacement`** |
| IME scroll hint | **`AnnotatedScrollBar.imeEngine`** · **`ensureImeVisible()`** |
| Consumer host | [`examples/osk-dock/`](../examples/osk-dock/) |
| Gallery refresh | **On-screen keyboard** · **AnnotatedScrollBar** · **Pitfalls** **2.58** |

---

## App checklist

- [ ] Copy [`examples/osk-dock/`](../examples/osk-dock/) — not Gallery **`OnScreenKeyboardPage`**
- [ ] One **`KeyboardEngine`** → **`sharedEngine:`** on footer **`OnScreenKeyboard`**
- [ ] Call **`sharedEngine.watch(Window.window)`** once on the host window
- [ ] Long forms: **`AnnotatedScrollBar { imeEngine: sharedEngine }`** (or call **`ensureImeVisible()`**)
- [ ] IME in scroll: **`candidateBarPlacement: "floating"`** on the dock
- [ ] Hide dock: rely on **`restoreFocusReturn()`** (wired on **`onCloseRequested`** / **`visible: false`**)
- [ ] Floating desktop input: still use [`examples/floating-osk/`](../examples/floating-osk/) — different host
- [ ] **`hardwareInput: true`** when physical keys should share the same IME path
- [ ] Layout hot-swap: **`engine.layoutIndex`** / **`layoutId`** — compose cancels on switch (by design)

**Next:** **2.60** friction checkpoint
