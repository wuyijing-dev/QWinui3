#pragma once

#include <QFont>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

// ThemeFonts — icon/mono registration + WinUI LanguageFont-style UI stacks.
class ThemeFonts : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString iconFamily READ iconFamily CONSTANT)
    Q_PROPERTY(QString monoFamily READ monoFamily CONSTANT)
    Q_PROPERTY(QFont monoFont READ monoFont CONSTANT)
    Q_PROPERTY(bool iconFontLoaded READ iconFontLoaded CONSTANT)
    Q_PROPERTY(QString uiFamily READ uiFamily NOTIFY uiFontsChanged)
    Q_PROPERTY(QStringList uiFamilies READ uiFamilies NOTIFY uiFontsChanged)
    Q_PROPERTY(QStringList textFamilies READ textFamilies NOTIFY uiFontsChanged)
    Q_PROPERTY(QStringList displayFamilies READ displayFamilies NOTIFY uiFontsChanged)
    Q_PROPERTY(QFont uiFont READ uiFont NOTIFY uiFontsChanged)
    Q_PROPERTY(QString uiLocale READ uiLocale NOTIFY uiFontsChanged)
    Q_PROPERTY(int revision READ revision NOTIFY uiFontsChanged)

public:
    explicit ThemeFonts(QObject *parent = nullptr);

    static ThemeFonts *create(QQmlEngine *engine, QJSEngine *scriptEngine);
    static ThemeFonts *instance();

    // Safe to call before QGuiApplication; idempotent.
    static void ensureLoaded();
    // Apply QGuiApplication font with the current UI stack (after QGuiApplication).
    static void applyApplicationFont();
    // WinUI-style: zh → YaHei UI first, ja → Yu Gothic UI, ko → Malgun Gothic, else Segoe first.
    static void applyForUiLocale(const QString &locale);

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
    QString uiLocale() const;
    int revision() const;

signals:
    void uiFontsChanged();

private:
    static void resolveUiStacks();
    static void emitUiFontsChanged();

    static ThemeFonts *s_instance;
    static bool s_loaded;
    static QString s_iconFamily;
    static QString s_monoFamily;
    static QString s_uiLocale;
    static int s_revision;
    static QStringList s_uiFamilies;
    static QStringList s_textFamilies;
    static QStringList s_displayFamilies;
};
