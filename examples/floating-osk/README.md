# Floating on-screen keyboard

Tiny host for experimental `OnScreenKeyboardWindow` (**1.84**). Copy this folder — **not** the Gallery tree.

On Windows, `systemWide` is on: after **Open floating keyboard**, click another app, then tap keys (`SendInput`). Linux floats but stays in-app (`supportsSystemWide === false`).

SIL Keyman Core is **vendored** in `third_party/keyman` (in `git clone`). WebView2 is unrelated and still an optional NuGet fetch.

Recipe: [`docs/on-screen-keyboard.md`](../../docs/on-screen-keyboard.md).

```bat
cmake --build build --config Release --target qwinui3_example_floating_osk
build\qwinui3_example_floating_osk.exe
```
