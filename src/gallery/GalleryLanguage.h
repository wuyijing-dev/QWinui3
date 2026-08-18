#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTranslator>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

// Gallery UI locale — runtime QTranslator + QQmlEngine::retranslate (full Gallery switch).
class GalleryLanguage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString currentLocale READ currentLocale WRITE setCurrentLocale NOTIFY currentLocaleChanged)
    Q_PROPERTY(QStringList availableLocales READ availableLocales CONSTANT)
    Q_PROPERTY(QStringList localeLabels READ localeLabels NOTIFY currentLocaleChanged)
    Q_PROPERTY(bool translatorActive READ translatorActive NOTIFY currentLocaleChanged)

public:
    explicit GalleryLanguage(QObject *parent = nullptr);

    static GalleryLanguage *create(QQmlEngine *engine, QJSEngine *scriptEngine);
    static GalleryLanguage *instance();

    // Optional --lang before QML loads (overrides QSettings until user picks in Settings).
    static void setStartupLocaleOverride(const QString &locale);

    QString currentLocale() const;
    void setCurrentLocale(const QString &locale);

    QStringList availableLocales() const;
    QStringList localeLabels() const;
    bool translatorActive() const;

    Q_INVOKABLE QString labelForLocale(const QString &locale) const;
    Q_INVOKABLE int indexOfLocale(const QString &locale) const;
    Q_INVOKABLE void applyLocale(const QString &locale);

signals:
    void currentLocaleChanged();

private:
    static QString normalizeLocale(const QString &locale);
    static QStringList searchDirectories();
    bool loadTranslator(const QString &locale);
    void unloadTranslator();
    void persistLocale(const QString &locale);
    static QString readPersistedLocale();

    QQmlEngine *m_engine = nullptr;
    QTranslator m_translator;
    bool m_installed = false;
    QString m_currentLocale;
    static QString s_startupOverride;
};
