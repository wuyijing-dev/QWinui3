import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — TitleBar.
//
// WinUI TitleBar: Back, PaneToggle, Icon, Title/Subtitle, Content, RightHeader. API: docs/components/TitleBar.md

CatalogPage {
    id: page
    title: qsTr("TitleBar")
    subtitle: qsTr("WinUI TitleBar: Back, PaneToggle, Icon, Title/Subtitle, Content, RightHeader. Cookbook: docs/title-bar-cookbook.md · Window shells page for ShellWindow slots.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("TitleBarCommandBar")
        qmlSource: "TitleBarCommandBar { commands: [ { label: qsTr(\"Save\"), symbol: FluentIcons.Save, action: save } ] }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                color: Theme.bgAcrylic
                border.width: 1
                border.color: Theme.strokeDivider
                radius: Theme.cornerControl
                TitleBarCommandBar {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.spacing
                    anchors.verticalCenter: parent.verticalCenter
                    commands: [
                        {
                            label: qsTr("Home"),
                            symbol: FluentIcons.Home,
                            shortcut: "Ctrl+H",
                            action: function () { cmdStatus.text = qsTr("Home") }
                        },
                        {
                            label: qsTr("Share"),
                            symbol: FluentIcons.Share,
                            action: function () { cmdStatus.text = qsTr("Share") }
                        }
                    ]
                }
            }
            Label {
                id: cmdStatus
                Layout.fillWidth: true
                color: Theme.textSecondary
                text: qsTr("Click a command — declarative objects for leftHeader / captionRightHeader.")
            }
        }
    }

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
                    content: Row {
                        spacing: 4
                        Button { text: qsTr("Undo"); flat: true }
                        Button { text: qsTr("Redo"); flat: true }
                    }
                    rightHeader: Button {
                        text: qsTr("Save")
                        flat: true
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("ShellWindow / StandardTitleChrome expose leftHeader, titleBarContent, rightHeader. StandardTitleChrome.rightHeader is PlatformTitleBar (before captions); ShellWindow.rightHeader is inside TitleBar — see docs/title-bar-cookbook.md.")
            }
            Button {
                flat: true
                text: qsTr("Open Window shells page")
                onClicked: page.openComp("WindowParadigmPage")
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

                    rightHeader: Row {
                        spacing: 4
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
        headerText: qsTr("ShellWindow captionRightHeader (before captions)")
        qmlSource: "NavigationWindow {\n    titleBarContent: TitleBarToolbar { Button { … } }\n    rightHeader: Button { text: \"Share\" }\n    captionRightHeader: FrameStatsBadge { }\n}"

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
                clip: true
                WindowChrome {
                    anchors.fill: parent
                    showCaptionButtons: false
                    title: qsTr("Shell host")
                    subtitle: qsTr("captionRightHeader vs rightHeader")
                    symbol: FluentIcons.People
                    searchEnabled: false
                    titleBarContent: TitleBarToolbar {
                        Button { text: qsTr("Undo"); flat: true }
                        Button { text: qsTr("Redo"); flat: true }
                    }
                    rightHeader: Button {
                        text: qsTr("Share")
                        flat: true
                    }
                    captionRightHeader: Row {
                        spacing: 4
                        FrameStatsBadge { }
                        Button {
                            text: qsTr("Account")
                            flat: true
                        }
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("ShellWindow / NavigationWindow now expose captionRightHeader (Platform slot, before min/max/close). rightHeader stays inside the title band. Use TitleBarToolbar in titleBarContent for toolbars.")
            }
        }
    }

    ControlExample {
        qmlSource: "StandardTitleChrome {\n    titleBarContent: Button { text: \"Filter\" }\n    Button { text: \"Share\" }  // extraContent / rightHeader\n}"

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
                clip: true
                StandardTitleChrome {
                    anchors.fill: parent
                    showCaptionButtons: false
                    title: qsTr("Host window")
                    subtitle: qsTr("extraContent sits before captions")
                    symbol: FluentIcons.Home
                    searchEnabled: false
                    titleBarContent: Button {
                        text: qsTr("Filter")
                        flat: true
                    }
                    Button {
                        text: qsTr("Share")
                        flat: true
                    }
                    FrameStatsBadge { }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Unnamed children of StandardTitleChrome go to extraContent (Platform rightHeader). Enable Settings → Show FPS to see FrameStatsBadge beside Share. Named slots: leftHeader, titleBarContent, rightHeader.")
            }
            Switch {
                text: qsTr("Show FPS in title bar")
                checked: FrameStatsMonitor.enabled && FrameStatsMonitor.inTitleBar
                onToggled: {
                    FrameStatsMonitor.enabled = checked
                    if (checked)
                        FrameStatsMonitor.inTitleBar = true
                }
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
