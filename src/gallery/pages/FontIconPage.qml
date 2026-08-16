import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Iconography (FluentIcons catalog, WinUI Gallery layout).

CatalogPage {
    id: page
    title: qsTr("Iconography")
    subtitle: qsTr("Segoe Fluent Icons exposed as FluentIcons.* — prefer named symbols over raw \\uE… escapes.")

    property string selectedName: ""

    readonly property var allNames: FluentIcons.names()
    readonly property var filteredNames: {
        var q = filterBox.text.trim().toLowerCase()
        var src = allNames
        if (!q.length)
            return src
        var out = []
        for (var i = 0; i < src.length; ++i) {
            var n = String(src[i])
            var hex = page.codeHex(n).toLowerCase()
            if (n.toLowerCase().indexOf(q) >= 0 || hex.indexOf(q) >= 0 || ("e" + hex).indexOf(q) >= 0)
                out.push(n)
        }
        return out
    }

    readonly property string selectedGlyph: selectedName.length ? FluentIcons.of(selectedName) : ""
    readonly property string selectedHex: selectedName.length ? codeHex(selectedName) : ""
    readonly property string selectedTextGlyph: selectedHex.length ? ("&#x" + selectedHex + ";") : ""
    readonly property string selectedCodeGlyph: selectedHex.length ? ("\\u" + selectedHex) : ""
    readonly property string selectedQml: selectedName.length
            ? ("FontIcon {\n    symbol: FluentIcons." + selectedName + "\n}")
            : ""
    readonly property string selectedSymbolRef: selectedName.length ? ("FluentIcons." + selectedName) : ""

    function codeHex(name) {
        var g = FluentIcons.of(name)
        if (!g || !g.length)
            return ""
        var cp = g.charCodeAt(0)
        return Number(cp).toString(16).toUpperCase()
    }

    function ensureSelection() {
        var list = filteredNames
        if (!list.length) {
            selectedName = ""
            return
        }
        if (selectedName.length) {
            for (var i = 0; i < list.length; ++i) {
                if (list[i] === selectedName)
                    return
            }
        }
        selectedName = list[0]
    }

    Component.onCompleted: ensureSelection()
    onFilteredNamesChanged: ensureSelection()

    // Full-viewport iconography host (grid + inspector), WinUI Gallery style.
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
                placeholderText: qsTr("Search icons by name or code")
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.spacingLoose

                // --- Icon grid ---
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
                        model: page.filteredNames
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                        delegate: Item {
                            id: cell
                            required property string modelData
                            required property int index
                            width: grid.cellWidth
                            height: grid.cellHeight

                            readonly property bool selected: page.selectedName === modelData

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
                                    FontIcon {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        symbol: cell.modelData
                                        fontSize: 28
                                        iconColor: Theme.textPrimary
                                    }
                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: tile.width - 12
                                        horizontalAlignment: Text.AlignHCenter
                                        text: cell.modelData
                                        elide: Text.ElideRight
                                        color: Theme.textSecondary
                                        font.pixelSize: Theme.fontCaption
                                    }
                                }

                                HoverHandler { id: hover }
                                TapHandler {
                                    onTapped: page.selectedName = cell.modelData
                                }
                                Accessible.role: Accessible.Button
                                Accessible.name: cell.modelData
                                Accessible.checkable: true
                                Accessible.checked: cell.selected
                            }
                        }
                    }

                    EmptyState {
                        anchors.centerIn: parent
                        visible: page.filteredNames.length === 0
                        title: qsTr("No icons found")
                        description: qsTr("Try another name or codepoint.")
                        symbol: FluentIcons.Search
                        bordered: false
                    }
                }

                // --- Details inspector ---
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
                                FontIcon {
                                    anchors.centerIn: parent
                                    symbol: page.selectedName
                                    fontSize: 56
                                    iconColor: Theme.textPrimary
                                    visible: page.selectedName.length > 0
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
                                visible: page.selectedName.length > 0

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
                                    label: qsTr("Symbol")
                                    value: page.selectedSymbolRef
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
                                    copyValue: page.selectedQml
                                }

                                Label {
                                    Layout.fillWidth: true
                                    text: qsTr("%1 icons · filter shows %2")
                                          .arg(page.allNames.length)
                                          .arg(page.filteredNames.length)
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontCaption
                                }
                            }

                            EmptyState {
                                Layout.fillWidth: true
                                Layout.margins: Theme.spacingLoose
                                visible: page.selectedName.length === 0
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
