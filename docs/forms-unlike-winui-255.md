# Forms unlike WinUI (2.55)

Targeted fixes for **FL-018** — validation timing, error summary a11y, and modal queue surprises. Not a reactive validator engine.

Related: [forms.md](forms.md) · [dialogs-flyouts.md](dialogs-flyouts.md) · [planning/friction-log.md](planning/friction-log.md)

---

## Goal

LoB teams copy WinUI form/dialog patterns and hit three recurring footguns: **async submit races**, **silent error banners**, and **modal stacks that feel random**. **2.55** closes the top three with small API additions + Gallery refresh.

---

## Top 3 footguns (fixed in 2.55)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | Double submit / stale errors during server check | No `validating` gate; `clearErrors()` skipped `NumberBox.inputInvalid` | **`beginValidate()` / `endValidate()`** + **`validating`**; **`clearErrors()`** resets **`inputInvalid`** |
| **2** | Screen readers miss the error summary | **`ValidationSummary`** only updated visually | **`Accessible.announce`** on error count change |
| **3** | Enter does nothing in dialog TextField; urgent confirm buried in FIFO | Keys on dialog root; queue append-only | **`Shortcut`** Enter → **`activateDefault()`** (skip **`TextArea`**); **`showFront()`** queue priority |

**Out:** QValidator pipeline; SettingsCard field errors; focus-ring scroll-into-view animation.

---

## Deliverables

| Item | Location |
|------|----------|
| Async validation API | **`FormLayout`**: `validating`, `beginValidate()`, `endValidate()`, `validateDeferred()`, `focusFirstError()` |
| Summary live region | **`ValidationSummary`**: `Accessible.announce` on error count delta |
| Queue priority | **`ContentDialogQueue.showFront()`** / **`enqueueFront()`**; **`ContentDialog.showFront()`** |
| Enter default | **`ContentDialog`**: `Shortcut` + multiline guard |
| Gallery refresh | **Form validation** async block · **ContentDialog** Enter + **showFront** |
| Troubleshooting | [forms.md](forms.md) **2.55** · [dialogs-flyouts.md](dialogs-flyouts.md) priority row |

---

## App checklist

- [ ] Wrap long server checks in **`form.beginValidate()` … `form.endValidate()`**; disable submit while **`form.validating`**
- [ ] After failed **`validate()`**, call **`form.focusFirstError()`**
- [ ] Bind **`ValidationSummary { errors: form.errors }`** above fields
- [ ] Use **`ContentDialog.show()`** (FIFO); **`showFront()`** only for urgent confirms while another dialog is open
- [ ] Set **`defaultButton`** explicitly on destructive dialogs
- [ ] Parent dialogs on owner **`Overlay.overlay`**

**Next:** **2.57** files on Linux
