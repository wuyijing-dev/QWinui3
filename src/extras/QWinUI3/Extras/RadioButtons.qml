import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// @notes
//   Grouped RadioButton column/grid from model; selectedIndex / selectedItem.
//   maxColumns wraps the grid (WinUI MaxColumns); horizontal=true is one row.

T.Control {
    id: control

    // Header label above the control
    property string header: ""
    // Supporting description text
    property string description: ""
    // Data model / item list for this control
    property var model: []
    // WinUI ItemsSource alias of model
    property alias itemsSource: control.model
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // WinUI MaxColumns — 0/1 = single column; >1 wraps into a grid
    property int maxColumns: 1
    // Horizontal orientation when true (all items in one row)
    property bool horizontal: false
    // Currently selected model item (WinUI SelectedItem)
    readonly property var selectedItem: {
        if (!model || currentIndex < 0 || currentIndex >= model.length)
            return null
        return model[currentIndex]
    }
    // Selected state
    signal selected(int index, var item)
    // Selection changed
    signal selectionChanged(int index)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    // Select item by index
    function select(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        currentIndex = index
        selected(index, model[index])
    }

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.RadioButton
    Accessible.name: header.length ? header : qsTr("Options")
    Accessible.description: description
    Keys.onUpPressed: select(Math.max(0, currentIndex - 1))
    Keys.onDownPressed: select(Math.min((model ? model.length : 1) - 1, currentIndex + 1))
    Keys.onLeftPressed: select(Math.max(0, currentIndex - 1))
    Keys.onRightPressed: select(Math.min((model ? model.length : 1) - 1, currentIndex + 1))

    readonly property int _columns: {
        if (horizontal)
            return Math.max(1, model ? model.length : 1)
        return Math.max(1, maxColumns)
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        Text {
            visible: control.header.length > 0
            Layout.fillWidth: true
            text: control.header
            font.family: control.font.family
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }
        Text {
            visible: control.description.length > 0
            Layout.fillWidth: true
            text: control.description
            font.family: control.font.family
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            wrapMode: Text.Wrap
        }

        GridLayout {
            columns: control._columns
            rowSpacing: 2
            columnSpacing: Theme.spacingLoose
            Layout.fillWidth: true

            Repeater {
                model: control.model
                ColumnLayout {
                    required property var modelData
                    required property int index
                    spacing: 0
                    Layout.fillWidth: control._columns === 1
                    Layout.preferredWidth: control._columns > 1
                        ? Math.max(120, (control.availableWidth - (control._columns - 1) * Theme.spacingLoose) / control._columns)
                        : -1

                    RadioButton {
                        id: radio
                        Layout.fillWidth: true
                        text: typeof modelData === "string" ? modelData
                              : (modelData.title || modelData.text || "")
                        checked: index === control.currentIndex
                        enabled: typeof modelData === "string" ? true
                                 : (modelData.enabled === undefined ? true : !!modelData.enabled)
                        padding: 8
                        leftPadding: 10
                        rightPadding: 12
                        onClicked: {
                            control.currentIndex = index
                            control.selected(index, modelData)
                        }

                        background: Rectangle {
                            radius: Theme.cornerControl
                            color: radio.hovered || radio.checked ? Theme.fillSubtleSecondary : "transparent"
                            border.width: radio.visualFocus ? 1 : 0
                            border.color: Theme.focusOuter
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                    }
                    Text {
                        visible: typeof modelData === "object" && !!(modelData.description)
                        Layout.fillWidth: true
                        Layout.leftMargin: 34
                        Layout.rightMargin: 12
                        Layout.bottomMargin: 6
                        text: typeof modelData === "object" ? (modelData.description || "") : ""
                        font.family: control.font.family
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}
