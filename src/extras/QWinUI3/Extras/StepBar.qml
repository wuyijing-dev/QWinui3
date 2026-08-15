import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// StepBar — Horizontal step / wizard progress.
//
//   StepBar { model: ["Cart", "Ship", "Pay"]; currentIndex: 1 }

T.Control {
    id: control

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // horizontal | vertical
    property string orientation: "horizontal"
    // Alias of interactive
    property bool isInteractive: true
    // Step Activated
    signal stepActivated(int index)

    readonly property bool _vertical: orientation === "vertical"

    function next() {
        if (currentIndex < (model ? model.length : 0) - 1) {
            currentIndex++
            stepActivated(currentIndex)
        }
    }
    function previous() {
        if (currentIndex > 0) {
            currentIndex--
            stepActivated(currentIndex)
        }
    }
    function goTo(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        currentIndex = index
        stepActivated(index)
    }

    implicitWidth: _vertical
                   ? Math.max(160, contentItem.implicitWidth + leftPadding + rightPadding)
                   : (contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight + 8,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Steps")
    Accessible.description: qsTr("Step %1 of %2").arg(currentIndex + 1).arg(model ? model.length : 0)

    contentItem: Loader {
        sourceComponent: control._vertical ? verticalComp : horizontalComp
    }

    Component {
        id: horizontalComp
        RowLayout {
            id: row
            spacing: 0
            width: control.availableWidth

            Repeater {
                model: control.model

                RowLayout {
                    id: stepRow
                    required property var modelData
                    required property int index
                    spacing: 0
                    Layout.fillWidth: true

                    AbstractButton {
                        id: stepBtn
                        Layout.fillWidth: true
                        enabled: control.isInteractive
                        hoverEnabled: control.isInteractive
                        onClicked: {
                            if (!control.isInteractive)
                                return
                            control.currentIndex = index
                            control.stepActivated(index)
                        }

                        contentItem: ColumnLayout {
                            spacing: 6
                            RowLayout {
                                spacing: 8
                                Layout.alignment: Qt.AlignHCenter
                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: width / 2
                                    color: index <= control.currentIndex ? Theme.accent : Theme.fillSubtle
                                    border.width: index === control.currentIndex ? 0 : 1
                                    border.color: Theme.strokeControl
                                    scale: stepBtn.down ? 0.92 : 1
                                    Behavior on color {
                                        enabled: !Theme.reducedMotion
                                        ColorAnimation {
                                            duration: Theme.duration(Theme.motionNormal)
                                            easing.type: Theme.easingStandard
                                        }
                                    }
                                    Behavior on scale {
                                        enabled: !Theme.reducedMotion
                                        NumberAnimation {
                                            duration: Theme.duration(Theme.motionFast)
                                        }
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        text: index < control.currentIndex ? FluentIcons.Accept : String(index + 1)
                                        font.family: index < control.currentIndex ? Theme.fontFamilyIcon : Theme.fontFamily
                                        font.pixelSize: index < control.currentIndex ? 10 : Theme.fontCaption
                                        font.weight: Theme.fontWeightSemiBold
                                        color: index <= control.currentIndex ? Theme.textOnAccent : Theme.textSecondary
                                    }
                                }
                                Text {
                                    text: typeof modelData === "string" ? modelData : (modelData.title || "")
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontCaption
                                    font.weight: index === control.currentIndex ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                                    color: index <= control.currentIndex ? Theme.textPrimary : Theme.textSecondary
                                    elide: Text.ElideRight
                                    Behavior on color {
                                        enabled: !Theme.reducedMotion
                                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                    }
                                }
                            }
                            Text {
                                visible: typeof modelData !== "string" && !!(modelData.description)
                                text: typeof modelData === "string" ? "" : (modelData.description || "")
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                                color: Theme.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true
                                wrapMode: Text.Wrap
                            }
                        }

                        background: Rectangle {
                            radius: Theme.cornerControl
                            color: stepBtn.hovered ? Theme.fillSubtleSecondary : "transparent"
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                    }

                    Rectangle {
                        visible: index < control.model.length - 1
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 2
                        Layout.alignment: Qt.AlignVCenter
                        radius: 1
                        color: index < control.currentIndex ? Theme.accent : Theme.strokeDivider
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: verticalComp
        ColumnLayout {
            spacing: 0
            width: control.availableWidth > 0 ? control.availableWidth : 200

            Repeater {
                model: control.model

                ColumnLayout {
                    required property var modelData
                    required property int index
                    spacing: 0
                    Layout.fillWidth: true

                    AbstractButton {
                        Layout.fillWidth: true
                        enabled: control.isInteractive
                        hoverEnabled: control.isInteractive
                        onClicked: {
                            if (!control.isInteractive)
                                return
                            control.currentIndex = index
                            control.stepActivated(index)
                        }

                        contentItem: RowLayout {
                            spacing: 12
                            Rectangle {
                                width: 24
                                height: 24
                                radius: width / 2
                                color: index <= control.currentIndex ? Theme.accent : Theme.fillSubtle
                                border.width: index === control.currentIndex ? 0 : 1
                                border.color: Theme.strokeControl
                                Layout.alignment: Qt.AlignTop
                                Text {
                                    anchors.centerIn: parent
                                    text: index < control.currentIndex ? FluentIcons.Accept : String(index + 1)
                                    font.family: index < control.currentIndex ? Theme.fontFamilyIcon : Theme.fontFamily
                                    font.pixelSize: index < control.currentIndex ? 10 : Theme.fontCaption
                                    font.weight: Theme.fontWeightSemiBold
                                    color: index <= control.currentIndex ? Theme.textOnAccent : Theme.textSecondary
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    text: typeof modelData === "string" ? modelData : (modelData.title || "")
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontBody
                                    font.weight: index === control.currentIndex ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                                    color: index <= control.currentIndex ? Theme.textPrimary : Theme.textSecondary
                                    Layout.fillWidth: true
                                }
                                Text {
                                    visible: typeof modelData !== "string" && !!(modelData.description)
                                    text: typeof modelData === "string" ? "" : (modelData.description || "")
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontCaption
                                    color: Theme.textSecondary
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        background: Rectangle {
                            radius: Theme.cornerControl
                            color: parent.hovered ? Theme.fillSubtleSecondary : "transparent"
                        }
                    }

                    Rectangle {
                        visible: index < control.model.length - 1
                        Layout.leftMargin: 11
                        Layout.preferredWidth: 2
                        Layout.preferredHeight: 20
                        radius: 1
                        color: index < control.currentIndex ? Theme.accent : Theme.strokeDivider
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                }
            }
        }
    }
}
