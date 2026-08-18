import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ComboBox — Fluent ComboBox with rotating chevron indicator.
//
//   ComboBox {
//       id: combo
//       model: ["Red", "Green", "Blue"]
//       onActivated: (index) => apply(index)
//   }
//   // --- API ---
//   // combo.model / currentIndex / currentText / activated() / accepted()
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls ComboBox.
//   Public API is the Qt Quick Controls ComboBox type; this file supplies visuals/metrics only.

T.ComboBox {
    id: control


    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText.length ? control.displayText : qsTr("Combo box")
    implicitWidth: Math.max(Theme.controlMinWidth,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight

    leftPadding: Theme.paddingControlH
    rightPadding: 32
    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    // True in light theme
    readonly property bool lightScheme: !Theme.dark
    readonly property color __fill: Theme.borderedControlFill(control.hovered, control.down, !control.enabled)

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

        // Selected state
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
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        // Hover / keyboard highlight only — accent pip is shared & tracks selection
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
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }

    indicator: Text {
        x: control.mirrored ? control.leftPadding : control.width - width - 10
        y: control.topPadding + (control.availableHeight - height) / 2
             + (control.pressed ? 1 : 0)
        width: implicitWidth
        height: implicitHeight
        text: FluentIcons.ChevronDown
        font.family: Theme.fontFamilyIcon
        font.pixelSize: 10
        color: control.enabled ? Theme.textSecondary : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        rotation: control.down || control.popup.visible ? 180 : 0

        Behavior on y {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on rotation {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }
    }

    contentItem: Text {
        text: control.displayText
        font: control.font
        color: {
            if (!control.enabled)
                return Theme.textDisabled
            if (control.down)
                return Theme.dark ? Qt.rgba(1, 1, 1, 0.7725) : Qt.rgba(0, 0, 0, 0.62)
            return Theme.textPrimary
        }
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

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
        implicitHeight: Theme.controlHeight
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

            // Draw solid stroke chrome
            readonly property bool hasSolidStroke: control.down || !control.enabled || Theme.dark
            // Draw gradient stroke chrome
            readonly property bool hasGradientStroke: !hasSolidStroke && control.enabled
            // Top edge stroke width
            readonly property color topStroke: Theme.dark ? "#12FFFFFF" : "#0F000000"
            // Bottom edge stroke width
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
                // Content inset
                readonly property bool inset: strokeShell.hasGradientStroke
                x: inset ? 1 : 0
                y: inset ? 1 : 0
                width: inset ? parent.width - 2 : parent.width
                height: inset ? parent.height - 2 : parent.height
                radius: inset ? Theme.cornerControl - 1 : Theme.cornerControl
                border.width: strokeShell.hasGradientStroke ? 0 : 1
                border.color: Theme.strokeControl
                color: control.__fill

                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
    }

    popup: T.Popup {
        id: comboPopup
        y: control.height + 2
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + topPadding + bottomPadding, 280)
        padding: 5
        topMargin: 8
        bottomMargin: 8
        transformOrigin: Item.Top

        // Open on the currently selected item
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
                // Follow pointer/keyboard while open; falls back to selection
                currentIndex: control.highlightedIndex >= 0 ? control.highlightedIndex
                                                            : control.currentIndex
                highlightMoveDuration: 0
                spacing: 2
                ScrollIndicator.vertical: ScrollIndicator {}
            }

            SelectionPip {
                id: selectionPip
                listView: popupList
                // Indicator stays on the committed selection; open scrolls to it
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
