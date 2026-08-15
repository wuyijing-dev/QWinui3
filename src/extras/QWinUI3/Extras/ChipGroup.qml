import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Horizontal chip group for filter / selection patterns.
T.Control {
    id: root

    property alias model: repeater.model
    property int currentIndex: -1
    property bool exclusive: true
    // single | multiple | none  (overrides exclusive when set non-empty via selectionMode)
    property string selectionMode: ""
    property var selectedIndexes: []
    property int maxSelected: 0 // 0 = unlimited (multiple mode)
    property real chipSpacing: Theme.spacing
    property string chipSize: "medium"
    signal selectionChanged()
    signal itemClicked(int index)

    readonly property bool _exclusive: {
        if (selectionMode === "multiple" || selectionMode === "none")
            return false
        if (selectionMode === "single")
            return true
        return exclusive
    }
    readonly property bool _selectable: selectionMode !== "none"

    implicitWidth: row.implicitWidth
    implicitHeight: Math.max(Theme.controlHeight - 4, row.implicitHeight)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption

    function isSelected(index) {
        if (!_selectable)
            return false
        if (_exclusive)
            return index === currentIndex
        return selectedIndexes.indexOf(index) >= 0
    }

    function toggleIndex(index) {
        if (!_selectable)
            return
        itemClicked(index)
        if (_exclusive) {
            currentIndex = (currentIndex === index) ? -1 : index
        } else {
            var next = selectedIndexes.slice()
            var at = next.indexOf(index)
            if (at >= 0) {
                next.splice(at, 1)
            } else {
                if (maxSelected > 0 && next.length >= maxSelected)
                    return
                next.push(index)
            }
            selectedIndexes = next
        }
        selectionChanged()
    }

    contentItem: Flow {
        id: row
        width: root.availableWidth > 0 ? root.availableWidth : implicitWidth
        spacing: root.chipSpacing

        Repeater {
            id: repeater

            delegate: Chip {
                required property var modelData
                required property int index
                text: typeof modelData === "string" ? modelData
                      : (modelData.title || modelData.text || String(modelData))
                iconGlyph: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""
                chipSize: root.chipSize
                checkable: root._selectable
                checked: root.isSelected(index)
                onClicked: root.toggleIndex(index)
            }
        }
    }

    background: Item {}
}
