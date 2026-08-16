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
class FilePicker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit FilePicker(QObject *parent = nullptr);

    static FilePicker *create(QQmlEngine *, QJSEngine *);

    // Open a single file; callback(pathString) — "" on cancel
    // parentWindow: optional Window / Item for portal dialog parenting (X11).
    Q_INVOKABLE void openFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, QObject *parentWindow = nullptr);
    // Open multiple files; callback(string[])
    Q_INVOKABLE void openFiles(const QString &title, const QVariantList &nameFilters,
                               const QJSValue &callback, QObject *parentWindow = nullptr);
    // Save file; callback(pathString)
    Q_INVOKABLE void saveFile(const QString &title, const QVariantList &nameFilters,
                              const QJSValue &callback, const QString &defaultSuffix = QString(),
                              QObject *parentWindow = nullptr);
    // Pick folder; callback(pathString)
    Q_INVOKABLE void openFolder(const QString &title, const QJSValue &callback,
                                QObject *parentWindow = nullptr);

private:
    void invokePath(const QJSValue &callback, const QString &path);
    void invokePaths(const QJSValue &callback, const QStringList &paths);
    static QStringList filtersFromVariant(const QVariantList &nameFilters);
};
