import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Pivot — Header tabs with sliding underline and pages.
//
//   Pivot {
//       id: pivot
//       model: ["Overview", "Details"]
//   }
//
//   // --- API ---
//   // signals: onCurrentIndexChangedByUser, onSelectionChanged
//   // methods: selectIndex(index)
//   // pivot.selectIndex(index)
//
// @notes
//   Tab-like pivot headers + content; model or PivotItem children.
//   leftHeader / rightHeader slots flank the tab strip (WinUI LeftHeader / RightHeader).
//   selectedItem mirrors the current model entry.

T.Control {
    id: control

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // Currently selected model item
    readonly property var selectedItem: {
        if (!model || currentIndex < 0)
            return null
        if (typeof model.count === "number" && typeof model.get === "function") {
            if (currentIndex >= model.count)
                return null
            return model.get(currentIndex)
        }
        if (currentIndex >= (model.length || 0))
            return null
        return model[currentIndex]
    }
    // Allow arrow-key navigation
    property bool keyboardNavigationEnabled: true
    // WinUI LeftHeader — content before the tab strip
    property alias leftHeader: leftHeaderSlot.data
    // WinUI RightHeader — content after the tab strip
    property alias rightHeader: rightHeaderSlot.data
    // Selection changed by user
    signal currentIndexChangedByUser(int index)
    // Selection changed
    signal selectionChanged(int index)

    // Shared underline geometry
    property real _pivotIndX: 0
    property real _pivotIndWidth: 0

    implicitWidth: 480
    implicitHeight: 200
    padding: 0
    spacing: 0
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Pivot")
    Accessible.description: qsTr("Tab %1 of %2").arg(currentIndex + 1).arg(model ? model.length : 0)

    function _syncPivotIndicator(tabItem) {
        if (!tabItem)
            return
        var margin = 8
        var contentW = tabItem.contentItem ? tabItem.contentItem.implicitWidth : tabItem.width
        control._pivotIndX = tabItem.x + margin
        control._pivotIndWidth = Math.max(16, Math.min(tabItem.width - margin * 2, contentW + 8))
    }

    function _resyncPivotFromIndex() {
        if (typeof headerRow === "undefined" || !headerRow)
            return
        var kids = headerRow.children
        for (var i = 0; i < kids.length; ++i) {
            var c = kids[i]
            if (c && c.index === control.currentIndex) {
                _syncPivotIndicator(c)
                return
            }
        }
    }

    onCurrentIndexChanged: {
        selectionChanged(currentIndex)
        Qt.callLater(function () { control._resyncPivotFromIndex() })
    }

    function _selectRelative(delta) {
        if (!keyboardNavigationEnabled || !model || model.length === 0)
            return
        var next = Math.max(0, Math.min(model.length - 1, currentIndex + delta))
        if (next !== currentIndex) {
            currentIndex = next
            currentIndexChangedByUser(next)
        }
    }

    Keys.onLeftPressed: _selectRelative(-1)
    Keys.onRightPressed: _selectRelative(1)
    Keys.onUpPressed: _selectRelative(-1)
    Keys.onDownPressed: _selectRelative(1)
    Keys.onPressed: function (event) {
        if (!keyboardNavigationEnabled || !model || model.length === 0)
            return
        if (event.key === Qt.Key_Home) {
            selectIndex(0)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            selectIndex(model.length - 1)
            event.accepted = true
        }
    }

    function selectIndex(index) {
        if (index < 0 || index >= model.length)
            return
        currentIndex = index
        currentIndexChangedByUser(index)
    }

    contentItem: Item {
        readonly property real _headerHeight: Theme.controlHeight + 8

        Item {
            id: headerBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent._headerHeight

            Item {
                id: leftHeaderSlot
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 4
                width: children.length ? Math.max(childrenRect.width, 1) : 0
                visible: children.length > 0
            }

            Item {
                id: rightHeaderSlot
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 4
                width: children.length ? Math.max(childrenRect.width, 1) : 0
                visible: children.length > 0
            }

            Flickable {
                id: headerFlick
                anchors.left: leftHeaderSlot.visible ? leftHeaderSlot.right : parent.left
                anchors.leftMargin: leftHeaderSlot.visible ? 4 : 0
                anchors.right: rightHeaderSlot.visible ? rightHeaderSlot.left : parent.right
                anchors.rightMargin: rightHeaderSlot.visible ? 4 : 0
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                contentWidth: Math.max(width, headerStrip.width)
                contentHeight: height
                clip: true
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds

                Item {
                    id: headerStrip
                    width: Math.max(headerRow.implicitWidth, 1)
                    height: headerFlick.height

                    Row {
                        id: headerRow
                        height: parent.height
                        spacing: 4

                        Repeater {
                            model: control.model
                            AbstractButton {
                                id: tab
                                required property var modelData
                                required property int index
                                height: headerRow.height
                                width: Math.max(72, headerContent.implicitWidth + 24)
                                hoverEnabled: true
                                checkable: true
                                checked: index === control.currentIndex
                                focusPolicy: Qt.NoFocus
                                scale: down && !Theme.reducedMotion ? 0.98 : 1
                                Behavior on scale {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation {
                                        duration: Theme.motionMs("fast")
                                        easing.type: Theme.motionEasing("standard")
                                    }
                                }
                                onClicked: control.selectIndex(index)
                                onCheckedChanged: {
                                    if (checked)
                                        control._syncPivotIndicator(tab)
                                }
                                Component.onCompleted: {
                                    if (checked)
                                        Qt.callLater(function () { control._syncPivotIndicator(tab) })
                                }
                                onWidthChanged: if (checked) control._syncPivotIndicator(tab)
                                onXChanged: if (checked) control._syncPivotIndicator(tab)

                                readonly property string _icon: {
                                    if (typeof modelData === "string" || !modelData)
                                        return ""
                                    return IconSource.resolve(modelData.symbol || "",
                                                              modelData.icon || modelData.glyph || "")
                                }
                                readonly property string _title: typeof modelData === "string"
                                                                ? modelData : (modelData.title || "")

                                contentItem: Row {
                                    id: headerContent
                                    spacing: 8
                                    anchors.centerIn: parent
                                    Text {
                                        visible: tab._icon.length > 0
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: tab._icon
                                        font.family: Theme.fontFamilyIcon
                                        font.pixelSize: 14
                                        color: tab.checked ? Theme.accent : Theme.textSecondary
                                        Behavior on color {
                                            enabled: !Theme.reducedMotion
                                            ColorAnimation {
                                                duration: Theme.motionMs("fast")
                                                easing.type: Theme.motionEasing("standard")
                                            }
                                        }
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: tab._title
                                        font.pixelSize: Theme.fontBody
                                        font.weight: tab.checked ? Theme.fontWeightSemiBold
                                                                 : Theme.fontWeightRegular
                                        color: tab.checked ? Theme.textPrimary : Theme.textSecondary
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Behavior on color {
                                            enabled: !Theme.reducedMotion
                                            ColorAnimation {
                                                duration: Theme.motionMs("fast")
                                                easing.type: Theme.motionEasing("standard")
                                            }
                                        }
                                    }
                                }

                                background: Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    anchors.bottomMargin: 4
                                    radius: Theme.cornerControl
                                    color: tab.hovered && !tab.checked ? Theme.fillSubtle : "transparent"
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

                    Rectangle {
                        height: 3
                        radius: 1.5
                        color: Theme.accent
                        y: headerStrip.height - height
                        z: 2
                        x: control._pivotIndX
                        width: Math.max(0, control._pivotIndWidth)
                        opacity: control._pivotIndWidth > 1 ? 1 : 0
                        Behavior on x {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.motionMs("normal")
                                easing.type: Theme.motionEasing("enter")
                            }
                        }
                        Behavior on width {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.motionMs("normal")
                                easing.type: Theme.motionEasing("enter")
                            }
                        }
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
        }

        Rectangle {
            id: headerDivider
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerBar.bottom
            height: 1
            color: Theme.strokeDivider
        }

        StackLayout {
            id: stack
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerDivider.bottom
            anchors.bottom: parent.bottom
            clip: true
            currentIndex: control.currentIndex

            Repeater {
                model: control.model
                Item {
                    id: pageHost
                    required property var modelData
                    required property int index

                    readonly property bool hasPage: typeof modelData === "object"
                                                   && modelData !== null
                                                   && modelData.page !== undefined
                                                   && modelData.page !== null

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        anchors.margins: 12
                        active: pageHost.hasPage
                        sourceComponent: pageHost.hasPage ? modelData.page : null
                        opacity: control.currentIndex === pageHost.index ? 1 : 0
                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }

                    Label {
                        anchors.centerIn: parent
                        width: parent.width - 48
                        visible: !pageHost.hasPage || pageLoader.status !== Loader.Ready
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.textSecondary
                        opacity: control.currentIndex === pageHost.index ? 1 : 0
                        text: typeof modelData === "string"
                              ? modelData
                              : (modelData.content || modelData.title || "")
                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
