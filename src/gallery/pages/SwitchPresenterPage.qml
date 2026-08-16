import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwitchPresenter.
//
// Shows one child case; selectedIndex, select(), and caseChanged. API: docs/components/SwitchPresenter.md

CatalogPage {
    title: qsTr("SwitchPresenter")
    subtitle: qsTr("Shows one child case; selectedIndex, select(), and caseChanged.")

    ControlExample {
        headerText: qsTr("Mode switch")
        qmlSource: "SwitchPresenter {\n    value: mode\n    onCaseChanged: …\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            SegmentedControl {
                id: modeSeg
                model: [qsTr("List"), qsTr("Grid"), qsTr("Empty")]
                currentIndex: 0
            }

            Label {
                id: caseStatus
                text: qsTr("Case index: 0")
                color: Theme.textSecondary
            }

            ContentCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                SwitchPresenter {
                    id: presenter
                    Layout.fillWidth: true
                    value: modeSeg.currentIndex === 0 ? "list"
                         : modeSeg.currentIndex === 1 ? "grid" : "empty"
                    onCaseChanged: function (v, index) {
                        caseStatus.text = qsTr("Case %1 · %2").arg(index).arg(v)
                    }
                    SwitchCase {
                        value: "list"
                        ColumnLayout {
                            spacing: 8
                            Label { text: qsTr("List view"); font.weight: Theme.fontWeightSemiBold }
                            Label { text: qsTr("Showing items in a vertical list."); color: Theme.textSecondary }
                            ListTile { title: qsTr("Document A"); subtitle: qsTr("Updated today") }
                        }
                    }
                    SwitchCase {
                        value: "grid"
                        ColumnLayout {
                            spacing: 8
                            Label { text: qsTr("Grid view"); font.weight: Theme.fontWeightSemiBold }
                            Label { text: qsTr("Showing tiles in a grid."); color: Theme.textSecondary }
                            Row {
                                spacing: 8
                                GridTile { title: qsTr("Alpha"); glyph: "\uE8A5"; tileWidth: 100; tileHeight: 88 }
                                GridTile { title: qsTr("Beta"); glyph: "\uE8BD"; tileWidth: 100; tileHeight: 88 }
                            }
                        }
                    }
                    SwitchCase {
                        value: "empty"
                        EmptyState {
                            width: parent ? parent.width : 280
                            title: qsTr("No items")
                            message: qsTr("Switch back to List or Grid to see content.")
                            glyph: "\uE7BA"
                            bordered: false
                        }
                    }
                }
            }
        }
    }
}
