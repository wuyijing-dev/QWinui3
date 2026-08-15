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
                title: qsTr("HyperlinkButton")
                subtitle: qsTr("Text link with icon, visited state, NavigateUri, and navigateMode.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Underline styles")
                qmlSource: "HyperlinkButton {\n    iconGlyph: \"\\uE8A7\"\n    navigateUri: \"https://doc.qt.io\"\n}"

                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        Label { text: qsTr("Underline"); color: Theme.textSecondary }
                        ComboBox {
                            id: underBox
                            model: ["onHover", "always", "never"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                    }
                    Flow {
                        Layout.fillWidth: true
                        spacing: Theme.spacingLoose
                        HyperlinkButton {
                            text: qsTr("Go to docs")
                            iconGlyph: "\uE8A7"
                            navigateUri: "https://doc.qt.io"
                            underlineStyle: underBox.currentText
                        }
                        HyperlinkButton {
                            text: qsTr("Signal only")
                            navigateMode: "signal"
                            navigateUri: "app://settings"
                            underlineStyle: underBox.currentText
                            onNavigateRequested: function (target) {
                                status.text = qsTr("navigateRequested: %1").arg(target)
                            }
                        }
                        HyperlinkButton {
                            text: qsTr("Disabled")
                            enabled: false
                            underlineStyle: underBox.currentText
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Click a link — visited styling applies after open.")
                        color: Theme.textSecondary
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
