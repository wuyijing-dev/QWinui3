import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PipsPager — Dot pager for carousels.
//
//   PipsPager {
//       id: pipsPager
//       count: 5; currentIndex: 2
//   }
//
//   // --- API ---
//   // signals: onCurrentIndexEdited, onSelectionChanged
//   // methods: goNext(), goPrevious(), select(index)
//   // pipsPager.goNext()
//   // pipsPager.goPrevious()
//   // pipsPager.select(index)
//
// @notes
//   Dot pager synced to a FlipView / SwipeView currentIndex.
//   MaxVisiblePips windows the visible dots; NumberOfPages aliases count.
//   Carousel hosts + reducedMotion: docs/carousel-recipes.md (2.37).

T.Control {
    id: control

    // Item count
    property int count: 0
    // WinUI NumberOfPages alias of count
    property alias numberOfPages: control.count
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // WinUI MaxVisiblePips — 0 = show all
    property int maxVisiblePips: 0
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    // Wrap children to next line
    property bool wrap: false
    // WinUI ButtonVisibility: "visible" | "visibleOnPointerOver" | "collapsed"
    property string previousButtonVisibility: "visible"
    // Visibility of the next button
    property string nextButtonVisibility: "visible"
    // Emitted when currentIndex changes via user edit
    signal currentIndexEdited(int index)
    // Selection changed
    signal selectionChanged(int index)

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Page indicators")
    Keys.onLeftPressed: goPrevious()
    Keys.onRightPressed: goNext()
    Keys.onUpPressed: goPrevious()
    Keys.onDownPressed: goNext()

    WheelHandler {
        enabled: control.enabled && control.count > 0
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            if (dir > 0)
                control.goPrevious()
            else
                control.goNext()
            event.accepted = true
        }
    }

    onCurrentIndexChanged: selectionChanged(currentIndex)

    readonly property int _windowSize: {
        if (maxVisiblePips <= 0 || maxVisiblePips >= count)
            return Math.max(0, count)
        return maxVisiblePips
    }
    readonly property int _windowStart: {
        if (_windowSize <= 0 || _windowSize >= count)
            return 0
        var half = Math.floor((_windowSize - 1) / 2)
        var start = currentIndex - half
        start = Math.max(0, Math.min(count - _windowSize, start))
        return start
    }
    readonly property var _visibleIndices: {
        var list = []
        var n = _windowSize
        for (var i = 0; i < n; ++i)
            list.push(_windowStart + i)
        return list
    }

    // Navigate to the next page / item
    function goNext() {
        if (count <= 0)
            return
        if (currentIndex >= count - 1) {
            if (wrap)
                currentIndex = 0
            else
                return
        } else {
            currentIndex++
        }
        currentIndexEdited(currentIndex)
    }

    // Navigate to the previous page / item
    function goPrevious() {
        if (count <= 0)
            return
        if (currentIndex <= 0) {
            if (wrap)
                currentIndex = count - 1
            else
                return
        } else {
            currentIndex--
        }
        currentIndexEdited(currentIndex)
    }

    // Select item by index
    function select(index) {
        if (index < 0 || index >= count)
            return
        if (currentIndex === index)
            return
        currentIndex = index
        currentIndexEdited(currentIndex)
    }

    function _btnVisible(mode) {
        if (mode === "collapsed")
            return false
        if (mode === "visibleOnPointerOver")
            return control.hovered || control.visualFocus || control.activeFocus
        return true
    }

    component NavButton: AbstractButton {
        id: nav
        // Fluent glyph drawn in the button
        property string glyph: ""
        hoverEnabled: true
        focusPolicy: Qt.NoFocus
        contentItem: Text {
            text: nav.glyph
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            color: nav.enabled ? (nav.hovered ? Theme.textPrimary : Theme.textSecondary)
                               : Theme.textDisabled
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: Theme.cornerControl
            color: {
                if (!nav.enabled)
                    return "transparent"
                if (nav.down)
                    return Theme.fillSubtleTertiary
                if (nav.hovered)
                    return Theme.fillSubtle
                return "transparent"
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
    }

    implicitWidth: row.implicitWidth + leftPadding + rightPadding
    implicitHeight: row.implicitHeight + topPadding + bottomPadding
    padding: 4
    contentItem: RowLayout {
        id: row
        spacing: 4

        NavButton {
            visible: control.orientation === Qt.Horizontal
                     && control._btnVisible(control.previousButtonVisibility)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            glyph: FluentIcons.ChevronLeft
            enabled: control.wrap || control.currentIndex > 0
            Accessible.name: qsTr("Previous")
            onClicked: control.goPrevious()
        }

        GridLayout {
            id: pipRow
            rows: control.orientation === Qt.Vertical ? control._windowSize : 1
            columns: control.orientation === Qt.Horizontal ? control._windowSize : 1
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: control._visibleIndices
                AbstractButton {
                    id: pip
                    required property int modelData
                    readonly property int index: modelData
                    Layout.preferredWidth: control.orientation === Qt.Horizontal
                                           ? (checked ? 16 : 8) : 8
                    Layout.preferredHeight: control.orientation === Qt.Vertical
                                            ? (checked ? 16 : 8) : 8
                    hoverEnabled: true
                    checkable: true
                    checked: index === control.currentIndex
                    focusPolicy: Qt.NoFocus
                    Accessible.role: Accessible.PageTab
                    Accessible.name: qsTr("Page %1").arg(index + 1)
                    Accessible.checkable: true
                    Accessible.checked: checked
                    onClicked: control.select(index)
                    background: Rectangle {
                        radius: Math.min(width, height) / 2
                        color: pip.checked ? Theme.accent
                             : (pip.hovered ? Theme.textSecondary : Theme.strokeControlStrong)
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }
                    Behavior on Layout.preferredWidth {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                    Behavior on Layout.preferredHeight {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }
        }

        NavButton {
            visible: control.orientation === Qt.Horizontal
                     && control._btnVisible(control.nextButtonVisibility)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            glyph: FluentIcons.ChevronRight
            enabled: control.wrap || control.currentIndex < control.count - 1
            Accessible.name: qsTr("Next")
            onClicked: control.goNext()
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: "transparent"
        border.width: control.activeFocus ? 1 : 0
        border.color: Theme.accent
    }
}
