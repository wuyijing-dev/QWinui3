# SingleInstance

Opt-in primary/secondary guard (2.74).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/SingleInstance.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/SingleInstance.h)

**Category:** Platform · **Library:** v2.81 · **C++ type**

[← Component index](../components.md)

**Extends** `QObject`.

## Example

```qml
Default is multi-instance. Enable with env QWINUI3_SINGLE_INSTANCE=1 or an
explicit tryBecomePrimary() call. Secondary processes forward argv to the
primary over QLocalSocket; the caller must exit when tryBecomePrimary returns false.

#include "SingleInstance.h"
QWinUI3::SingleInstance guard;
if (!guard.tryBecomePrimary(QStringLiteral("org.example.myapp")))
    return 0;
QObject::connect(&guard, &QWinUI3::SingleInstance::activationRequested,
                 [](const QStringList &args) { /* raise window */ });
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `primary` | `bool` | — |
| `serverName` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `activationRequested(const QStringList &args)` | — |
| `primaryChanged()` | — |
| `serverNameChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `isEnvOptIn()` | — |
| `tryBecomePrimary(const QString &serverName)` | — |
| `release()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
