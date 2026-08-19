# PySide6 consumer packaging — planned

**Status:** **Draft placeholder** — ships with **2.71** PySide6 integration slice (after **2.02** `find_package` / shared layout is stable).

**Goal:** Document the supported **PySide6 6.8+** path — QML import roots, Theme bootstrap, wheel layout expectations, and how it relates to [packaging-consumer.md](packaging-consumer.md) **Path E**.

**Out of scope here:** PyQt6; Shiboken wrappers for every C++ helper; vendoring full Qt inside wheels.

Related: [roadmap.md](roadmap.md) **2.71…2.72** · checkpoint-273 · [friction-log.md](planning/friction-log.md) **FL-011**.

---

## Planned sections (2.71)

| Section | Content |
|---------|---------|
| Prerequisites | **2.02** artifact layout · PySide6 **6.8+** |
| Minimal app | `examples/pyside6-minimal/` walkthrough |
| Import paths | `QQmlApplicationEngine` + QWinUI3 QML roots |
| Verification | `scripts/verify_pyside6.py` |
| Wheels | Cross-link **2.72** PyPI tag |

---

## Consumer checklist (TBD)

- [ ] Install PySide6 **6.8+**
- [ ] Point QML import path at installed QWinUI3 `qml/`
- [ ] Run minimal example + verify script
