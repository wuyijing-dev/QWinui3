import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TitleBar.
//
// WinUI TitleBar: Back, PaneToggle, Icon, Title/Subtitle, Content, RightHeader. API: docs/components/TitleBar.md

CatalogPage {
    title: qsTr("TitleBar")
    subtitle: qsTr("WinUI TitleBar: Back, PaneToggle, Icon, Title/Subtitle, Content, RightHeader.")

    ControlExample {
        headerText: qsTr("LeftHeader & Content slots")
        qmlSource: "TitleBar {\n    leftHeader: ComboBox { model: [\"A\", \"B\"] }\n    content: Row { Button { … } }\n    rightHeader: Button { text: \"Share\" }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: Theme.bgAcrylic
                border.width: 1
                border.color: Theme.strokeDivider
                radius: Theme.cornerControl
                TitleBar {
                    anchors.fill: parent
                    anchors.margins: 1
                    embedded: true
                    searchEnabled: false
                    title: qsTr("Custom chrome")
                    subtitle: qsTr("LeftHeader + Content + RightHeader")
                    symbol: FluentIcons.Edit
                    leftHeader: ComboBox {
                        implicitWidth: 120
                        model: [qsTr("Draft"), qsTr("Published")]
                    }
                    Row {
                        spacing: 4
                        Button { text: qsTr("Undo"); flat: true }
                        Button { text: qsTr("Redo"); flat: true }
                    }
                    Button {
                        text: qsTr("Save")
                        flat: true
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                text: qsTr("ShellWindow / StandardTitleChrome expose the same slots: leftHeader, titleBarContent, rightHeader.")
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("WinUI anatomy")
        qmlSource: "TitleBar {\n    title: \"App\"\n    subtitle: \"Subtitle\"\n    symbol: FluentIcons.Home\n    isBackButtonVisible: true\n    isPaneToggleButtonVisible: true\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: Theme.bgAcrylic
                border.width: 1
                border.color: Theme.strokeDivider
                radius: Theme.cornerControl
                TitleBar {
                    id: anatomyBar
                    anchors.fill: parent
                    anchors.margins: 1
                    embedded: true
                    searchEnabled: false
                    title: qsTr("Contoso Photos")
                    subtitle: qsTr("Library")
                    symbol: FluentIcons.Home
                    isBackButtonVisible: true
                    isPaneToggleButtonVisible: true
                    onBackRequested: tip.text = qsTr("BackRequested")
                    onPaneToggleRequested: tip.text = qsTr("PaneToggleRequested")

                    Button {
                        text: qsTr("Share")
                        flat: true
                    }
                    Button {
                        text: qsTr("More")
                        flat: true
                    }
                }
            }
            Label {
                id: tip
                Layout.fillWidth: true
                text: qsTr("Interact with Back / Pane toggle — Share/More sit in RightHeader")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("Built-in search Content")
        qmlSource: "TitleBar {\n    searchEnabled: true\n    searchModel: […]\n}"
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            color: Theme.bgAcrylic
            border.width: 1
            border.color: Theme.strokeDivider
            radius: Theme.cornerControl
            TitleBar {
                anchors.fill: parent
                anchors.margins: 1
                embedded: true
                title: qsTr("Sample window")
                subtitle: qsTr("Search is default Content when the Content slot is empty")
                searchModel: [
                    { title: qsTr("Button"), component: "ButtonPage" },
                    { title: qsTr("Slider"), component: "SliderPage" }
                ]
            }
        }
    }
}
