import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Button (WinUI appearances, icon, accent, loading).

CatalogPage {
    title: qsTr("Button")
    subtitle: qsTr("Appearances, leading icon, accent, loading — docs/components/Button.md")

    ControlExample {
        headerText: qsTr("A simple Button")
        qmlSource: "Button { text: \"Standard\" }\nButton { text: \"Disabled\"; enabled: false }"
        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Button { text: qsTr("Standard") }
            Button { text: qsTr("Disabled"); enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("Button appearances")
        qmlSource: "Button { appearance: \"filled\" }\nButton { appearance: \"subtle\" }\nButton { appearance: \"outline\" }\nButton { appearance: \"ghost\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("filled (default) · subtle · outline · ghost. Prefer AccentButton or highlighted for the primary CTA.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Button { text: qsTr("Filled"); appearance: "filled" }
                Button { text: qsTr("Subtle"); appearance: "subtle" }
                Button { text: qsTr("Outline"); appearance: "outline" }
                Button { text: qsTr("Ghost"); appearance: "ghost" }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Accent Button")
        qmlSource: "Button {\n    text: \"Accent\"\n    highlighted: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("highlighted: true uses accent fill. AccentButton adds a Fluent symbol API on top of the same chrome.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Button { text: qsTr("Accent"); highlighted: true }
                Button {
                    text: qsTr("Save")
                    highlighted: true
                    leadingSymbol: FluentIcons.Save
                }
                Button { text: qsTr("Accent disabled"); highlighted: true; enabled: false }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Button with an icon")
        qmlSource: "Button {\n    text: \"Share\"\n    leadingSymbol: FluentIcons.Share\n}"
        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Button {
                text: qsTr("Share")
                leadingSymbol: FluentIcons.Share
            }
            Button {
                text: qsTr("Settings")
                appearance: "outline"
                leadingSymbol: FluentIcons.Settings
            }
            Button {
                text: qsTr("Delete")
                appearance: "subtle"
                leadingSymbol: FluentIcons.Delete
            }
            Button {
                leadingSymbol: FluentIcons.Add
                Accessible.name: qsTr("Add")
                // Icon-only — keep hit target via Theme.controlHeight
            }
        }
    }

    ControlExample {
        headerText: qsTr("A Button that shows progress")
        qmlSource: "Button {\n    text: \"Submit\"\n    loading: busy\n    onClicked: busy = true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("loading: true shows an inline BusyIndicator and blocks clicks. Width stays stable when preserveWidthWhileLoading is true.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacingLoose
                Button {
                    id: submitBtn
                    text: qsTr("Submit")
                    highlighted: true
                    leadingSymbol: FluentIcons.Send
                    loading: submitBusy.running
                    onClicked: submitBusy.restart()
                }
                Button {
                    text: qsTr("Cancel")
                    appearance: "outline"
                    enabled: submitBusy.running
                    onClicked: submitBusy.stop()
                }
                Label {
                    text: submitBusy.running ? qsTr("Working…") : qsTr("Idle")
                    color: Theme.textSecondary
                }
            }
            Timer {
                id: submitBusy
                interval: 2200
                repeat: false
            }
        }
    }
}
