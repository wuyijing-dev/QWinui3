#pragma once

#include <QString>
#include <QStringList>

class QObject;

// Thin xdg-desktop-portal helpers for Linux / Wayland (optional Qt DBus).
namespace LinuxPortal {

bool available();

// xdg-desktop-portal parent_window: "x11:0x…" on X11/XWayland;
// "wayland:HANDLE" when Qt exports xdg-foreign (GuiPrivate portalWindowIdentifier
// when available, else native-resource keys); else empty on pure Wayland.
QString parentWindowFrom(QObject *windowObject);

// Resolve explicit parent or focus/visible window (2.57 FilePicker fallback).
QObject *resolveParentObject(QObject *parentWindow);

// org.freedesktop.Notifications
bool notify(const QString &appName, const QString &title, const QString &message, int timeoutMs = 5000);

// org.freedesktop.portal.Settings — appearance color-scheme:
// 0 = no preference, 1 = prefer dark, 2 = prefer light. Returns false if unavailable.
bool tryReadColorScheme(uint *schemeOut);

// Watch portal SettingChanged; invokes receiver's refreshColorScheme-compatible callback via
// connection to WindowHelper (call from WindowHelper ctor). Returns false if DBus missing.
bool watchColorSchemeChanges(QObject *receiver, const char *slot);

// org.freedesktop.portal.OpenURI
bool tryOpenUri(const QString &uri, const QString &parentWindow = QString());

// Reveal files in the desktop file manager (org.freedesktop.FileManager1).
bool tryShowItems(const QStringList &uris);

// Idle inhibit — prefers portal Inhibit, then org.freedesktop.ScreenSaver.
// cookieOut receives a handle for releaseIdleInhibit.
bool tryInhibitIdle(const QString &appName, const QString &reason, quint32 *cookieOut);
bool tryUninhibitIdle(quint32 cookie);

// FileChooser — true when portal handled (OK, cancel, or timeout after the
// dialog was shown). false → caller may fall back to zenity/kdialog.
bool tryOpenFile(const QString &title, QString *pathOut, const QString &parentWindow = QString(),
                 const QStringList &nameFilters = QStringList());
bool tryOpenFiles(const QString &title, QStringList *pathsOut, const QString &parentWindow = QString(),
                  const QStringList &nameFilters = QStringList());
bool trySaveFile(const QString &title, QString *pathOut, const QString &parentWindow = QString(),
                 const QStringList &nameFilters = QStringList(), const QString &currentName = QString());
bool tryOpenFolder(const QString &title, QString *pathOut, const QString &parentWindow = QString());

} // namespace LinuxPortal
