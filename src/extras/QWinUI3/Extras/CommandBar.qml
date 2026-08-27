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
//   Product toolbar preset: compact: false; isDynamicOverflowEnabled: true;
//   isToggleButtonVisible: true; defaultLabelPosition: "bottom" — docs/recipes.md.
//   commandAlignment left|center|right|stretch; compact densifies like Edge toolbar.
//   overflowOpensUpward false opens down (top toolbars); auto flips when space is tight.
//   Keyboard: Tab into bar; F10 / Alt+Down opens overflow (…); Esc closes overflow Menu.
//   AppBarButton: set text or Accessible.name; optional keyboardAcceleratorText hint.

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
    // Primary command alignment: left | center | right | stretch (default)
    property string commandAlignment: "stretch"
    // Dense Edge-like toolbar (also follows Theme.density === "compact" when unset path)
    property bool compact: Theme.density === "compact"
    // Prefer opening overflow upward; false = down (typical top toolbar)
    property bool overflowOpensUpward: false

    readonly property string _align: String(commandAlignment).toLowerCase()
    readonly property bool _alignStretch: _align === "stretch" || _align.length === 0
    readonly property bool _alignCenter: _align === "center"
    readonly property bool _alignRight: _align === "right"
    readonly property bool _alignLeft: _align === "left" || (!_alignStretch && !_alignCenter && !_alignRight)
    readonly property real _chromeHeight: compact ? Math.max(28, Theme.controlHeight - 4) : Theme.controlHeight
    readonly property real _moreWidth: compact ? 32 : 36

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
    Accessible.description: root.isOpen ? qsTr("Expanded") : qsTr("Collapsed")
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_F10
                || (event.key === Qt.Key_Down && (event.modifiers & Qt.AltModifier))) {
            if (moreBtn.visible && moreBtn.enabled) {
                moreBtn.clicked()
                event.accepted = true
            }
        } else if (event.key === Qt.Key_Escape && overflowMenu.visible) {
            overflowMenu.close()
            event.accepted = true
        }
    }

    // Resolved label position
    readonly property string effectiveLabelPosition: {
        if (root.compact || root._showMinimalChrome)
            return "collapsed"
        if (!root.isOpen && root.closedDisplayMode === "compact")
            return "collapsed"
        return root.defaultLabelPosition
    }
    readonly property bool _barVisible: root.isOpen || root.closedDisplayMode !== "hidden"
    readonly property bool _showPrimary: root.isOpen
                                         || root.closedDisplayMode === "compact"
                                         || root._showMinimalChrome
    readonly property bool _showMoreOnly: !root.isOpen && root.closedDisplayMode === "minimal"
    readonly property bool _showMinimalChrome: !root.isOpen && root.closedDisplayMode === "minimal"
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
    onEffectiveLabelPositionChanged: Qt.callLater(function () { root._syncBarChrome() })
    onCompactChanged: Qt.callLater(function () { root._syncBarChrome() })
    onCommandAlignmentChanged: Qt.callLater(_relayoutDynamicOverflow)
    Component.onCompleted: {
        Qt.callLater(_relayoutDynamicOverflow)
        Qt.callLater(function () { root._syncBarChrome() })
    }

    // Push label position + compact density into AppBar* children
    function _syncBarChrome() {
        function syncRow(row) {
            if (!row)
                return
            var kids = row.children || []
            for (var i = 0; i < kids.length; ++i) {
                var c = kids[i]
                if (!c)
                    continue
                if (c.hasOwnProperty("barLabelPosition"))
                    c.barLabelPosition = root.effectiveLabelPosition
                if (c.hasOwnProperty("barCompact"))
                    c.barCompact = root.compact
            }
        }
        syncRow(primaryRow)
        syncRow(secondaryHost)
    }

    function _openOverflowMenu() {
        if (!moreBtn.visible)
            return
        var openUp = root.overflowOpensUpward
        if (!openUp) {
            var win = root.Window.window
            var overlay = (typeof Overlay !== "undefined" && Overlay.overlay) ? Overlay.overlay : null
            var hostH = overlay && overlay.height > 0 ? overlay.height
                       : (win ? win.height : 0)
            if (hostH > 0) {
                var globalY = moreBtn.mapToItem(overlay || win.contentItem, 0, moreBtn.height).y
                var spaceBelow = hostH - globalY
                var estimate = Math.max(120, overflowMenu.implicitHeight || 160)
                if (spaceBelow < estimate)
                    openUp = true
            }
        }
        if (openUp)
            overflowMenu.popup(moreBtn, 0, -Math.max(overflowMenu.implicitHeight, 1) - 4)
        else
            overflowMenu.popup(moreBtn, 0, moreBtn.height + 4)
    }

    hoverEnabled: true
    padding: compact ? 2 : 4
    implicitWidth: Math.max(120, barRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: {
        if (!_barVisible)
            return 0
        if (!isOpen) {
            if (closedDisplayMode === "minimal")
                return Math.max(_chromeHeight, padding * 2 + (compact ? 28 : 32))
            return _chromeHeight + padding * 2
        }
        if (defaultLabelPosition === "bottom" && !compact)
            return Theme.controlHeight + 22 + padding * 2
        return _chromeHeight + padding * 2
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
        onChildrenChanged: Qt.callLater(function () { root._syncBarChrome() })
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
    }

    contentItem: Item {
        implicitWidth: Math.max(barRow.implicitWidth, root.width)
        implicitHeight: barRow.implicitHeight
        width: root.width
        height: implicitHeight
        clip: false
        visible: root._barVisible

        RowLayout {
            id: barRow
            anchors.fill: parent
            spacing: root.barSpacing
            Layout.alignment: Qt.AlignVCenter

            // Leading spring for center / right alignment
            Item {
                Layout.fillWidth: root._alignCenter || root._alignRight
                visible: root._alignCenter || root._alignRight
            }

            RowLayout {
                id: primaryRow
                spacing: root.barSpacing
                Layout.fillWidth: root._alignStretch
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: root._alignStretch ? -1
                                   : Math.max(0, barRow.width
                                              - (moreBtn.visible ? root._moreWidth + root.barSpacing : 0)
                                              - (toggleBtn.visible ? root._moreWidth + root.barSpacing : 0)
                                              - 8)
                clip: false
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
                onChildrenChanged: Qt.callLater(function () {
                    root._syncBarChrome()
                    root._relayoutDynamicOverflow()
                })
            }

            // Trailing spring for left / center (stretch uses primary fillWidth instead)
            Item {
                Layout.fillWidth: root._alignStretch || root._alignLeft || root._alignCenter || root._showMoreOnly
                visible: root._alignStretch || root._alignLeft || root._alignCenter || root._showMoreOnly
            }

            ToolButton {
                id: moreBtn
                visible: root.isMoreButtonVisible
                         && (root._hasOverflow || root._showMinimalChrome)
                         && (root.isOpen || root.closedDisplayMode === "minimal"
                             || root.closedDisplayMode === "compact")
                Layout.preferredWidth: root._moreWidth
                Layout.preferredHeight: root._chromeHeight
                text: FluentIcons.More
                font: Theme.iconFontFor(root.compact ? 12 : 14)
                focusPolicy: Qt.StrongFocus
                Accessible.role: Accessible.Button
                Accessible.name: root.isOpen ? qsTr("See more") : qsTr("Open command bar")
                scale: down && !Theme.reducedMotion ? 0.94 : 1
                onClicked: {
                    root.moreButtonClicked()
                    if (!root.isOpen && root.closedDisplayMode === "minimal")
                        root.isOpen = true
                    else
                        root._openOverflowMenu()
                }
                Keys.onReturnPressed: moreBtn.clicked()
                Keys.onEnterPressed: moreBtn.clicked()
                Keys.onSpacePressed: moreBtn.clicked()
                ToolTip.visible: hovered
                ToolTip.text: root.isOpen ? qsTr("See more") : qsTr("Open command bar")
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
                background: Item {
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.cornerControl
                        color: moreBtn.down ? Theme.fillSubtleTertiary
                             : (moreBtn.hovered || moreBtn.visualFocus ? Theme.fillSubtle : "transparent")
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionFast)
                            }
                        }
                    }
                    FocusStroke {
                        anchors.fill: parent
                        show: moreBtn.visualFocus
                        frameRadius: Theme.cornerControl
                    }
                }
            }

            ToolButton {
                id: toggleBtn
                visible: (root.isToggleButtonVisible && root.closedDisplayMode !== "hidden")
                         || root._showMinimalChrome
                Layout.preferredWidth: root._moreWidth
                Layout.preferredHeight: root._chromeHeight
                text: root.isOpen ? FluentIcons.ChevronUp : FluentIcons.ChevronDown
                font: Theme.iconFontFor(12)
                focusPolicy: Qt.StrongFocus
                Accessible.role: Accessible.Button
                Accessible.name: root.isOpen ? qsTr("Collapse") : qsTr("Expand")
                scale: down && !Theme.reducedMotion ? 0.94 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                onClicked: root.toggle()
                Keys.onReturnPressed: toggleBtn.clicked()
                Keys.onEnterPressed: toggleBtn.clicked()
                Keys.onSpacePressed: toggleBtn.clicked()
                ToolTip.visible: hovered
                ToolTip.text: root.isOpen ? qsTr("Collapse") : qsTr("Expand")
                background: Item {
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.cornerControl
                        color: toggleBtn.down ? Theme.fillSubtleTertiary
                             : (toggleBtn.hovered || toggleBtn.visualFocus ? Theme.fillSubtle : "transparent")
                    }
                    FocusStroke {
                        anchors.fill: parent
                        show: toggleBtn.visualFocus
                        frameRadius: Theme.cornerControl
                    }
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
