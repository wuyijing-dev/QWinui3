import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QWinUI3.Theme

Rectangle {
    id: root

    property string headerText: ""
    property string qmlSource: ""
    property bool bordered: true
    default property alias sampleData: sampleColumn.data

    color: Theme.bgCard
    radius: Theme.cornerCard
    border.width: bordered ? 1 : 0
    border.color: Theme.strokeCard
    Layout.fillWidth: true
    clip: false
    implicitHeight: mainCol.implicitHeight

    layer.enabled: bordered
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: Theme.dark ? 0.14 : 0.06
        shadowColor: "#000000"
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 2
        blurMax: 12
        // Padding shifts the layer vs hit-test geometry and eats clicks on compact chrome.
        autoPaddingEnabled: false
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 48

            Rectangle {
                anchors.fill: parent
                color: Theme.fillSubtleSecondary
                // Match host radius — opaque children are not clipped to parent radius.
                topLeftRadius: root.radius
                topRightRadius: root.radius
            }

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                text: root.headerText
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                elide: Text.ElideRight
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Theme.strokeDivider
            }
        }

        ColumnLayout {
            id: sampleColumn
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 16
            Layout.bottomMargin: 16
            spacing: Theme.spacingLoose
        }

        Rectangle {
            visible: root.qmlSource.length > 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        ColumnLayout {
            visible: root.qmlSource.length > 0
            Layout.fillWidth: true
            spacing: 0

            ItemDelegate {
                id: expander
                Layout.fillWidth: true
                height: Theme.navItemHeight
                checkable: true
                checked: false

                contentItem: RowLayout {
                    spacing: Theme.spacing
                    Text {
                        text: FluentIcons.ChevronDown
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 12
                        color: Theme.textSecondary
                        rotation: expander.checked ? 180 : 0
                        Behavior on rotation {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionNormal)
                                easing.type: Theme.easingStandard
                            }
                        }
                    }
                    Text {
                        text: qsTr("Source code")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        color: Theme.textPrimary
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                id: codeHost
                visible: expander.checked || height > 0
                Layout.fillWidth: true
                color: Theme.dark ? "#1A1A1A" : "#F5F5F5"
                bottomLeftRadius: root.radius
                bottomRightRadius: root.radius
                clip: true
                implicitHeight: expander.checked ? (codeEdit.implicitHeight + 24) : 0
                opacity: expander.checked ? 1 : 0

                Behavior on implicitHeight {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: expander.checked ? Theme.easingEnter : Theme.easingExit
                    }
                }
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }

                TextEdit {
                    id: codeEdit
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 12
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextEdit.NoWrap
                    text: root.qmlSource
                    color: Theme.textPrimary
                    font: ThemeFonts.monoFontFor(Theme.fontCaption)
                    textFormat: TextEdit.PlainText
                }
            }
        }
    }
}
