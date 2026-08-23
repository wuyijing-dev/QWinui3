import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQml
import QWinUI3.Theme

// BreadcrumbBar — Path trail; model items raise itemClicked.
//
//   BreadcrumbBar {
//       id: breadcrumbBar
//       model: [{ title: "Home" }, { title: "Docs" }]
//       onItemClicked: (index) => navigate(index)
//   }
//
//   // --- API ---
//   // signals: onItemClicked, onItemInvoked
//   // methods: crumbTitle(data), crumbIcon(data), isCurrent(index), isClickable(entry)
//   // breadcrumbBar.crumbTitle(data)
//   // breadcrumbBar.crumbIcon(data)
//   // breadcrumbBar.isCurrent(index)
//   // breadcrumbBar.isClickable(entry)
//
// @notes
//   Path trail from model [{ title, icon? }]; itemClicked(index); overflow collapses.

T.Control {
    id: root

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: Math.max(0, (model ? model.length : 1) - 1)
    // Currently selected model item (WinUI SelectedItem)
    readonly property var selectedItem: {
        if (!model || currentIndex < 0 || currentIndex >= model.length)
            return null
        return model[currentIndex]
    }
    // Collapse middle crumbs when count exceeds this (0 = show all)
    property int maxVisibleItems: 0
    // WinUI MaxItems alias
    property alias maxItems: root.maxVisibleItems
    // WinUI: current/last crumb is usually non-interactive
    property bool lastItemClickable: false
    // Breadcrumb separator FluentIcons symbol
    property var separatorSymbol: FluentIcons.ChevronRight
    // Breadcrumb separator glyph string
    property string separatorGlyph: ""
    // Override list name when multiple trails share a page (2.29)
    property string accessibleName: qsTr("Breadcrumb")
    // Qt 6.8+ live region for crumb activation (2.29)
    property bool announceChanges: true
    // Emitted when an item is clicked
    signal itemClicked(int index)
    // WinUI ItemInvoked
    signal itemInvoked(int index)

    // Resolved separator glyph
    readonly property string effectiveSeparatorGlyph: IconSource.resolve(separatorSymbol, separatorGlyph)

    implicitWidth: row.implicitWidth
    implicitHeight: Theme.controlHeight
    padding: 0
    font.pixelSize: Theme.fontBody
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    property int _focusVisibleIndex: 0
    property Item _ellipsisCrumb: null
    Accessible.role: Accessible.List
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Breadcrumb")
    Accessible.description: {
        var m = root.model || []
        var parts = []
        for (var i = 0; i < m.length; ++i)
            parts.push(root.crumbTitle(m[i]))
        return parts.join(" › ")
    }

    // Visible (non-overflow) crumbs
    readonly property var visibleModel: {
        var m = root.model || []
        var maxV = root.maxVisibleItems
        if (maxV <= 0 || m.length <= maxV)
            return m.map(function (item, i) { return { data: item, index: i, ellipsis: false } })

        var keepTail = Math.max(1, maxV - 2)
        var out = []
        out.push({ data: m[0], index: 0, ellipsis: false })
        out.push({ data: "…", index: -1, ellipsis: true })
        for (var i = m.length - keepTail; i < m.length; ++i)
            out.push({ data: m[i], index: i, ellipsis: false })
        return out
    }

    // Overflow crumb items
    readonly property var overflowModel: {
        var m = root.model || []
        var maxV = root.maxVisibleItems
        if (maxV <= 0 || m.length <= maxV)
            return []
        var keepTail = Math.max(1, maxV - 2)
        var start = 1
        var end = m.length - keepTail
        var out = []
        for (var i = start; i < end; ++i)
            out.push({ data: m[i], index: i })
        return out
    }

    // Title text for a breadcrumb item
    function crumbTitle(data) {
        if (typeof data === "string")
            return data
        return (data && data.title) ? data.title : ""
    }

    // Icon for a breadcrumb item
    function crumbIcon(data) {
        if (typeof data !== "object" || !data)
            return ""
        return IconSource.resolve(data.symbol || "", data.icon || data.glyph || "")
    }

    // True when this crumb is the current page
    function isCurrent(index) {
        return !isNaN(index) && index >= 0 && index === root.currentIndex
    }

    // Map NavigationView.breadcrumbPathForKey() to a BreadcrumbBar model (2.23)
    function modelFromNavigationPath(path) {
        if (!path)
            return []
        var out = []
        for (var i = 0; i < path.length; ++i) {
            var e = path[i]
            out.push({ title: e.title || "", symbol: e.symbol || e.icon || "" })
        }
        return out
    }

    // Emit clicked when activated
    function isClickable(entry) {
        if (!entry || entry.ellipsis)
            return true
        if (isCurrent(entry.index) && !root.lastItemClickable)
            return false
        return true
    }

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    function _announceCrumb(index) {
        if (index < 0 || !root.model || index >= root.model.length)
            return
        var title = root.crumbTitle(root.model[index])
        if (title.length)
            _announce(qsTr("Navigated to %1").arg(title))
    }

    function _syncFocusVisibleIndex() {
        var vis = visibleModel
        for (var i = 0; i < vis.length; ++i) {
            if (!vis[i].ellipsis && vis[i].index === currentIndex) {
                _focusVisibleIndex = i
                return
            }
        }
        _focusVisibleIndex = Math.max(0, vis.length - 1)
    }

    function _moveFocusVisible(delta) {
        var vis = visibleModel
        if (!vis.length)
            return
        var i = _focusVisibleIndex
        for (var step = 0; step < vis.length; ++step) {
            i = (i + delta + vis.length) % vis.length
            if (isClickable(vis[i])) {
                _focusVisibleIndex = i
                return
            }
        }
    }

    function _activateFocusedVisible() {
        var vis = visibleModel
        if (_focusVisibleIndex < 0 || _focusVisibleIndex >= vis.length)
            return
        var entry = vis[_focusVisibleIndex]
        if (!isClickable(entry))
            return
        if (entry.ellipsis) {
            if (_ellipsisCrumb)
                overflowMenu.popup(_ellipsisCrumb, 0, _ellipsisCrumb.height + 4)
            return
        }
        currentIndex = entry.index
        itemClicked(entry.index)
        itemInvoked(entry.index)
        _announceCrumb(entry.index)
    }

    onActiveFocusChanged: if (activeFocus) _syncFocusVisibleIndex()
    onVisibleModelChanged: if (activeFocus) _syncFocusVisibleIndex()

    Keys.onLeftPressed: _moveFocusVisible(-1)
    Keys.onRightPressed: _moveFocusVisible(1)
    Keys.onPressed: function (event) {
        var vis = visibleModel
        if (!vis.length)
            return
        if (event.key === Qt.Key_Home) {
            for (var i = 0; i < vis.length; ++i) {
                if (isClickable(vis[i])) {
                    _focusVisibleIndex = i
                    event.accepted = true
                    return
                }
            }
        } else if (event.key === Qt.Key_End) {
            for (var j = vis.length - 1; j >= 0; --j) {
                if (isClickable(vis[j])) {
                    _focusVisibleIndex = j
                    event.accepted = true
                    return
                }
            }
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter
                   || event.key === Qt.Key_Space) {
            _activateFocusedVisible()
            event.accepted = true
        }
    }

    contentItem: RowLayout {
        id: row
        spacing: 4

        Repeater {
            model: root.visibleModel

            RowLayout {
                required property var modelData
                required property int index
                spacing: 4

                Text {
                    id: sepGlyph
                    visible: index > 0
                    text: root.effectiveSeparatorGlyph
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: Theme.textSecondary
                    transform: Scale {
                        origin.x: sepGlyph.width / 2
                        origin.y: sepGlyph.height / 2
                        xScale: {
                            // Prefer app RTL — Scale cannot host LayoutMirroring
                            var rtl = Qt.application.layoutDirection === Qt.RightToLeft
                            return (rtl && Theme.iconShouldMirror(root.effectiveSeparatorGlyph)) ? -1 : 1
                        }
                    }
                }

                AbstractButton {
                    id: crumb
                    hoverEnabled: root.isClickable(modelData)
                    enabled: true
                    focusPolicy: Qt.NoFocus
                    readonly property bool _keyboardFocused: root.activeFocus
                                                         && root._focusVisibleIndex === index
                    readonly property bool _showHoverChrome: (crumb.hovered || crumb._keyboardFocused)
                            && (root.isClickable(modelData) || modelData.ellipsis)

                    Component.onCompleted: {
                        if (modelData.ellipsis)
                            root._ellipsisCrumb = crumb
                    }
                    Component.onDestruction: {
                        if (root._ellipsisCrumb === crumb)
                            root._ellipsisCrumb = null
                    }

                    Accessible.role: Accessible.ListItem
                    Accessible.name: modelData.ellipsis
                                     ? qsTr("More breadcrumbs")
                                     : root.crumbTitle(modelData.data)
                    Accessible.description: root.isCurrent(modelData.index)
                                            ? qsTr("Current location")
                                            : ""
                    onClicked: {
                        if (!root.isClickable(modelData) && !modelData.ellipsis)
                            return
                        if (modelData.ellipsis) {
                            overflowMenu.popup(crumb, 0, crumb.height + 4)
                            return
                        }
                        root.currentIndex = modelData.index
                        root.itemClicked(modelData.index)
                        root.itemInvoked(modelData.index)
                        root._announceCrumb(modelData.index)
                    }
                    scale: down && !Theme.reducedMotion
                           && (root.isClickable(modelData) || modelData.ellipsis) ? 0.96 : 1
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.motionMs("fast")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }

                    PointerCursor {
                        shape: (root.isClickable(modelData) || modelData.ellipsis)
                               ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }

                    contentItem: RowLayout {
                        spacing: 6
                        Text {
                            readonly property string _glyph: root.crumbIcon(modelData.data)
                            visible: _glyph.length > 0
                            text: _glyph
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 12
                            color: (!modelData.ellipsis && modelData.index === root.currentIndex)
                                   ? Theme.textPrimary : Theme.textSecondary
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation {
                                    duration: Theme.motionMs("fast")
                                    easing.type: Theme.motionEasing("standard")
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: false
                            implicitWidth: crumbLabel.implicitWidth
                            implicitHeight: crumbLabel.implicitHeight + 3

                            Text {
                                id: crumbLabel
                                anchors.top: parent.top
                                text: {
                                    if (modelData.ellipsis)
                                        return "…"
                                    return root.crumbTitle(modelData.data)
                                }
                                font.family: root.font.family
                                font.pixelSize: root.font.pixelSize
                                font.weight: (!modelData.ellipsis && modelData.index === root.currentIndex)
                                             ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                                color: {
                                    if (modelData.ellipsis)
                                        return crumb.hovered ? Theme.textPrimary : Theme.textSecondary
                                    if (modelData.index === root.currentIndex)
                                        return Theme.textPrimary
                                    return crumb.hovered ? Theme.textPrimary : Theme.textSecondary
                                }
                                elide: Text.ElideRight
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation {
                                        duration: Theme.motionMs("fast")
                                        easing.type: Theme.motionEasing("standard")
                                    }
                                }
                            }
                            // Hover / ellipsis underline (M18)
                            Rectangle {
                                anchors.left: crumbLabel.left
                                anchors.right: crumbLabel.right
                                anchors.top: crumbLabel.bottom
                                anchors.topMargin: 1
                                height: 1
                                color: Theme.accent
                                opacity: crumb._showHoverChrome
                                         && (modelData.ellipsis
                                             || (!root.isCurrent(modelData.index)
                                                 && root.isClickable(modelData)))
                                         ? 1 : 0
                                Behavior on opacity {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation {
                                        duration: Theme.motionMs("fast")
                                        easing.type: Theme.motionEasing("standard")
                                    }
                                }
                            }
                        }
                    }

                    background: Rectangle {
                        radius: Theme.cornerControl
                        color: {
                            if (!root.isClickable(modelData) && !modelData.ellipsis)
                                return "transparent"
                            if (crumb.down)
                                return Theme.fillSubtleTertiary
                            if (crumb.hovered || crumb._keyboardFocused)
                                return Theme.fillSubtle
                            return "transparent"
                        }
                        implicitHeight: Theme.controlHeight - 8
                        implicitWidth: Math.max(24, crumb.contentItem.implicitWidth + 12)
                        border.width: crumb._keyboardFocused ? 1 : 0
                        border.color: Theme.accent
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.motionMs("fast")
                                easing.type: Theme.motionEasing("standard")
                            }
                        }
                    }
                }
            }
        }

        Menu {
            id: overflowMenu
            Instantiator {
                model: root.overflowModel
                delegate: MenuItem {
                    required property var modelData
                    text: root.crumbTitle(modelData.data)
                    onTriggered: {
                        root.currentIndex = modelData.index
                        root.itemClicked(modelData.index)
                        root.itemInvoked(modelData.index)
                        root._announceCrumb(modelData.index)
                    }
                    // Overflow flyout press feedback (M18)
                    scale: down && !Theme.reducedMotion ? 0.98 : 1
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.motionMs("fast")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }
                }
                onObjectAdded: function (i, obj) { overflowMenu.insertItem(i, obj) }
                onObjectRemoved: function (i, obj) { overflowMenu.removeItem(obj) }
            }
        }
    }

    background: Item {}
}
