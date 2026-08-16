import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TextBlock.

CatalogPage {
    title: qsTr("TextBlock")
    subtitle: qsTr("WinUI type ramp, styleName / setStyleName(), selection, and trimming.")

    ControlExample {
        headerText: qsTr("Type ramp")
        qmlSource: "TextBlock { text: \"Title\"; style: title }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextBlock { id: tbDisplay; text: qsTr("Display"); style: tbDisplay.display }
            TextBlock { id: tbTitleLarge; text: qsTr("Title Large"); style: tbTitleLarge.titleLarge }
            TextBlock { id: tbTitle; text: qsTr("Title"); style: tbTitle.title }
            TextBlock { id: tbSubtitle; text: qsTr("Subtitle"); style: tbSubtitle.subtitle }
            TextBlock { id: tbStrong; text: qsTr("Body Strong"); style: tbStrong.bodyStrong }
            TextBlock {
                text: qsTr("Body — selectable. Drag to select this sentence.")
                isTextSelectionEnabled: true
            }
            TextBlock {
                id: tbCaption
                Layout.fillWidth: true
                Layout.maximumWidth: 220
                text: qsTr("Caption with ellipsis when the line is too long for the available width.")
                style: tbCaption.caption
                textTrimming: "characterEllipsis"
                maxLines: 1
            }
        }
    }
}
