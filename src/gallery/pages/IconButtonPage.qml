import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — IconButton.

CatalogPage {
    title: qsTr("IconButton")
    subtitle: qsTr("Icon-only button with Fluent symbol, badge, hover/press micro-motion, and Accessible name from toolTip.")

    ControlExample {
        headerText: qsTr("Icons")
        qmlSource: "IconButton {\n    symbol: FluentIcons.Copy\n    toolTipText: qsTr(\"Copy\")\n}"
        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Hover lifts the glyph; press squashes it. Opt out with microMotionEnabled: false. Honors Theme.reducedMotion — docs/icons.md.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            RowLayout {
                spacing: Theme.spacing
                IconButton {
                    symbol: FluentIcons.Copy
                    toolTipText: qsTr("Copy")
                    onClicked: status.text = qsTr("Copy")
                }
                IconButton {
                    symbol: FluentIcons.Cut
                    toolTipText: qsTr("Cut")
                    onClicked: status.text = qsTr("Cut")
                }
                IconButton {
                    symbol: FluentIcons.Delete
                    highlighted: true
                    toolTipText: qsTr("Delete")
                    onClicked: status.text = qsTr("Delete")
                }
                IconButton {
                    symbol: FluentIcons.Refresh
                    flat: false
                    toolTipText: qsTr("Refresh")
                    onClicked: status.text = qsTr("Refresh")
                }
                IconButton {
                    symbol: FluentIcons.Mail
                    toolTipText: qsTr("Notifications")
                    badgeValue: 3
                    onClicked: status.text = qsTr("Notifications")
                }
                IconButton {
                    symbol: FluentIcons.Settings
                    toolTipText: qsTr("Motion off")
                    microMotionEnabled: false
                    onClicked: status.text = qsTr("Motion off")
                }
                IconButton { symbol: FluentIcons.ChromeClose; enabled: false; toolTipText: qsTr("Close") }
            }
            RowLayout {
                spacing: Theme.spacing
                IconButton {
                    id: loadBtn
                    symbol: FluentIcons.Save
                    toolTipText: qsTr("Save")
                    loading: loadDemo.checked
                    onClicked: status.text = qsTr("Save (loading demo)")
                }
                CheckBox {
                    id: loadDemo
                    text: qsTr("loading")
                }
            }
            CheckBox {
                text: qsTr("Theme.reducedMotion")
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
            Label {
                id: status
                text: qsTr("Ready — hover and click the icons")
                color: Theme.textSecondary
            }
        }
    }
}
