import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: control

    property int count: 0
    property int currentIndex: 0
    property int orientation: Qt.Horizontal
    property bool wrap: false
    // WinUI ButtonVisibility: "visible" | "visibleOnPointerOver" | "collapsed"
    property string previousButtonVisibility: "visible"
    property string nextButtonVisibility: "visible"
    signal currentIndexEdited(int index)

    hoverEnabled: true

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

    function _btnVisible(mode) {
        if (mode === "collapsed")
            return false
        if (mode === "visibleOnPointerOver")
            return control.hovered || control.visualFocus
        return true
    }

    implicitWidth: row.implicitWidth + leftPadding + rightPadding
    implicitHeight: row.implicitHeight + topPadding + bottomPadding
    padding: 4
    font.family: Theme.fontFamily

    contentItem: RowLayout {
        id: row
        spacing: 4

        ToolButton {
            visible: control.orientation === Qt.Horizontal
                     && control._btnVisible(control.previousButtonVisibility)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            text: "\uE76B"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
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
                    onClicked: {
                        control.currentIndex = index
                        control.currentIndexEdited(index)
                    }
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

        ToolButton {
            visible: control.orientation === Qt.Horizontal
                     && control._btnVisible(control.nextButtonVisibility)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            text: "\uE76C"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            enabled: control.wrap || control.currentIndex < control.count - 1
            Accessible.name: qsTr("Next")
            onClicked: control.goNext()
        }
    }
}
