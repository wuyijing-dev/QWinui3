import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — FlipView.
//
// Swipeable pages with Fluent chevrons, PipsPager, and Accessible page index. API: docs/components/FlipView.md

CatalogPage {
    title: qsTr("FlipView")
    subtitle: qsTr("Swipeable pages with Fluent chevrons, PipsPager, and Accessible page index — docs/carousel-recipes.md (2.37).")

    ControlExample {
        headerText: qsTr("Reduced motion (2.37)")
        qmlSource: "Theme.reducedMotion — pip/chevron Behaviors snap off"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("FlipView chevron fade and embedded PipsPager pip animations honor Theme.reducedMotion. Toggle below and hover chevrons / change pages — motion should snap.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            SettingsToggleCard {
                Layout.fillWidth: true
                title: qsTr("Reduced motion")
                description: qsTr("Sets Theme.reducedMotion for this session — same flag as Settings → Accessibility.")
                symbol: FluentIcons.AlignLeft
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
        }
    }

    ControlExample {
        headerText: qsTr("Pages")
        qmlSource: "FlipView {\n    buttonVisibility: \"onHover\"\n    wrap: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Buttons"); color: Theme.textSecondary }
                ComboBox {
                    id: btnVis
                    model: ["onHover", "always", "hidden"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
                CheckBox {
                    id: wrapBox
                    text: qsTr("Wrap")
                }
                CheckBox {
                    id: indBox
                    text: qsTr("Indicator")
                    checked: true
                }
                CheckBox {
                    id: vertBox
                    text: qsTr("Vertical")
                }
            }
            FlipView {
                id: flip
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                buttonVisibility: btnVis.currentText
                wrap: wrapBox.checked
                isIndicatorVisible: indBox.checked
                orientation: vertBox.checked ? Qt.Vertical : Qt.Horizontal
                onSelectionChanged: function (index) {
                    // keep label binding live
                }
                Rectangle {
                    color: Theme.systemAttentionBg
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Page 1")
                        color: Theme.textPrimary
                    }
                }
                Rectangle {
                    color: Theme.systemSuccessBg
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Page 2")
                        color: Theme.textPrimary
                    }
                }
                Rectangle {
                    color: Theme.systemCautionBg
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Page 3")
                        color: Theme.textPrimary
                    }
                }
            }
            Label {
                text: qsTr("selectedIndex: %1 / %2").arg(flip.selectedIndex + 1).arg(flip.count)
                color: Theme.textSecondary
            }
        }
    }
}
