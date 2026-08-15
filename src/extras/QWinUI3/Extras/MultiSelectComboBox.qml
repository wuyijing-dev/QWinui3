import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// MultiSelectComboBox — Combo that keeps the popup open for multi-select.
//
//   MultiSelectComboBox {
//       id: multiSelectComboBox
//       model: items; selectedIndexes: [0, 2]
//   }
//
//   // --- API ---
//   // signals: onSelectionChanged
//   // methods: toggleAt(index), ensureObjectModel(), selectAll(), clearSelection()
//   // multiSelectComboBox.toggleAt(index)
//   // multiSelectComboBox.ensureObjectModel()
//   // multiSelectComboBox.selectAll()
//   // multiSelectComboBox.clearSelection()
//   // inherits AbstractButton (+ Qt Quick Controls base API)
//
// @notes
//   ComboBox with multi-check selection; selectedIndexes / selectedItems.
//   exclusive mode behaves like a normal combo.

T.AbstractButton {
    id: control

    // Data model / item list for this control
    property var model: []
    // Placeholder when empty
    property string placeholderText: qsTr("Select items")
    // Header label above the control
    property string header: ""
    // Selection changed
    signal selectionChanged(var selected)

    implicitWidth: 220
    implicitHeight: Theme.controlHeight
    leftPadding: Theme.paddingControlH
    rightPadding: 10
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Multi-select")
    Accessible.description: displayText

    // Menu currently open
    readonly property bool menuOpen: popup.visible
    // Open / visible state
    property alias isOpen: popup.visible

    // Currently selected items
    readonly property var selectedItems: {
        var out = []
        var m = model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (typeof it === "string")
                continue
            if (it && it.checked)
                out.push(it)
        }
        return out
    }

    // Text shown to the user
    readonly property string displayText: {
        var names = []
        var m = model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (typeof it === "string")
                continue
            if (it && it.checked)
                names.push(it.text || it.title || "")
        }
        if (!names.length)
            return placeholderText
        if (names.length <= 2)
            return names.join(", ")
        return qsTr("%1 selected").arg(names.length)
    }

    // Toggle item at index
    function toggleAt(index) {
        var next = (model || []).slice()
        var it = next[index]
        if (typeof it === "string") {
            next[index] = { text: it, checked: true }
        } else {
            var copy = Object.assign({}, it)
            copy.checked = !copy.checked
            next[index] = copy
        }
        model = next
        selectionChanged(selectedItems)
    }

    // Ensure model is an ObjectModel
    function ensureObjectModel() {
        var m = model || []
        var next = []
        var changed = false
        for (var i = 0; i < m.length; ++i) {
            if (typeof m[i] === "string") {
                next.push({ text: m[i], checked: false })
                changed = true
            } else {
                next.push(m[i])
            }
        }
        if (changed)
            model = next
    }

    // Select all items
    function selectAll() {
        ensureObjectModel()
        var next = (model || []).slice()
        for (var i = 0; i < next.length; ++i) {
            var copy = Object.assign({}, next[i])
            copy.checked = true
            next[i] = copy
        }
        model = next
        selectionChanged(selectedItems)
    }

    // Clear the current selection
    function clearSelection() {
        ensureObjectModel()
        var next = (model || []).slice()
        for (var i = 0; i < next.length; ++i) {
            var copy = Object.assign({}, next[i])
            copy.checked = false
            next[i] = copy
        }
        model = next
        selectionChanged(selectedItems)
    }

    Component.onCompleted: ensureObjectModel()

    contentItem: RowLayout {
        spacing: 8
        Text {
            Layout.fillWidth: true
            text: control.displayText
            elide: Text.ElideRight
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            color: control.selectedItems.length ? Theme.textPrimary : Theme.textSecondary
            verticalAlignment: Text.AlignVCenter
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
        Text {
            text: FluentIcons.ChevronDown
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            color: Theme.textSecondary
            rotation: control.menuOpen ? 180 : 0
            Behavior on rotation {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    background: Item {
        implicitWidth: 220
        implicitHeight: Theme.controlHeight

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: control.hovered || control.menuOpen
                   ? Theme.fillControlSecondary
                   : (Theme.dark ? "#0FFFFFFF" : "#FFFFFF")
            border.width: 1
            border.color: Theme.strokeControl
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: control.menuOpen ? 2 : 1
                color: control.menuOpen ? Theme.accent : Theme.strokeControl
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: Theme.cornerControl + 2
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: Theme.focusOuter
            visible: control.visualFocus
        }
    }

    onClicked: {
        control.ensureObjectModel()
        if (popup.visible)
            popup.close()
        else
            popup.open()
    }

    Popup {
        id: popup
        y: control.height + 4
        width: Math.max(200, control.width)
        padding: 5
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        transformOrigin: Item.Top
        // Match Menu / ComboBox open animation.
        enter: Transition {
            NumberAnimation {
                property: "height"
                from: popup.implicitHeight * 0.33
                to: popup.implicitHeight
                easing.type: Theme.easingEnter
                duration: Theme.duration(Theme.motionSlow)
            }
            NumberAnimation {
                property: "opacity"
                from: 0; to: 1
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingEnter
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1; to: 0
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingExit
            }
        }

        background: ElevatedChrome {
            radius: Theme.cornerOverlay
            color: Theme.bgCardElevated
            borderColor: Theme.strokeCard
            borderWidth: 1
            elevation: 6
            shadowOpacity: Theme.dark ? 0.28 : 0.14
        }

        contentItem: ListView {
            id: list
            clip: true
            implicitHeight: Math.min(contentHeight, 280)
            model: control.model
            spacing: 2
            boundsBehavior: Flickable.StopAtBounds

            header: Item {
                width: list.width
                height: headerCol.implicitHeight + 4

                ColumnLayout {
                    id: headerCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 4
                    spacing: 4

                    Text {
                        visible: control.header.length > 0
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        Layout.topMargin: 4
                        text: control.header
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textSecondary
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        spacing: 4
                        Button {
                            flat: true
                            text: qsTr("Select all")
                            font.pixelSize: Theme.fontCaption
                            onClicked: control.selectAll()
                        }
                        Button {
                            flat: true
                            text: qsTr("Clear")
                            font.pixelSize: Theme.fontCaption
                            onClicked: control.clearSelection()
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: Theme.strokeDivider
                    }
                }
            }

            delegate: ItemDelegate {
                id: row
                required property var modelData
                required property int index
                width: ListView.view.width
                height: Theme.controlHeight
                hoverEnabled: true
                padding: 8
                leftPadding: 12
                rightPadding: 12

                // True when this option is selected
                readonly property bool itemChecked: typeof modelData === "string"
                        ? false : !!modelData.checked
                // Display text for this option
                readonly property string itemText: typeof modelData === "string"
                        ? modelData : (modelData.text || modelData.title || "")

                onClicked: control.toggleAt(index)

                contentItem: RowLayout {
                    spacing: Theme.spacing

                    Rectangle {
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignVCenter
                        radius: 3
                        color: row.itemChecked ? Theme.accent : "transparent"
                        border.width: row.itemChecked ? 0 : 1
                        border.color: Theme.strokeControl
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: FluentIcons.Accept
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 11
                            color: Theme.textOnAccent
                            opacity: row.itemChecked ? 1 : 0
                            scale: row.itemChecked ? 1 : 0.6
                            Behavior on opacity {
                                enabled: !Theme.reducedMotion
                                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                            Behavior on scale {
                                enabled: !Theme.reducedMotion
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionFast)
                                    easing.type: Theme.easingEnter
                                }
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        text: row.itemText
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: row.itemChecked ? Theme.fontWeightSemiBold
                                                     : Theme.fontWeightRegular
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                    }
                }

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    radius: Theme.cornerControl
                    color: row.down ? Theme.fillSubtleTertiary
                         : (row.hovered ? Theme.fillSubtle : "transparent")
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }
        }
    }
}
