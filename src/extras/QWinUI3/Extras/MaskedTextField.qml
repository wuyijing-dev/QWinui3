import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// MaskedTextField — Simple input mask for phone / ID-style patterns (2.71).
//
//   MaskedTextField {
//       mask: "(###) ###-####"
//       text: ""
//   }
//
//   // --- API ---
//   // mask: '#' = digit, 'A' = letter, '*' = alphanumeric, other chars are literals
//   // text / displayText / rawText, acceptableInput
//
// @notes
//   Thin TextField wrapper — not a full locale/IME mask engine.

T.TextField {
    id: control

    property string mask: ""
    readonly property string rawText: _digitsOnly(text)
    readonly property bool acceptableInput: _isComplete(text)

    selectByMouse: true
    font.pixelSize: Theme.fontBody
    color: Theme.textPrimary
    placeholderTextColor: Theme.textSecondary
    leftPadding: 12
    rightPadding: 12
    topPadding: 8
    bottomPadding: 8
    implicitHeight: Math.max(32, contentHeight + topPadding + bottomPadding)
    implicitWidth: 200

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 32
        radius: Theme.cornerControl
        color: control.enabled ? Theme.bgControlRest : Theme.fillControlDisabled
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? Theme.accent : Theme.strokeControl
    }

    function _digitsOnly(s) {
        var out = ""
        for (var i = 0; i < s.length; ++i) {
            var ch = s.charAt(i)
            if (/[0-9A-Za-z]/.test(ch))
                out += ch
        }
        return out
    }

    function _slotKind(ch) {
        if (ch === "#")
            return "digit"
        if (ch === "A")
            return "letter"
        if (ch === "*")
            return "alnum"
        return "literal"
    }

    function _charFits(kind, ch) {
        if (kind === "digit")
            return /[0-9]/.test(ch)
        if (kind === "letter")
            return /[A-Za-z]/.test(ch)
        if (kind === "alnum")
            return /[0-9A-Za-z]/.test(ch)
        return false
    }

    function _applyMask(raw) {
        if (!mask || !mask.length)
            return raw
        var out = ""
        var ri = 0
        for (var mi = 0; mi < mask.length; ++mi) {
            var kind = _slotKind(mask.charAt(mi))
            if (kind === "literal") {
                out += mask.charAt(mi)
                continue
            }
            if (ri >= raw.length)
                break
            var ch = raw.charAt(ri)
            if (!_charFits(kind, ch)) {
                ++ri
                --mi
                continue
            }
            out += ch
            ++ri
        }
        return out
    }

    function _isComplete(display) {
        if (!mask || !mask.length)
            return true
        var need = 0
        for (var i = 0; i < mask.length; ++i) {
            if (_slotKind(mask.charAt(i)) !== "literal")
                ++need
        }
        return _digitsOnly(display).length >= need
    }

    onTextEdited: {
        if (!mask || !mask.length)
            return
        var formatted = _applyMask(_digitsOnly(text))
        if (formatted !== text) {
            var pos = cursorPosition
            text = formatted
            cursorPosition = Math.min(pos, text.length)
        }
    }
}
