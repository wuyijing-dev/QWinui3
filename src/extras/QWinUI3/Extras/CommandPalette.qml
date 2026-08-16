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
//   Place under Overlay.overlay (ShellWindow wires Ctrl+K when commandPaletteEnabled).
//   Enter runs highlighted command; Esc closes; arrows move selection.

Popup {
    id: root

    property var commands: []
    property string placeholderText: qsTr("Type a command")
    property int maxVisible: 8
    property real paletteWidth: Math.min(560, (parent ? parent.width : 560) - 48)

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
    Accessible.role: Accessible.Dialog
    Accessible.name: qsTr("Command palette")

    property var _filtered: []
    property int _highlight: 0

    function open() {
        queryField.text = ""
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

    function _rebuild(query) {
        var q = (query || "").trim().toLowerCase()
        var src = commands || []
        var out = []
        for (var i = 0; i < src.length; ++i) {
            var cmd = src[i]
            if (!cmd)
                continue
            var title = String(cmd.title || cmd.text || "")
            var sub = String(cmd.subtitle || cmd.description || "")
            var keys = String(cmd.keywords || "")
            if (!q.length
                    || title.toLowerCase().indexOf(q) >= 0
                    || sub.toLowerCase().indexOf(q) >= 0
                    || keys.toLowerCase().indexOf(q) >= 0) {
                out.push(cmd)
            }
        }
        _filtered = out
        _highlight = out.length ? 0 : -1
    }

    function _run(index) {
        if (index < 0 || index >= _filtered.length)
            return
        var cmd = _filtered[index]
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

    contentItem: ColumnLayout {
        id: column
        width: root.width
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
                onTextChanged: root._rebuild(text)
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

            delegate: ItemDelegate {
                id: del
                required property var modelData
                required property int index
                width: ListView.view.width
                height: Theme.navItemHeight
                highlighted: index === root._highlight
                onClicked: root._run(index)
                onHoveredChanged: if (hovered) root._highlight = index

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
            text: qsTr("↑↓ navigate · Enter run · Esc close")
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
            horizontalAlignment: Text.AlignHCenter
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
