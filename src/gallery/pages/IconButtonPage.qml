import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("IconButton")
                subtitle: qsTr("A compact icon-only button with tooltip and optional badge.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Icons")
                qmlSource: "IconButton {\n    iconGlyph: \"\\uE8C8\"\n    toolTipText: \"Copy\"\n    badgeValue: 3\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        spacing: Theme.spacing
                        IconButton {
                            iconGlyph: "\uE8C8"
                            toolTipText: qsTr("Copy")
                            onClicked: status.text = qsTr("Copy")
                        }
                        IconButton {
                            iconGlyph: "\uE77F"
                            toolTipText: qsTr("Cut")
                            onClicked: status.text = qsTr("Cut")
                        }
                        IconButton {
                            iconGlyph: "\uE74D"
                            highlighted: true
                            toolTipText: qsTr("Delete")
                            onClicked: status.text = qsTr("Delete")
                        }
                        IconButton {
                            iconGlyph: "\uE72C"
                            flat: false
                            toolTipText: qsTr("Refresh")
                            onClicked: status.text = qsTr("Refresh")
                        }
                        IconButton {
                            iconGlyph: "\uE715"
                            toolTipText: qsTr("Notifications")
                            badgeValue: 3
                            onClicked: status.text = qsTr("Notifications")
                        }
                        IconButton { iconGlyph: "\uE711"; enabled: false }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
