# Visual smoke goldens (1.62)

Reference manifests for optional `python scripts/smoke_visual.py --compare`.

## Generate locally

```bat
cmake --build build --config Release --target qwinui3_gallery
python scripts/smoke_visual.py --build-dir build --update-goldens
```

Writes `<os>-qt68.manifest.json` here (e.g. `windows-qt68.manifest.json`).

## Notes

- Primary gate is **grab success** (PNG size / dimensions) — not pixel identity.
- Exact `sha256` compare is **best-effort** (fonts, GPU, timing). Use `--compare` (warn) or `--compare-strict` (fail).
- Force `QT_SCALE_FACTOR=1` (script default). Still not bit-identical across machines.
- Do **not** treat goldens as a full screenshot farm — subset only (Home + 4 chrome pages).

See [docs/ci-smoke.md](../../docs/ci-smoke.md).
