import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ComboBox — Fluent / WinUI 3 ComboBox (Header, editable, ShowError chrome).
//
//   ComboBox {
//       header: qsTr("Color")
//       model: ["Red", "Green", "Blue"]
//       onActivated: (index) => apply(index)
//   }
//
// @notes
//   Header / description / errorMessage around the field; filled | outline appearance.
//   editable uses an inline TextInput. FormLayout left headers: HeaderedComboBox.

T.ComboBox {
    id: control

    // WinUI Header — label above the field
    property string header: ""
    // Supporting caption under the header (hidden while errorMessage is set)
    property string description: ""
    // Validation message — critical caption; also paints error chrome
    property string errorMessage: ""
    // Form validation error flag (also treated as error when errorMessage is set)
    property bool hasError: false
    // Visual variant: filled | outline | "" (filled default)
    property string appearance: ""

    property int _errorShakeSeq: 0
    property real _shakeOffset: 0

    readonly property string _effectiveAppearance: appearance.length ? appearance : "filled"
    readonly property bool _outlineAppearance: _effectiveAppearance === "outline"
    readonly property bool _error: hasError || errorMessage.length > 0
    readonly property bool _critical: _error

    readonly property real _fieldH: Theme.controlHeight
    readonly property bool _hasHeader: header.length > 0
                                    || (description.length > 0 && !_error)
    readonly property bool _hasFooter: errorMessage.length > 0
    readonly property real _headerH: _hasHeader ? headerCol.implicitHeight + 4 : 0
    readonly property real _footerH: _hasFooter ? footerRow.implicitHeight + 4 : 0

    // True in light theme (legacy)
    readonly property bool lightScheme: !Theme.dark
    readonly property color __fill: {
        if (!control.enabled)
            return Theme.fillControlDisabled
        if (control._outlineAppearance)
            return "transparent"
        return Theme.borderedControlFill(control.hovered, control.down, !control.enabled)
    }

    on_ErrorChanged: {
        if (_error)
            _errorShakeSeq += 1
    }
    on_ErrorShakeSeqChanged: {
        if (_errorShakeSeq <= 0)
            return
        if (Theme.reducedMotion) {
            _shakeOffset = 0
            return
        }
        errorShakeAnim.restart()
    }

    SequentialAnimation {
        id: errorShakeAnim
        NumberAnimation { target: control; property: "_shakeOffset"; to: -4; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: 4; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: -2; duration: Theme.duration(40); easing.type: Theme.easingStandard }
        NumberAnimation { target: control; property: "_shakeOffset"; to: 0; duration: Theme.duration(40); easing.type: Theme.easingStandard }
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: {
        if (control.header.length)
            return control.header
        if (control.displayText.length)
            return control.displayText
        return qsTr("Combo box")
    }
    Accessible.description: {
        if (control.errorMessage.length)
            return control.errorMessage
        return control.description
    }

    implicitWidth: Math.max(Theme.controlMinWidth,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: _fieldH + _headerH + _footerH

    // Chevron sits on the trailing edge — swap padding under RTL / mirrored
    leftPadding: control.mirrored ? 32 : Theme.paddingControlH
    rightPadding: control.mirrored ? Theme.paddingControlH : 32
    topPadding: Theme.paddingControlV + _headerH
    bottomPadding: Theme.paddingControlV + _footerH
    spacing: Theme.spacing
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: control.editable ? Qt.IBeamCursor : Qt.PointingHandCursor }

    // Header above the field
    Column {
        id: headerCol
        z: 1
        x: 0
        y: 0
        width: control.width
        spacing: 2
        visible: control._hasHeader

        Text {
            width: parent.width
            visible: control.header.length > 0
            text: control.header
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            elide: Text.ElideRight
        }
        Text {
            width: parent.width
            visible: control.description.length > 0 && !control._error
            text: control.description
            font.pixelSize: Theme.fontCaption
            color: control.enabled ? Theme.textSecondary : Theme.textDisabled
            wrapMode: Text.WordWrap
        }
    }

    // Footer: error message
    Item {
        id: footerRow
        z: 1
        visible: control._hasFooter
        x: 0
        y: control.height - height
        width: control.width
        height: errorBlock.implicitHeight

        Row {
            id: errorBlock
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: control.errorMessage.length > 0

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: FluentIcons.Error
                font: Theme.iconFontFor(12)
                color: Theme.systemCritical
            }
            Text {
                width: Math.max(0, errorBlock.width - 16)
                text: control.errorMessage
                font.pixelSize: Theme.fontCaption
                color: Theme.systemCritical
                wrapMode: Text.WordWrap
            }
        }
    }

    delegate: T.ItemDelegate {
        id: delegateRoot
        required property var modelData
        required property int index
        width: ListView.view ? ListView.view.width : control.popup.width
        height: Theme.controlHeight
        highlighted: control.highlightedIndex === index
        text: {
            if (control.textRole && modelData !== undefined && modelData !== null
                    && typeof modelData === "object")
                return modelData[control.textRole] ?? ""
            return modelData === undefined || modelData === null ? "" : ("" + modelData)
        }
        hoverEnabled: true

        readonly property bool selected: index === control.currentIndex

        contentItem: Text {
            text: delegateRoot.text
            font: control.font
            color: {
                if (delegateRoot.down)
                    return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
                return Theme.textPrimary
            }
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            leftPadding: Theme.paddingControlH

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.pressed || control.popup.visible)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        background: Item {
            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                anchors.topMargin: 1
                anchors.bottomMargin: 1
                radius: Theme.cornerControl
                color: {
                    if (delegateRoot.down)
                        return Theme.fillSubtleTertiary
                    if (delegateRoot.highlighted || delegateRoot.hovered)
                        return Theme.fillSubtle
                    if (delegateRoot.selected)
                        return Theme.fillSubtleSecondary
                    return "transparent"
                }

                Behavior on color {
                    enabled: !Theme.reducedMotion
                             && (delegateRoot.hovered || delegateRoot.down
                                 || delegateRoot.highlighted || delegateRoot.selected)
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingControlH
                anchors.verticalCenter: parent.verticalCenter
                text: FluentIcons.CheckMark
                font: Theme.iconFontFor(12)
                color: Theme.accent
                opacity: delegateRoot.selected ? 1 : 0
                scale: delegateRoot.selected ? 1 : 0.6
                visible: opacity > 0.01 || delegateRoot.selected

                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }

    indicator: Text {
        x: control.mirrored ? 10 : control.width - width - 10
        y: control.topPadding + (control.availableHeight - height) / 2
             + (control.pressed ? 1 : 0)
        width: implicitWidth
        height: implicitHeight
        z: 2
        text: FluentIcons.ChevronDown
        font: Theme.iconFontFor(10)
        color: control.enabled ? Theme.textSecondary : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        rotation: control.down || control.popup.visible ? 180 : 0

        Behavior on y {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("normal")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on rotation {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("normal")
                easing.type: Theme.motionEasing("standard")
            }
        }
    }

    // Editable: live TextInput. Closed list: disable input so presses open the popup
    // (a read-only TextInput still steals clicks in the middle of the field).
    contentItem: TextInput {
        clip: true
        font: control.font
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.down && !control.editable)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
            return Theme.textPrimary
        }
        verticalAlignment: Text.AlignVCenter
        autoScroll: control.editable
        readOnly: !control.editable
        selectByMouse: control.editable
        activeFocusOnPress: control.editable
        // When not editable, stay disabled so mouse events reach ComboBox → open popup
        enabled: control.enabled && control.editable
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        text: control.editable ? control.editText : control.displayText
        // Keep label fully opaque even though this item is disabled when !editable
        opacity: 1

        onTextEdited: {
            if (control.editable)
                control.editText = text
        }

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Item {
        implicitWidth: Theme.controlMinWidth
        implicitHeight: control._fieldH

        Item {
            id: fieldHost
            x: control._shakeOffset
            y: control._headerH
            width: parent.width
            height: control._fieldH
            scale: control.pressed && !Theme.reducedMotion ? 0.98 : 1

            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                id: strokeShell
                anchors.fill: parent
                radius: Theme.cornerControl

                readonly property bool hasSolidStroke: control._critical || control.down
                                                   || !control.enabled || Theme.dark
                                                   || control._outlineAppearance
                readonly property bool hasGradientStroke: !hasSolidStroke && control.enabled
                readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
                readonly property color bottomStroke: Theme.dark ? "#18FFFFFF" : "#29000000"

                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                    }
                    GradientStop {
                        position: 0.91
                        color: strokeShell.hasGradientStroke ? strokeShell.topStroke : "transparent"
                    }
                    GradientStop {
                        position: 1.0
                        color: strokeShell.hasGradientStroke ? strokeShell.bottomStroke : "transparent"
                    }
                }

                Rectangle {
                    readonly property bool inset: strokeShell.hasGradientStroke
                    x: inset ? 1 : 0
                    y: inset ? 1 : 0
                    width: inset ? parent.width - 2 : parent.width
                    height: inset ? parent.height - 2 : parent.height
                    radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                    border.width: control._critical ? 2
                                 : (strokeShell.hasGradientStroke ? 0
                                    : (control._outlineAppearance && control.activeFocus ? 2 : 1))
                    border.color: control._critical ? Theme.systemCritical
                                  : (control.activeFocus && control._outlineAppearance
                                     ? Theme.accent : Theme.strokeControl)
                    color: control.__fill

                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingStandard
                        }
                    }
                    Behavior on border.color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }

                    Rectangle {
                        visible: !control._outlineAppearance && !control._critical
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: control.activeFocus ? 2 : 1
                        color: control.activeFocus ? Theme.accent : Theme.strokeControl
                        opacity: control.activeFocus ? 1 : 0.85
                    }
                    Rectangle {
                        visible: control._critical
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 2
                        color: Theme.systemCritical
                    }
                }
            }

            FocusStroke {
                anchors.fill: parent
                show: control.visualFocus
                frameRadius: Theme.cornerControl
            }
        }
    }

    popup: T.Popup {
        id: comboPopup
        // Open under the field chrome (not under error footer)
        y: control._headerH + control._fieldH + 2
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + topPadding + bottomPadding, 280)
        padding: 5
        topMargin: 8
        bottomMargin: 8
        transformOrigin: Item.Top

        onAboutToShow: {
            popupList.positionViewAtIndex(Math.max(0, control.currentIndex), ListView.Contain)
            selectionPip.snapTo(control.currentIndex)
        }
        onOpened: {
            popupList.positionViewAtIndex(Math.max(0, control.currentIndex), ListView.Contain)
            selectionPip.snapTo(control.currentIndex)
        }

        contentItem: Item {
            implicitHeight: popupList.contentHeight

            ListView {
                id: popupList
                anchors.fill: parent
                clip: true
                implicitHeight: contentHeight
                model: control.delegateModel
                currentIndex: control.highlightedIndex >= 0 ? control.highlightedIndex
                                                            : control.currentIndex
                highlightMoveDuration: 0
                spacing: 2
                ScrollIndicator.vertical: ScrollIndicator {}
            }

            SelectionPip {
                id: selectionPip
                listView: popupList
                targetIndex: control.currentIndex
            }
        }

        background: ElevatedChrome {
            implicitWidth: 120
            implicitHeight: 40
            color: Theme.bgCardElevated
            radius: Theme.cornerOverlay
            borderColor: Theme.strokeCard
            borderWidth: 1
            elevation: 6
            shadowOpacity: Theme.dark ? 0.28 : 0.14
        }

        enter: Transition {
            NumberAnimation {
                property: "height"
                from: comboPopup.implicitHeight * 0.33
                to: comboPopup.implicitHeight
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
    }
}
