import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme

// TitleBar — WinUI TitleBar content chrome (not caption buttons).
//
//   TitleBar {
//       id: titleBar
//       title: qsTr("App")
//       subtitle: qsTr("Optional")
//       symbol: FluentIcons.Home
//   }
//
//   // --- API ---
//   // signals: onSearchActivated, onSearchTextEdited, onBackRequested, onPaneToggleRequested
//   // methods: clientExcludeRectsFor(window)
//   // titleBar.clientExcludeRectsFor(window)
//
// @notes
//   WinUI-style title bar for ShellWindow / WindowChrome.
//   preferredHeightOption: standard (32) or tall (48) via WindowHelper.
//   Caption hit-test uses screen-logical rects (mapToGlobal) so maximize/fullscreen
//   caption buttons stay clickable.

Item {
    id: root

    // Primary title text
    property string title: qsTr("Application")
    // Secondary subtitle text
    property string subtitle: ""
    // Image icon when symbol / iconGlyph are empty
    property url iconSource: ""
    // FluentIcons value (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Title-bar search field text
    property alias searchText: searchField.text
    // Suggestion rows for the built-in search field
    property var searchModel: []
    // When true and content slot is empty, show built-in catalog search (Gallery default).
    property bool searchEnabled: true
    // Show back button
    property bool isBackButtonVisible: false
    // Enable back button
    property bool isBackButtonEnabled: true
    // Show navigation pane toggle
    property bool isPaneToggleButtonVisible: false
    // Hosted inside PlatformTitleBar / WindowChrome (hides local acrylic plate)
    property bool embedded: false
    // Use Window.startSystemMove for caption drag
    property bool useSystemMove: true
    // Extra right inset when caption buttons are drawn outside this item
    property real trailingReserve: 0
    // Window used for system move
    property var dragWindow: null
    // WinUI TitleBarHeightOption — Standard 32 / Tall 48 (from PlatformTitleBar).
    property real preferredHeight: 48

    // Resolved glyph string
    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)
    // Content slot has children
    readonly property bool hasContentChildren: customContentHost.children.length > 0
    // Show built-in search field
    readonly property bool showBuiltInSearch: searchEnabled && !hasContentChildren
    readonly property real _verticalPad: preferredHeight <= 32 ? 8 : 16

    // WinUI LeftHeader slot
    property alias leftHeader: leftHeaderSlot.data
    // WinUI Content slot (replaces built-in search when set)
    property alias content: customContentHost.data
    // WinUI RightHeader — also the default children slot for trailing actions.
    default property alias rightHeader: trailingRow.data
    // Trailing slot
    property alias trailing: trailingRow.data

    // Emitted when a search result is activated
    signal searchActivated(var item)
    // Emitted when search text changes
    signal searchTextEdited(string text)
    // Emitted when back is requested
    signal backRequested()
    // Emitted when pane toggle is clicked
    signal paneToggleRequested()

    height: Math.max(preferredHeight, titleCol.implicitHeight + _verticalPad)
    implicitHeight: height

    // Screen-logical rects that must stay HTCLIENT under native chrome.
    // Use childrenRect for stretch hosts so menusInTitleBar does not claim the
    // whole fill-width slot (caption drag vs menu clicks).
    function clientExcludeRectsFor(window) {
        var list = []
        // Push a rectangle into hit-test clientRects
        function pushRect(gx, gy, w, h) {
            if (w <= 0 || h <= 0)
                return
            list.push(Qt.rect(Math.floor(gx) - 2,
                              Math.floor(gy) - 2,
                              Math.ceil(w) + 4,
                              Math.ceil(h) + 4))
        }
        // Push an item onto the stack
        function pushItem(item) {
            if (!item || !item.visible || item.width <= 0 || item.height <= 0)
                return
            var g = item.mapToGlobal(0, 0)
            pushRect(g.x, g.y, item.width, item.height)
        }
        // Push content into the host
        function pushHostContent(host) {
            if (!host || !host.visible || host.children.length === 0)
                return
            var cr = host.childrenRect
            if (cr.width <= 0 || cr.height <= 0)
                return
            var g = host.mapToGlobal(cr.x, cr.y)
            pushRect(g.x, g.y, cr.width, Math.max(cr.height, host.height * 0.5))
        }
        pushItem(backBtn)
        pushItem(paneBtn)
        pushHostContent(leftHeaderSlot)
        if (root.hasContentChildren)
            pushHostContent(customContentHost)
        if (root.showBuiltInSearch && searchField.visible)
            pushItem(searchField)
        pushHostContent(trailingRow)
        return list
    }

    Rectangle {
        anchors.fill: parent
        visible: !root.embedded
        color: Theme.bgAcrylic
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: root.trailingReserve
        z: -1
        enabled: root.embedded && root.dragWindow
        acceptedButtons: Qt.LeftButton
        onPressed: {
            if (root.dragWindow && root.dragWindow.startSystemMove)
                root.dragWindow.startSystemMove()
        }
        onDoubleClicked: {
            if (!root.dragWindow)
                return
            if (root.dragWindow.visibility === Window.Maximized
                    || root.dragWindow.visibility === Window.FullScreen)
                root.dragWindow.showNormal()
            else
                root.dragWindow.showMaximized()
        }
    }

    component TitleChromeButton: AbstractButton {
        id: tbtn
        // Fluent glyph drawn in the button
        property string glyph: ""
        implicitWidth: 40
        implicitHeight: 36
        hoverEnabled: true
        focusPolicy: Qt.StrongFocus
        scale: down && !Theme.reducedMotion ? 0.94 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        contentItem: Text {
            text: tbtn.glyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 14
            color: tbtn.enabled
                   ? (tbtn.down ? Theme.textPrimary : Theme.textSecondary)
                   : Theme.textDisabled
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: Theme.cornerControl
            color: {
                if (!tbtn.enabled)
                    return "transparent"
                if (tbtn.down)
                    return Theme.fillSubtleTertiary
                if (tbtn.hovered || tbtn.visualFocus)
                    return Theme.fillSubtle
                return "transparent"
            }
            border.width: tbtn.visualFocus ? 1 : 0
            border.color: Theme.accent
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8 + root.trailingReserve
        spacing: 4

        TitleChromeButton {
            id: backBtn
            visible: root.isBackButtonVisible
            enabled: root.isBackButtonEnabled
            glyph: FluentIcons.Back
            Accessible.name: qsTr("Back")
            onClicked: root.backRequested()
            Layout.alignment: Qt.AlignVCenter
        }

        TitleChromeButton {
            id: paneBtn
            visible: root.isPaneToggleButtonVisible
            glyph: FluentIcons.GlobalNavButton
            Accessible.name: qsTr("Toggle navigation")
            onClicked: root.paneToggleRequested()
            Layout.alignment: Qt.AlignVCenter
        }

        Row {
            id: leftHeaderSlot
            spacing: 4
            Layout.alignment: Qt.AlignVCenter
            visible: children.length > 0
        }

        Item {
            visible: root.effectiveIconGlyph.length > 0 || root.iconSource.toString().length > 0
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
            Text {
                anchors.centerIn: parent
                visible: root.effectiveIconGlyph.length > 0
                text: root.effectiveIconGlyph
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 16
                color: Theme.accent
            }
            Image {
                anchors.fill: parent
                visible: root.effectiveIconGlyph.length === 0
                         && root.iconSource.toString().length > 0
                source: root.iconSource
                sourceSize.width: 16
                sourceSize.height: 16
                fillMode: Image.PreserveAspectFit
            }
        }

        ColumnLayout {
            id: titleCol
            spacing: 0
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 220
            Text {
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Text {
                visible: root.subtitle.length > 0
                text: root.subtitle
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        Item {
            id: contentSlot
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.searchBoxHeight
            Layout.maximumWidth: 560
            Layout.alignment: Qt.AlignVCenter
            visible: root.hasContentChildren || root.showBuiltInSearch
            clip: true

            Item {
                id: customContentHost
                anchors.fill: parent
                visible: root.hasContentChildren
            }

            Item {
                anchors.fill: parent
                visible: root.showBuiltInSearch

                TextField {
                    id: searchField
                    anchors.fill: parent
                    placeholderText: qsTr("Search controls")
                    leftPadding: 36
                    rightPadding: clearBtn.visible ? 36 : Theme.paddingControlH
                    onTextChanged: {
                        if (text.length === 0) {
                            searchDebounce.stop()
                            root.searchTextEdited("")
                            suggestPopup.close()
                            return
                        }
                        searchDebounce.restart()
                    }
                    Keys.onDownPressed: suggestList.forceActiveFocus()
                    Keys.onReturnPressed: {
                        if (root.searchModel.length > 0)
                            root.searchActivated(root.searchModel[0])
                    }
                    Keys.onEscapePressed: {
                        text = ""
                        suggestPopup.close()
                    }
                }

                Timer {
                    id: searchDebounce
                    interval: 100
                    repeat: false
                    onTriggered: {
                        root.searchTextEdited(searchField.text)
                        if (searchField.text.length > 0 && root.searchModel.length > 0)
                            suggestPopup.open()
                        else if (searchField.text.length === 0)
                            suggestPopup.close()
                    }
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: FluentIcons.Search
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 14
                    color: searchField.activeFocus ? Theme.accent : Theme.textSecondary
                    z: 1
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }

                AbstractButton {
                    id: clearBtn
                    visible: searchField.text.length > 0
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32
                    height: 32
                    z: 1
                    hoverEnabled: true
                    Accessible.name: qsTr("Clear search")
                    onClicked: {
                        searchField.text = ""
                        searchField.forceActiveFocus()
                    }
                    contentItem: Text {
                        text: FluentIcons.ChromeClose
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 10
                        color: clearBtn.hovered ? Theme.textPrimary : Theme.textSecondary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: Theme.cornerControl
                        color: clearBtn.down ? Theme.fillSubtleTertiary
                             : (clearBtn.hovered ? Theme.fillSubtle : "transparent")
                    }
                }

                Popup {
                    id: suggestPopup
                    y: searchField.height + 4
                    width: searchField.width
                    padding: 4
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                    visible: searchField.activeFocus
                             && root.searchText.length > 0
                             && root.searchModel.length > 0
                    transformOrigin: Item.Top

                    enter: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0; to: 1
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingEnter
                        }
                        NumberAnimation {
                            property: "scale"
                            from: 0.98; to: 1
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingEnter
                        }
                    }
                    exit: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 1; to: 0
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingExit
                        }
                    }

                    background: ElevatedChrome {
                        color: Theme.bgCardElevated
                        radius: Theme.cornerOverlay
                        borderColor: Theme.strokeCard
                        borderWidth: 1
                        elevation: 6
                        shadowOpacity: Theme.dark ? 0.3 : 0.16
                    }

                    contentItem: ListView {
                        id: suggestList
                        implicitHeight: Math.min(contentHeight, 280)
                        clip: true
                        model: root.searchModel
                        highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionFast)
                        delegate: ItemDelegate {
                            required property var modelData
                            required property int index
                            width: ListView.view.width
                            height: Theme.navItemHeight
                            text: modelData.title
                            onClicked: {
                                root.searchActivated(modelData)
                                suggestPopup.close()
                                searchField.text = ""
                            }

                            contentItem: RowLayout {
                                spacing: 12
                                Text {
                                    text: IconSource.resolve(modelData.symbol || "", modelData.icon || "")
                                          || FluentIcons.Document
                                    font.family: Theme.fontFamilyIcon
                                    font.pixelSize: 16
                                    color: Theme.textSecondary
                                }
                                ColumnLayout {
                                    spacing: 0
                                    Layout.fillWidth: true
                                    Text {
                                        text: modelData.title !== undefined ? String(modelData.title) : ""
                                        font.pixelSize: Theme.fontBody
                                        color: Theme.textPrimary
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        visible: modelData.description !== undefined
                                                 && modelData.description !== null
                                                 && String(modelData.description).length > 0
                                        text: modelData.description !== undefined && modelData.description !== null
                                              ? String(modelData.description) : ""
                                        font.pixelSize: Theme.fontCaption
                                        color: Theme.textSecondary
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true; Layout.preferredWidth: 1 }

        Row {
            id: trailingRow
            spacing: Theme.spacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }
}
