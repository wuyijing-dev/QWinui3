import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme

// Shared Fluent legend for chart series / slices.
// items: [{ label, color?, value?, secondary? }]
Item {
    id: root

    property var items: []
    property int hoverIndex: -1
    property int selectedIndex: -1
    property bool interactive: true
    property int orientation: Qt.Horizontal // or Qt.Vertical
    property bool showValue: true
    property string header: ""

    signal itemClicked(int index)
    signal itemHovered(int index)

    implicitHeight: {
        var h = orientation === Qt.Horizontal ? flow.implicitHeight : col.implicitHeight
        if (header.length)
            h += Theme.fontCaption + 8
        return h
    }
    implicitWidth: orientation === Qt.Horizontal ? parent ? parent.width : 200 : 140

    function select(index) {
        selectedIndex = index
        itemClicked(index)
    }

    Column {
        anchors.fill: parent
        spacing: 6

        Text {
            visible: root.header.length > 0
            width: parent.width
            text: root.header
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textSecondary
        }

        Flow {
            id: flow
            width: parent.width
            visible: root.orientation === Qt.Horizontal
            spacing: 12
            Repeater {
                model: root.items
                Row {
                    required property var modelData
                    required property int index
                    spacing: 6
                    opacity: {
                        if (root.selectedIndex >= 0)
                            return root.selectedIndex === index ? 1 : 0.4
                        return root.hoverIndex < 0 || root.hoverIndex === index ? 1 : 0.45
                    }
                    Behavior on opacity {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                    Rectangle {
                        width: 10
                        height: 10
                        radius: 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: modelData.color || ChartUtils.palette(Theme, index)
                        scale: (root.hoverIndex === index || root.selectedIndex === index) ? 1.15 : 1
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            var t = modelData.label || ("#" + (index + 1))
                            if (root.showValue && modelData.value !== undefined)
                                t += "  " + ChartUtils.formatNumber(modelData.value)
                            if (modelData.secondary)
                                t += "  " + modelData.secondary
                            return t
                        }
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        font.weight: (root.hoverIndex === index || root.selectedIndex === index)
                                ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                        color: (root.hoverIndex === index || root.selectedIndex === index)
                                ? Theme.textPrimary : Theme.textSecondary
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: root.interactive
                        enabled: root.interactive
                        onEntered: {
                            root.hoverIndex = index
                            root.itemHovered(index)
                        }
                        onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                        onClicked: root.select(index)
                    }
                }
            }
        }

        Column {
            id: col
            width: parent.width
            visible: root.orientation === Qt.Vertical
            spacing: 6
            Repeater {
                model: root.items
                Rectangle {
                    required property var modelData
                    required property int index
                    width: parent.width
                    height: 28
                    radius: Theme.cornerControl
                    color: (root.hoverIndex === index || root.selectedIndex === index)
                            ? Theme.fillSubtleSecondary : "transparent"
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        spacing: 8
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: modelData.color || ChartUtils.palette(Theme, index)
                        }
                        Text {
                            width: Math.max(40, parent.width - 18)
                            anchors.verticalCenter: parent.verticalCenter
                            text: {
                                var t = modelData.label || ("#" + (index + 1))
                                if (root.showValue && modelData.value !== undefined)
                                    t += "  " + ChartUtils.formatNumber(modelData.value)
                                if (modelData.secondary)
                                    t += "  " + modelData.secondary
                                return t
                            }
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            font.weight: (root.hoverIndex === index || root.selectedIndex === index)
                                    ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: (root.hoverIndex === index || root.selectedIndex === index)
                                    ? Theme.textPrimary : Theme.textSecondary
                            elide: Text.ElideRight
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: root.interactive
                        enabled: root.interactive
                        onEntered: {
                            root.hoverIndex = index
                            root.itemHovered(index)
                        }
                        onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                        onClicked: root.select(index)
                    }
                }
            }
        }
    }
}
