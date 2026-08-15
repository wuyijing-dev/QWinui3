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
//   // link.navigateUri / showExternalGlyph

T.AbstractButton {
    id: control

    // URL / source URL
    property url url: ""
    // Navigate to a URI
    property alias navigateUri: control.url
    // always | onHover | never
    property string underlineStyle: "onHover"
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // True when the step was visited
    property bool visited: false
    // Show external-link glyph
    property bool showExternalGlyph: false
    // "external" opens the URL; "signal" only emits clicked / navigateRequested
    property string navigateMode: "external"
    // Emitted to request navigation
    signal navigateRequested(url target)

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2
    spacing: 6
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    Accessible.role: Accessible.Link
    Accessible.name: control.text.length ? control.text : qsTr("Hyperlink")
    Accessible.description: url.toString()

    scale: down && !Theme.reducedMotion ? 0.98 : 1
    Behavior on scale {
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
                switch (control.underlineStyle) {
                case "always": return true
                case "never": return false
                default: return control.hovered || control.visualFocus
                }
            }
            color: {
                if (!control.enabled)
                    return Theme.textDisabled
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
        implicitHeight: Theme.fontBody + 4
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }

    onClicked: {
        var target = control.url
        if (control.navigateMode !== "signal" && target.toString().length > 0)
            Qt.openUrlExternally(target)
        if (target.toString().length > 0)
            control.visited = true
        control.navigateRequested(target)
    }
}
