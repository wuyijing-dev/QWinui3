import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI TextBlock with type-ramp styles mapped to Theme tokens.
T.Control {
    id: root

    readonly property int caption: 0
    readonly property int body: 1
    readonly property int bodyStrong: 2
    readonly property int subtitle: 3
    readonly property int title: 4
    readonly property int titleLarge: 5
    readonly property int display: 6

    property string text: ""
    property int style: body
    // WinUI IsTextSelectionEnabled — uses TextEdit when true (Label has no selectByMouse)
    property bool isTextSelectionEnabled: false
    // none | characterEllipsis | wordEllipsis
    property string textTrimming: "none"
    property int maxLines: 0 // 0 = unlimited

    property color color: style === caption ? Theme.textSecondary : Theme.textPrimary

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

    readonly property int _wrapMode: textTrimming === "none" ? Text.Wrap : Text.NoWrap
    readonly property int _elide: {
        switch (textTrimming) {
        case "characterEllipsis": return Text.ElideRight
        case "wordEllipsis": return Text.ElideRight
        default: return Text.ElideNone
        }
    }
    readonly property int _maxLines: maxLines > 0 ? maxLines : 0

    implicitWidth: contentItem.implicitWidth
    implicitHeight: contentItem.implicitHeight
    background: Item {}
    padding: 0
    Accessible.role: Accessible.Paragraph
    Accessible.name: text

    contentItem: Loader {
        id: loader
        width: root.width > 0 ? root.width : item ? item.implicitWidth : 0
        sourceComponent: root.isTextSelectionEnabled ? selectableComp : plainComp

        Binding {
            target: loader.item
            property: "width"
            value: loader.width
            when: loader.item && loader.width > 0
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
            wrapMode: root._wrapMode === Text.Wrap ? TextEdit.Wrap : TextEdit.NoWrap
            // TextEdit (QtQuick) has no background/padding — unlike Controls TextField
            activeFocusOnPress: true
        }
    }
}
