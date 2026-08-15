import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme

ColumnLayout {
    id: root

    property string title: ""
    property string subtitle: ""

    spacing: 8
    Layout.fillWidth: true

    Text {
        id: titleLabel
        text: root.title
        font.family: Theme.fontFamilyDisplay
        font.pixelSize: Theme.fontTitle
        font.weight: Theme.fontWeightSemiBold
        color: Theme.textPrimary
        wrapMode: Text.Wrap
        Layout.fillWidth: true
    }

    Rectangle {
        Layout.preferredWidth: 36
        Layout.preferredHeight: 3
        radius: 1.5
        color: Theme.accent
        opacity: 0.85
    }

    Text {
        visible: root.subtitle.length > 0
        text: root.subtitle
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontBody
        color: Theme.textSecondary
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        Layout.maximumWidth: 720
        Layout.topMargin: 4
    }
}
