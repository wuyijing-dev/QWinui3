import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CommandPalette — Ctrl+K style command launcher (fuzzy filter + keyboard).
//
//   CommandPalette {
//       id: palette
//       commands: [
//           { title: qsTr("Settings"), subtitle: qsTr("Open settings"),
//             shortcut: "Ctrl+,", symbol: FluentIcons.Settings, action: openSettings }
//       ]
//   }
//   palette.open()
//
//   // --- API ---
//   // commands: [{ title, subtitle?, shortcut?, symbol?, keywords?, action|onTriggered }]
//   // methods: open(), close(), toggle()
//   // signals: commandTriggered(var), closed()
//
// @notes
//   Place under Overlay.overlay (ShellWindow wires Ctrl+K / Meta+K when commandPaletteEnabled).
//   Keyboard: type to filter; ↑↓ move highlight; Enter runs; Esc closes.
//   Each row exposes Accessible.name from title (+ shortcut in description).
//   Large lists (2.16): filterDebounceMs + maxResults + _lastFilterKey skip.
//   Recent commands (2.59): maxRecentCommands + optional command id for recentKeyRole.
//   Accelerator discovery (2.41): filter matches shortcut string; commandCount / filteredCount.

Popup {
    id: root

    property var commands: []
    property string placeholderText: qsTr("Type a command")
    property int maxVisible: 8
    property real paletteWidth: Math.min(560, (parent ? parent.width : 560) - 48)
    // Debounce filter keystrokes (2.16 — large command lists).
    property int filterDebounceMs: 80
    // Cap filtered rows before ListView bind (2.16).
    property int maxResults: 64
    // Pin recently run commands when query is empty (2.59).
    property int maxRecentCommands: 5
    property string recentKeyRole: "id"

    readonly property int commandCount: (commands || []).length
    readonly property int filteredCount: _filtered.length

    signal commandTriggered(var command)
    // closed() inherited from Popup

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0
    width: paletteWidth
    height: column.implicitHeight
    x: parent ? Math.round((parent.width - width) / 2) : 0
    y: parent ? Math.round(parent.height * 0.18) : 80
    // Accessible chrome lives on contentItem (Dialog) — avoid duplicate Popup host names

    property var _filtered: []
    property int _highlight: 0
    property string _pendingQuery: ""
    property string _lastFilterKey: ""
    property var _recentKeys: []

    Timer {
        id: filterDebounce
        interval: root.filterDebounceMs
        onTriggered: root._rebuild(root._pendingQuery)
    }

    function open() {
        queryField.text = ""
        _lastFilterKey = ""
        _rebuild("")
        visible = true
        Qt.callLater(function () { queryField.forceActiveFocus() })
    }

    function toggle() {
        if (visible)
            close()
        else
            open()
    }

    function _scheduleRebuild(query) {
        root._pendingQuery = query || ""
        var q = root._pendingQuery.trim()
        if (!q.length) {
            filterDebounce.stop()
            root._rebuild("")
            return
        }
        filterDebounce.restart()
    }

    function _commandKey(cmd) {
        if (!cmd)
            return ""
        if (recentKeyRole && cmd[recentKeyRole] !== undefined)
            return String(cmd[recentKeyRole])
        return String(cmd.title || cmd.text || "")
    }

    function _rememberRecent(cmd) {
        var key = _commandKey(cmd)
        if (!key.length)
            return
        var next = _recentKeys.slice()
        var at = next.indexOf(key)
        if (at >= 0)
            next.splice(at, 1)
        next.unshift(key)
        if (maxRecentCommands > 0 && next.length > maxRecentCommands)
            next = next.slice(0, maxRecentCommands)
        _recentKeys = next
    }

    function _findCommand(key) {
        var src = commands || []
        for (var i = 0; i < src.length; ++i) {
            if (_commandKey(src[i]) === key)
                return src[i]
        }
        return null
    }

    function _matchesQuery(cmd, q) {
        if (!cmd)
            return false
        var title = String(cmd.title || cmd.text || "")
        var sub = String(cmd.subtitle || cmd.description || "")
        var keys = String(cmd.keywords || "")
        var chord = String(cmd.shortcut || "")
        return !q.length
                || title.toLowerCase().indexOf(q) >= 0
                || sub.toLowerCase().indexOf(q) >= 0
                || keys.toLowerCase().indexOf(q) >= 0
                || chord.toLowerCase().indexOf(q) >= 0
    }

    function _rebuild(query) {
        var q = (query || "").trim().toLowerCase()
        if (q === root._lastFilterKey)
            return
        root._lastFilterKey = q
        var src = commands || []
        var out = []
        var seen = {}

        function push(cmd) {
            if (!cmd)
                return
            var k = _commandKey(cmd)
            if (k.length && seen[k])
                return
            if (k.length)
                seen[k] = true
            if (root.maxResults > 0 && out.length >= root.maxResults)
                return
            out.push(cmd)
        }

        if (!q.length && maxRecentCommands > 0) {
            for (var r = 0; r < _recentKeys.length; ++r)
                push(_findCommand(_recentKeys[r]))
        }

        for (var i = 0; i < src.length; ++i) {
            if (root.maxResults > 0 && out.length >= root.maxResults)
                break
            var cmd = src[i]
            if (_matchesQuery(cmd, q))
                push(cmd)
        }

        if (q.length && maxRecentCommands > 0 && out.length > 1) {
            var recent = []
            var rest = []
            for (var j = 0; j < out.length; ++j) {
                var ck = _commandKey(out[j])
                if (_recentKeys.indexOf(ck) >= 0)
                    recent.push(out[j])
                else
                    rest.push(out[j])
            }
            out = recent.concat(rest)
        }

        root._filtered = out
        if (!out.length)
            root._highlight = -1
        else if (root._highlight < 0 || root._highlight >= out.length)
            root._highlight = 0
    }

    function _run(index) {
        if (index < 0 || index >= _filtered.length)
            return
        var cmd = _filtered[index]
        _rememberRecent(cmd)
        close()
        commandTriggered(cmd)
        if (typeof cmd.action === "function")
            cmd.action()
        else if (typeof cmd.onTriggered === "function")
            cmd.onTriggered()
    }

    function _move(delta) {
        if (!_filtered.length)
            return
        var next = _highlight < 0 ? 0 : _highlight + delta
        if (next < 0)
            next = _filtered.length - 1
        if (next >= _filtered.length)
            next = 0
        _highlight = next
        list.positionViewAtIndex(next, ListView.Contain)
    }

    background: ElevatedChrome {
        implicitWidth: root.width
        implicitHeight: root.height
        radius: Theme.cornerOverlay
    }

    contentItem: Item {
        id: chrome
        implicitWidth: column.implicitWidth
        implicitHeight: column.implicitHeight
        width: root.width
        height: column.implicitHeight
        Accessible.role: Accessible.Dialog
        Accessible.name: qsTr("Command palette")

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Theme.spacing
                spacing: Theme.spacing

                Label {
                    text: IconSource.resolve(FluentIcons.Search, "")
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: Theme.fontBody
                    color: Theme.textSecondary
                }

                TextField {
                    id: queryField
                    Layout.fillWidth: true
                    placeholderText: root.placeholderText
                    background: Item {}
                    Accessible.name: qsTr("Command search")
                    onTextChanged: root._scheduleRebuild(text)
                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Down) {
                            root._move(1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up) {
                            root._move(-1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root._run(root._highlight)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Escape) {
                            root.close()
                            event.accepted = true
                        }
                    }
                }

                KeyChordVisual {
                    visible: !queryField.text.length
                    shortcut: "Esc"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.strokeCard
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(root.maxVisible, Math.max(1, root._filtered.length))
                                       * Theme.navItemHeight
                clip: true
                model: root._filtered
                currentIndex: root._highlight
                boundsBehavior: Flickable.StopAtBounds
                Accessible.role: Accessible.List
                Accessible.name: qsTr("Commands")

                delegate: ItemDelegate {
                    id: del
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    height: Theme.navItemHeight
                    highlighted: index === root._highlight
                    onClicked: root._run(index)
                    onHoveredChanged: if (hovered) root._highlight = index
                    Accessible.role: Accessible.ListItem
                    Accessible.name: {
                        var t = del.modelData.title || del.modelData.text || ""
                        return t.length ? t : qsTr("Command")
                    }
                    Accessible.description: {
                        var parts = []
                        var sub = del.modelData.subtitle || del.modelData.description || ""
                        if (sub.length)
                            parts.push(sub)
                        if (del.modelData.shortcut)
                            parts.push(String(del.modelData.shortcut))
                        return parts.join(" · ")
                    }
                    Accessible.onPressAction: root._run(index)

                    contentItem: RowLayout {
                        spacing: Theme.spacing
                        Label {
                            visible: IconSource.resolve(del.modelData.symbol, del.modelData.iconGlyph || "").length > 0
                            text: IconSource.resolve(del.modelData.symbol, del.modelData.iconGlyph || "")
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: Theme.fontBody
                            color: Theme.textSecondary
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Label {
                                Layout.fillWidth: true
                                text: del.modelData.title || del.modelData.text || ""
                                elide: Text.ElideRight
                                color: Theme.textPrimary
                                font.weight: Theme.fontWeightSemiBold
                            }
                            Label {
                                visible: !!(del.modelData.subtitle || del.modelData.description)
                                Layout.fillWidth: true
                                text: del.modelData.subtitle || del.modelData.description || ""
                                elide: Text.ElideRight
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontCaption
                            }
                        }
                        KeyChordVisual {
                            visible: !!(del.modelData.shortcut)
                            shortcut: del.modelData.shortcut || ""
                        }
                    }
                }

                EmptyState {
                    anchors.centerIn: parent
                    visible: root._filtered.length === 0
                    title: qsTr("No commands")
                    description: qsTr("Try a different query.")
                    symbol: FluentIcons.Search
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.margins: Theme.spacing
                text: queryField.text.length
                      ? qsTr("%1 of %2 commands · ↑↓ navigate · Enter run · Esc close")
                            .arg(root.filteredCount).arg(root.commandCount)
                      : qsTr("↑↓ navigate · Enter run · Esc close")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.duration(Theme.motionFast) }
        NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: Theme.duration(Theme.motionFast) }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.duration(Theme.motionFast) }
    }
    scale: 1
    transformOrigin: Item.Center
}
