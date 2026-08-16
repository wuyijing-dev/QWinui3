import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBadge.

CatalogPage {
    title: qsTr("InfoBadge")
    subtitle: qsTr("Counts, status dots, or Fluent symbols with severityName and bump animation.")

    ControlExample {
        headerText: qsTr("Values and overlay")
        qmlSource: "InfoBadge { value: 3 }\nInfoBadge { symbol: FluentIcons.FavoriteStarFill }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Row {
                spacing: Theme.spacingLoose
                InfoBadge { value: 3 }
                InfoBadge { value: 99 }
                InfoBadge { value: 120 }
                InfoBadge { }
                InfoBadge { symbol: FluentIcons.FavoriteStarFill; severity: 0 }
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
                Button {
                    text: qsTr("Cycle severity")
                    onClicked: {
                        var names = ["error", "success", "warning", "informational", "attention", "neutral"]
                        var i = names.indexOf(emptyBadge.severityName)
                        emptyBadge.setSeverityName(names[(i + 1) % names.length])
                        if (emptyBadge.value <= 0)
                            emptyBadge.value = 7
                    }
                }
                Label {
                    text: emptyBadge.isOpen
                          ? qsTr("Badge open · %1").arg(emptyBadge.severityName)
                          : qsTr("Badge hidden (hideWhenEmpty)")
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
}
