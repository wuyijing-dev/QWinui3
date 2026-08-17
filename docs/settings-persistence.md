# Settings persistence & roaming (1.65)

How to persist **app preferences** next to QWinUI3 chrome — without inventing a second geometry store or a cloud sync product.

| Concern | Supported approach |
|---------|-------------------|
| Window size / monitor | `geometryPersistenceKey` → `QSettings` `WindowGeometry/<key>` — [window-helper.md](window-helper.md) |
| Theme / toggles / coach flags | Qt Quick **`Settings`** (`QtCore`) or C++ `QSettings` under **your** org/app. Theme knobs: **`ThemePrefs`** / **`ThemeAppearanceSettings`** (**1.69**) — [theme-overrides.md](theme-overrides.md) |
| Portable / USB install | `QSettings::IniFormat` + explicit file under the install tree |
| “Roaming” between PCs | Copy Ini / known folder — **not** a QWinUI3 cloud service |

Gallery: **Settings persistence** · **Theme prefs**. Examples: [`form-settings`](../examples/form-settings/) (prefs + schema), [`gallery-shell`](../examples/gallery-shell/) (geometry key + `ThemeAppearanceSettings`).

Related: [forms.md](forms.md) · [window-helper.md](window-helper.md) · [window-shells.md](window-shells.md) · [feedback.md](feedback.md) (onboarding “don’t show again”) · [graphics-backend.md](graphics-backend.md).

**Out of scope (1.65):** cloud roaming backends, encrypted vaults, replacing `WindowGeometry/*`.

---

## Split geometry from prefs

| Store | Owner | Keys |
|-------|-------|------|
| `WindowGeometry/<role>` | Shells via `geometryPersistenceKey` | Frame + maximized + screen name |
| `Prefs/<category>` (you choose) | App `Settings` / `QSettings` | Theme, feature flags, form defaults |

Do **not** write window geometry under a custom prefs category — keep the supported geometry recipe intact ([window-chrome.md](window-chrome.md)).

```qml
NavigationWindow {
    geometryPersistenceKey: "MyAppMain"   // kit-owned schema
    // …
}
```

---

## Recipe A — QML `Settings` (preferred for toggles)

Qt 6: `import QtCore` then `Settings { }`. Properties sync to the application `QSettings` path (NativeFormat on desktop by default).

```qml
import QtCore
import QWinUI3.Theme
import QWinUI3.Extras

Settings {
    id: prefs
    category: "Prefs"           // → …/Prefs/…
    property int schemaVersion: 1
    property bool shareDiagnostics: true
    property bool dark: false
}

Component.onCompleted: {
    // Optional one-shot migration
    if (prefs.schemaVersion < 1) {
        prefs.shareDiagnostics = true
        prefs.schemaVersion = 1
    }
    Theme.dark = prefs.dark
}

SettingsCard {
    title: qsTr("Share diagnostics")
    toggle: true
    checked: prefs.shareDiagnostics
    onToggled: prefs.shareDiagnostics = checked
}

SettingsCard {
    title: qsTr("Dark mode")
    toggle: true
    checked: Theme.dark
    onToggled: {
        Theme.dark = checked
        prefs.dark = checked
    }
}
```

| Tip | Detail |
|-----|--------|
| Org / app | Set `QCoreApplication` organization/application **before** first `Settings` / `QSettings` (Bootstrap `configureApplication` does this for Gallery/examples). |
| Category | One category per feature area (`Prefs`, `OnboardingCoach`, …). |
| Lists / maps | Store JSON strings (see Gallery `GalleryHistory`) — `Settings` binds primitives best. |
| Don’t show again | Same pattern as [feedback.md](feedback.md) TeachingTip coach (**1.55**). |

---

## Recipe B — Portable Ini (side-by-side install)

```cpp
#include <QSettings>
#include <QCoreApplication>
#include <QDir>

QSettings appSettings()
{
    const QString ini = QCoreApplication::applicationDirPath()
                        + QStringLiteral("/config/myapp.ini");
    QDir().mkpath(QFileInfo(ini).absolutePath());
    return QSettings(ini, QSettings::IniFormat);
}

// Migration
void migrate(QSettings &s)
{
    const int v = s.value(QStringLiteral("schemaVersion"), 0).toInt();
    if (v < 1) {
        s.setValue(QStringLiteral("Prefs/shareDiagnostics"), true);
        s.setValue(QStringLiteral("schemaVersion"), 1);
    }
}
```

| Mode | When |
|------|------|
| **NativeFormat** (default `Settings`) | Normal installed LoB — per-user OS location |
| **Ini next to exe** | Portable / locked-down machines / IT copies a template Ini |
| **Both** | Read portable Ini if present, else Native — app policy |

Expose values to QML via a small C++ singleton or write Ini only from C++ and keep QML on `Settings` for the per-user path.

---

## Recipe C — “Roaming” without cloud

Honest options that stay in 1.xx scope:

1. **Document the Ini path** and let IT / users copy `config/myapp.ini` between machines.
2. **Known folder** on Windows (`AppData\Roaming\…`) — NativeFormat often already lands under a roaming-capable root depending on org policy; verify on target SKUs.
3. **Export / import** button: write a JSON snapshot via `FilePicker.saveFile` / open — [print-share.md](print-share.md) / [system-integration.md](system-integration.md).

Not provided: account login, conflict merge, or encrypted sync.

---

## Migration keys

```text
schemaVersion = 1
Prefs/shareDiagnostics = true
Prefs/dark = false
```

1. Bump `schemaVersion` when defaults or key names change.
2. Run migrations **once** at startup before binding UI.
3. Never rename `WindowGeometry/*` keys casually — geometry restore will look “broken”.

---

## Form vs settings (reminder)

- **FormLayout** — validated fields; persist **after** `form.validate()` succeeds (write prefs or your model).
- **SettingsCard** — immediate toggles; bind straight to `Settings` properties.

[`examples/form-settings`](../examples/form-settings/) (**1.65**): diagnostics + theme persist via `Settings`; profile save remains an in-session toast until you wire a backend.

---

## Win / Linux notes

| Host | Expectation |
|------|-------------|
| **Windows** | NativeFormat → registry or `AppData`; portable Ini under install dir works offline. |
| **Linux** | NativeFormat → `~/.config/<org>/<app>.conf` (typical); portable Ini same recipe. |
| **Wayland / X11** | Prefs storage unrelated to portal FilePicker — [platform-linux-wayland.md](platform-linux-wayland.md). |

---

## Checklist

- [ ] Unique `geometryPersistenceKey` per top-level window
- [ ] App prefs under a dedicated `Settings` category (not `WindowGeometry`)
- [ ] `schemaVersion` + one-shot migration
- [ ] Org/app id set before first read/write
- [ ] No cloud SDK required for the LoB path
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) for this minor
