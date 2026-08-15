import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Blank shell.
//
// Empty client — add your content as children

Page {
    id: root
    padding: 0

    property var _openWindows: []

    function track(win) {
        if (!win)
            return
        _openWindows = _openWindows.concat([win])
        win.closing.connect(function () {
            var next = []
            for (var i = 0; i < root._openWindows.length; ++i) {
                if (root._openWindows[i] !== win)
                    next.push(root._openWindows[i])
            }
            root._openWindows = next
        })
    }

    function spawn(comp) {
        // Independent top-level window — no transientParent / no StandardWindow subclass.
        var win = comp.createObject(null)
        if (!win)
            return null
        track(win)
        Qt.callLater(function () {
            if (!win)
                return
            win.visible = true
            win.raise()
            win.requestActivate()
        })
        return win
    }

    function closeAll() {
        var list = _openWindows.slice()
        for (var i = 0; i < list.length; ++i) {
            if (list[i])
                list[i].close()
        }
        _openWindows = []
    }

    Component {
        id: blankComp
        BlankWindow {
            id: win
            width: 640
            height: 420
            title: qsTr("Blank shell")
            subtitle: qsTr("Empty client — add your content as children")
            Label {
                anchors.centerIn: parent
                text: qsTr("Empty client area\nDeclare controls as children of BlankWindow.")
                horizontalAlignment: Text.AlignHCenter
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                width: parent.width - 48
            }
            Button {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Theme.spacingSection
                text: qsTr("Close")
                onClicked: win.close()
            }
        }
    }

    Component {
        id: navComp
        NavigationWindow {
            id: win
            width: 960
            height: 640
            title: qsTr("Navigation shell")
            subtitle: qsTr("paneDisplayMode · back · footer")
            paneHeaderText: qsTr("Library")
            currentKey: "home"
            isBackButtonVisible: true
            isPaneSearchEnabled: true
            footerText: qsTr("Settings")
            footerSymbol: FluentIcons.Settings
            paneSearchModel: [
                { key: "home", title: qsTr("Home") },
                { key: "recent", title: qsTr("Recent") },
                { key: "docs", title: qsTr("Documents") },
                { key: "pics", title: qsTr("Pictures") }
            ]
            navModel: [
                { key: "home", title: qsTr("Home"), symbol: FluentIcons.Home, badgeValue: 2 },
                { key: "recent", title: qsTr("Recent"), symbol: FluentIcons.History },
                {
                    type: "group",
                    key: "lib",
                    title: qsTr("Library"),
                    symbol: FluentIcons.Library,
                    children: [
                        { key: "docs", title: qsTr("Documents"), symbol: FluentIcons.Document },
                        { key: "pics", title: qsTr("Pictures"), symbol: FluentIcons.Picture }
                    ]
                }
            ]

            property string bodyText: qsTr("Select an item, or use Back / Footer / pane mode.")

            rightHeader: Row {
                spacing: 8
                ComboBox {
                    id: modeBox
                    implicitWidth: 140
                    model: ["left", "leftCompact", "leftMinimal", "top", "auto"]
                    currentIndex: 0
                    onActivated: win.paneDisplayMode = model[currentIndex]
                }
                ComboBox {
                    id: heightBox
                    implicitWidth: 120
                    model: [qsTr("Tall 48"), qsTr("Standard 32")]
                    currentIndex: 0
                    onActivated: {
                        win.preferredHeightOption = currentIndex === 0
                                ? WindowHelper.TitleBarHeightTall
                                : WindowHelper.TitleBarHeightStandard
                    }
                }
            }

            content: Item {
                anchors.fill: parent
                Label {
                    anchors.centerIn: parent
                    width: parent.width - 64
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    text: win.bodyText
                    color: Theme.textSecondary
                }
                Button {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: Theme.spacingSection
                    text: qsTr("Close")
                    onClicked: win.close()
                }
            }

            onNavActivated: function (item) {
                win.bodyText = qsTr("Activated: %1").arg(item && item.title ? item.title : "?")
            }
            onBackRequested: win.bodyText = qsTr("Back requested")
            onFooterClicked: win.bodyText = qsTr("Footer (Settings) clicked")
        }
    }

    Component {
        id: blankStandardComp
        BlankWindow {
            id: win
            width: 640
            height: 420
            title: qsTr("Blank · Standard height")
            subtitle: qsTr("TitleBarHeightStandard (32)")
            preferredHeightOption: WindowHelper.TitleBarHeightStandard
            Label {
                anchors.centerIn: parent
                text: qsTr("preferredHeightOption: TitleBarHeightStandard")
                color: Theme.textSecondary
                horizontalAlignment: Text.AlignHCenter
            }
            Button {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Theme.spacingSection
                text: qsTr("Close")
                onClicked: win.close()
            }
        }
    }

    Component {
        id: menuStatusComp
        MenuStatusWindow {
            id: win
            width: 880
            height: 560
            title: qsTr("Menu + status shell")
            subtitle: qsTr("MenuBar · content · StatusBar")
            statusText: qsTr("Ready")
            statusProgress: -1
            menusInTitleBar: true

            Menu {
                title: qsTr("File")
                Action { text: qsTr("New"); onTriggered: win.statusText = qsTr("New document") }
                Action { text: qsTr("Open…"); onTriggered: win.statusText = qsTr("Open…") }
                MenuSeparator {}
                Action { text: qsTr("Close window"); onTriggered: win.close() }
            }
            Menu {
                title: qsTr("Edit")
                Action { text: qsTr("Copy"); onTriggered: win.statusText = qsTr("Copy") }
                Action {
                    text: qsTr("Simulate progress")
                    onTriggered: {
                        win.statusProgress = 0
                        win.statusProgressIndeterminate = false
                        progressAnim.restart()
                    }
                }
            }

            content: Item {
                anchors.fill: parent
                Label {
                    anchors.centerIn: parent
                    width: parent.width - 64
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Menus are embedded in the TitleBar (menusInTitleBar).\nStatusBar supports progress + segments.")
                    color: Theme.textSecondary
                }
            }

            NumberAnimation {
                id: progressAnim
                target: win
                property: "statusProgress"
                from: 0
                to: 1
                duration: 1600
                onFinished: {
                    win.statusText = qsTr("Done")
                    win.statusProgress = -1
                }
            }
        }
    }

    Component {
        id: dialogShellComp
        DialogShellWindow {
            id: win
            title: qsTr("Dialog shell")
            Label {
                anchors.centerIn: parent
                text: qsTr("DialogShellWindow — ShellWindow API + dialog paradigm")
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                width: parent.width - 48
                horizontalAlignment: Text.AlignHCenter
            }
            Button {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                text: qsTr("Close")
                onClicked: win.close()
            }
        }
    }

    Component {
        id: toolShellComp
        ToolShellWindow {
            id: win
            title: qsTr("Tool shell")
            Label {
                anchors.centerIn: parent
                text: qsTr("ToolShellWindow")
                color: Theme.textSecondary
            }
            Button {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                text: qsTr("Close")
                onClicked: win.close()
            }
        }
    }

    Component {
        id: overlayShellComp
        CompactOverlayShellWindow {
            id: win
            title: qsTr("Compact overlay")
            Label {
                anchors.centerIn: parent
                text: qsTr("CompactOverlayShellWindow")
                color: Theme.textSecondary
            }
            Button {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                text: qsTr("Close")
                onClicked: win.close()
            }
        }
    }

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
                title: qsTr("Window shells")
                subtitle: qsTr("Library shell paradigms: blank, left navigation, and menu + status workbench.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Open a shell")
                qmlSource: "BlankWindow { title: \"…\" }\nNavigationWindow { navModel: […] }\nMenuStatusWindow { Menu { } }"

                GridLayout {
                    Layout.fillWidth: true
                    columns: width > 720 ? 3 : 2
                    rowSpacing: 12
                    columnSpacing: 12

                    component LaunchCard: Rectangle {
                        id: card
                        property string titleText
                        property string bodyText
                        property var symbol: FluentIcons.OpenInNewWindow
                        signal clicked()

                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        radius: Theme.cornerCard
                        color: Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 12
                            Text {
                                text: IconSource.resolve(card.symbol, "")
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 22
                                color: Theme.accent
                                Layout.alignment: Qt.AlignTop
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                Label {
                                    text: card.titleText
                                    font.weight: Theme.fontWeightSemiBold
                                    color: Theme.textPrimary
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: card.bodyText
                                    wrapMode: Text.Wrap
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontCaption
                                }
                            }
                        }
                        HoverHandler { id: hh }
                        TapHandler { onTapped: card.clicked() }
                        scale: hh.hovered ? 1.01 : 1
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }

                    LaunchCard {
                        titleText: qsTr("BlankWindow")
                        bodyText: qsTr("Empty client — children are the content")
                        symbol: FluentIcons.OpenInNewWindow
                        onClicked: root.spawn(blankComp)
                    }
                    LaunchCard {
                        titleText: qsTr("NavigationWindow")
                        bodyText: qsTr("Modes · back · footer · title height")
                        symbol: FluentIcons.GlobalNavButton
                        onClicked: root.spawn(navComp)
                    }
                    LaunchCard {
                        titleText: qsTr("Blank · Standard 32")
                        bodyText: qsTr("TitleBarHeightStandard caption height")
                        symbol: FluentIcons.OpenInNewWindow
                        onClicked: root.spawn(blankStandardComp)
                    }
                    LaunchCard {
                        titleText: qsTr("MenuStatusWindow")
                        bodyText: qsTr("TitleBar menus + multi-segment StatusBar")
                        symbol: FluentIcons.Library
                        onClicked: root.spawn(menuStatusComp)
                    }
                    LaunchCard {
                        titleText: qsTr("DialogShellWindow")
                        bodyText: qsTr("ShellWindow + dialog paradigm")
                        symbol: FluentIcons.OpenInNewWindow
                        onClicked: root.spawn(dialogShellComp)
                    }
                    LaunchCard {
                        titleText: qsTr("ToolShellWindow")
                        bodyText: qsTr("Floating tool shell")
                        symbol: FluentIcons.OpenInNewWindow
                        onClicked: root.spawn(toolShellComp)
                    }
                    LaunchCard {
                        titleText: qsTr("CompactOverlayShell")
                        bodyText: qsTr("Always-on-top PiP shell")
                        symbol: FluentIcons.FullScreen
                        onClicked: root.spawn(overlayShellComp)
                    }
                    LaunchCard {
                        titleText: qsTr("Close all")
                        bodyText: qsTr("%1 open").arg(root._openWindows.length)
                        symbol: FluentIcons.ChromeClose
                        onClicked: root.closeAll()
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Library usage")
                qmlSource: "NavigationWindow {\n    title: \"App\"\n    paneDisplayMode: \"left\"\n    isBackButtonVisible: true\n    footerText: \"Settings\"\n    navModel: [{ key: \"home\", title: \"Home\", symbol: FluentIcons.Home }]\n    content: Label { text: \"Hello\" }\n}"

                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    color: Theme.textSecondary
                    text: qsTr("ShellWindow exposes WinUI TitleBar slots (back, leftHeader, titleBarContent, rightHeader) "
                               + "and AppWindow options (preferredHeightOption, caption buttons). "
                               + "NavigationWindow adds paneDisplayMode, footer, and merged backRequested.")
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
