#include "KeyboardEngine.h"
#include "PinyinLexicon.h"
#include "RomajiKana.h"

#include <QCoreApplication>
#include <QFile>
#include <QGuiApplication>
#include <QInputMethodEvent>
#include <QInputMethodQueryEvent>
#include <QKeyEvent>
#include <QQuickItem>
#include <QQuickWindow>
#include <QTextCharFormat>
#include <QVector>
#include <string>

#ifdef QWINUI3_HAVE_KEYMAN
#include <keyman/keyman_core_api.h>
#include <keyman/keyman_core_api_consts.h>
#include <keyman/keyman_core_api_vkeys.h>
#endif

namespace {

const QStringList kLayoutIds = {
    QStringLiteral("en-US"),
    QStringLiteral("de-DE"),
    QStringLiteral("fr-FR"),
    QStringLiteral("es-ES"),
    QStringLiteral("ru-RU"),
    QStringLiteral("ar"),
    QStringLiteral("zh-Hans"),
    QStringLiteral("ja-JP"),
    QStringLiteral("ko-KR"),
};

#ifdef QWINUI3_HAVE_KEYMAN
QString kmxResource(const QString &layoutId)
{
    if (layoutId == QLatin1String("de-DE"))
        return QStringLiteral("basic_kbdgr.kmx");
    if (layoutId == QLatin1String("fr-FR"))
        return QStringLiteral("basic_kbdfr.kmx");
    if (layoutId == QLatin1String("es-ES"))
        return QStringLiteral("basic_kbdes.kmx");
    if (layoutId == QLatin1String("ru-RU"))
        return QStringLiteral("basic_kbdru.kmx");
    if (layoutId == QLatin1String("ar"))
        return QStringLiteral("basic_kbda1.kmx");
    return QStringLiteral("basic_kbdus.kmx");
}

QString usvToQString(const km_core_usv *text)
{
    if (!text)
        return {};
    qsizetype n = 0;
    while (text[n])
        ++n;
    return QString::fromUcs4(reinterpret_cast<const char32_t *>(text), n);
}

km_core_option_item kEnv[] = {KM_CORE_OPTIONS_END};
#endif

QString builtinGlyph(int vk, bool shift)
{
    if (vk >= 65 && vk <= 90) {
        const QChar c(vk);
        return QString(shift ? c : c.toLower());
    }
    if (vk >= 48 && vk <= 57) {
        static const char shifted[] = ")!@#$%^&*(";
        if (shift)
            return QString(QChar::fromLatin1(shifted[vk - 48]));
        return QString(QChar(vk));
    }
    return {};
}

} // namespace

KeyboardEngine::KeyboardEngine(QObject *parent)
    : QObject(parent)
{
#ifdef QWINUI3_HAVE_KEYMAN
    loadLayout(m_layoutId);
#endif
}

KeyboardEngine::~KeyboardEngine()
{
#ifdef QWINUI3_HAVE_KEYMAN
    disposeCore();
#endif
}

QString KeyboardEngine::backend() const
{
    if (pinyin())
        return QStringLiteral("pinyin");
    if (japanese())
        return QStringLiteral("romaji");
    if (korean())
        return QStringLiteral("hangul");
#ifdef QWINUI3_HAVE_KEYMAN
    return QStringLiteral("keyman");
#else
    return QStringLiteral("builtin");
#endif
}

bool KeyboardEngine::isKnownLayout(const QString &id)
{
    return kLayoutIds.contains(id);
}

QStringList KeyboardEngine::layoutIds() const
{
    return kLayoutIds;
}

QStringList KeyboardEngine::layoutLabels() const
{
    return {
        tr("English"),
        tr("Deutsch"),
        tr("Français"),
        tr("Español"),
        tr("Русский"),
        tr("العربية"),
        tr("中文"),
        tr("日本語"),
        tr("한국어"),
    };
}

QString KeyboardEngine::layoutLabel() const
{
    const int i = layoutIndex();
    const QStringList labels = layoutLabels();
    if (i < 0 || i >= labels.size())
        return m_layoutId;
    return labels.at(i);
}

int KeyboardEngine::layoutIndex() const
{
    return kLayoutIds.indexOf(m_layoutId);
}

void KeyboardEngine::setLayoutIndex(int index)
{
    if (index < 0 || index >= kLayoutIds.size())
        return;
    setLayoutId(kLayoutIds.at(index));
}

void KeyboardEngine::setLayoutId(const QString &id)
{
    if (id == m_layoutId)
        return;
    if (!isKnownLayout(id))
        return;
    if (ime())
        cancelCompose();
    m_layoutId = id;
#ifdef QWINUI3_HAVE_KEYMAN
    loadLayout(m_layoutId);
#endif
    emit layoutIdChanged();
}

bool KeyboardEngine::rtl() const
{
    return m_layoutId == QLatin1String("ar");
}

bool KeyboardEngine::pinyin() const
{
    return m_layoutId == QLatin1String("zh-Hans");
}

bool KeyboardEngine::japanese() const
{
    return m_layoutId == QLatin1String("ja-JP");
}

bool KeyboardEngine::korean() const
{
    return m_layoutId == QLatin1String("ko-KR");
}

bool KeyboardEngine::ime() const
{
    return pinyin() || japanese() || korean();
}

bool KeyboardEngine::composing() const
{
    return !displayPreedit().isEmpty();
}

QString KeyboardEngine::preedit() const
{
    return displayPreedit();
}

QString KeyboardEngine::displayPreedit() const
{
    if (korean())
        return m_hangul.preedit();
    if (japanese()) {
        QString rest;
        return RomajiKana::toHiragana(m_preedit, &rest) + rest;
    }
    return m_preedit;
}

void KeyboardEngine::cycleLayout()
{
    const int n = kLayoutIds.size();
    if (n <= 0)
        return;
    setLayoutIndex((layoutIndex() + 1) % n);
}

void KeyboardEngine::watch(QObject *window)
{
    auto *quick = qobject_cast<QQuickWindow *>(window);
    if (m_window == quick)
        return;
    if (m_window)
        disconnect(m_window, nullptr, this, nullptr);
    m_window = quick;
    if (!m_window)
        return;
    connect(m_window, &QQuickWindow::activeFocusItemChanged,
            this, &KeyboardEngine::onFocusChanged);
    onFocusChanged();
}

void KeyboardEngine::onFocusChanged()
{
    if (!m_window)
        return;
    rememberEditor(m_window->activeFocusItem());
}

void KeyboardEngine::rememberEditor(QObject *object)
{
    QObject *walk = object;
    while (walk && !looksLikeEditor(walk))
        walk = walk->parent();
    if (!walk || walk == m_target)
        return;
    m_target = walk;
#ifdef QWINUI3_HAVE_KEYMAN
    syncContext();
#endif
    emit hasTargetChanged();
}

QObject *KeyboardEngine::target() const
{
    if (m_target)
        return m_target;
    QObject *focus = QGuiApplication::focusObject();
    QObject *walk = focus;
    while (walk && !looksLikeEditor(walk))
        walk = walk->parent();
    return walk;
}

bool KeyboardEngine::looksLikeEditor(const QObject *object)
{
    if (!object)
        return false;
    const QMetaObject *mo = object->metaObject();
    while (mo) {
        const QByteArray cn(mo->className());
        if (cn.contains("TextInput") || cn.contains("TextEdit"))
            return true;
        mo = mo->superClass();
    }
    return false;
}

void KeyboardEngine::commitText(const QString &text)
{
    if (text.isEmpty())
        return;
    if (ime() && composing())
        confirmCompose();
    rememberEditor(QGuiApplication::focusObject());
    QObject *item = target();
    if (!item)
        return;
    QInputMethodEvent event;
    event.setCommitString(text);
    QCoreApplication::sendEvent(item, &event);
}

void KeyboardEngine::processVk(int vk, bool shift)
{
    if (pinyin()) {
        processPinyinVk(vk, shift);
        return;
    }
    if (japanese()) {
        processJapaneseVk(vk, shift);
        return;
    }
    if (korean()) {
        processKoreanVk(vk, shift);
        return;
    }
#ifdef QWINUI3_HAVE_KEYMAN
    if (m_state) {
        rememberEditor(QGuiApplication::focusObject());
        const uint16_t mods = shift ? KM_CORE_MODIFIER_SHIFT : KM_CORE_MODIFIER_NONE;
        km_core_process_event(m_state, km_core_virtual_key(vk), mods, 1, KM_CORE_EVENT_FLAG_TOUCH);
        applyCoreActions();
        km_core_process_event(m_state, km_core_virtual_key(vk), mods, 0, KM_CORE_EVENT_FLAG_TOUCH);
        return;
    }
#endif
    commitText(builtinGlyph(vk, shift));
}

QString KeyboardEngine::previewVk(int vk, bool shift) const
{
    if (pinyin() || japanese())
        return builtinGlyph(vk, false);
    if (korean()) {
        const QChar jamo = HangulComposer::jamoFromVk(vk, shift);
        if (!jamo.isNull())
            return QString(jamo);
    }
#ifdef QWINUI3_HAVE_KEYMAN
    const QString probed = probeVk(vk, shift);
    if (!probed.isEmpty())
        return probed;
#endif
    return builtinGlyph(vk, shift);
}

void KeyboardEngine::backspace()
{
    if (korean()) {
        if (m_hangul.backspace() != QLatin1String("\b")) {
            refreshCompose();
            return;
        }
    } else if (ime() && !m_preedit.isEmpty()) {
        m_preedit.chop(1);
        refreshCompose();
        return;
    }
#ifdef QWINUI3_HAVE_KEYMAN
    if (m_state) {
        processVk(KM_CORE_VKEY_BKSP, false);
        return;
    }
#endif
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Backspace);
}

void KeyboardEngine::enterKey()
{
    if (ime() && composing()) {
        confirmCompose();
        return;
    }
#ifdef QWINUI3_HAVE_KEYMAN
    if (m_state) {
        processVk(KM_CORE_VKEY_ENTER, false);
        return;
    }
#endif
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Return, QStringLiteral("\n"));
}

void KeyboardEngine::tabKey()
{
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Tab, QStringLiteral("\t"));
}

void KeyboardEngine::sendKey(int key, const QString &text) const
{
    QObject *item = target();
    if (!item)
        return;
    QKeyEvent press(QEvent::KeyPress, key, Qt::NoModifier, text);
    QKeyEvent release(QEvent::KeyRelease, key, Qt::NoModifier, text);
    QCoreApplication::sendEvent(item, &press);
    QCoreApplication::sendEvent(item, &release);
}

int KeyboardEngine::candidatePageCount() const
{
    if (m_candidates.isEmpty())
        return 0;
    return (m_candidates.size() + kPageSize - 1) / kPageSize;
}

QStringList KeyboardEngine::pagedCandidates() const
{
    QStringList out;
    const int start = m_candidatePage * kPageSize;
    for (int i = 0; i < kPageSize && start + i < m_candidates.size(); ++i)
        out.append(m_candidates.at(start + i));
    return out;
}

void KeyboardEngine::processPinyinVk(int vk, bool shift)
{
    Q_UNUSED(shift);
    rememberEditor(QGuiApplication::focusObject());
    if (vk >= 65 && vk <= 90) {
        const QChar letter = QChar(vk).toLower();
        if (!PinyinLexicon::instance().canAppend(m_preedit, letter))
            return;
        m_preedit.append(letter);
        refreshCompose();
        return;
    }
    if (vk >= 49 && vk <= 57) {
        pickCandidate(vk - 49);
        return;
    }
    if (vk == 8) {
        backspace();
        return;
    }
    if (vk == 13) {
        enterKey();
        return;
    }
}

void KeyboardEngine::processJapaneseVk(int vk, bool shift)
{
    Q_UNUSED(shift);
    rememberEditor(QGuiApplication::focusObject());
    if (vk >= 65 && vk <= 90) {
        m_preedit.append(QChar(vk).toLower());
        refreshCompose();
        return;
    }
    if (vk >= 49 && vk <= 57) {
        pickCandidate(vk - 49);
        return;
    }
    if (vk == 8) {
        backspace();
        return;
    }
    if (vk == 13) {
        enterKey();
        return;
    }
}

void KeyboardEngine::processKoreanVk(int vk, bool shift)
{
    rememberEditor(QGuiApplication::focusObject());
    if (vk >= 65 && vk <= 90) {
        const QString committed = m_hangul.feedVk(vk, shift);
        if (!committed.isEmpty())
            commitReplace(committed);
        refreshCompose();
        return;
    }
    if (vk >= 49 && vk <= 57) {
        pickCandidate(vk - 49);
        return;
    }
    if (vk == 8) {
        backspace();
        return;
    }
    if (vk == 13) {
        enterKey();
        return;
    }
}

void KeyboardEngine::refreshCompose()
{
    if (pinyin())
        m_candidates = PinyinLexicon::instance().lookup(m_preedit);
    else if (japanese())
        m_candidates = RomajiKana::candidates(m_preedit);
    else if (korean()) {
        const QString syllable = m_hangul.preedit();
        m_candidates = syllable.isEmpty() ? QStringList{} : QStringList{syllable};
    } else {
        m_candidates.clear();
    }
    m_candidatePage = 0;
    sendPreedit();
    emit composeChanged();
}

void KeyboardEngine::sendPreedit()
{
    QObject *item = target();
    if (!item)
        return;
    const QString shown = displayPreedit();
    QList<QInputMethodEvent::Attribute> attrs;
    if (!shown.isEmpty()) {
        QTextCharFormat fmt;
        fmt.setFontUnderline(true);
        attrs.append({QInputMethodEvent::TextFormat, 0, int(shown.size()), QVariant::fromValue(fmt)});
        attrs.append({QInputMethodEvent::Cursor, int(shown.size()), 1, QVariant()});
    }
    QInputMethodEvent ev(shown, attrs);
    QCoreApplication::sendEvent(item, &ev);
}

void KeyboardEngine::commitReplace(const QString &text)
{
    rememberEditor(QGuiApplication::focusObject());
    QObject *item = target();
    if (!item)
        return;
    QInputMethodEvent ev(QString(), {});
    ev.setCommitString(text);
    QCoreApplication::sendEvent(item, &ev);
}

void KeyboardEngine::pickCandidate(int indexOnPage)
{
    if (m_candidates.isEmpty())
        return;
    const int idx = m_candidatePage * kPageSize + indexOnPage;
    if (idx < 0 || idx >= m_candidates.size())
        return;
    const QString picked = m_candidates.at(idx);
    if (korean()) {
        m_hangul.reset();
        commitReplace(picked);
        refreshCompose();
        return;
    }
    if (japanese()) {
        QString rest;
        RomajiKana::toHiragana(m_preedit, &rest);
        commitReplace(picked);
        m_preedit = rest;
        refreshCompose();
        return;
    }
    if (!pinyin())
        return;
    const QString syl = PinyinLexicon::instance().firstSyllable(m_preedit);
    const int consume = picked.size() > 1 ? int(m_preedit.size()) : qMax(1, int(syl.size()));
    const QString rest = m_preedit.mid(consume);
    commitReplace(picked);
    m_preedit = rest;
    refreshCompose();
}

void KeyboardEngine::nextCandidatePage()
{
    const int n = candidatePageCount();
    if (n <= 0)
        return;
    m_candidatePage = (m_candidatePage + 1) % n;
    emit composeChanged();
}

void KeyboardEngine::prevCandidatePage()
{
    const int n = candidatePageCount();
    if (n <= 0)
        return;
    m_candidatePage = (m_candidatePage + n - 1) % n;
    emit composeChanged();
}

void KeyboardEngine::confirmCompose()
{
    if (!composing())
        return;
    if (korean() && m_candidates.isEmpty()) {
        const QString out = m_hangul.flush();
        if (!out.isEmpty())
            commitReplace(out);
        refreshCompose();
        return;
    }
    if (!m_candidates.isEmpty()) {
        pickCandidate(0);
        return;
    }
    const QString raw = displayPreedit();
    m_preedit.clear();
    m_hangul.reset();
    m_candidates.clear();
    m_candidatePage = 0;
    commitReplace(raw);
    emit composeChanged();
}

void KeyboardEngine::cancelCompose()
{
    if (m_preedit.isEmpty() && m_candidates.isEmpty() && m_hangul.preedit().isEmpty())
        return;
    m_preedit.clear();
    m_hangul.reset();
    m_candidates.clear();
    m_candidatePage = 0;
    sendPreedit();
    emit composeChanged();
}

#ifdef QWINUI3_HAVE_KEYMAN

void KeyboardEngine::disposeCore()
{
    if (m_state) {
        km_core_state_dispose(m_state);
        m_state = nullptr;
    }
    if (m_keyboard) {
        km_core_keyboard_dispose(m_keyboard);
        m_keyboard = nullptr;
    }
}

QByteArray KeyboardEngine::loadKmx(const QString &id) const
{
    QFile f(QStringLiteral(":/QWinUI3/keyboards/%1").arg(kmxResource(id)));
    if (!f.open(QIODevice::ReadOnly))
        return {};
    return f.readAll();
}

bool KeyboardEngine::loadLayout(const QString &id)
{
    disposeCore();
    if (id == QLatin1String("zh-Hans") || id == QLatin1String("ja-JP")
        || id == QLatin1String("ko-KR"))
        return true;
    const QByteArray blob = loadKmx(id);
    if (blob.isEmpty())
        return false;
    const QString name = kmxResource(id);
#ifdef _WIN32
    const std::wstring wname = name.toStdWString();
    const km_core_path_name kbName = wname.c_str();
#else
    const QByteArray utf8 = name.toUtf8();
    const km_core_path_name kbName = utf8.constData();
#endif
    if (km_core_keyboard_load_from_blob(kbName, blob.constData(), size_t(blob.size()), &m_keyboard)
        != KM_CORE_STATUS_OK) {
        m_keyboard = nullptr;
        return false;
    }
    if (km_core_state_create(m_keyboard, kEnv, &m_state) != KM_CORE_STATUS_OK) {
        km_core_keyboard_dispose(m_keyboard);
        m_keyboard = nullptr;
        m_state = nullptr;
        return false;
    }
    syncContext();
    return true;
}

void KeyboardEngine::syncContext()
{
    QObject *item = target();
    if (!item || !m_state)
        return;
    QInputMethodQueryEvent q(Qt::ImSurroundingText | Qt::ImCursorPosition);
    QCoreApplication::sendEvent(item, &q);
    const QString surrounding = q.value(Qt::ImSurroundingText).toString();
    const int cursor = q.value(Qt::ImCursorPosition).toInt();
    const QString before = surrounding.left(qMax(0, cursor));
    const QString utf16 = before;
    QVector<char16_t> buf;
    buf.reserve(utf16.size() + 1);
    const auto u16 = utf16.utf16();
    for (int i = 0; i < utf16.size(); ++i)
        buf.push_back(char16_t(u16[i]));
    buf.push_back(0);
    km_core_state_context_set_if_needed(m_state, buf.constData());
}

void KeyboardEngine::applyCoreActions()
{
    if (!m_state)
        return;
    const km_core_actions *actions = km_core_state_get_actions(m_state);
    if (!actions)
        return;
    QObject *item = target();
    if (!item)
        return;
    const QString out = usvToQString(actions->output);
    const int del = int(actions->code_points_to_delete);
    if (del <= 0 && out.isEmpty() && !actions->emit_keystroke)
        return;
    if (actions->emit_keystroke && out.isEmpty() && del <= 0)
        return;
    QInputMethodEvent event;
    if (del > 0)
        event.setCommitString(out, -del, del);
    else
        event.setCommitString(out);
    QCoreApplication::sendEvent(item, &event);
}

QString KeyboardEngine::probeVk(int vk, bool shift) const
{
    if (!m_keyboard)
        return {};
    km_core_state *tmp = nullptr;
    if (km_core_state_create(m_keyboard, kEnv, &tmp) != KM_CORE_STATUS_OK)
        return {};
    const uint16_t mods = shift ? KM_CORE_MODIFIER_SHIFT : KM_CORE_MODIFIER_NONE;
    km_core_process_event(tmp, km_core_virtual_key(vk), mods, 1, KM_CORE_EVENT_FLAG_TOUCH);
    const km_core_actions *actions = km_core_state_get_actions(tmp);
    QString out = actions ? usvToQString(actions->output) : QString();
    km_core_process_event(tmp, km_core_virtual_key(vk), mods, 0, KM_CORE_EVENT_FLAG_TOUCH);
    km_core_state_dispose(tmp);
    return out;
}

#endif
