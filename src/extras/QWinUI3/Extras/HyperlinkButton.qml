import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// HyperlinkButton — Link-styled button.
//
//   HyperlinkButton {
//       id: link
//       text: qsTr("Learn more")
//       navigateUri: "https://example.com"
//       onClicked: Qt.openUrlExternally(navigateUri)
//   }
//   // --- API ---
//   // link.navigateUri / showExternalGlyph / navigateMode (auto | external | inPage | signal)
//
// @notes
//   Link-styled button; navigateUri + optional external glyph.
//   navigateMode auto: "#anchor" scrolls in-page; http(s) opens externally.

T.AbstractButton {
    id: control

    // URL / source URL
    property url url: ""
    // Navigate to a URI
    property alias navigateUri: control.url
    // always | onHover | never
    property string underlineStyle: "onHover"
    // Visual variant: ghost (default link) | subtle | outline | filled — 2.66 A1
    property string appearance: "ghost"
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // True when the step was visited
    property bool visited: false
    // Show external-link glyph
    property bool showExternalGlyph: false
    // navigateMode: auto | external | inPage | signal
    property string navigateMode: "auto"
    // Emitted to request navigation
    signal navigateRequested(url target)

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    readonly property string _mode: {
        var a = String(appearance || "").toLowerCase()
        if (a === "subtle" || a === "outline" || a === "filled")
            return a
        return "ghost"
    }
    readonly property bool _chrome: _mode !== "ghost"

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: control._chrome ? Theme.paddingControlV : 2
    leftPadding: control._chrome ? Theme.paddingControlH : 2
    rightPadding: control._chrome ? Theme.paddingControlH : 2
    spacing: 6
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    Accessible.role: Accessible.Link
    Accessible.name: control.text.length ? control.text : qsTr("Hyperlink")
    Accessible.description: url.toString()

    scale: down && !Theme.reducedMotion ? 0.98 : 1
    opacity: down && enabled && !_chrome ? 0.8 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }
    Behavior on opacity {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: RowLayout {
        spacing: control.spacing

        Text {
            visible: control.effectiveIconGlyph.length > 0
            text: control.effectiveIconGlyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: label.color
            Layout.alignment: Qt.AlignVCenter
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        Text {
            id: label
            Layout.alignment: Qt.AlignVCenter
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.underline: {
                if (control._chrome)
                    return false
                switch (control.underlineStyle) {
                case "always": return true
                case "never": return false
                default: return control.hovered
                }
            }
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
                if (control._mode === "filled")
                    return Theme.textOnAccent
                if (control.visited)
                    return control.down ? Theme.accentDark1 : Qt.tint(Theme.accent, Qt.rgba(0.35, 0.2, 0.55, 0.55))
                return control.down ? Theme.accentDark1 : Theme.accent
            }
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        Text {
            visible: control.showExternalGlyph && control.url.toString().length > 0
            text: FluentIcons.OpenInNewWindow
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: label.color
            opacity: 0.85
            Layout.alignment: Qt.AlignVCenter
        }
    }

    background: Item {
        implicitHeight: control._chrome ? Theme.controlHeight : (Theme.fontBody + 4)
        implicitWidth: 40

        Rectangle {
            anchors.fill: parent
            visible: control._chrome
            radius: Theme.cornerControl
            border.width: control._mode === "outline" ? 1 : 0
            border.color: control.enabled ? Theme.accent : Theme.strokeControl
            color: {
                if (!control._chrome || !control.enabled)
                    return "transparent"
                if (control._mode === "filled") {
                    if (control.down)
                        return Qt.tint(Theme.accent, Qt.rgba(0, 0, 0, 0.15))
                    if (control.hovered)
                        return Qt.tint(Theme.accent, Qt.rgba(1, 1, 1, 0.1))
                    return Theme.accent
                }
                if (control._mode === "subtle") {
                    if (control.down)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.28)
                    if (control.hovered)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18)
                    return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12)
                }
                // outline
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: control._chrome ? Theme.cornerControl : 2
        }
    }

    function _urlString() {
        return control.url ? control.url.toString() : ""
    }

    function _urlFragment() {
        var f = control.url ? control.url.fragment : ""
        return f ? String(f) : ""
    }

    function _fragment() {
        var s = _urlString()
        if (s.length && s.charAt(0) === "#")
            return s.substring(1)
        var hash = s.lastIndexOf("#")
        if (hash < 0)
            return _urlFragment()
        try {
            return decodeURIComponent(s.substring(hash + 1))
        } catch (err) {
            return s.substring(hash + 1)
        }
    }

    function _isFragmentOnly() {
        var s = _urlString()
        if (!s.length)
            return false
        if (s.charAt(0) === "#")
            return true
        var hash = s.lastIndexOf("#")
        if (hash < 0)
            return false
        var before = s.substring(0, hash).toLowerCase()
        if (before.indexOf("http:") === 0 || before.indexOf("https:") === 0
                || before.indexOf("mailto:") === 0)
            return false
        return true
    }

    function _findNamed(item, name) {
        if (!item || !name)
            return null
        if (item.objectName === name)
            return item
        var kids = item.children || []
        for (var i = 0; i < kids.length; ++i) {
            var hit = _findNamed(kids[i], name)
            if (hit)
                return hit
        }
        return null
    }

    function _scrollToFragment(frag) {
        if (!frag.length)
            return false
        var p = control.parent
        while (p) {
            if (typeof p.scrollToName === "function" && p.scrollToName(frag))
                return true
            p = p.parent
        }
        var win = control.Window.window
        var rootItem = win && win.contentItem ? win.contentItem : control
        var target = _findNamed(rootItem, frag)
        if (!target)
            return false
        var q = target
        while (q) {
            if (typeof q.scrollToItem === "function")
                return q.scrollToItem(target)
            if (q.contentY !== undefined && q.contentItem
                    && q.flickableDirection !== undefined) {
                var pt = target.mapToItem(q.contentItem, 0, 0)
                var maxY = Math.max(0, q.contentHeight - q.height)
                q.contentY = Math.max(0, Math.min(pt.y - 12, maxY))
                return true
            }
            q = q.parent
        }
        return false
    }

    onClicked: {
        var target = control.url
        var mode = String(control.navigateMode || "auto").toLowerCase()
        var frag = control._fragment()
        var inPage = mode === "inpage"
                     || (mode === "auto" && control._isFragmentOnly() && frag.length)
        if (mode !== "signal" && inPage && control._scrollToFragment(frag)) {
            control.visited = true
            control.navigateRequested(target)
            Qt.callLater(function () { control._scrollToFragment(frag) })
            return
        }
        if (mode !== "signal" && mode !== "inpage" && target.toString().length > 0
                && !control._isFragmentOnly())
            Qt.openUrlExternally(target)
        if (target.toString().length > 0)
            control.visited = true
        control.navigateRequested(target)
    }
}
