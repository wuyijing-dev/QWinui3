import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Iconography (full WinSymbols / FluentIcons catalog).

CatalogPage {
    id: page
    title: qsTr("Iconography")
    subtitle: qsTr("All glyphs from the icon font. Prefer FluentIcons.Name in components — not raw \\uE… escapes.")

    property int selectedIndex: 0

    readonly property var allEntries: FluentIconsCatalog.entries
    readonly property var filteredEntries: {
        var q = filterBox.text.trim().toLowerCase()
        var src = allEntries
        if (!src || !src.length)
            return []
        if (!q.length)
            return src
        var out = []
        for (var i = 0; i < src.length; ++i) {
            var e = src[i]
            var name = String(e.name).toLowerCase()
            var hex = String(e.codeHex).toLowerCase()
            var sym = String(e.symbol || "").toLowerCase()
            if (name.indexOf(q) >= 0 || hex.indexOf(q) >= 0 || sym.indexOf(q) >= 0
                    || ("u+" + hex).indexOf(q) >= 0 || ("\\u" + hex).indexOf(q) >= 0) {
                out.push(e)
                continue
            }
            var aliases = e.aliases || []
            var hit = false
            for (var a = 0; a < aliases.length; ++a) {
                if (String(aliases[a]).toLowerCase().indexOf(q) >= 0) {
                    hit = true
                    break
                }
            }
            if (!hit) {
                var tags = e.tags || []
                for (var t = 0; t < tags.length; ++t) {
                    if (String(tags[t]).indexOf(q) >= 0) {
                        hit = true
                        break
                    }
                }
            }
            if (hit)
                out.push(e)
        }
        return out
    }

    readonly property var selectedEntry: {
        var list = filteredEntries
        if (!list || !list.length || selectedIndex < 0 || selectedIndex >= list.length)
            return null
        return list[selectedIndex]
    }

    readonly property string selectedName: selectedEntry ? String(selectedEntry.name) : ""
    readonly property string selectedSymbol: (selectedEntry && selectedEntry.symbol)
                                            ? String(selectedEntry.symbol) : ""
    readonly property string selectedHex: selectedEntry ? String(selectedEntry.codeHex) : ""
    readonly property string selectedGlyph: selectedEntry ? String(selectedEntry.glyph) : ""
    readonly property bool selectedNamed: selectedEntry ? !!selectedEntry.named : false
    readonly property string selectedTextGlyph: selectedHex.length ? ("&#x" + selectedHex + ";") : ""
    readonly property string selectedCodeGlyph: selectedHex.length ? ("\\u" + selectedHex) : ""
    readonly property string selectedQml: {
        if (!selectedEntry)
            return ""
        if (selectedNamed && selectedSymbol.length)
            return "FontIcon {\n    symbol: FluentIcons." + selectedSymbol + "\n}"
        return "FontIcon {\n    glyph: \"\\u" + selectedHex + "\"\n}"
    }
    readonly property string selectedSymbolRef: {
        if (selectedNamed && selectedSymbol.length)
            return "FluentIcons." + selectedSymbol
        return selectedCodeGlyph
    }

    function ensureSelection() {
        var list = filteredEntries
        if (!list || !list.length) {
            selectedIndex = -1
            return
        }
        if (selectedIndex < 0 || selectedIndex >= list.length)
            selectedIndex = 0
    }

    Component.onCompleted: ensureSelection()
    onFilteredEntriesChanged: ensureSelection()

    Item {
        id: host
        Layout.fillWidth: true
        implicitHeight: Math.max(520, page.height - 132)
        height: implicitHeight

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacing

            SearchBox {
                id: filterBox
                Layout.fillWidth: true
                placeholderText: qsTr("Search icons by name, code, or tags")
            }

            Label {
                text: qsTr("%1 icons · showing %2 · %3 named FluentIcons")
                      .arg(FluentIconsCatalog.entryCount)
                      .arg(page.filteredEntries ? page.filteredEntries.length : 0)
                      .arg(FluentIconsCatalog.namedCount)
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.spacingLoose

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Theme.cornerCard
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    clip: true

                    GridView {
                        id: grid
                        anchors.fill: parent
                        anchors.margins: 8
                        clip: true
                        cellWidth: 104
                        cellHeight: 104
                        model: page.filteredEntries
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                        currentIndex: page.selectedIndex

                        delegate: Item {
                            id: cell
                            required property var modelData
                            required property int index
                            width: grid.cellWidth
                            height: grid.cellHeight

                            readonly property bool selected: page.selectedIndex === index

                            Rectangle {
                                id: tile
                                anchors.fill: parent
                                anchors.margins: 4
                                radius: Theme.cornerControl
                                color: {
                                    if (cell.selected)
                                        return Theme.fillSubtleSecondary
                                    if (hover.hovered)
                                        return Theme.fillSubtle
                                    return "transparent"
                                }
                                border.width: cell.selected ? 2 : 1
                                border.color: cell.selected ? Theme.accent
                                                            : (hover.hovered ? Theme.strokeControl : "transparent")

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: cell.modelData.glyph
                                        font.family: Theme.fontFamilyIcon
                                        font.pixelSize: 28
                                        color: Theme.textPrimary
                                    }
                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: tile.width - 12
                                        horizontalAlignment: Text.AlignHCenter
                                        text: cell.modelData.name
                                        elide: Text.ElideRight
                                        color: cell.modelData.named ? Theme.textSecondary : Theme.textDisabled
                                        font.pixelSize: Theme.fontCaption
                                    }
                                }

                                HoverHandler { id: hover }
                                TapHandler {
                                    onTapped: page.selectedIndex = cell.index
                                }
                            }
                        }
                    }

                    EmptyState {
                        anchors.centerIn: parent
                        visible: !page.filteredEntries || page.filteredEntries.length === 0
                        title: qsTr("No icons found")
                        description: qsTr("Try another name or codepoint.")
                        symbol: FluentIcons.Search
                        bordered: false
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    radius: Theme.cornerCard
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    clip: true

                    ScrollView {
                        anchors.fill: parent
                        contentWidth: availableWidth
                        clip: true
                        background: null

                        ColumnLayout {
                            width: 300 - 2
                            spacing: 0

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                Text {
                                    anchors.centerIn: parent
                                    visible: page.selectedGlyph.length > 0
                                    text: page.selectedGlyph
                                    font.family: Theme.fontFamilyIcon
                                    font.pixelSize: 56
                                    color: Theme.textPrimary
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1
                                color: Theme.strokeCard
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.margins: Theme.spacingLoose
                                spacing: Theme.spacingLoose
                                visible: page.selectedEntry !== null

                                component DetailRow: RowLayout {
                                    property string label: ""
                                    property string value: ""
                                    property string copyValue: value
                                    Layout.fillWidth: true
                                    spacing: Theme.spacing

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Label {
                                            text: label
                                            color: Theme.textSecondary
                                            font.pixelSize: Theme.fontCaption
                                        }
                                        Label {
                                            Layout.fillWidth: true
                                            text: value
                                            color: Theme.textPrimary
                                            wrapMode: Text.WrapAnywhere
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontBody
                                        }
                                    }
                                    CopyButton {
                                        iconOnly: true
                                        textToCopy: copyValue
                                        enabled: copyValue.length > 0
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }

                                DetailRow {
                                    label: qsTr("Icon name")
                                    value: page.selectedName
                                }
                                DetailRow {
                                    label: qsTr("Aliases")
                                    value: {
                                        var a = page.selectedEntry && page.selectedEntry.aliases
                                        if (!a || !a.length)
                                            return qsTr("(none)")
                                        return a.join(", ")
                                    }
                                    visible: page.selectedNamed
                                             && page.selectedEntry
                                             && page.selectedEntry.aliases
                                             && page.selectedEntry.aliases.length > 0
                                }
                                DetailRow {
                                    label: qsTr("Symbol")
                                    value: page.selectedSymbolRef
                                    visible: page.selectedNamed
                                }
                                DetailRow {
                                    label: qsTr("Text glyph")
                                    value: page.selectedTextGlyph
                                }
                                DetailRow {
                                    label: qsTr("Code glyph")
                                    value: page.selectedCodeGlyph
                                }
                                DetailRow {
                                    label: qsTr("FontIcon QML")
                                    value: page.selectedQml
                                }

                                Label {
                                    Layout.fillWidth: true
                                    visible: !page.selectedNamed
                                    wrapMode: Text.Wrap
                                    text: qsTr("Unnamed glyph — add a FluentIcons put() if components should reference it by name.")
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontCaption
                                }
                            }

                            EmptyState {
                                Layout.fillWidth: true
                                Layout.margins: Theme.spacingLoose
                                visible: page.selectedEntry === null
                                title: qsTr("Select an icon")
                                description: qsTr("Details and copy snippets appear here.")
                                symbol: FluentIcons.View
                                bordered: false
                            }
                        }
                    }
                }
            }
        }
    }
}
