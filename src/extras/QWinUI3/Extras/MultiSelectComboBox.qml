import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// MultiSelectComboBox — Combo that keeps the popup open for multi-select.
//
//   MultiSelectComboBox {
//       id: multiSelectComboBox
//       header: qsTr("Teams")
//       model: items; selectedIndexes: [0, 2]
//   }
//
//   // --- API ---
//   // signals: onSelectionChanged
//   // methods: toggleAt(index), ensureObjectModel(), selectAll(), clearSelection(), focusField()
//   // inherits Control (+ Qt Quick Controls base API)
//
// @notes
//   ComboBox with multi-check selection; selectedIndexes / selectedItems.
//   header / description / errorMessage for FormLayout (2.25).

T.Control {
    id: root

    Layout.fillWidth: true

    property var model: []
    property string placeholderText: qsTr("Select items")
    property string header: ""
    property string description: ""
    property string errorMessage: ""
    property string headerPlacement: "top"
    property real labelWidth: 120
    property bool formBound: true

    signal selectionChanged(var selected)

    readonly property bool hasError: errorMessage.length > 0
    readonly property bool _headerLeft: headerPlacement === "left"
    readonly property bool menuOpen: popup.visible
    property alias isOpen: popup.visible

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

    property var selectedIndexes: []
    property bool _syncingIndexes: false

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

    implicitWidth: 280
    implicitHeight: contentRoot.implicitHeight
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.ComboBox
    Accessible.name: header.length ? header : qsTr("Multi-select")
    Accessible.description: hasError ? errorMessage : displayText
    Accessible.onPressAction: combo.clicked()

    function focusField() { combo.forceActiveFocus() }

    function _indexesFromModel() {
        var out = []
        var m = model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (typeof it !== "string" && it && it.checked)
                out.push(i)
        }
        return out
    }

    function _syncIndexesFromModel() {
        _syncingIndexes = true
        selectedIndexes = _indexesFromModel()
        _syncingIndexes = false
    }

    function setSelectedIndexes(indexes) {
        ensureObjectModel()
        var want = {}
        var list = indexes || []
        for (var i = 0; i < list.length; ++i)
            want[list[i]] = true
        var next = (model || []).slice()
        for (var j = 0; j < next.length; ++j) {
            var copy = Object.assign({}, next[j])
            copy.checked = !!want[j]
            next[j] = copy
        }
        model = next
        _syncIndexesFromModel()
        selectionChanged(selectedItems)
    }

    onSelectedIndexesChanged: {
        if (_syncingIndexes)
            return
        setSelectedIndexes(selectedIndexes)
    }

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
        _syncIndexesFromModel()
        selectionChanged(selectedItems)
    }

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

    function selectAll() {
        ensureObjectModel()
        var next = (model || []).slice()
        for (var i = 0; i < next.length; ++i) {
            var copy = Object.assign({}, next[i])
            copy.checked = true
            next[i] = copy
        }
        model = next
        _syncIndexesFromModel()
        selectionChanged(selectedItems)
    }

    function clearSelection() {
        ensureObjectModel()
        var next = (model || []).slice()
        for (var i = 0; i < next.length; ++i) {
            var copy = Object.assign({}, next[i])
            copy.checked = false
            next[i] = copy
        }
        model = next
        _syncIndexesFromModel()
        selectionChanged(selectedItems)
    }

    Component.onCompleted: {
        ensureObjectModel()
        _syncIndexesFromModel()
    }

    contentItem: GridLayout {
        id: contentRoot
        columns: root._headerLeft ? 2 : 1
        columnSpacing: Theme.spacingLoose
        rowSpacing: 4

        ColumnLayout {
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: !root._headerLeft
            Layout.preferredWidth: root._headerLeft ? root.labelWidth : -1
            Layout.maximumWidth: root._headerLeft ? root.labelWidth : -1
            Layout.alignment: root._headerLeft ? Qt.AlignVCenter : Qt.AlignLeading
            spacing: 4
            visible: root.header.length > 0 || (root.description.length > 0 && !root.hasError)

            Text {
                visible: root.header.length > 0
                Layout.fillWidth: true
                text: root.header
                font.family: root.font.family
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                elide: Text.ElideRight
            }
            Text {
                visible: root.description.length > 0 && !root.hasError
                Layout.fillWidth: true
                text: root.description
                font.family: root.font.family
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }

        ColumnLayout {
            Layout.row: root._headerLeft ? 0 : 1
            Layout.column: root._headerLeft ? 1 : 0
            Layout.fillWidth: true
            spacing: 4

            T.AbstractButton {
                id: combo
                Layout.fillWidth: true
                implicitHeight: Theme.controlHeight
                hoverEnabled: true
                focusPolicy: Qt.StrongFocus
                leftPadding: Theme.paddingControlH
                rightPadding: 10
                topPadding: Theme.paddingControlV
                bottomPadding: Theme.paddingControlV

                Keys.onDownPressed: {
                    if (!popup.visible)
                        popup.open()
                }
                Keys.onEscapePressed: {
                    if (popup.visible)
                        popup.close()
                }

                onClicked: {
                    root.ensureObjectModel()
                    if (popup.visible)
                        popup.close()
                    else
                        popup.open()
                }

                contentItem: RowLayout {
                    spacing: 8
                    Text {
                        Layout.fillWidth: true
                        text: root.displayText
                        elide: Text.ElideRight
                        font.family: root.font.family
                        font.pixelSize: root.font.pixelSize
                        color: root.selectedItems.length ? Theme.textPrimary : Theme.textSecondary
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        text: FluentIcons.ChevronDown
                        font: Theme.iconFontFor(10)
                        color: Theme.textSecondary
                        rotation: root.menuOpen ? 180 : 0
                    }
                }

                background: Item {
                    implicitHeight: Theme.controlHeight

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.cornerControl
                        color: combo.hovered || root.menuOpen
                               ? Theme.fillControlSecondary
                               : (Theme.dark ? "#0FFFFFFF" : "#FFFFFF")
                        border.width: 1
                        border.color: root.hasError ? Theme.systemCritical : Theme.strokeControl

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: root.menuOpen || root.hasError ? 2 : 1
                            color: root.hasError ? Theme.systemCritical
                                 : (root.menuOpen ? Theme.accent : Theme.strokeControl)
                        }
                    }

                    FocusStroke {
                        anchors.fill: parent
                        show: combo.visualFocus
                        frameRadius: Theme.cornerControl
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: root.hasError
                Text {
                    text: FluentIcons.Error
                    font: Theme.iconFontFor(12)
                    color: Theme.systemCritical
                }
                Text {
                    Layout.fillWidth: true
                    text: root.errorMessage
                    font.family: root.font.family
                    font.pixelSize: Theme.fontCaption
                    color: Theme.systemCritical
                    wrapMode: Text.Wrap
                }
            }
        }
    }

    background: Item {}

    Popup {
        id: popup
        parent: combo
        y: combo.height + 4
        width: Math.max(200, combo.width)
        padding: 5
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        transformOrigin: Item.Top
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
            model: root.model
            spacing: 2
            boundsBehavior: Flickable.StopAtBounds

            header: Item {
                width: list.width
                height: popupHeaderCol.implicitHeight + 4

                ColumnLayout {
                    id: popupHeaderCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 4
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        spacing: 4
                        Button {
                            flat: true
                            text: qsTr("Select all")
                            font.pixelSize: Theme.fontCaption
                            onClicked: root.selectAll()
                        }
                        Button {
                            flat: true
                            text: qsTr("Clear")
                            font.pixelSize: Theme.fontCaption
                            onClicked: root.clearSelection()
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

                readonly property bool itemChecked: typeof modelData === "string"
                        ? false : !!modelData.checked
                readonly property string itemText: typeof modelData === "string"
                        ? modelData : (modelData.text || modelData.title || "")

                onClicked: root.toggleAt(index)

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

                        Text {
                            anchors.centerIn: parent
                            text: FluentIcons.Accept
                            font: Theme.iconFontFor(11)
                            color: Theme.textOnAccent
                            opacity: row.itemChecked ? 1 : 0
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: row.itemText
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
                }
            }
        }
    }
}
