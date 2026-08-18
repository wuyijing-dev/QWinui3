#pragma once

#include <QFont>
#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

// ThemeFonts — registers embedded Fluent-compatible icon fonts (qrc).
class ThemeFonts : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString iconFamily READ iconFamily CONSTANT)
    Q_PROPERTY(QString monoFamily READ monoFamily CONSTANT)
    Q_PROPERTY(QFont monoFont READ monoFont CONSTANT)
    Q_PROPERTY(bool iconFontLoaded READ iconFontLoaded CONSTANT)

public:
    explicit ThemeFonts(QObject *parent = nullptr);

    static ThemeFonts *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    // Safe to call before QGuiApplication; idempotent.
    static void ensureLoaded();

    QString iconFamily() const;
    QString monoFamily() const;
    QFont monoFont() const;
    Q_INVOKABLE QFont monoFontFor(int pixelSize) const;
    bool iconFontLoaded() const;

private:
    static bool s_loaded;
    static QString s_iconFamily;
    static QString s_monoFamily;
};
