#include "FilePicker.h"

#include <QGuiApplication>
#include <QJSEngine>
#include <QQmlEngine>
#include <QVariant>
#include <QWindow>
#include <QProcess>
#include <QRegularExpression>
#include <QDebug>

#include "LinuxPortal.h"

#if defined(Q_OS_WIN)
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <shobjidl.h>
#  include <vector>
#  include <string>
#endif

FilePicker::FilePicker(QObject *parent)
    : QObject(parent)
{
}

FilePicker *FilePicker::create(QQmlEngine *, QJSEngine *)
{
    return new FilePicker;
}

QStringList FilePicker::filtersFromVariant(const QVariantList &nameFilters)
{
    QStringList out;
    for (const QVariant &v : nameFilters) {
        const QString s = v.toString().trimmed();
        if (!s.isEmpty())
            out.push_back(s);
    }
    if (out.isEmpty())
        out.push_back(QStringLiteral("All files (*.*)"));
    return out;
}

void FilePicker::invokePath(const QJSValue &callback, const QString &path)
{
    if (!callback.isCallable())
        return;
    QJSValue cb = callback;
    QJSValueList args;
    args << QJSValue(path);
    cb.call(args);
}

void FilePicker::invokePaths(const QJSValue &callback, const QStringList &paths)
{
    if (!callback.isCallable())
        return;
    QJSEngine *engine = qjsEngine(this);
    if (!engine)
        return;
    QJSValue cb = callback;
    QJSValue arr = engine->newArray(quint32(paths.size()));
    for (int i = 0; i < paths.size(); ++i)
        arr.setProperty(quint32(i), paths.at(i));
    QJSValueList args;
    args << arr;
    cb.call(args);
}

#if defined(Q_OS_WIN)

namespace {

HWND ownerHwnd()
{
    if (!qGuiApp)
        return nullptr;
    for (QWindow *w : qGuiApp->allWindows()) {
        if (w && w->isVisible() && w->handle())
            return reinterpret_cast<HWND>(w->winId());
    }
    return nullptr;
}

HWND hwndFromParent(QObject *parentWindow)
{
    if (parentWindow) {
        QWindow *window = qobject_cast<QWindow *>(parentWindow);
        if (!window)
            window = parentWindow->property("window").value<QWindow *>();
        if (window && window->handle())
            return reinterpret_cast<HWND>(window->winId());
    }
    return ownerHwnd();
}

void applyFilters(IFileDialog *dialog, const QStringList &filters)
{
    if (!dialog || filters.isEmpty())
        return;

    std::vector<std::wstring> names;
    std::vector<std::wstring> patterns;
    std::vector<COMDLG_FILTERSPEC> specs;
    names.reserve(size_t(filters.size()));
    patterns.reserve(size_t(filters.size()));
    specs.reserve(size_t(filters.size()));

    for (const QString &f : filters) {
        QString name = f;
        QString pattern = QStringLiteral("*.*");
        const int lp = f.lastIndexOf(QLatin1Char('('));
        const int rp = f.lastIndexOf(QLatin1Char(')'));
        if (lp >= 0 && rp > lp) {
            name = f.left(lp).trimmed();
            pattern = f.mid(lp + 1, rp - lp - 1).trimmed();
            pattern.replace(QLatin1Char(' '), QLatin1Char(';'));
        }
        if (name.isEmpty())
            name = f;
        names.push_back(name.toStdWString());
        patterns.push_back(pattern.toStdWString());
        COMDLG_FILTERSPEC spec {};
        spec.pszName = names.back().c_str();
        spec.pszSpec = patterns.back().c_str();
        specs.push_back(spec);
    }
    dialog->SetFileTypes(UINT(specs.size()), specs.data());
    dialog->SetFileTypeIndex(1);
}

QString shellItemPath(IShellItem *item)
{
    if (!item)
        return {};
    PWSTR path = nullptr;
    QString result;
    if (SUCCEEDED(item->GetDisplayName(SIGDN_FILESYSPATH, &path)) && path) {
        result = QString::fromWCharArray(path);
        CoTaskMemFree(path);
    }
    return result;
}

QString pickFiles(bool multi, bool save, const QString &title,
                  const QStringList &filters, const QString &defaultSuffix,
                  QStringList *outList, HWND owner)
{
    const HRESULT initHr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    const bool shouldUninit = (initHr == S_OK);

    IFileDialog *dialog = nullptr;
    HRESULT hr = save
        ? CoCreateInstance(CLSID_FileSaveDialog, nullptr, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&dialog))
        : CoCreateInstance(CLSID_FileOpenDialog, nullptr, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&dialog));

    QString result;
    if (SUCCEEDED(hr) && dialog) {
        DWORD options = 0;
        dialog->GetOptions(&options);
        options |= FOS_FORCEFILESYSTEM | FOS_PATHMUSTEXIST;
        if (!save)
            options |= FOS_FILEMUSTEXIST;
        if (multi && !save)
            options |= FOS_ALLOWMULTISELECT;
        if (save)
            options |= FOS_OVERWRITEPROMPT;
        dialog->SetOptions(options);
        if (!title.isEmpty())
            dialog->SetTitle(reinterpret_cast<LPCWSTR>(title.utf16()));
        applyFilters(dialog, filters);
        if (save && !defaultSuffix.isEmpty())
            dialog->SetDefaultExtension(reinterpret_cast<LPCWSTR>(defaultSuffix.utf16()));

        hr = dialog->Show(owner ? owner : ownerHwnd());
        if (SUCCEEDED(hr)) {
            if (multi && !save) {
                IFileOpenDialog *openDlg = nullptr;
                if (SUCCEEDED(dialog->QueryInterface(IID_PPV_ARGS(&openDlg))) && openDlg) {
                    IShellItemArray *items = nullptr;
                    if (SUCCEEDED(openDlg->GetResults(&items)) && items) {
                        DWORD count = 0;
                        items->GetCount(&count);
                        for (DWORD i = 0; i < count; ++i) {
                            IShellItem *item = nullptr;
                            if (SUCCEEDED(items->GetItemAt(i, &item)) && item) {
                                const QString path = shellItemPath(item);
                                if (!path.isEmpty() && outList)
                                    outList->push_back(path);
                                item->Release();
                            }
                        }
                        items->Release();
                    }
                    openDlg->Release();
                }
            } else {
                IShellItem *item = nullptr;
                if (SUCCEEDED(dialog->GetResult(&item)) && item) {
                    result = shellItemPath(item);
                    item->Release();
                }
            }
        }
        dialog->Release();
    }

    if (shouldUninit)
        CoUninitialize();
    return result;
}

QString pickFolder(const QString &title, HWND owner)
{
    const HRESULT initHr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    const bool shouldUninit = (initHr == S_OK);

    IFileDialog *dialog = nullptr;
    HRESULT hr = CoCreateInstance(CLSID_FileOpenDialog, nullptr, CLSCTX_INPROC_SERVER,
                                  IID_PPV_ARGS(&dialog));
    QString result;
    if (SUCCEEDED(hr) && dialog) {
        DWORD options = 0;
        dialog->GetOptions(&options);
        options |= FOS_PICKFOLDERS | FOS_FORCEFILESYSTEM | FOS_PATHMUSTEXIST;
        dialog->SetOptions(options);
        if (!title.isEmpty())
            dialog->SetTitle(reinterpret_cast<LPCWSTR>(title.utf16()));
        hr = dialog->Show(owner ? owner : ownerHwnd());
        if (SUCCEEDED(hr)) {
            IShellItem *item = nullptr;
            if (SUCCEEDED(dialog->GetResult(&item)) && item) {
                result = shellItemPath(item);
                item->Release();
            }
        }
        dialog->Release();
    }

    if (shouldUninit)
        CoUninitialize();
    return result;
}

} // namespace

#endif // Q_OS_WIN

#if defined(Q_OS_LINUX)

namespace {

void warnMissingPortalParent()
{
    const QByteArray session = qgetenv("XDG_SESSION_TYPE").toLower();
    const bool wayland = session == "wayland"
                         || !qEnvironmentVariableIsEmpty("WAYLAND_DISPLAY")
                         || !qEnvironmentVariableIsEmpty("WAYLAND_SOCKET");
    if (!wayland)
        return;
    qWarning("FilePicker: pass Window.window as parentWindow on Wayland — "
             "portal parent_window may be empty (docs/platform-linux-wayland.md)");
}

QString portalParentFor(QObject *parentWindow)
{
    QObject *effective = LinuxPortal::resolveParentObject(parentWindow);
    const QString parent = LinuxPortal::parentWindowFrom(effective);
    if (!parentWindow && parent.isEmpty())
        warnMissingPortalParent();
    return parent;
}

QStringList linuxDialogTools()
{
    const QString desktop = qEnvironmentVariable("XDG_CURRENT_DESKTOP").toLower();
    // KDE/Plasma prefers kdialog (portal-aware); GNOME and others prefer zenity.
    if (desktop.contains(QLatin1String("kde")) || desktop.contains(QLatin1String("plasma")))
        return {QStringLiteral("kdialog"), QStringLiteral("zenity")};
    return {QStringLiteral("zenity"), QStringLiteral("kdialog")};
}

bool runDialog(const QString &program, const QStringList &args, QString *stdoutText)
{
    QProcess p;
    p.start(program, args);
    if (!p.waitForStarted(3000))
        return false;
    if (!p.waitForFinished(120000) || p.exitCode() != 0)
        return false;
    if (stdoutText)
        *stdoutText = QString::fromUtf8(p.readAllStandardOutput()).trimmed();
    return true;
}

bool pickWithZenity(const QStringList &args, QString *out)
{
    return runDialog(QStringLiteral("zenity"), args, out);
}

bool pickWithKdialog(const QStringList &args, QString *out)
{
    return runDialog(QStringLiteral("kdialog"), args, out);
}

QStringList zenityFilterArgs(const QStringList &filters)
{
    QStringList args;
    for (const QString &f : filters) {
        QString name = f;
        QString globs = QStringLiteral("*");
        const int lp = f.lastIndexOf(QLatin1Char('('));
        const int rp = f.lastIndexOf(QLatin1Char(')'));
        if (lp >= 0 && rp > lp) {
            name = f.left(lp).trimmed();
            globs = f.mid(lp + 1, rp - lp - 1).trimmed();
            globs.replace(QLatin1Char(';'), QLatin1Char(' '));
        }
        if (name.isEmpty())
            name = f;
        args << QStringLiteral("--file-filter=%1 | %2").arg(name, globs);
    }
    return args;
}

QString kdialogFilter(const QStringList &filters)
{
    if (filters.isEmpty())
        return {};
    return filters.first();
}

QString linuxOpenFile(const QString &title, QObject *parentWindow, const QStringList &filters)
{
    QString path;
    const QString parent = portalParentFor(parentWindow);
    if (LinuxPortal::tryOpenFile(title, &path, parent, filters))
        return path;
    for (const QString &tool : linuxDialogTools()) {
        if (tool == QLatin1String("zenity")) {
            QStringList args = {QStringLiteral("--file-selection"),
                                QStringLiteral("--title=") + title};
            args += zenityFilterArgs(filters);
            if (pickWithZenity(args, &path))
                return path;
        } else if (tool == QLatin1String("kdialog")) {
            QStringList args = {QStringLiteral("--getopenfilename"),
                                QStringLiteral("."), title};
            const QString kf = kdialogFilter(filters);
            if (!kf.isEmpty())
                args << kf;
            if (pickWithKdialog(args, &path))
                return path;
        }
    }
    return {};
}

QStringList linuxOpenFiles(const QString &title, QObject *parentWindow, const QStringList &filters)
{
    QStringList list;
    const QString parent = portalParentFor(parentWindow);
    if (LinuxPortal::tryOpenFiles(title, &list, parent, filters))
        return list;
    QString out;
    for (const QString &tool : linuxDialogTools()) {
        if (tool == QLatin1String("zenity")) {
            QStringList args = {QStringLiteral("--file-selection"),
                                QStringLiteral("--multiple"),
                                QStringLiteral("--separator=\n"),
                                QStringLiteral("--title=") + title};
            args += zenityFilterArgs(filters);
            if (pickWithZenity(args, &out)) {
                return out.isEmpty() ? QStringList{}
                                     : out.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
            }
        } else if (tool == QLatin1String("kdialog")) {
            QStringList args = {QStringLiteral("--getopenfilename"),
                                QStringLiteral("."), title,
                                QStringLiteral("--multiple")};
            const QString kf = kdialogFilter(filters);
            if (!kf.isEmpty())
                args << kf;
            if (pickWithKdialog(args, &out)) {
                return out.split(QRegularExpression(QStringLiteral("[\\n\\r]+")),
                                 Qt::SkipEmptyParts);
            }
        }
    }
    return {};
}

QString linuxSaveFile(const QString &title, QObject *parentWindow, const QStringList &filters,
                      const QString &defaultSuffix)
{
    QString path;
    const QString parent = portalParentFor(parentWindow);
    QString currentName;
    if (!defaultSuffix.isEmpty())
        currentName = QStringLiteral("untitled.%1").arg(defaultSuffix);
    if (LinuxPortal::trySaveFile(title, &path, parent, filters, currentName))
        return path;
    for (const QString &tool : linuxDialogTools()) {
        if (tool == QLatin1String("zenity")) {
            QStringList args = {QStringLiteral("--file-selection"),
                                QStringLiteral("--save"),
                                QStringLiteral("--confirm-overwrite"),
                                QStringLiteral("--title=") + title};
            args += zenityFilterArgs(filters);
            if (pickWithZenity(args, &path))
                return path;
        } else if (tool == QLatin1String("kdialog")) {
            QStringList args = {QStringLiteral("--getsavefilename"),
                                QStringLiteral("."), title};
            const QString kf = kdialogFilter(filters);
            if (!kf.isEmpty())
                args << kf;
            if (pickWithKdialog(args, &path))
                return path;
        }
    }
    return {};
}

QString linuxOpenFolder(const QString &title, QObject *parentWindow)
{
    QString path;
    const QString parent = portalParentFor(parentWindow);
    if (LinuxPortal::tryOpenFolder(title, &path, parent))
        return path;
    for (const QString &tool : linuxDialogTools()) {
        if (tool == QLatin1String("zenity")) {
            if (pickWithZenity({QStringLiteral("--file-selection"),
                                QStringLiteral("--directory"),
                                QStringLiteral("--title=") + title},
                               &path))
                return path;
        } else if (tool == QLatin1String("kdialog")) {
            if (pickWithKdialog({QStringLiteral("--getexistingdirectory"),
                                 QStringLiteral("."), title},
                                &path))
                return path;
        }
    }
    return {};
}

} // namespace

#endif // Q_OS_LINUX

void FilePicker::openFile(const QString &title, const QVariantList &nameFilters,
                          const QJSValue &callback, QObject *parentWindow)
{
#if defined(Q_OS_WIN)
    invokePath(callback, pickFiles(false, false, title, filtersFromVariant(nameFilters),
                                   QString(), nullptr, hwndFromParent(parentWindow)));
#elif defined(Q_OS_LINUX)
    invokePath(callback, linuxOpenFile(title, parentWindow, filtersFromVariant(nameFilters)));
#else
    Q_UNUSED(title);
    Q_UNUSED(nameFilters);
    Q_UNUSED(parentWindow);
    invokePath(callback, QString());
#endif
}

void FilePicker::openFiles(const QString &title, const QVariantList &nameFilters,
                           const QJSValue &callback, QObject *parentWindow)
{
#if defined(Q_OS_WIN)
    QStringList list;
    pickFiles(true, false, title, filtersFromVariant(nameFilters), QString(), &list,
              hwndFromParent(parentWindow));
    invokePaths(callback, list);
#elif defined(Q_OS_LINUX)
    invokePaths(callback, linuxOpenFiles(title, parentWindow, filtersFromVariant(nameFilters)));
#else
    Q_UNUSED(title);
    Q_UNUSED(nameFilters);
    Q_UNUSED(parentWindow);
    invokePaths(callback, {});
#endif
}

void FilePicker::saveFile(const QString &title, const QVariantList &nameFilters,
                          const QJSValue &callback, const QString &defaultSuffix,
                          QObject *parentWindow)
{
#if defined(Q_OS_WIN)
    invokePath(callback, pickFiles(false, true, title, filtersFromVariant(nameFilters),
                                   defaultSuffix, nullptr, hwndFromParent(parentWindow)));
#elif defined(Q_OS_LINUX)
    invokePath(callback, linuxSaveFile(title, parentWindow, filtersFromVariant(nameFilters),
                                       defaultSuffix));
#else
    Q_UNUSED(title);
    Q_UNUSED(nameFilters);
    Q_UNUSED(defaultSuffix);
    Q_UNUSED(parentWindow);
    invokePath(callback, QString());
#endif
}

void FilePicker::openFolder(const QString &title, const QJSValue &callback,
                            QObject *parentWindow)
{
#if defined(Q_OS_WIN)
    invokePath(callback, pickFolder(title, hwndFromParent(parentWindow)));
#elif defined(Q_OS_LINUX)
    invokePath(callback, linuxOpenFolder(title, parentWindow));
#else
    Q_UNUSED(title);
    Q_UNUSED(parentWindow);
    invokePath(callback, QString());
#endif
}
