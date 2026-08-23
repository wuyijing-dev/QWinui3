import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// RichEdit — Fluent rich-text editor for mail / template / long notes (2.61).
//
//   RichEdit {
//       id: body
//       placeholderText: qsTr("Write your message…")
//       onLinkActivated: (url) => Qt.openUrlExternally(url)
//   }
//   body.toggleBold()
//   body.insertLink("https://example.com")
//
// @notes
//   Experimental — basic HTML formatting (bold/italic/lists/links), paste sanitization,
//   IME-friendly TextEdit (FL-005). Not a Word-compatible engine. See docs/rich-edit-261.md.
//   The editor pane is a fixed viewport (ScrollView); it does not grow with contentHeight.

T.Control {
    id: root

    property alias text: editor.text
    property string plainText: ""
    property string placeholderText: qsTr("Write here…")
    property bool readOnly: false
    property bool showToolbar: true
    property bool sanitizePaste: true
    property string header: ""
    property string description: ""
    property string accessibleName: ""

    signal textEdited()
    signal linkActivated(string url)
    signal formattingChanged()

    implicitWidth: 320
    implicitHeight: 220
    clip: true

    Component.onCompleted: root._refreshPlainText()

    Accessible.role: Accessible.EditableText
    Accessible.multiLine: true
    Accessible.readOnly: root.readOnly
    Accessible.name: {
        if (root.accessibleName.length)
            return root.accessibleName
        if (root.header.length)
            return root.header
        if (root.placeholderText.length)
            return root.placeholderText
        return qsTr("Rich text editor")
    }
    Accessible.description: root.description

    function focusEditor() {
        editor.forceActiveFocus()
    }

    function clear() {
        editor.text = ""
        editor.cursorPosition = 0
        root.plainText = ""
    }

    function wrapSelection(openTag, closeTag) {
        var start = editor.selectionStart
        var end = editor.selectionEnd
        if (start > end) {
            var swap = start
            start = end
            end = swap
        }
        var t = editor.text
        if (start === end) {
            editor.insert(start, openTag + closeTag)
            editor.select(start + openTag.length, start + openTag.length)
        } else {
            var before = t.substring(0, start)
            var mid = t.substring(start, end)
            var after = t.substring(end)
            editor.text = before + openTag + mid + closeTag + after
            editor.select(start + openTag.length, start + openTag.length + mid.length)
        }
        root.formattingChanged()
    }

    function toggleBold() {
        wrapSelection("<b>", "</b>")
    }

    function toggleItalic() {
        wrapSelection("<i>", "</i>")
    }

    function insertUnorderedList() {
        wrapSelection("<ul><li>", "</li></ul>")
    }

    function insertLink(url) {
        var href = url && url.length ? url : "https://"
        wrapSelection('<a href="' + href + '">', "</a>")
    }

    function _sanitizeHtml(html) {
        if (!html || !html.length)
            return html
        var s = String(html)
        s = s.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, "")
        s = s.replace(/<iframe\b[^>]*>[\s\S]*?<\/iframe>/gi, "")
        s = s.replace(/\s(on\w+|style)\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)/gi, "")
        s = s.replace(/javascript\s*:/gi, "")
        return s
    }

    function _refreshPlainText() {
        var t = editor.getText(0, editor.length)
        root.plainText = String(t || "").replace(/\s+/g, " ").trim()
    }

    function _runSanitize() {
        if (!root.sanitizePaste)
            return
        var clean = root._sanitizeHtml(editor.text)
        if (clean === editor.text)
            return
        var pos = editor.cursorPosition
        editor.text = clean
        editor.cursorPosition = Math.min(pos, clean.length)
    }

    contentItem: ColumnLayout {
        spacing: 0
        width: root.availableWidth
        height: root.availableHeight

        RowLayout {
            id: toolbarRow
            Layout.fillWidth: true
            visible: root.showToolbar && !root.readOnly
            spacing: 2
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.topMargin: 4

            Button {
                text: "B"
                flat: true
                implicitWidth: Theme.controlHeight
                implicitHeight: Theme.controlHeight
                font.bold: true
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Bold")
                onClicked: root.toggleBold()
            }
            Button {
                text: "I"
                flat: true
                implicitWidth: Theme.controlHeight
                implicitHeight: Theme.controlHeight
                font.italic: true
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Italic")
                onClicked: root.toggleItalic()
            }
            Button {
                text: "\u2022"
                flat: true
                implicitWidth: Theme.controlHeight
                implicitHeight: Theme.controlHeight
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Bullet list")
                onClicked: root.insertUnorderedList()
            }
            IconButton {
                symbol: FluentIcons.Link
                toolTipText: qsTr("Insert link")
                onClicked: root.insertLink("")
            }
            Item { Layout.fillWidth: true }
        }

        Rectangle {
            id: editorPane
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 120
            implicitHeight: 160
            radius: Theme.cornerControl
            color: {
                if (!root.enabled)
                    return Theme.fillControlDisabled
                if (editor.hovered)
                    return Theme.fillControlSecondary
                return Theme.bgControlRest
            }
            border.width: 1
            border.color: Theme.strokeControl
            clip: true

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                id: underline
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: editor.activeFocus ? 2 : 1
                color: editor.activeFocus ? Theme.accent : Theme.strokeControl
                opacity: editor.activeFocus ? 1 : 0.85
            }

            FocusStroke {
                anchors.fill: parent
                show: editor.activeFocus && (editor.focusReason === Qt.TabFocusReason
                                             || editor.focusReason === Qt.BacktabFocusReason)
            }

            ScrollView {
                anchors.fill: parent
                anchors.margins: 1
                clip: true
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                TextEdit {
                    id: editor
                    width: Math.max(0, editorPane.width - Theme.paddingControlH * 2)
                    padding: Theme.paddingControlH
                    selectByMouse: true
                    readOnly: root.readOnly
                    wrapMode: TextEdit.Wrap
                    textFormat: TextEdit.RichText
                    color: root.enabled ? Theme.textPrimary : Theme.textDisabled
                    selectionColor: Theme.accent
                    selectedTextColor: Theme.textOnAccent
                    font.pixelSize: Theme.fontBody

                    onLinkActivated: function (link) {
                        root.linkActivated(link)
                    }
                    onTextChanged: {
                        if (editor.preeditText.length)
                            return
                        plainTimer.restart()
                        if (root.sanitizePaste)
                            sanitizeTimer.restart()
                        root.textEdited()
                    }
                }
            }

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.paddingControlH + 4
                text: root.placeholderText
                visible: !editor.text.length && !editor.activeFocus
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
                wrapMode: Text.WordWrap
            }
        }
    }

    Timer {
        id: sanitizeTimer
        interval: 180
        onTriggered: root._runSanitize()
    }
    Timer {
        id: plainTimer
        interval: 80
        onTriggered: root._refreshPlainText()
    }
}
