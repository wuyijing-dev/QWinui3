# Gallery shell translations (2.12)

Consumer **`qt_add_translations`** demo for 2.x apps — full recipe in [`docs/i18n-rtl.md`](../../../docs/i18n-rtl.md) (**Consumer lrelease recipe**).

| File | Role |
|------|------|
| `qwinui3_gallery_shell_en.ts` | English seed (identity) |
| `qwinui3_gallery_shell_ko_KR.ts` | Korean demo subset |

Build embeds `.qm` under `:/i18n/` via `RESOURCE_PREFIX` in [`CMakeLists.txt`](../CMakeLists.txt).

```bat
cmake --build build --config Release --target qwinui3_example_gallery_shell
build\qwinui3_example_gallery_shell.exe --lang ko_KR
```

Refresh catalogs (manual):

```bat
lupdate examples/gallery-shell -ts examples/gallery-shell/translations/qwinui3_gallery_shell_en.ts
```
