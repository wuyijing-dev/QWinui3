#include "KeyboardEngine.h"
#include "PinyinLexicon.h"
#include "RomajiKana.h"

#include <QCoreApplication>
#include <QClipboard>
#include <QEvent>
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

#ifdef Q_OS_WIN
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#endif

#ifdef QWINUI3_HAVE_KEYMAN
#include <keyman/keyman_core_api.h>
#include <keyman/keyman_core_api_consts.h>
#include <keyman/keyman_core_api_vkeys.h>
#endif

namespace {

const QStringList kLayoutIds = {
    QStringLiteral("en-US"),
    QStringLiteral("en-GB"),
    QStringLiteral("de-DE"),
    QStringLiteral("fr-FR"),
    QStringLiteral("es-ES"),
    QStringLiteral("it-IT"),
    QStringLiteral("pt-PT"),
    QStringLiteral("pl-PL"),
    QStringLiteral("sv-SE"),
    QStringLiteral("tr-TR"),
    QStringLiteral("ru-RU"),
    QStringLiteral("ar"),
    QStringLiteral("zh-Hans"),
    QStringLiteral("ja-JP"),
    QStringLiteral("ko-KR"),
};

#ifdef QWINUI3_HAVE_KEYMAN
QString kmxResource(const QString &layoutId)
{
    if (layoutId == QLatin1String("en-GB"))
        return QStringLiteral("basic_kbduk.kmx");
    if (layoutId == QLatin1String("de-DE"))
        return QStringLiteral("basic_kbdgr.kmx");
    if (layoutId == QLatin1String("fr-FR"))
        return QStringLiteral("basic_kbdfr.kmx");
    if (layoutId == QLatin1String("es-ES"))
        return QStringLiteral("basic_kbdes.kmx");
    if (layoutId == QLatin1String("it-IT"))
        return QStringLiteral("basic_kbdit.kmx");
    if (layoutId == QLatin1String("pt-PT"))
        return QStringLiteral("basic_kbdpo.kmx");
    if (layoutId == QLatin1String("pl-PL"))
        return QStringLiteral("basic_kbdpl.kmx");
    if (layoutId == QLatin1String("sv-SE"))
        return QStringLiteral("basic_kbdsw.kmx");
    if (layoutId == QLatin1String("tr-TR"))
        return QStringLiteral("basic_kbdtuq.kmx");
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
    if (QCoreApplication::instance())
        QCoreApplication::instance()->installEventFilter(this);
#ifdef QWINUI3_HAVE_KEYMAN
    loadLayout(m_layoutId);
#endif
}

KeyboardEngine::~KeyboardEngine()
{
    if (QCoreApplication::instance())
        QCoreApplication::instance()->removeEventFilter(this);
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
        tr("English (US)"),
        tr("English (UK)"),
        tr("Deutsch"),
        tr("Français"),
        tr("Español"),
        tr("Italiano"),
        tr("Português"),
        tr("Polski"),
        tr("Svenska"),
        tr("Türkçe"),
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
        return RomajiKana::toHiragana(m_preedit, &rest, true) + rest;
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

namespace {

#ifdef Q_OS_WIN
void winSendUnicode(const QString &text)
{
    if (text.isEmpty())
        return;
    QVector<INPUT> inputs;
    inputs.reserve(text.size() * 2);
    for (QChar ch : text) {
        INPUT down {};
        down.type = INPUT_KEYBOARD;
        down.ki.wScan = ch.unicode();
        down.ki.dwFlags = KEYEVENTF_UNICODE;
        INPUT up = down;
        up.ki.dwFlags = KEYEVENTF_UNICODE | KEYEVENTF_KEYUP;
        inputs.append(down);
        inputs.append(up);
    }
    if (!inputs.isEmpty())
        SendInput(UINT(inputs.size()), inputs.data(), sizeof(INPUT));
}

void winSendVk(WORD vk)
{
    INPUT down {};
    down.type = INPUT_KEYBOARD;
    down.ki.wVk = vk;
    INPUT up = down;
    up.ki.dwFlags = KEYEVENTF_KEYUP;
    INPUT pair[2] = { down, up };
    SendInput(2, pair, sizeof(INPUT));
}

WORD qtKeyToWinVk(int qtKey)
{
    switch (qtKey) {
    case Qt::Key_Backspace:
        return VK_BACK;
    case Qt::Key_Tab:
        return VK_TAB;
    case Qt::Key_Return:
    case Qt::Key_Enter:
        return VK_RETURN;
    case Qt::Key_Escape:
        return VK_ESCAPE;
    case Qt::Key_Left:
        return VK_LEFT;
    case Qt::Key_Right:
        return VK_RIGHT;
    case Qt::Key_Up:
        return VK_UP;
    case Qt::Key_Down:
        return VK_DOWN;
    case Qt::Key_Delete:
        return VK_DELETE;
    case Qt::Key_Home:
        return VK_HOME;
    case Qt::Key_End:
        return VK_END;
    default:
        return 0;
    }
}
#endif

} // namespace

bool KeyboardEngine::supportsSystemWide() const
{
#ifdef Q_OS_WIN
    return true;
#else
    return false;
#endif
}

void KeyboardEngine::setSystemWide(bool on)
{
    const bool enabled = on && supportsSystemWide();
    if (m_systemWide == enabled)
        return;
    m_systemWide = enabled;
    emit systemWideChanged();
}

bool KeyboardEngine::trySystemWideText(const QString &text) const
{
#ifdef Q_OS_WIN
    if (!m_systemWide || text.isEmpty())
        return false;
    winSendUnicode(text);
    return true;
#else
    Q_UNUSED(text);
    return false;
#endif
}

bool KeyboardEngine::trySystemWideKey(int qtKey) const
{
#ifdef Q_OS_WIN
    if (!m_systemWide)
        return false;
    const WORD vk = qtKeyToWinVk(qtKey);
    if (!vk)
        return false;
    winSendVk(vk);
    return true;
#else
    Q_UNUSED(qtKey);
    return false;
#endif
}

void KeyboardEngine::commitText(const QString &text)
{
    if (text.isEmpty())
        return;
    if (ime() && composing())
        confirmCompose();
    if (trySystemWideText(text))
        return;
    rememberEditor(QGuiApplication::focusObject());
    QObject *item = target();
    if (!item)
        return;
    QInputMethodEvent event;
    event.setCommitString(text);
    QCoreApplication::sendEvent(item, &event);
}

void KeyboardEngine::setHardwareInput(bool on)
{
    if (m_hardwareInput == on)
        return;
    m_hardwareInput = on;
    emit hardwareInputChanged();
}

void KeyboardEngine::processVk(int vk, bool shift)
{
    processVk(vk, shift, false);
}

void KeyboardEngine::processVk(int vk, bool shift, bool altGr)
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
        processKeymanVk(vk, shift, altGr);
        return;
    }
#endif
    Q_UNUSED(altGr);
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
    if (trySystemWideKey(Qt::Key_Backspace))
        return;
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
    if (trySystemWideKey(Qt::Key_Return))
        return;
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Return, QStringLiteral("\n"));
}

void KeyboardEngine::tabKey()
{
    if (trySystemWideKey(Qt::Key_Tab))
        return;
    rememberEditor(QGuiApplication::focusObject());
    sendKey(Qt::Key_Tab, QStringLiteral("\t"));
}

void KeyboardEngine::navigateKey(int qtKey)
{
    if (qtKey == Qt::Key_Escape) {
        if (composing()) {
            cancelCompose();
            return;
        }
        if (trySystemWideKey(Qt::Key_Escape))
            return;
        sendKey(Qt::Key_Escape);
        return;
    }
    if (trySystemWideKey(qtKey))
        return;
    rememberEditor(QGuiApplication::focusObject());
    sendKey(qtKey);
}

void KeyboardEngine::pasteClipboard()
{
    const QString text = QGuiApplication::clipboard()->text();
    if (text.isEmpty())
        return;
    if (composing())
        confirmCompose();
    commitText(text);
}

QString KeyboardEngine::clipboardText() const
{
    return QGuiApplication::clipboard()->text();
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
        if (composing() || !m_candidates.isEmpty()) {
            pickCandidate(vk - 49);
            return;
        }
        commitText(QString(QChar(QLatin1Char('0' + (vk - 48)))));
        return;
    }
    if (vk == 48) {
        commitText(QStringLiteral("0"));
        return;
    }
    if (vk == 32) {
        if (composing())
            confirmCompose();
        else
            commitText(QStringLiteral(" "));
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
    if (vk == 27) {
        cancelCompose();
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
        if (composing() || !m_candidates.isEmpty()) {
            pickCandidate(vk - 49);
            return;
        }
        commitText(QString(QChar(QLatin1Char('0' + (vk - 48)))));
        return;
    }
    if (vk == 48) {
        commitText(QStringLiteral("0"));
        return;
    }
    if (vk == 32) {
        if (composing())
            confirmCompose();
        else
            commitText(QStringLiteral(" "));
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
    if (vk == 27) {
        cancelCompose();
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
        if (composing() || !m_candidates.isEmpty()) {
            pickCandidate(vk - 49);
            return;
        }
        commitText(QString(QChar(QLatin1Char('0' + (vk - 48)))));
        return;
    }
    if (vk == 48) {
        commitText(QStringLiteral("0"));
        return;
    }
    if (vk == 32) {
        if (composing()) {
            confirmCompose();
            commitText(QStringLiteral(" "));
        } else {
            commitText(QStringLiteral(" "));
        }
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
    if (vk == 27) {
        cancelCompose();
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
    // System-wide: keep composition on the OSK candidate bar only (no foreign preedit).
    if (m_systemWide)
        return;
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
    if (trySystemWideText(text))
        return;
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
        RomajiKana::toHiragana(m_preedit, &rest, true);
        commitReplace(picked);
        m_preedit = rest;
        refreshCompose();
        return;
    }
    if (!pinyin())
        return;
    const int consume = PinyinLexicon::instance().consumeLength(m_preedit, picked);
    const QString rest = m_preedit.mid(qMax(1, consume));
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

bool KeyboardEngine::editorFocused() const
{
    if (looksLikeEditor(target()))
        return true;
    QObject *focus = QGuiApplication::focusObject();
    QObject *walk = focus;
    while (walk) {
        if (looksLikeEditor(walk))
            return true;
        walk = walk->parent();
    }
    return false;
}

bool KeyboardEngine::capsLockOn() const
{
#ifdef Q_OS_WIN
    return (GetKeyState(VK_CAPITAL) & 1) != 0;
#else
    return m_capsLockOn;
#endif
}

int KeyboardEngine::qtKeyToVk(int key)
{
    if (key >= Qt::Key_A && key <= Qt::Key_Z)
        return key; // Qt::Key_A == 0x41
    if (key >= Qt::Key_0 && key <= Qt::Key_9)
        return key; // Qt::Key_0 == 0x30
    switch (key) {
    case Qt::Key_Backspace:
        return 8;
    case Qt::Key_Tab:
        return 9;
    case Qt::Key_Return:
    case Qt::Key_Enter:
        return 13;
    case Qt::Key_Escape:
        return 27;
    case Qt::Key_Space:
        return 32;
    case Qt::Key_Period:
        return 190;
    case Qt::Key_Comma:
        return 188;
    case Qt::Key_Minus:
        return 189;
    case Qt::Key_Plus:
        return 187;
    case Qt::Key_BracketLeft:
        return 219;
    case Qt::Key_BracketRight:
        return 221;
    case Qt::Key_Backslash:
        return 220;
    case Qt::Key_Semicolon:
        return 186;
    case Qt::Key_Apostrophe:
        return 222;
    case Qt::Key_QuoteLeft:
    case Qt::Key_AsciiTilde:
        return 192;
    case Qt::Key_Slash:
        return 191;
    default:
        return 0;
    }
}

bool KeyboardEngine::canHandleHardware(const QKeyEvent *ke) const
{
    if (!ke || ke->isAutoRepeat())
        return false;
    if (!editorFocused())
        return false;

    const Qt::KeyboardModifiers mods = ke->modifiers();
    const bool altGr = (mods & Qt::AltModifier) && (mods & Qt::ControlModifier);
    const bool ctrlOnly = (mods & Qt::ControlModifier) && !(mods & Qt::AltModifier);
    if (ctrlOnly || (mods & Qt::MetaModifier))
        return false;
    if ((mods & Qt::AltModifier) && !altGr)
        return false;

    const int key = ke->key();
    if (key == Qt::Key_Escape)
        return composing();
    if (key == Qt::Key_PageUp || key == Qt::Key_PageDown)
        return composing() || !m_candidates.isEmpty();
#ifdef Q_OS_WIN
    const quint32 nvk = ke->nativeVirtualKey();
    if ((nvk >= '0' && nvk <= '9') || (nvk >= 'A' && nvk <= 'Z') || nvk == VK_SPACE
        || nvk == VK_BACK || nvk == VK_RETURN || nvk == VK_TAB || nvk == VK_ESCAPE
        || (nvk >= 186 && nvk <= 222))
        return true;
#endif
    if (qtKeyToVk(key) != 0)
        return true;
    return false;
}

bool KeyboardEngine::handleHardwareKey(QKeyEvent *ke)
{
    if (!canHandleHardware(ke))
        return false;

    rememberEditor(QGuiApplication::focusObject());
    const int key = ke->key();
    if (key == Qt::Key_Escape) {
        cancelCompose();
        return true;
    }
    if (key == Qt::Key_PageDown) {
        nextCandidatePage();
        return true;
    }
    if (key == Qt::Key_PageUp) {
        prevCandidatePage();
        return true;
    }

    int vk = 0;
#ifdef Q_OS_WIN
    const quint32 nvk = ke->nativeVirtualKey();
    if ((nvk >= '0' && nvk <= '9') || (nvk >= 'A' && nvk <= 'Z') || nvk == VK_SPACE
        || nvk == VK_BACK || nvk == VK_RETURN || nvk == VK_TAB || nvk == VK_ESCAPE
        || (nvk >= 186 && nvk <= 222))
        vk = int(nvk);
#endif
    if (vk == 0)
        vk = qtKeyToVk(key);
    if (vk == 0)
        return false;

    const Qt::KeyboardModifiers mods = ke->modifiers();
    const bool altGr = (mods & Qt::AltModifier) && (mods & Qt::ControlModifier);
    bool shift = mods & Qt::ShiftModifier;
    if (!korean() && !ime() && (vk >= 65 && vk <= 90) && capsLockOn())
        shift = !shift;
    if (korean())
        shift = mods & Qt::ShiftModifier;

    if (vk == 32) {
        processVk(32, false, false);
        return true;
    }

    // OEM punctuation — Keyman / builtin only; IME layouts leave them to Qt.
    if (vk >= 186 && vk <= 222) {
        if (ime() || korean())
            return false;
#ifdef QWINUI3_HAVE_KEYMAN
        if (m_state) {
            processKeymanVk(vk, shift, altGr);
            return true;
        }
#endif
        return false;
    }

    processVk(vk, shift, altGr);
    return true;
}

bool KeyboardEngine::eventFilter(QObject *watched, QEvent *event)
{
    Q_UNUSED(watched);
    const QEvent::Type type = event->type();
    if (type == QEvent::KeyPress) {
        auto *ke = static_cast<QKeyEvent *>(event);
#ifndef Q_OS_WIN
        // Sync CapsLock for Latin hardware path under Wayland/X11.
        if (ke->key() == Qt::Key_CapsLock && !ke->isAutoRepeat())
            m_capsLockOn = !m_capsLockOn;
#else
        Q_UNUSED(ke);
#endif
    }

    if (!m_hardwareInput)
        return false;

    if (type != QEvent::KeyPress && type != QEvent::ShortcutOverride)
        return false;

    auto *ke = static_cast<QKeyEvent *>(event);
    if (type == QEvent::ShortcutOverride) {
        if (canHandleHardware(ke)) {
            ke->accept();
            return true;
        }
        return false;
    }

    return handleHardwareKey(ke);
}

#ifdef QWINUI3_HAVE_KEYMAN

void KeyboardEngine::processKeymanVk(int vk, bool shift, bool altGr)
{
    rememberEditor(QGuiApplication::focusObject());
    uint16_t mods = KM_CORE_MODIFIER_NONE;
    if (shift)
        mods |= KM_CORE_MODIFIER_SHIFT;
    if (altGr)
        mods |= KM_CORE_MODIFIER_RALT;
    km_core_process_event(m_state, km_core_virtual_key(vk), mods, 1, KM_CORE_EVENT_FLAG_TOUCH);
    applyCoreActions();
    km_core_process_event(m_state, km_core_virtual_key(vk), mods, 0, KM_CORE_EVENT_FLAG_TOUCH);
}

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
    const QString out = usvToQString(actions->output);
    const int del = int(actions->code_points_to_delete);
    if (del <= 0 && out.isEmpty() && !actions->emit_keystroke)
        return;
    if (actions->emit_keystroke && out.isEmpty() && del <= 0)
        return;
    if (m_systemWide && supportsSystemWide()) {
#ifdef Q_OS_WIN
        for (int i = 0; i < del; ++i)
            winSendVk(VK_BACK);
        if (!out.isEmpty())
            winSendUnicode(out);
#endif
        return;
    }
    QObject *item = target();
    if (!item)
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
