# Single-instance (opt-in) — 2.74

**Default: multi-instance.** Gallery and consumer apps may run side-by-side. Single-instance is **opt-in**.

## Enable

1. **Environment:** `QWINUI3_SINGLE_INSTANCE=1` (also `true` / `yes` / `on`), **and** an explicit call in `main`, or
2. **Explicit only:** call `tryBecomePrimary` / `tryBecomeSingleInstancePrimary` without the env (caller decides).

```cpp
#include "Bootstrap.h"
#include "SingleInstance.h"

QWINUI3_IMPORT_QML_PLUGINS

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]);
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));

    SingleInstance guard;
    // Optional: gate on SingleInstance::isEnvOptIn() so plain launches stay multi-instance.
    if (SingleInstance::isEnvOptIn()
        && !guard.tryBecomePrimary(QStringLiteral("org.example.myapp"))) {
        return 0; // secondary already forwarded argv
    }
    QObject::connect(&guard, &SingleInstance::activationRequested,
                     [](const QStringList &args) {
                         Q_UNUSED(args);
                         // Raise / focus the existing window
                     });

    // … engine.load …
    return app.exec();
}
```

Thin QML/C++ helper on the Platform singleton:

```qml
import QWinUI3.Platform
// After configureApplication:
if (WindowHelper.singleInstanceEnvOptIn()
        && !WindowHelper.tryBecomeSingleInstancePrimary("org.example.myapp"))
    Qt.quit()
Connections {
    target: WindowHelper
    function onSingleInstanceActivationRequested(args) { /* raise */ }
}
```

## Notes

- Uses `QLockFile` + `QLocalServer` / `QLocalSocket` (Qt Network).
- Secondary sends `QCoreApplication::arguments()` then returns `false` — **caller must exit**.
- Primary emits `activationRequested(args)` / `WindowHelper.singleInstanceActivationRequested`.
- Not forced on Gallery; see System integration Gallery callout.

See also: [getting-started.md](getting-started.md) · `examples/first-app/main.cpp`.
