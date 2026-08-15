import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Renders a shortcut chord (e.g. Ctrl+Shift+P) as a row of KeyVisuals.
// Parses "Ctrl+Shift+P", "Ctrl-K, Ctrl-S", or a keys[] list. No Qt Virtual Keyboard.
T.Control {
    id: root

    // Raw accelerator string: "Ctrl+Shift+P" or multi-stroke "Ctrl+K, Ctrl+S"
    property string shortcut: ""
    // Explicit key labels; when set, overrides shortcut parsing.
    property var keys: []
    property string size: "medium"
    property bool emphasized: false
    property string separator: "+"
    property real keySpacing: 4
    property string toolTipText: ""

    readonly property var _strokes: {
        if (keys && keys.length > 0)
            return [keys]
        return root._parseShortcut(shortcut)
    }
    readonly property string chordText: {
        if (keys && keys.length > 0)
            return keys.join(separator)
        return shortcut
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: toolTipText.length ? toolTipText
                   : (chordText.length ? chordText : qsTr("Keyboard shortcut"))
    ToolTip.visible: hover.hovered && toolTipText.length > 0
    ToolTip.text: toolTipText
    ToolTip.delay: 400

    HoverHandler {
        id: hover
        enabled: root.toolTipText.length > 0
    }

    function _parseShortcut(text) {
        if (!text || text.length === 0)
            return []
        var strokes = []
        var parts = String(text).split(",")
        for (var i = 0; i < parts.length; ++i) {
            var stroke = parts[i].trim()
            if (!stroke.length)
                continue
            var tokens = stroke.split(/[+\-]/)
            var labels = []
            for (var j = 0; j < tokens.length; ++j) {
                var t = tokens[j].trim()
                if (t.length)
                    labels.push(root._prettyKey(t))
            }
            if (labels.length)
                strokes.push(labels)
        }
        return strokes
    }

    function _prettyKey(token) {
        var map = {
            "control": "Ctrl",
            "ctrl": "Ctrl",
            "cmd": "Ctrl",
            "command": "Ctrl",
            "shift": "Shift",
            "alt": "Alt",
            "option": "Alt",
            "meta": "Win",
            "win": "Win",
            "windows": "Win",
            "super": "Win",
            "enter": "Enter",
            "return": "Enter",
            "escape": "Esc",
            "esc": "Esc",
            "space": "Space",
            "tab": "Tab",
            "backspace": "Backspace",
            "delete": "Del",
            "del": "Del",
            "insert": "Ins",
            "home": "Home",
            "end": "End",
            "pageup": "PgUp",
            "pagedown": "PgDn",
            "pgup": "PgUp",
            "pgdn": "PgDn",
            "up": "↑",
            "down": "↓",
            "left": "←",
            "right": "→",
            "arrowup": "↑",
            "arrowdown": "↓",
            "arrowleft": "←",
            "arrowright": "→"
        }
        var lower = String(token).toLowerCase()
        if (map[lower] !== undefined)
            return map[lower]
        if (token.length === 1)
            return token.toUpperCase()
        return token
    }

    function _minWidthFor(label) {
        var wide = ["Backspace", "Enter", "Shift", "Space", "Ctrl", "Alt"]
        if (wide.indexOf(label) >= 0)
            return size === "small" ? 36 : (size === "large" ? 56 : 48)
        return size === "small" ? 22 : (size === "large" ? 36 : 28)
    }

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    contentItem: Row {
        id: row
        spacing: root.keySpacing
        Repeater {
            model: root._strokes
            Row {
                id: strokeRow
                spacing: root.keySpacing
                required property var modelData
                required property int index

                // Gap between multi-stroke chords (Ctrl+K then Ctrl+S)
                Text {
                    visible: strokeRow.index > 0
                    text: ","
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 2
                    rightPadding: 2
                }

                Repeater {
                    model: strokeRow.modelData
                    Row {
                        id: keyRow
                        spacing: root.keySpacing
                        required property var modelData
                        required property int index

                        Text {
                            visible: keyRow.index > 0
                            text: root.separator
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        KeyVisual {
                            keyText: String(keyRow.modelData)
                            size: root.size
                            emphasized: root.emphasized
                            minWidth: root._minWidthFor(String(keyRow.modelData))
                        }
                    }
                }
            }
        }
    }
}
