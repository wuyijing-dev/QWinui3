import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

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
        var win = comp.createObject(null)
        if (!win)
            return
        track(win)
        win.visible = true
        win.raise()
        win.requestActivate()
    }

    function closeAll() {
        var list = _openWindows.slice()
        for (var i = 0; i < list.length; ++i) {
            if (list[i])
                list[i].close()
        }
        _openWindows = []
    }

    component DemoChrome: PlatformTitleBar {
        id: chrome
        required property var host
        required property string heading
        property bool allowMaximize: true
        targetWindow: host
        showMaximize: allowMaximize
        showMinimize: true

        TitleBar {
            anchors.fill: parent
            embedded: true
            dragWindow: chrome.host
            useSystemMove: true
            searchEnabled: false
            title: chrome.heading
            onWidthChanged: chrome.reportHitTest()
            onHeightChanged: chrome.reportHitTest()
        }

        Component.onCompleted: Qt.callLater(function () { chrome.reportHitTest() })
    }

    Component {
        id: standardComp
        StandardWindow {
            id: win
            width: 720
            height: 480
            title: qsTr("Standard window")
            backdrop: WindowHelper.BackdropSolid
            header: DemoChrome {
                host: win
                heading: qsTr("StandardWindow")
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                spacing: Theme.spacing
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("Primary app window paradigm. Drag the title bar to move.")
                    color: Theme.textSecondary
                }
                Item { Layout.fillHeight: true }
                Button {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Close")
                    onClicked: win.close()
                }
            }
            Component.onCompleted: Qt.callLater(function () {
                if (header && header.reportHitTest)
                    header.reportHitTest()
            })
        }
    }

    Component {
        id: dialogComp
        DialogWindow {
            id: win
            title: qsTr("Dialog window")
            header: DemoChrome {
                host: win
                heading: qsTr("DialogWindow")
                allowMaximize: false
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                spacing: Theme.spacing
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("Dialog paradigm — centered, compact, no maximize. Drag the title bar.")
                    color: Theme.textSecondary
                }
                TextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("Sample input")
                }
                Item { Layout.fillHeight: true }
                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Button { text: qsTr("Cancel"); onClicked: win.close() }
                    AccentButton { text: qsTr("OK"); onClicked: win.close() }
                }
            }
        }
    }

    Component {
        id: toolComp
        ToolWindow {
            id: win
            title: qsTr("Tool window")
            header: DemoChrome {
                host: win
                heading: qsTr("ToolWindow")
                allowMaximize: false
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("Tool / palette paradigm (Qt.Tool). Stays handy for inspectors.")
                    color: Theme.textSecondary
                }
                Switch { text: qsTr("Sample option"); checked: true }
                Slider { Layout.fillWidth: true; from: 0; to: 100; value: 40 }
            }
        }
    }

    Component {
        id: micaComp
        StandardWindow {
            id: win
            width: 640
            height: 420
            title: qsTr("Mica sample")
            backdrop: WindowHelper.BackdropMica
            header: DemoChrome {
                host: win
                heading: qsTr("Standard + Mica")
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("Same StandardWindow paradigm with Mica backdrop.")
                    color: Theme.textSecondary
                }
                AcrylicSurface {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("AcrylicSurface card")
                        color: Theme.textPrimary
                    }
                }
                Item { Layout.fillHeight: true }
                Button {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Close")
                    onClicked: win.close()
                }
            }
        }
    }

    Component {
        id: acrylicComp
        StandardWindow {
            id: win
            width: 640
            height: 420
            title: qsTr("Acrylic sample")
            backdrop: WindowHelper.BackdropAcrylic
            header: DemoChrome {
                host: win
                heading: qsTr("Standard + Acrylic")
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSection
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    text: qsTr("StandardWindow with Acrylic system backdrop.")
                    color: Theme.textSecondary
                }
                Item { Layout.fillHeight: true }
                Button {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Close")
                    onClicked: win.close()
                }
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
                title: qsTr("Window gallery")
                subtitle: qsTr("Open Standard, Dialog, Tool, and material variants. Each window has a draggable title bar.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Open a window")
                qmlSource: "StandardWindow { }\nDialogWindow { }\nToolWindow { }"

                GridLayout {
                    Layout.fillWidth: true
                    columns: width > 720 ? 3 : 2
                    rowSpacing: 12
                    columnSpacing: 12

                    component LaunchCard: Rectangle {
                        property string titleText
                        property string bodyText
                        property string glyph: "\uE8A5"
                        signal clicked()

                        Layout.fillWidth: true
                        Layout.preferredHeight: 112
                        radius: Theme.cornerCard
                        color: Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 12
                            Text {
                                text: glyph
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 22
                                color: Theme.accent
                                Layout.alignment: Qt.AlignTop
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                Label {
                                    text: titleText
                                    font.weight: Theme.fontWeightSemiBold
                                    color: Theme.textPrimary
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: bodyText
                                    wrapMode: Text.Wrap
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.fontCaption
                                }
                            }
                        }
                        HoverHandler { id: hh }
                        TapHandler { onTapped: parent.clicked() }
                        scale: hh.hovered ? 1.01 : 1
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }

                    LaunchCard {
                        titleText: qsTr("StandardWindow")
                        bodyText: qsTr("Primary application window")
                        glyph: "\uE8A5"
                        onClicked: root.spawn(standardComp)
                    }
                    LaunchCard {
                        titleText: qsTr("DialogWindow")
                        bodyText: qsTr("Centered dialog, no maximize")
                        glyph: "\uE8BD"
                        onClicked: root.spawn(dialogComp)
                    }
                    LaunchCard {
                        titleText: qsTr("ToolWindow")
                        bodyText: qsTr("Palette / inspector (Qt.Tool)")
                        glyph: "\uE90F"
                        onClicked: root.spawn(toolComp)
                    }
                    LaunchCard {
                        titleText: qsTr("Standard + Mica")
                        bodyText: qsTr("Same paradigm, Mica backdrop")
                        glyph: "\uE790"
                        onClicked: root.spawn(micaComp)
                    }
                    LaunchCard {
                        titleText: qsTr("Standard + Acrylic")
                        bodyText: qsTr("Same paradigm, Acrylic backdrop")
                        glyph: "\uEA86"
                        onClicked: root.spawn(acrylicComp)
                    }
                    LaunchCard {
                        titleText: qsTr("Close all")
                        bodyText: qsTr("%1 open").arg(root._openWindows.length)
                        glyph: "\uE711"
                        onClicked: root.closeAll()
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
