#include "FluentIcons.h"
#include "ThemeFonts.h"

#include <QChar>
#include <QHash>
#include <QMutex>
#include <QMutexLocker>
#include <QVariantMap>
#include <algorithm>

#include "FluentIconsFontMap.inc"

namespace {

QMutex g_mutex;
bool g_ready = false;
QStringList g_names;
QVariantList g_entries;
QHash<ushort, QString> g_primaryNameByCode;
QHash<QString, QString> g_glyphByName;

QString glyphOf(char32_t cp)
{
    return QString(QChar(ushort(cp)));
}

void putShared(const char *key, char32_t cp)
{
    const QString name = QString::fromLatin1(key);
    const QString glyph = glyphOf(cp);
    g_glyphByName.insert(name, glyph);
    g_names.append(name);
    const ushort code = ushort(cp);
    if (!g_primaryNameByCode.contains(code))
        g_primaryNameByCode.insert(code, name);
}

void buildSharedCatalog_unlocked()
{
    if (g_ready)
        return;

    ThemeFonts::ensureLoaded();
    g_names.clear();
    g_glyphByName.clear();
    g_primaryNameByCode.clear();
    g_entries.clear();

    // Chrome / navigation
    putShared("ChromeClose", 0xE711);
    putShared("ChromeCloseAlt", 0xE8BB);
    putShared("ChromeMinimize", 0xE921);
    putShared("ChromeMaximize", 0xE922);
    putShared("ChromeRestore", 0xE923);
    putShared("Cancel", 0xE711);
    putShared("Clear", 0xE894);
    putShared("Back", 0xE72B);
    putShared("Forward", 0xE72A);
    putShared("ChevronDown", 0xE70D);
    putShared("ChevronUp", 0xE70E);
    putShared("ChevronLeft", 0xE76B);
    putShared("ChevronRight", 0xE76C);
    putShared("More", 0xE712);
    putShared("Home", 0xE80F);
    putShared("GlobalNavButton", 0xE700);

    // Actions
    putShared("Add", 0xE710);
    putShared("Remove", 0xE738);
    putShared("Delete", 0xE74D);
    putShared("Backspace", 0xE750);
    putShared("ReturnKey", 0xE751);
    putShared("Edit", 0xE70F);
    putShared("Save", 0xE74E);
    putShared("SaveAs", 0xE792);
    putShared("Copy", 0xE8C8);
    putShared("Cut", 0xE8C6);
    putShared("Paste", 0xE77F);
    putShared("Undo", 0xE7A7);
    putShared("Redo", 0xE7A6);
    putShared("Refresh", 0xE72C);
    putShared("Sync", 0xE895);
    putShared("Share", 0xE72D);
    putShared("Download", 0xE896);
    putShared("Upload", 0xE898);
    putShared("Print", 0xE749);
    putShared("OpenFile", 0xE8E5);
    putShared("OpenInNewWindow", 0xE8A7);
    putShared("Attach", 0xE723);
    putShared("Send", 0xE724);
    putShared("Pin", 0xE718);
    putShared("Unpin", 0xE77A);
    putShared("Filter", 0xE71C);
    putShared("Sort", 0xE8CB);
    putShared("Search", 0xE721);
    putShared("Zoom", 0xE71E);
    putShared("FullScreen", 0xE740);
    putShared("BackToWindow", 0xE73F);

    // Status
    putShared("Accept", 0xE73E);
    putShared("Checkmark", 0xE73E);
    putShared("Checkbox", 0xE73A);
    putShared("RadioButton", 0xECCA);
    putShared("Important", 0xE8C9);
    putShared("Info", 0xE946);
    putShared("Warning", 0xE7BA);
    putShared("Error", 0xE783);
    putShared("Favorite", 0xE734);
    putShared("FavoriteStarFill", 0xE735);
    putShared("Flag", 0xE7C1);
    putShared("SolidStar", 0xE735);
    putShared("OutlineStar", 0xE734);
    putShared("HalfStar", 0xE737);
    putShared("Presence", 0xE765);

    // People
    putShared("Contact", 0xE77B);
    putShared("People", 0xE716);
    putShared("Account", 0xE77B);
    putShared("OtherUser", 0xE8BD);

    // Objects / devices
    putShared("Settings", 0xE713);
    putShared("Calendar", 0xE787);
    putShared("Mail", 0xE715);
    putShared("Folder", 0xE8B7);
    putShared("FolderOpen", 0xE8F4);
    putShared("Document", 0xE8A5);
    putShared("Library", 0xE8F1);
    putShared("Tag", 0xE8EC);
    putShared("Link", 0xE71B);
    putShared("Globe", 0xE774);
    putShared("Map", 0xE707);
    putShared("Shop", 0xE719);
    putShared("Camera", 0xE722);
    putShared("Video", 0xE714);
    putShared("Microphone", 0xE720);
    putShared("Volume", 0xE767);
    putShared("Mute", 0xE74F);
    putShared("Brightness", 0xE706);
    putShared("Wifi", 0xE701);
    putShared("Bluetooth", 0xE702);
    putShared("VPN", 0xE705);
    putShared("Airplane", 0xE709);
    putShared("Tablet", 0xE70A);
    putShared("Mouse", 0xE962);
    putShared("Headphone", 0xE7F6);
    putShared("Lock", 0xE72E);
    putShared("Unlock", 0xE785);
    putShared("Permissions", 0xE8D7);
    putShared("HardDrive", 0xE7F4);
    putShared("Game", 0xE7C7);
    putShared("EaseOfAccess", 0xE8AB);
    putShared("DeveloperTools", 0xE945);
    putShared("Street", 0xE7C3);
    putShared("Cloud", 0xE753);
    putShared("CloudDownload", 0xEBD3);

    // View / input
    putShared("View", 0xE890);
    putShared("Hide", 0xED1A);
    putShared("List", 0xE8FD);
    putShared("GridView", 0xE80A);
    putShared("BulletedList", 0xE8FD);
    putShared("BulletedList2", 0xE8E9);
    putShared("GridViewSmall", 0xE8EA);
    putShared("PageList", 0xE8F0);
    putShared("ViewAll", 0xE8A9);
    putShared("Preview", 0xE8FF);
    putShared("Picture", 0xE8B9);
    putShared("Photo", 0xEB9F);
    putShared("ScrollMode", 0xE76F);
    putShared("Slider", 0xE9E9);
    putShared("Toggle", 0xE9CE);
    putShared("Comment", 0xE8A1);
    putShared("Lightbulb", 0xE75A);
    putShared("KnowledgeArticle", 0xE82F);

    // Charts
    putShared("AreaChart", 0xE9D2);
    putShared("PieSingle", 0xE9D9);
    putShared("DonutChart", 0xEB05);
    putShared("BarChartVertical", 0xE81E);
    putShared("AreaChartMirrored", 0xE9F9);
    putShared("Dial6", 0xE9E6);
    putShared("DialShape3", 0xF56C);
    putShared("ProgressRingCommon", 0xEA3A);

    // Media
    putShared("Play", 0xE768);
    putShared("Pause", 0xE769);
    putShared("Stop", 0xE71A);
    putShared("Previous", 0xE892);
    putShared("Next", 0xE893);

    // Editing
    putShared("Bold", 0xE8DD);
    putShared("Italic", 0xE8DB);
    putShared("Underline", 0xE8DC);
    putShared("Font", 0xE8D2);
    putShared("FontColor", 0xE8D3);
    putShared("AlignLeft", 0xE8E4);
    putShared("AlignCenter", 0xE8E3);
    putShared("AlignRight", 0xE8E2);

    // Misc
    putShared("Placeholder", 0xE8A7);
    putShared("Character", 0xE8C1);
    putShared("Emoji", 0xE899);
    putShared("Calculator", 0xE8EF);
    putShared("Clock", 0xE823);
    putShared("History", 0xE81C);
    putShared("Bookmarks", 0xE8A4);
    putShared("Puzzle", 0xEA86);
    putShared("Code", 0xE943);
    putShared("Admin", 0xE7EF);
    putShared("Leave", 0xF405);
    putShared("SignOut", 0xF3B1);
    putShared("Color", 0xE790);
    putShared("Repair", 0xE90F);
    putShared("ConstructionCone", 0xE909);
    putShared("UpdateRestore", 0xE777);
    putShared("Notification", 0xEA8F);
    putShared("QuietHours", 0xE708);
    putShared("Processing", 0xE7FC);
    putShared("Publish", 0xE74A);
    putShared("Ruler", 0xED5E);
    putShared("Trim", 0xE78A);

    // Common WinUI / search aliases (same glyphs as primary names above)
    putShared("Close", 0xE711);
    putShared("Menu", 0xE700);
    putShared("Hamburger", 0xE700);
    putShared("Find", 0xE721);
    putShared("OK", 0xE73E);
    putShared("Completed", 0xE73E);
    putShared("Alert", 0xE7BA);
    putShared("Star", 0xE734);
    putShared("StarFill", 0xE735);
    putShared("Trash", 0xE74D);
    putShared("Rename", 0xE70F);
    putShared("Open", 0xE8E5);
    putShared("NewWindow", 0xE8A7);
    putShared("MapPin", 0xE707);
    putShared("World", 0xE774);
    putShared("Image", 0xE8B9);
    putShared("PhotoLibrary", 0xEB9F);
    putShared("LeaveChat", 0xF405);
    putShared("Help", 0xE897);
    putShared("Question", 0xE897);
    putShared("Like", 0xE8E1);
    putShared("Dislike", 0xE8E0);
    putShared("Heart", 0xEB52);
    putShared("Phone", 0xE717);
    putShared("Call", 0xE717);
    putShared("Message", 0xE8F2);
    putShared("Reply", 0xE97A);
    putShared("Shield", 0xEA18);
    putShared("Power", 0xE7E8);
    putShared("Battery", 0xE850);
    putShared("SelectAll", 0xE8B3);
    putShared("ZoomIn", 0xE8A3);
    putShared("ZoomOut", 0xE71F);
    putShared("Bug", 0xEBE8);
    putShared("Key", 0xE192);
    putShared("Record", 0xE7C8);
    putShared("Show", 0xE890);
    putShared("ContactInfo", 0xE779);
    putShared("Dictionary", 0xE82D);
    putShared("ReadingList", 0xE7BC);
    putShared("DockLeft", 0xE90C);
    putShared("DockRight", 0xE90D);

    std::sort(g_names.begin(), g_names.end());

    QHash<ushort, QStringList> namesByCode;
    for (auto it = g_glyphByName.constBegin(); it != g_glyphByName.constEnd(); ++it) {
        if (it.value().isEmpty())
            continue;
        namesByCode[ushort(it.value().at(0).unicode())].append(it.key());
    }

    g_entries.reserve(kFluentIconCodepointCount);
    for (int i = 0; i < kFluentIconCodepointCount; ++i) {
        const ushort cp = kFluentIconCodepoints[i];
        QVariantMap row;
        const QString hex = QString::number(cp, 16).toUpper();
        const QString glyph = glyphOf(cp);
        const QString primary = g_primaryNameByCode.value(cp);
        QStringList allNames = namesByCode.value(cp);
        allNames.removeDuplicates();
        std::sort(allNames.begin(), allNames.end());
        QStringList aliases;
        for (const QString &n : allNames) {
            if (n != primary)
                aliases.append(n);
        }
        // Lightweight search tags (synonyms) for Iconography filter
        QStringList tags;
        if (!primary.isEmpty()) {
            tags.append(primary.toLower());
            for (const QString &a : aliases)
                tags.append(a.toLower());
        }
        row.insert(QStringLiteral("codeHex"), hex);
        row.insert(QStringLiteral("glyph"), glyph);
        row.insert(QStringLiteral("named"), !primary.isEmpty());
        row.insert(QStringLiteral("name"),
                   primary.isEmpty() ? (QStringLiteral("U+") + hex) : primary);
        row.insert(QStringLiteral("symbol"), primary);
        row.insert(QStringLiteral("aliases"), aliases);
        row.insert(QStringLiteral("tags"), tags);
        g_entries.append(row);
    }

    g_ready = true;
}

} // namespace

void FluentIcons::ensureCatalogData()
{
    QMutexLocker lock(&g_mutex);
    buildSharedCatalog_unlocked();
}

QStringList FluentIcons::catalogNames()
{
    ensureCatalogData();
    QMutexLocker lock(&g_mutex);
    return g_names;
}

QVariantList FluentIcons::catalogEntries()
{
    ensureCatalogData();
    QMutexLocker lock(&g_mutex);
    return g_entries;
}

FluentIcons::FluentIcons(QObject *parent)
    : QQmlPropertyMap(parent)
{
    ThemeFonts::ensureLoaded();
    populate();
}

FluentIcons *FluentIcons::create(QQmlEngine *, QJSEngine *)
{
    return new FluentIcons;
}

QString FluentIcons::of(const QString &name) const
{
    const QVariant v = value(name);
    if (v.isValid())
        return v.toString();
    return {};
}

bool FluentIcons::has(const QString &name) const
{
    return value(name).isValid();
}

QString FluentIcons::codeHex(const QString &name) const
{
    const QString g = of(name);
    if (g.isEmpty())
        return {};
    return QString::number(ushort(g.at(0).unicode()), 16).toUpper();
}

void FluentIcons::populate()
{
    ensureCatalogData();
    QMutexLocker lock(&g_mutex);
    for (auto it = g_glyphByName.constBegin(); it != g_glyphByName.constEnd(); ++it)
        insert(it.key(), it.value());
}
