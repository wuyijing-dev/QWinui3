import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PipsPager — Dot pager for carousels.
//
//   PipsPager { count: 5; currentIndex: 2 }

T.Control {
    id: control

    // Item count
    property int count: 0
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    // Wrap children to next line
    property bool wrap: false
    // WinUI ButtonVisibility: "visible" | "visibleOnPointerOver" | "collapsed"
    property string previousButtonVisibility: "visible"
    // Next Button Visibility
    property string nextButtonVisibility: "visible"
    // Current Index Edited
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

    onCurrentIndexChanged: selectionChanged(currentIndex)

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
    font.family: Theme.fontFamily

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
            rows: control.orientation === Qt.Vertical ? control.count : 1
            columns: control.orientation === Qt.Horizontal ? control.count : 1
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: control.count
                AbstractButton {
                    id: pip
                    required property int index
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
