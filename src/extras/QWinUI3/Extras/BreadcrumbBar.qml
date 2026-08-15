import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQml
import QWinUI3.Theme

T.Control {
    id: root

    property var model: []
    property int currentIndex: Math.max(0, (model ? model.length : 1) - 1)
    // Collapse middle crumbs when count exceeds this (0 = show all)
    property int maxVisibleItems: 0
    // WinUI: current/last crumb is usually non-interactive
    property bool lastItemClickable: false
    property string separatorGlyph: "\uE76C"
    signal itemClicked(int index)
    // WinUI ItemInvoked
    signal itemInvoked(int index)

    implicitWidth: row.implicitWidth
    implicitHeight: Theme.controlHeight
    padding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.List
    Accessible.name: qsTr("Breadcrumb")

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

    function crumbTitle(data) {
        if (typeof data === "string")
            return data
        return (data && data.title) ? data.title : ""
    }

    function isCurrent(index) {
        return !isNaN(index) && index >= 0 && index === root.currentIndex
    }

    function isClickable(entry) {
        if (!entry || entry.ellipsis)
            return true
        if (isCurrent(entry.index) && !root.lastItemClickable)
            return false
        return true
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
                    visible: index > 0
                    text: root.separatorGlyph
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: Theme.textSecondary
                }

                AbstractButton {
                    id: crumb
                    hoverEnabled: root.isClickable(modelData)
                    enabled: true
                    focusPolicy: root.isClickable(modelData) ? Qt.StrongFocus : Qt.NoFocus
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
                    }
                    scale: down && !Theme.reducedMotion && root.isClickable(modelData) ? 0.96 : 1
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }

                    contentItem: RowLayout {
                        spacing: 6
                        Text {
                            visible: typeof modelData.data === "object" && modelData.data
                                     && modelData.data.icon
                            text: (typeof modelData.data === "object" && modelData.data)
                                  ? (modelData.data.icon || "") : ""
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 12
                            color: (!modelData.ellipsis && modelData.index === root.currentIndex)
                                   ? Theme.textPrimary : Theme.textSecondary
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                        Text {
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
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
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
                            if (crumb.hovered || crumb.visualFocus)
                                return Theme.fillSubtle
                            return "transparent"
                        }
                        implicitHeight: Theme.controlHeight - 8
                        implicitWidth: Math.max(24, crumb.contentItem.implicitWidth + 12)
                        border.width: crumb.visualFocus ? 1 : 0
                        border.color: Theme.accent
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionFast)
                                easing.type: Theme.easingStandard
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
                    }
                }
                onObjectAdded: function (i, obj) { overflowMenu.insertItem(i, obj) }
                onObjectRemoved: function (i, obj) { overflowMenu.removeItem(obj) }
            }
        }
    }

    background: Item {}
}
