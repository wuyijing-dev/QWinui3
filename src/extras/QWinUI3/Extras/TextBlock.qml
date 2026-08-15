import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI TextBlock with type-ramp styles mapped to Theme tokens.
T.Label {
    id: root

    readonly property int caption: 0
    readonly property int body: 1
    readonly property int bodyStrong: 2
    readonly property int subtitle: 3
    readonly property int title: 4
    readonly property int titleLarge: 5
    readonly property int display: 6

    property int style: body
    // WinUI IsTextSelectionEnabled
    property bool isTextSelectionEnabled: false
    // none | characterEllipsis | wordEllipsis
    property string textTrimming: "none"
    property int maxLines: 0 // 0 = unlimited

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
    color: style === caption ? Theme.textSecondary : Theme.textPrimary
    wrapMode: textTrimming === "none" ? Text.Wrap : Text.NoWrap
    elide: {
        switch (textTrimming) {
        case "characterEllipsis": return Text.ElideRight
        case "wordEllipsis": return Text.ElideRight
        default: return Text.ElideNone
        }
    }
    maximumLineCount: maxLines > 0 ? maxLines : 0
    selectByMouse: isTextSelectionEnabled
    // Label may not support selection on all styles — use TextInput-like when needed
}
