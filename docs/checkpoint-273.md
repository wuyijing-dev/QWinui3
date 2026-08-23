# Checkpoint 273 — Consumer fast integration (2.73)

**Status:** green on master at **2.73**  
**Scope:** DX1–DX4 — `getting-started` · `qwinui3 init` · `doctor --fix` · list shells/packaging · templates

## Paths

| Path | Proof |
|------|--------|
| **A** in-tree | `init --cpp --packaging subtree --shell first-app` |
| **B** zip kit | `init --cpp --packaging zip` + package_release_libs |
| **C** find_package | `init --cpp --packaging cmake-config` · find-package-consumer |
| **D** vcpkg/Conan | `init --cpp --packaging vcpkg\|conan` stub |
| **E** Python | `init --python --packaging pip` |

## Exit criteria

- [x] [getting-started.md](getting-started.md) linked from docs index / README
- [x] `python scripts/qwinui3.py init --list-shells` / `--list-packaging`
- [x] `doctor --fix` actionable lines
- [x] Templates under `templates/consumer/`

## Next

**2.74** single-instance (opt-in) · `qwinui3 run` · **2.75** error boundary.
