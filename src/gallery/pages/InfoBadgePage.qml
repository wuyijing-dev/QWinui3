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
                title: qsTr("InfoBadge")
                subtitle: qsTr("A small badge for counts, status dots, or Fluent glyphs.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Values and overlay")
                qmlSource: "InfoBadge { value: 3 }\nInfoBadge { value: 120 }\nInfoBadge { iconGlyph: \"\\uE735\" }"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    Row {
                        spacing: Theme.spacingLoose
                        InfoBadge { value: 3 }
                        InfoBadge { value: 99 }
                        InfoBadge { value: 120 }
                        InfoBadge { }
                        InfoBadge { iconGlyph: "\uE735"; severity: 0 }
                    }

                    Row {
                        spacing: Theme.spacingLoose
                        InfoBadge { id: b1; value: 2; severity: b1.success }
                        InfoBadge { id: b2; value: 5; severity: b2.warning }
                        InfoBadge { id: b3; value: 1; severity: b3.informational }
                        InfoBadge { id: b4; severity: b4.error }
                        InfoBadge { id: b5; text: "NEW"; severity: b5.attention }
                        InfoBadge { id: b6; value: 4; severity: b6.neutral }
                        InfoBadge {
                            id: emptyBadge
                            value: 0
                            hideWhenEmpty: true
                            severity: emptyBadge.informational
                        }
                    }

                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("Toggle empty badge")
                            onClicked: emptyBadge.value = emptyBadge.value > 0 ? 0 : 7
                        }
                        Label {
                            text: emptyBadge.isOpen ? qsTr("Badge open") : qsTr("Badge hidden (hideWhenEmpty)")
                            color: Theme.textSecondary
                        }
                    }

                    Item {
                        Layout.preferredWidth: badgeButton.implicitWidth + 8
                        Layout.preferredHeight: badgeButton.implicitHeight + 8

                        Button {
                            id: badgeButton
                            text: qsTr("Inbox")
                        }
                        InfoBadge {
                            anchors.top: badgeButton.top
                            anchors.right: badgeButton.right
                            anchors.topMargin: -4
                            anchors.rightMargin: -4
                            value: 3
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
