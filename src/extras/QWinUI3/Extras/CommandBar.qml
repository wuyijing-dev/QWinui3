import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQml
import QWinUI3.Theme

// CommandBar — Primary/secondary command row (AppBar host).
//
//   CommandBar {
//       id: commandBar
//       AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
//       // JS overflow (compat):
//       // overflowItems / secondaryCommands: [{ text, triggered }]
//       // Real AppBar secondary host:
//       // secondaryCommandsHost: AppBarButton { text: qsTr("Find"); … }
//   }
//
//   // --- API ---
//   // signals: onOpening, onClosing, onOpened, onClosed, onMoreButtonClicked
//   // methods: open(), close(), toggle()
//   // primary: default children → primaryCommands
//   // secondary: secondaryCommandsHost (AppBar*) and/or overflowItems / secondaryCommands
//
// @notes
//   Primary + secondary AppBar command row; overflow via secondary commands.
//   secondaryCommandsHost accepts AppBarButton / AppBarToggleButton children.
//   secondaryCommands / overflowItems keep the JS [{text, triggered}] API.
//   isDynamicOverflowEnabled moves overflowing primary commands into (…).

T.Control {
    id: root

    // Default children / content slot
    default property alias contentData: primaryRow.data
    // Primary command host
    property alias primaryCommands: primaryRow
    // Overflow Menu for secondary commands
    property alias overflowMenu: overflowMenu
    // [{ text: string, triggered: function() }] — MenuItem cannot parent to Menu in Qt 6
    property var overflowItems: []
    // Compat alias of overflowItems (JS secondary list)
    property alias secondaryCommands: root.overflowItems
    // WinUI-style secondary AppBar elements (hidden host → overflow Menu)
    property alias secondaryCommandsHost: secondaryHost.data
    // Spacing between commands
    property real barSpacing: 2
    // Open / visible state
    property bool isOpen: true
    // Default AppBar label position
    property string defaultLabelPosition: "bottom"
    // How labels show when closed
    property string closedDisplayMode: "compact"
    // Show overflow (…) button
    property bool isMoreButtonVisible: true
    // Show toggle / more button
    property bool isToggleButtonVisible: true
    // WinUI IsDynamicOverflowEnabled — move overflowing primary commands into (…)
    property bool isDynamicOverflowEnabled: true

    // True while opening
    signal opening()
    // True while closing
    signal closing()
    // Emitted when opened
    signal opened()
    // Swipe content closed
    signal closed()
    // Overflow more button clicked
    signal moreButtonClicked()

    // Open / show
    function open() { isOpen = true }
    // Close / dismiss
    function close() { isOpen = false }
    // Toggle checked / expanded state
    function toggle() { isOpen = !isOpen }

    onIsOpenChanged: {
        if (isOpen) {
            opening()
            opened()
        } else {
            closing()
            closed()
        }
    }

    Accessible.role: Accessible.ToolBar
    Accessible.name: qsTr("Command bar")

    // Resolved label position
    readonly property string effectiveLabelPosition: {
        if (!root.isOpen && root.closedDisplayMode === "compact")
            return "collapsed"
        return root.defaultLabelPosition
    }
    readonly property bool _barVisible: root.isOpen || root.closedDisplayMode !== "hidden"
    readonly property bool _showPrimary: root.isOpen
                                         || root.closedDisplayMode === "compact"
    readonly property bool _showMoreOnly: !root.isOpen && root.closedDisplayMode === "minimal"
    readonly property bool _hasSecondaryHost: secondaryHost.children.length > 0
    readonly property bool _hasOverflowItems: root.overflowItems && root.overflowItems.length > 0
    property var _overflowedPrimaries: []
    readonly property bool _hasDynamicOverflow: isDynamicOverflowEnabled
                                                && _overflowedPrimaries && _overflowedPrimaries.length > 0
    readonly property bool _hasOverflow: _hasSecondaryHost || _hasOverflowItems || _hasDynamicOverflow

    function _secondaryTitle(item) {
        if (!item)
            return ""
        if (item.text && String(item.text).length)
            return String(item.text)
        if (item.Accessible && item.Accessible.name)
            return String(item.Accessible.name)
        return qsTr("Command")
    }

    function _invokeSecondary(item) {
        if (!item)
            return
        if (item.checkable && typeof item.toggle === "function") {
            item.toggle()
            return
        }
        // Emit clicked() on AppBarButton / AbstractButton
        item.clicked()
    }

    function _relayoutDynamicOverflow() {
        var kids = []
        for (var i = 0; i < primaryRow.children.length; ++i) {
            var ch = primaryRow.children[i]
            if (ch)
                kids.push(ch)
        }
        if (!isDynamicOverflowEnabled || !_showPrimary) {
            for (var r = 0; r < kids.length; ++r)
                kids[r].visible = true
            _overflowedPrimaries = []
            return
        }
        var avail = Math.max(0, primaryRow.width)
        var gap = barSpacing
        var used = 0
        var overflowed = []
        for (var n = 0; n < kids.length; ++n) {
            var item = kids[n]
            var w = item.implicitWidth > 0 ? item.implicitWidth
                  : (item.Layout && item.Layout.preferredWidth > 0 ? item.Layout.preferredWidth
                  : (item.width > 0 ? item.width : 40))
            if (n > 0 && used + gap + w > avail && avail > 0) {
                item.visible = false
                overflowed.push(item)
            } else {
                item.visible = true
                used += (n > 0 ? gap : 0) + w
            }
        }
        _overflowedPrimaries = overflowed
    }

    onIsDynamicOverflowEnabledChanged: Qt.callLater(_relayoutDynamicOverflow)
    onWidthChanged: Qt.callLater(_relayoutDynamicOverflow)
    Component.onCompleted: Qt.callLater(_relayoutDynamicOverflow)

    padding: 4
    implicitWidth: Math.max(120, barRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: {
        if (!_barVisible)
            return 0
        if (!isOpen) {
            if (closedDisplayMode === "minimal")
                return Math.max(Theme.controlHeight, padding * 2 + 32)
            return Theme.controlHeight + padding * 2
        }
        if (defaultLabelPosition === "bottom")
            return Theme.controlHeight + 22 + padding * 2
        return Theme.controlHeight + padding * 2
    }

    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }

    // Off-tree host for secondary AppBar elements
    Item {
        id: secondaryHost
        width: 0
        height: 0
        visible: false
        enabled: false
    }

    background: Rectangle {
        color: Theme.bgAcrylic
        border.width: root._barVisible ? 1 : 0
        border.color: Theme.strokeDivider
        radius: Theme.cornerControl
        opacity: root.isOpen ? 1 : 0.85
        visible: root._barVisible
        Behavior on opacity {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: 1
            color: Theme.dark ? "#12FFFFFF" : "#0F000000"
            opacity: 0.5
            radius: 1
            visible: root.isOpen
        }
    }

    contentItem: Item {
        implicitWidth: barRow.implicitWidth
        implicitHeight: barRow.implicitHeight
        clip: true
        visible: root._barVisible

        RowLayout {
            id: barRow
            anchors.fill: parent
            spacing: root.barSpacing

            RowLayout {
                id: primaryRow
                spacing: root.barSpacing
                Layout.fillWidth: true
                clip: root.isDynamicOverflowEnabled
                visible: root._showPrimary
                opacity: visible ? 1 : 0
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                onWidthChanged: Qt.callLater(root._relayoutDynamicOverflow)
                onChildrenChanged: Qt.callLater(root._relayoutDynamicOverflow)
            }

            Item { Layout.fillWidth: true; visible: root._showMoreOnly }

            ToolButton {
                id: moreBtn
                visible: root.isMoreButtonVisible
                         && root._hasOverflow
                         && (root.isOpen || root.closedDisplayMode === "minimal"
                             || root.closedDisplayMode === "compact")
                Layout.preferredWidth: 36
                Layout.preferredHeight: Theme.controlHeight
                text: FluentIcons.More
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 14
                Accessible.name: root.isOpen ? qsTr("See more") : qsTr("Open command bar")
                scale: down && !Theme.reducedMotion ? 0.94 : 1
                onClicked: {
                    root.moreButtonClicked()
                    if (!root.isOpen && root.closedDisplayMode === "minimal")
                        root.isOpen = true
                    else
                        overflowMenu.popup(moreBtn, 0, moreBtn.height + 4)
                }
                ToolTip.visible: hovered
                ToolTip.text: root.isOpen ? qsTr("See more") : qsTr("Open command bar")
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: moreBtn.down ? Theme.fillSubtleTertiary
                         : (moreBtn.hovered || moreBtn.visualFocus ? Theme.fillSubtle : "transparent")
                    border.width: moreBtn.visualFocus ? 1 : 0
                    border.color: Theme.accent
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                        }
                    }
                }
            }

            ToolButton {
                id: toggleBtn
                visible: root.isToggleButtonVisible && root.closedDisplayMode !== "hidden"
                Layout.preferredWidth: 36
                Layout.preferredHeight: Theme.controlHeight
                text: root.isOpen ? FluentIcons.ChevronUp : FluentIcons.ChevronDown
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 12
                Accessible.name: root.isOpen ? qsTr("Collapse") : qsTr("Expand")
                scale: down && !Theme.reducedMotion ? 0.94 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                onClicked: root.toggle()
                ToolTip.visible: hovered
                ToolTip.text: root.isOpen ? qsTr("Collapse") : qsTr("Expand")
                background: Rectangle {
                    radius: Theme.cornerControl
                    color: toggleBtn.down ? Theme.fillSubtleTertiary
                         : (toggleBtn.hovered || toggleBtn.visualFocus ? Theme.fillSubtle : "transparent")
                    border.width: toggleBtn.visualFocus ? 1 : 0
                    border.color: Theme.accent
                }
            }
        }

        Menu {
            id: overflowMenu
            Instantiator {
                model: root.overflowItems
                delegate: MenuItem {
                    required property var modelData
                    text: modelData && modelData.text ? modelData.text : ""
                    onTriggered: {
                        if (modelData && typeof modelData.triggered === "function")
                            modelData.triggered()
                    }
                }
                onObjectAdded: function (index, object) {
                    overflowMenu.insertItem(index, object)
                }
                onObjectRemoved: function (index, object) {
                    overflowMenu.removeItem(object)
                }
            }
            Instantiator {
                model: secondaryHost.children
                delegate: MenuItem {
                    required property var modelData
                    text: root._secondaryTitle(modelData)
                    enabled: modelData ? modelData.enabled !== false : true
                    checkable: !!(modelData && modelData.checkable)
                    checked: !!(modelData && modelData.checked)
                    onTriggered: root._invokeSecondary(modelData)
                }
                onObjectAdded: function (index, object) {
                    overflowMenu.addItem(object)
                }
                onObjectRemoved: function (index, object) {
                    overflowMenu.removeItem(object)
                }
            }
            Instantiator {
                model: root._overflowedPrimaries
                delegate: MenuItem {
                    required property var modelData
                    text: root._secondaryTitle(modelData)
                    enabled: modelData ? modelData.enabled !== false : true
                    checkable: !!(modelData && modelData.checkable)
                    checked: !!(modelData && modelData.checked)
                    onTriggered: root._invokeSecondary(modelData)
                }
                onObjectAdded: function (index, object) {
                    overflowMenu.addItem(object)
                }
                onObjectRemoved: function (index, object) {
                    overflowMenu.removeItem(object)
                }
            }
        }
    }
}
