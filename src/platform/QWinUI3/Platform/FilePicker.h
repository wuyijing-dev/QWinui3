#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QJSValue>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

// FilePicker — Native open/save/folder dialogs for QML (no QtQuick.Dialogs).
//
//   FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (path) { … }, Window.window)
//
// Cancel → empty string / empty array. Pass parent Window for modal ownership
// (Windows HWND; Linux xdg-desktop-portal on X11). See docs/system-integration.md.
class FilePicker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit FilePicker(QObject *parent = nullptr);

    static FilePicker *create(QQmlEngine *, QJSEngine *);

    // Open a single file; callback(pathString) — "" on cancel.
    // parentWindow: Window / Item — Win HWND owner; Linux portal parent (X11).
    Q_INVOKABLE void openFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, QObject *parentWindow = nullptr);
    // Open multiple files; callback(string[]) — [] on cancel
    Q_INVOKABLE void openFiles(const QString &title, const QVariantList &nameFilters,
                               const QJSValue &callback, QObject *parentWindow = nullptr);
    // Save file; callback(pathString) — "" on cancel
    Q_INVOKABLE void saveFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, const QString &defaultSuffix = QString(),
                              QObject *parentWindow = nullptr);
    // Pick folder; callback(pathString) — "" on cancel
    Q_INVOKABLE void openFolder(const QString &title, const QJSValue &callback,
                                QObject *parentWindow = nullptr);

private:
    void invokePath(const QJSValue &callback, const QString &path);
    void invokePaths(const QJSValue &callback, const QStringList &paths);
    static QStringList filtersFromVariant(const QVariantList &nameFilters);
};
