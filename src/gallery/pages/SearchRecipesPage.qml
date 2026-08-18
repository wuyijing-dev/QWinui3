import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — In-app search & AutoSuggest recipes (1.59 · 2.16).
// Recipe: docs/search.md · docs/commands.md · docs/data-collections.md

CatalogPage {
    id: page
    title: qsTr("Search recipes")
    subtitle: qsTr("AutoSuggest keyboard polish · debounced filter — docs/search.md (2.16).")

    signal openControl(var item)

    property string listFilter: ""
    property string statusText: qsTr("Pick a recipe below — CommandPalette stays for Ctrl+K commands.")

    readonly property var samplePeople: [
        { title: qsTr("Alex Rivera"), subtitle: qsTr("Design") },
        { title: qsTr("Blake Chen"), subtitle: qsTr("Engineering") },
        { title: qsTr("Casey Nguyen"), subtitle: qsTr("Product") },
        { title: qsTr("Dana Okonkwo"), subtitle: qsTr("Support") },
        { title: qsTr("Ellis Park"), subtitle: qsTr("Engineering") },
        { title: qsTr("Fran Rossi"), subtitle: qsTr("Design") }
    ]

    readonly property var filteredPeople: {
        var q = (page.listFilter || "").trim().toLowerCase()
        var src = page.samplePeople
        if (!q.length)
            return src
        var out = []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            var t = String(row.title).toLowerCase()
            var s = String(row.subtitle).toLowerCase()
            if (t.indexOf(q) >= 0 || s.indexOf(q) >= 0)
                out.push(row)
        }
        return out
    }

    readonly property var catalogSuggestModel: {
        GalleryLanguage.currentLocale
        var out = []
        var src = ControlCatalog.controls
        var limit = 40
        for (var i = 0; i < src.length && out.length < limit; ++i) {
            var c = src[i]
            out.push({
                title: c.title,
                component: c.component,
                category: c.category,
                description: c.description
            })
        }
        return out
    }

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    function openCatalogHit(item) {
        if (!item)
            return
        var comp = typeof item === "object" ? item.component : ""
        if (!comp.length)
            return
        var hit = ControlCatalog.findByComponent(comp)
        if (hit)
            page.openControl(hit)
        page.statusText = qsTr("Opened: %1").arg(typeof item === "object" ? item.title : String(item))
    }

    ControlExample {
        headerText: qsTr("When to use (1.59)")
        qmlSource: "AutoSuggestBox · SearchBox · filter-above\nCommandPalette · docs/search.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("AutoSuggestBox / SearchBox for typed suggestions. Filter-above for narrowing a visible list. Gallery title-bar search jumps the catalog. CommandPalette (Ctrl+K) is for commands — not document search. Full cookbook: docs/search.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: page.statusText
                color: Theme.textPrimary
            }
            Repeater {
                model: [
                    { label: qsTr("AutoSuggestBox"), page: "AutoSuggestBoxPage" },
                    { label: qsTr("SearchBox"), page: "SearchBoxPage" },
                    { label: qsTr("ItemsView (filter-above)"), page: "ItemsViewPage" },
                    { label: qsTr("CommandPalette"), page: "CommandPalettePage" },
                    { label: qsTr("Commands hub"), page: "CommandsHubPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("AutoSuggest → open catalog page")
        qmlSource: "AutoSuggestBox {\n    model: catalogRows\n    textMemberPath: \"title\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 420
            spacing: Theme.spacing
            AutoSuggestBox {
                Layout.fillWidth: true
                header: qsTr("Jump to control")
                description: qsTr("Type a title (subset of ControlCatalog). Choose a suggestion to navigate.")
                placeholderText: qsTr("Button, NavigationView…")
                symbol: FluentIcons.Search
                textMemberPath: "title"
                updateTextOnSelect: true
                chooseSuggestionOnEnter: true
                maxSuggestionListHeight: 200
                model: page.catalogSuggestModel
                onSuggestionChosen: function (item) {
                    page.openCatalogHit(item)
                }
                onQuerySubmitted: function (query) {
                    var hits = ControlCatalog.search(query)
                    if (hits.length)
                        page.openCatalogHit(hits[0])
                    else
                        page.statusText = qsTr("No catalog hit for “%1”").arg(query)
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Filter-above list")
        qmlSource: "TextField { onTextChanged: filterQuery = text }\nItemsView { model: filteredModel }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextField {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                placeholderText: qsTr("Filter people by name or team…")
                text: page.listFilter
                onTextChanged: page.listFilter = text
            }
            ItemsView {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                model: page.filteredPeople
                titleRole: "title"
                subtitleRole: "subtitle"
                emptyMessage: qsTr("No matches — clear the filter.")
                emptyActionText: qsTr("Clear filter")
                onEmptyActionClicked: page.listFilter = ""
                onItemActivated: function (index, itemData) {
                    if (itemData)
                        page.statusText = qsTr("Selected: %1 (%2)")
                            .arg(itemData.title).arg(itemData.subtitle)
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textTertiary
                text: qsTr("Showing %1 of %2").arg(page.filteredPeople.length).arg(page.samplePeople.length)
            }
        }
    }

    ControlExample {
        headerText: qsTr("Checklist")
        qmlSource: "docs/search.md · docs/commands.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("Commands → CommandPalette (Ctrl+K), not AutoSuggest") }
            CheckBox { text: qsTr("Form suggest → AutoSuggestBox / SearchBox") }
            CheckBox { text: qsTr("↑↓ in field moves highlight — focus stays in field (2.16)") }
            CheckBox { text: qsTr("Esc closes popup only; ↑ at row 0 returns to field (2.16)") }
            CheckBox { text: qsTr("List/table → filter-above + filtered model") }
            CheckBox { text: qsTr("Cap huge catalog results (Gallery uses 24 in title bar)") }
            CheckBox { text: qsTr("Empty state when filter matches nothing") }
        }
    }
}
