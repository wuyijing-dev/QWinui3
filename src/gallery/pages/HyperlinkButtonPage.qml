import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HyperlinkButton.

CatalogPage {
    title: qsTr("HyperlinkButton")
    subtitle: qsTr("Fluent link with symbol, showExternalGlyph, visited, in-page jump, and navigateMode.")

    ControlExample {
        headerText: qsTr("Appearances (2.66 A1)")
        qmlSource: "HyperlinkButton { appearance: \"ghost\" }\nHyperlinkButton { appearance: \"subtle\" }\nHyperlinkButton { appearance: \"outline\" }\nHyperlinkButton { appearance: \"filled\" }"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            HyperlinkButton {
                text: qsTr("Ghost")
                appearance: "ghost"
                navigateMode: "signal"
                navigateUri: "app://ghost"
            }
            HyperlinkButton {
                text: qsTr("Subtle")
                appearance: "subtle"
                navigateMode: "signal"
                navigateUri: "app://subtle"
            }
            HyperlinkButton {
                text: qsTr("Outline")
                appearance: "outline"
                navigateMode: "signal"
                navigateUri: "app://outline"
            }
            HyperlinkButton {
                text: qsTr("Filled")
                appearance: "filled"
                navigateMode: "signal"
                navigateUri: "app://filled"
            }
        }
    }

    ControlExample {
        objectName: "underlineStyles"
        headerText: qsTr("Underline styles")
        qmlSource: "HyperlinkButton {\n    navigateUri: \"#section\"\n    navigateMode: \"inPage\"\n}"

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
                    symbol: FluentIcons.Document
                    showExternalGlyph: true
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
                    text: qsTr("Jump to in-page demo")
                    navigateUri: "#inPageJump"
                    underlineStyle: underBox.currentText
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

    ControlExample {
        objectName: "inPageJump"
        headerText: qsTr("In-page jump")
        qmlSource: "HyperlinkButton {\n    navigateUri: \"#underlineStyles\"\n}"

        ColumnLayout {
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Fragment URLs (#objectName) scroll this Gallery page. External http(s) still open in the browser.")
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacingLoose
                HyperlinkButton {
                    text: qsTr("Back to underline styles")
                    navigateUri: "#underlineStyles"
                }
                HyperlinkButton {
                    text: qsTr("Jump to this block")
                    navigateUri: "#inPageJump"
                    navigateMode: "inPage"
                }
            }
        }
    }
}
