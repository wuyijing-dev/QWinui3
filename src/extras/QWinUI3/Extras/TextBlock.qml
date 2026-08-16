import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TextBlock — Fluent typography styles (title, body, caption…).
//
//   TextBlock {
//       id: textBlock
//       text: qsTr("Title"); style: title
//       textWrapping: "wrap"              // WinUI TextWrapping
//       textTrimming: "characterEllipsis" // WinUI TextTrimming
//       maxLines: 2                       // WinUI MaxLines
//   }
//
//   // --- API ---
//   // methods: setStyleName(name)
//   // textBlock.setStyleName(name)
//
// @notes
//   Themed text helper (style/weight tokens); prefer for Fluent type ramps.
//   Long text: bind width (or Layout.fillWidth) then use textWrapping /
//   textTrimming / maxLines like WinUI TextBlock.

T.Control {
    id: root

    // Caption under / beside the value
    readonly property int caption: 0
    // Body style
    readonly property int body: 1
    // Body strong style
    readonly property int bodyStrong: 2
    // Secondary subtitle text
    readonly property int subtitle: 3
    // Primary title text
    readonly property int title: 4
    // Title large style
    readonly property int titleLarge: 5
    // Display typography style
    readonly property int display: 6

    // Display / input text
    property string text: ""
    // Typography style token
    property int style: body
    // WinUI IsTextSelectionEnabled — uses TextEdit when true (Label has no selectByMouse)
    property bool isTextSelectionEnabled: false
    // WinUI TextWrapping: wrap | noWrap | wrapWholeWords
    property string textWrapping: "wrap"
    // WinUI TextTrimming: none | characterEllipsis | wordEllipsis
    property string textTrimming: "none"
    // WinUI MaxLines — 0 = unlimited; with trimming, elides after N lines
    property int maxLines: 0

    // Primary color
    property color color: style === caption ? Theme.textSecondary : Theme.textPrimary

    // Current style name
    readonly property string styleName: {
        switch (style) {
        case caption: return "caption"
        case bodyStrong: return "bodyStrong"
        case subtitle: return "subtitle"
        case title: return "title"
        case titleLarge: return "titleLarge"
        case display: return "display"
        default: return "body"
        }
    }

    // Set style by name
    function setStyleName(name) {
        switch (String(name).toLowerCase()) {
        case "caption": style = caption; break
        case "bodystrong":
        case "body-strong": style = bodyStrong; break
        case "subtitle": style = subtitle; break
        case "title": style = title; break
        case "titlelarge":
        case "title-large": style = titleLarge; break
        case "display": style = display; break
        default: style = body; break
        }
    }

    font.family: {
        switch (style) {
        case display:
        case titleLarge:
        case title:
            return Theme.fontFamilyDisplay
        default:
            return Theme.fontFamily
        }
    }
    font.pixelSize: {
        switch (style) {
        case caption: return Theme.fontCaption
        case subtitle: return Theme.fontSubtitle
        case title: return Theme.fontTitle
        case titleLarge: return Theme.fontTitleLarge
        case display: return Theme.fontTitleLarge + 12
        case bodyStrong:
        case body:
        default: return Theme.fontBody
        }
    }
    font.weight: (style === bodyStrong || style === subtitle || style === title
                  || style === titleLarge || style === display)
                 ? Theme.fontWeightSemiBold
                 : Theme.fontWeightRegular

    readonly property bool _trim: {
        var t = String(textTrimming).toLowerCase()
        return t === "characterellipsis" || t === "wordellipsis"
    }
    readonly property int _wrapMode: {
        var w = String(textWrapping).toLowerCase()
        // WinUI: NoWrap when single-line trim; Wrap (+ MaxLines) when multi-line trim.
        if (_trim && maxLines <= 1)
            return Text.NoWrap
        if (w === "nowrap")
            return Text.NoWrap
        if (w === "wrapwholewords")
            return Text.WordWrap
        return Text.Wrap
    }
    readonly property int _elide: _trim ? Text.ElideRight : Text.ElideNone
    readonly property int _maxLines: {
        if (maxLines > 0)
            return maxLines
        // Single-line ellipsis needs maximumLineCount 1 for Text.elide to apply.
        if (_trim && _wrapMode === Text.NoWrap)
            return 1
        return 0
    }

    implicitWidth: Math.ceil(loader.item ? loader.item.implicitWidth : 0)
    implicitHeight: Math.ceil(loader.item ? loader.item.implicitHeight : 0)
    background: Item {}
    padding: 0
    Accessible.role: Accessible.Paragraph
    Accessible.name: text

    contentItem: Loader {
        id: loader
        // Do not bind width to root.width — that loops with implicitWidth when the
        // control is sized from its content. T.Control assigns contentItem geometry.
        sourceComponent: root.isTextSelectionEnabled ? selectableComp : plainComp

        // Pass the Control-assigned width through for wrapping / elide.
        Binding {
            target: loader.item
            property: "width"
            value: loader.width
            when: loader.status === Loader.Ready && loader.width > 0
        }
    }

    Component {
        id: plainComp
        Text {
            text: root.text
            font: root.font
            color: root.color
            wrapMode: root._wrapMode
            elide: root._elide
            maximumLineCount: root._maxLines
        }
    }

    Component {
        id: selectableComp
        TextEdit {
            text: root.text
            font: root.font
            color: root.color
            readOnly: true
            selectByMouse: true
            wrapMode: root._wrapMode === Text.NoWrap ? TextEdit.NoWrap : TextEdit.Wrap
            // TextEdit (QtQuick) has no background/padding — unlike Controls TextField
            activeFocusOnPress: true
        }
    }
}
