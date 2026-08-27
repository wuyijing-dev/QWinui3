import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TextField — Fluent / WinUI 3 TextBox-style TextField.
//
//   TextField {
//       header: qsTr("Name")
//       description: qsTr("Displayed on your profile.")
//       placeholderText: qsTr("Enter a name")
//       clearButtonVisible: true
//   }
//
// @notes
//   Header / description / errorMessage / characterLimit chrome around the field.
//   appearance: filled | outline. Leading icon + clear. For FormLayout left headers use HeaderedTextBox.

T.TextField {
    id: control

    // WinUI Header — label above the field
    property string header: ""
    // Supporting caption under the header (hidden while errorMessage is set)
    property string description: ""
    // Validation message — critical caption; also paints error chrome
    property string errorMessage: ""
    // Soft character counter (0 = hidden). Over-limit paints critical.
    property int characterLimit: 0
    // Form validation error flag (also treated as error when errorMessage is set)
    property bool hasError: false
    // Visual variant: filled | outline | "" (filled default)
    property string appearance: ""
    // Leading FluentIcons symbol (preferred) or raw glyph
    property var leadingSymbol: ""
    property string leadingGlyph: ""
    // Show clear (×) when non-empty and editable
    property bool clearButtonVisible: true
    // WinUI IsReadOnly alias
    property alias isReadOnly: control.readOnly

    property int _errorShakeSeq: 0
    property real _shakeOffset: 0

    readonly property string _effectiveAppearance: appearance.length ? appearance : "filled"
    readonly property bool _outlineAppearance: _effectiveAppearance === "outline"
    readonly property string _leadingGlyph: {
        var fromSym = IconSource.resolve(leadingSymbol, "")
        if (fromSym.length)
            return fromSym
        return IconSource.resolve(leadingGlyph, "")
    }
    readonly property bool _showLeading: _leadingGlyph.length > 0
    readonly property bool _showClear: clearButtonVisible && !readOnly && enabled && text.length > 0
    readonly property bool _error: hasError || errorMessage.length > 0
    readonly property int characterCount: text.length
    readonly property bool overLimit: characterLimit > 0 && characterCount > characterLimit
    readonly property bool _critical: _error || overLimit

    readonly property real _fieldH: Theme.searchBoxHeight
    readonly property bool _hasHeader: header.length > 0
                                    || (description.length > 0 && !_error)
    readonly property bool _hasFooter: errorMessage.length > 0 || characterLimit > 0
    readonly property real _headerH: _hasHeader ? headerCol.implicitHeight + 4 : 0
    readonly property real _footerH: _hasFooter ? footerRow.implicitHeight + 4 : 0

    on_ErrorChanged: {
        if (_error)
            _errorShakeSeq += 1
    }
    onOverLimitChanged: {
        if (overLimit)
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

    Accessible.role: Accessible.EditableText
    Accessible.name: {
        if (control.header.length)
            return control.header
        if (control.placeholderText.length)
            return control.placeholderText
        return qsTr("Text field")
    }
    Accessible.description: {
        if (control.errorMessage.length)
            return control.errorMessage
        return control.description
    }
    Accessible.readOnly: control.readOnly

    implicitWidth: Math.max(200, contentWidth + leftPadding + rightPadding)
    implicitHeight: _fieldH + _headerH + _footerH

    leftPadding: Theme.paddingControlH
                 + (control.mirrored ? (control._showClear ? 28 : 0)
                                     : (control._showLeading ? 22 : 0))
    rightPadding: Theme.paddingControlH
                  + (control.mirrored ? (control._showLeading ? 22 : 0)
                                      : (control._showClear ? 28 : 0))
    topPadding: Theme.paddingControlV + _headerH
    bottomPadding: Theme.paddingControlV + _footerH

    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    placeholderTextColor: Theme.textSecondary
    selectionColor: Theme.accent
    selectedTextColor: Theme.textOnAccent
    font.pixelSize: Theme.fontBody
    verticalAlignment: TextInput.AlignVCenter
    hoverEnabled: true

    PointerCursor { shape: control.readOnly ? Qt.ArrowCursor : Qt.IBeamCursor }

    // Header above the field (uses topPadding reservation)
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

    // Footer below the field (uses bottomPadding reservation)
    Item {
        id: footerRow
        z: 1
        visible: control._hasFooter
        x: 0
        y: control.height - height
        width: control.width
        height: Math.max(errorBlock.implicitHeight, counterText.implicitHeight)

        Row {
            id: errorBlock
            anchors.left: parent.left
            anchors.right: counterText.visible ? counterText.left : parent.right
            anchors.rightMargin: counterText.visible ? Theme.spacing : 0
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

        Text {
            id: counterText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: control.characterLimit > 0
            text: qsTr("%1 / %2").arg(control.characterCount).arg(control.characterLimit)
            font.pixelSize: Theme.fontCaption
            color: control.overLimit ? Theme.systemCritical : Theme.textSecondary
        }
    }

    // Background fills the whole control (QQC2); field chrome is inset to the content band.
    background: Item {
        implicitWidth: 200
        implicitHeight: control._fieldH

        Item {
            id: fieldHost
            x: control._shakeOffset
            y: control._headerH
            width: parent.width
            height: control._fieldH

            Rectangle {
                id: fieldChrome
                anchors.fill: parent
                radius: Theme.cornerControl
                color: {
                    if (!control.enabled)
                        return Theme.fillControlDisabled
                    if (control.readOnly)
                        return Theme.dark ? "#0AFFFFFF" : "#08000000"
                    if (control.hovered && !control.readOnly)
                        return Theme.fillControlSecondary
                    if (control._outlineAppearance)
                        return "transparent"
                    return Theme.bgControlRest
                }
                border.width: control._critical ? 2
                            : (control._outlineAppearance && control.activeFocus ? 2 : 1)
                border.color: control._critical ? Theme.systemCritical
                              : (control.activeFocus && control._outlineAppearance
                                 ? Theme.accent : Theme.strokeControl)

                Behavior on color {
                    enabled: !Theme.reducedMotion && (control.hovered || control.activeFocus)
                    ColorAnimation {
                        duration: Theme.motionMs("normal")
                        easing.type: Theme.motionEasing("standard")
                    }
                }
                Behavior on border.color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.motionMs("fast")
                        easing.type: Theme.motionEasing("standard")
                    }
                }

                Rectangle {
                    id: underline
                    visible: !control._outlineAppearance
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: control.activeFocus || control._critical ? 2 : 1
                    color: control._critical ? Theme.systemCritical
                         : (control.activeFocus ? Theme.accent : Theme.strokeControl)
                    opacity: control.activeFocus || control._critical ? 1 : 0.85

                    Behavior on height {
                        enabled: !Theme.reducedMotion && (control.activeFocus || control.hovered)
                        NumberAnimation {
                            duration: Theme.motionMs("normal")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                                 && (control.activeFocus || control.hovered || control._critical)
                        ColorAnimation {
                            duration: Theme.motionMs("normal")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }

                    transform: Scale {
                        origin.x: underline.width / 2
                        xScale: (control.activeFocus || control._critical) ? 1
                              : (Theme.reducedMotion ? 1 : 0.28)
                        Behavior on xScale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.motionMs("normal")
                                easing.type: Theme.motionEasing("standard")
                            }
                        }
                    }
                }
            }

            Text {
                visible: control._showLeading
                anchors.left: control.mirrored ? undefined : parent.left
                anchors.right: control.mirrored ? parent.right : undefined
                anchors.leftMargin: control.mirrored ? 0 : Theme.paddingControlH - 2
                anchors.rightMargin: control.mirrored ? Theme.paddingControlH - 2 : 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Theme.iconOpticalOffset(14).y
                text: control._leadingGlyph
                font: Theme.iconFontFor(14)
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                Accessible.ignored: true
            }

            Item {
                id: clearHit
                visible: control._showClear
                anchors.right: control.mirrored ? undefined : parent.right
                anchors.left: control.mirrored ? parent.left : undefined
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                z: 2

                Rectangle {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 10
                    color: clearHover.hovered ? Theme.fillSubtle : "transparent"
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.motionMs("fast")
                            easing.type: Theme.motionEasing("standard")
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: FluentIcons.ChromeClose
                        font: Theme.iconFontFor(10)
                        color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                    }
                }

                HoverHandler { id: clearHover }
                TapHandler {
                    onTapped: {
                        control.clear()
                        control.forceActiveFocus()
                    }
                }
                PointerCursor { shape: Qt.PointingHandCursor }
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("Clear")
                Accessible.onPressAction: {
                    control.clear()
                    control.forceActiveFocus()
                }
            }

            FocusStroke {
                anchors.fill: parent
                show: control.activeFocus && (control.focusReason === Qt.TabFocusReason
                                              || control.focusReason === Qt.BacktabFocusReason)
            }
        }
    }
}
