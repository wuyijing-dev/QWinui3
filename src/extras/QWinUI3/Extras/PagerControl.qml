import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// PagerControl — Numbered page navigation (prev / numbers / next).
//
//   PagerControl {
//       numberOfPages: 12
//       selectedIndex: 0
//       onSelectedIndexChanged: { … }
//   }
//
//   // --- API ---
//   // methods: goNext(), goPrevious(), select(index)
//   // signals: onSelectionChanged, onCurrentIndexEdited
//
// @notes
//   WinUI-style numbered pager for lists/grids. maxVisiblePages windows the
//   number strip; pairs with ListView / ItemsView pageSize patterns.

T.Control {
    id: root

    property int numberOfPages: 1
    property int selectedIndex: 0
    property alias currentIndex: root.selectedIndex
    property int maxVisiblePages: 7
    property bool wrap: false

    signal selectionChanged(int index)
    signal currentIndexEdited(int index)

    implicitHeight: Theme.controlHeight
    implicitWidth: row.implicitWidth
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Pager")
    Accessible.description: qsTr("Page %1 of %2").arg(selectedIndex + 1).arg(numberOfPages)

    onSelectedIndexChanged: selectionChanged(selectedIndex)
    // Qt Keys has no onHomePressed / onEndPressed attached signals.
    Keys.onLeftPressed: function (event) { goPrevious(); event.accepted = true }
    Keys.onRightPressed: function (event) { goNext(); event.accepted = true }
    Keys.onUpPressed: function (event) { goPrevious(); event.accepted = true }
    Keys.onDownPressed: function (event) { goNext(); event.accepted = true }
    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Home) {
            select(0)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            select(numberOfPages - 1)
            event.accepted = true
        }
    }

    WheelHandler {
        enabled: root.enabled
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            if (dir > 0)
                root.goPrevious()
            else
                root.goNext()
            event.accepted = true
        }
    }

    function select(index) {
        if (numberOfPages <= 0)
            return
        var i = Math.max(0, Math.min(numberOfPages - 1, index))
        if (i !== selectedIndex) {
            selectedIndex = i
            currentIndexEdited(i)
        }
    }

    function goNext() {
        if (selectedIndex < numberOfPages - 1)
            select(selectedIndex + 1)
        else if (wrap)
            select(0)
    }

    function goPrevious() {
        if (selectedIndex > 0)
            select(selectedIndex - 1)
        else if (wrap)
            select(numberOfPages - 1)
    }

    readonly property int _windowSize: {
        if (maxVisiblePages <= 0 || maxVisiblePages >= numberOfPages)
            return Math.max(0, numberOfPages)
        return maxVisiblePages
    }
    readonly property int _windowStart: {
        if (_windowSize <= 0 || _windowSize >= numberOfPages)
            return 0
        var half = Math.floor((_windowSize - 1) / 2)
        return Math.max(0, Math.min(numberOfPages - _windowSize, selectedIndex - half))
    }

    contentItem: RowLayout {
        id: row
        spacing: 4

        ToolButton {
            text: FluentIcons.ChevronLeft
            font.family: Theme.fontFamilyIcon
            enabled: root.wrap || root.selectedIndex > 0
            focusPolicy: Qt.NoFocus
            activeFocusOnTab: false
            Accessible.name: qsTr("Previous page")
            onClicked: {
                root.goPrevious()
                root.forceActiveFocus()
            }
        }

        Repeater {
            model: root._windowSize
            delegate: Button {
                required property int index
                readonly property int pageIndex: root._windowStart + index
                text: String(pageIndex + 1)
                flat: pageIndex !== root.selectedIndex
                highlighted: pageIndex === root.selectedIndex
                Layout.preferredWidth: Math.max(implicitWidth, Theme.controlHeight)
                focusPolicy: Qt.NoFocus
                activeFocusOnTab: false
                Accessible.name: qsTr("Page %1").arg(pageIndex + 1)
                onClicked: {
                    root.select(pageIndex)
                    root.forceActiveFocus()
                }
            }
        }

        ToolButton {
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            enabled: root.wrap || root.selectedIndex < root.numberOfPages - 1
            focusPolicy: Qt.NoFocus
            activeFocusOnTab: false
            Accessible.name: qsTr("Next page")
            onClicked: {
                root.goNext()
                root.forceActiveFocus()
            }
        }
    }
}
