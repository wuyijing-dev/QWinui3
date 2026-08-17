# Embedded on-screen keyboard dock

Copy-ready host for **`OnScreenKeyboard`** in a product footer (**2.58**). One shared **`KeyboardEngine`** wires dock typing, floating IME candidates, and **`AnnotatedScrollBar`** scroll hints — copy this folder, **not** the Gallery tree.

| Pattern | This example |
|---------|----------------|
| Footer dock | `OnScreenKeyboard` anchored to window bottom |
| Shared engine | `KeyboardEngine { id: sharedEngine }` → `sharedEngine:` on dock |
| IME in long forms | `AnnotatedScrollBar { imeEngine: sharedEngine }` |
| Focus return | Close dock → field focus restored automatically |

Floating desktop input remains in [`examples/floating-osk/`](../floating-osk/) (**1.84**).

Recipe: [`docs/osk-in-apps-258.md`](../../docs/osk-in-apps-258.md).

```bat
cmake --build build --config Release --target qwinui3_example_osk_dock
build\qwinui3_example_osk_dock.exe
```
