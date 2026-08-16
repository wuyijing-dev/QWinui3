#include "FluentIcons.h"
#include "ThemeFonts.h"

#include <QChar>
#include <algorithm>

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
    // case-insensitive / PascalCase fallback handled in IconSource.qml
    return {};
}

bool FluentIcons::has(const QString &name) const
{
    return value(name).isValid();
}

QStringList FluentIcons::names() const
{
    return m_names;
}

static QString g(char32_t cp)
{
    return QString(QChar(ushort(cp)));
}

void FluentIcons::populate()
{
    auto put = [this](const char *key, char32_t cp) {
        const QString name = QString::fromLatin1(key);
        insert(name, g(cp));
        m_names.append(name);
    };

    // Chrome / navigation (incl. AppWindowTitleBar caption glyphs)
    put("ChromeClose", 0xE711);
    put("ChromeCloseAlt", 0xE8BB); // caption close plate
    put("ChromeMinimize", 0xE921);
    put("ChromeMaximize", 0xE922);
    put("ChromeRestore", 0xE923);
    put("Cancel", 0xE711);
    put("Clear", 0xE894);
    put("Back", 0xE72B);
    put("Forward", 0xE72A);
    put("ChevronDown", 0xE70D);
    put("ChevronUp", 0xE70E);
    put("ChevronLeft", 0xE76B);
    put("ChevronRight", 0xE76C);
    put("More", 0xE712);
    put("Home", 0xE80F);
    put("GlobalNavButton", 0xE700);

    // Actions
    put("Add", 0xE710);
    put("Remove", 0xE738);
    put("Delete", 0xE74D);
    put("Edit", 0xE70F);
    put("Save", 0xE74E);
    put("SaveAs", 0xE792);
    put("Copy", 0xE8C8);
    put("Cut", 0xE8C6);
    put("Paste", 0xE77F);
    put("Undo", 0xE7A7);
    put("Redo", 0xE7A6);
    put("Refresh", 0xE72C);
    put("Sync", 0xE895);
    put("Share", 0xE72D);
    put("Download", 0xE896);
    put("Upload", 0xE898);
    put("Print", 0xE749);
    put("OpenFile", 0xE8E5);
    put("OpenInNewWindow", 0xE8A7);
    put("Attach", 0xE723);
    put("Send", 0xE724);
    put("Pin", 0xE718);
    put("Unpin", 0xE77A);
    put("Filter", 0xE71C);
    put("Sort", 0xE8CB);
    put("Search", 0xE721);
    put("Zoom", 0xE71E);
    put("FullScreen", 0xE740);
    put("BackToWindow", 0xE73F);

    // Status
    put("Accept", 0xE73E);
    put("Checkmark", 0xE73E);
    put("Checkbox", 0xE73A);
    put("RadioButton", 0xECCA);
    put("Important", 0xE8C9);
    put("Info", 0xE946);
    put("Warning", 0xE7BA);
    put("Error", 0xE783);
    put("Favorite", 0xE734);
    put("FavoriteStarFill", 0xE735);
    put("Flag", 0xE7C1);
    put("SolidStar", 0xE735);
    put("OutlineStar", 0xE734);
    put("HalfStar", 0xE737);
    put("Presence", 0xE765);

    // People
    put("Contact", 0xE77B);
    put("People", 0xE716);
    put("Account", 0xE77B);
    put("OtherUser", 0xE8BD);

    // Objects
    put("Settings", 0xE713);
    put("Calendar", 0xE787);
    put("Mail", 0xE715);
    put("Folder", 0xE8B7);
    put("FolderOpen", 0xE8F4);
    put("Document", 0xE8A5);
    put("Library", 0xE8F1);
    put("Tag", 0xE8EC);
    put("Link", 0xE71B);
    put("Globe", 0xE774);
    put("Map", 0xE707);
    put("Shop", 0xE719);
    put("Camera", 0xE722);
    put("Video", 0xE714);
    put("Microphone", 0xE720);
    put("Volume", 0xE767);
    put("Mute", 0xE74F);
    put("Brightness", 0xE706);
    put("Wifi", 0xE701);
    put("Lock", 0xE72E);
    put("Unlock", 0xE785);
    put("Permissions", 0xE8D7);
    put("HardDrive", 0xE7F4);
    put("Game", 0xE7C7);
    put("EaseOfAccess", 0xE8AB);
    put("DeveloperTools", 0xE945);
    put("Street", 0xE7C3);

    // View / input chrome
    put("View", 0xE890);
    put("Hide", 0xED1A);
    put("List", 0xE8FD);
    put("GridView", 0xE80A);
    put("BulletedList", 0xE8FD);
    put("BulletedList2", 0xE8E9);
    put("GridViewSmall", 0xE8EA);
    put("PageList", 0xE8F0);
    put("ViewAll", 0xE8A9);
    put("Preview", 0xE8FF);
    put("Picture", 0xE8B9);
    put("Photo", 0xEB9F);
    put("ScrollMode", 0xE76F);
    put("Slider", 0xE9E9);
    put("Toggle", 0xE9CE);
    put("Comment", 0xE8A1);
    put("Lightbulb", 0xE75A);
    put("KnowledgeArticle", 0xE82F);

    // Charts
    put("AreaChart", 0xE9D2);
    put("PieSingle", 0xE9D9);
    put("DonutChart", 0xEB05);
    put("BarChartVertical", 0xE81E);
    put("AreaChartMirrored", 0xE9F9);
    put("Dial6", 0xE9E6);
    put("DialShape3", 0xF56C);
    put("ProgressRingCommon", 0xEA3A);

    // Media
    put("Play", 0xE768);
    put("Pause", 0xE769);
    put("Stop", 0xE71A);
    put("Previous", 0xE892);
    put("Next", 0xE893);

    // Editing
    put("Bold", 0xE8DD);
    put("Italic", 0xE8DB);
    put("Underline", 0xE8DC);
    put("Font", 0xE8D2);
    put("FontColor", 0xE8D3);
    put("AlignLeft", 0xE8E4);
    put("AlignCenter", 0xE8E3);
    put("AlignRight", 0xE8E2);

    // Misc
    put("Placeholder", 0xE8A7);
    put("Character", 0xE8C1);
    put("Emoji", 0xE899);
    put("Calculator", 0xE8EF);
    put("Clock", 0xE823);
    put("History", 0xE81C);
    put("Bookmarks", 0xE8A4);
    put("Puzzle", 0xEA86);
    put("Code", 0xE943);
    put("Admin", 0xE7EF);
    put("Leave", 0xF405);
    put("SignOut", 0xF3B1);
    put("Color", 0xE790);
    put("Repair", 0xE90F);
    put("ConstructionCone", 0xE909);
    put("UpdateRestore", 0xE777);
    put("Notification", 0xEA8F);
    put("QuietHours", 0xE708);
    put("Processing", 0xE7FC);
    put("Publish", 0xE74A);
    put("Ruler", 0xED5E);
    put("Trim", 0xE78A);

    std::sort(m_names.begin(), m_names.end());
}
