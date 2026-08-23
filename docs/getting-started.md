# Getting started — Paths A–E (2.73)

One page to first window. Prefer this over hopping packaging docs until you need deep detail.

Full packaging matrix: [packaging-consumer.md](packaging-consumer.md) · Python: [packaging-python.md](packaging-python.md).

---

## Decide once

| Question | Choices |
|----------|---------|
| Language | **C++** or **Python** |
| How you consume the kit | **A** in-tree · **B** shared zip · **C** `find_package` · **D** vcpkg/Conan · **E** `pip install qwinui3` |
| Shell | **first-app** (smallest) · **gallery-shell** · **dashboard** · **blank** |

CLI (from a clone of this repo):

```bash
python scripts/qwinui3.py init --list-shells
python scripts/qwinui3.py init --list-packaging
python scripts/qwinui3.py init --cpp --packaging subtree --shell first-app --out ../my-app
python scripts/qwinui3.py doctor --fix
```

---

## Path A — in-tree C++ (`add_subdirectory`)

1. `python scripts/qwinui3.py init --cpp --packaging subtree --shell first-app --out ../my-app`
2. Point `QWINUI3_ROOT` / `add_subdirectory` at this repo (generated README).
3. Configure Release, build, run.

Seed: [`examples/first-app`](../examples/first-app/).

## Path B — shared Release zip

1. `python scripts/package_release_libs.py --shared --archive`
2. `init --cpp --packaging zip --kit dist/qwinui3-…-shared --out ../my-app`
3. Set `CMAKE_PREFIX_PATH` to the kit; build Release.

## Path C — `find_package(QWinUI3)`

1. Install / package kit with CMake config.
2. `init --cpp --packaging cmake-config --out ../my-app`
3. `find_package(QWinUI3 CONFIG REQUIRED)` — see [`examples/find-package-consumer`](../examples/find-package-consumer/).

## Path D — vcpkg / Conan

Overlay recipes: [packaging-vcpkg-conan.md](packaging-vcpkg-conan.md).  
`init --cpp --packaging vcpkg` or `conan` writes a stub README + CMake that expects the overlay.

## Path E — Python

```bash
pip install qwinui3 PySide6
python scripts/qwinui3.py init --python --packaging pip --shell blank --out ../my-py-app
cd ../my-py-app && python main.py
```

Or full Gallery: [packaging-python.md](packaging-python.md).

---

## Doctor

```bash
python scripts/qwinui3.py doctor
python scripts/qwinui3.py doctor --fix
```

`--fix` prints actionable next steps (Qt prefix, Gallery binary, kit, bindings).

---

## Checkpoint

Consumer DX audit: [checkpoint-273.md](checkpoint-273.md).
