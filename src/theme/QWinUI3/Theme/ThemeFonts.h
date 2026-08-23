#pragma once

#include <QFont>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

// ThemeFonts — icon/mono registration + WinUI-aligned UI font stacks (incl. CJK).
class ThemeFonts : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString iconFamily READ iconFamily CONSTANT)
    Q_PROPERTY(QString monoFamily READ monoFamily CONSTANT)
    Q_PROPERTY(QFont monoFont READ monoFont CONSTANT)
    Q_PROPERTY(bool iconFontLoaded READ iconFontLoaded CONSTANT)
    Q_PROPERTY(QString uiFamily READ uiFamily CONSTANT)
    Q_PROPERTY(QStringList uiFamilies READ uiFamilies CONSTANT)
    Q_PROPERTY(QStringList textFamilies READ textFamilies CONSTANT)
    Q_PROPERTY(QStringList displayFamilies READ displayFamilies CONSTANT)
    Q_PROPERTY(QFont uiFont READ uiFont CONSTANT)

public:
    explicit ThemeFonts(QObject *parent = nullptr);

    static ThemeFonts *create(QQmlEngine *engine, QJSEngine *scriptEngine);

    // Safe to call before QGuiApplication; idempotent.
    static void ensureLoaded();
    // Apply QGuiApplication font with CJK-aware families (after QGuiApplication exists).
    static void applyApplicationFont();

    QString iconFamily() const;
    QString monoFamily() const;
    QFont monoFont() const;
    Q_INVOKABLE QFont monoFontFor(int pixelSize) const;
    bool iconFontLoaded() const;

    QString uiFamily() const;
    QStringList uiFamilies() const;
    QStringList textFamilies() const;
    QStringList displayFamilies() const;
    QFont uiFont() const;
    Q_INVOKABLE QFont uiFontFor(int pixelSize) const;

private:
    static void resolveUiStacks();

    static bool s_loaded;
    static QString s_iconFamily;
    static QString s_monoFamily;
    static QStringList s_uiFamilies;
    static QStringList s_textFamilies;
    static QStringList s_displayFamilies;
};
