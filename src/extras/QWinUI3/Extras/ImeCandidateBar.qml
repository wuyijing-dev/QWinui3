import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ImeCandidateBar — Win11-style in-app pinyin candidate strip (1.72).
//
//   ImeCandidateBar { engine: osk.engine }
//
// @notes
//   Host above OnScreenKeyboard. Theme tokens only. No focus steal.
//   Lexicon is MIT pinyin-data / phrase-pinyin-data, not Microsoft Pinyin.

T.Control {
    id: root

    property KeyboardEngine engine

    visible: engine && (engine.composing || engine.candidates.length > 0)
    implicitHeight: visible ? Math.max(Theme.dp(40), Theme.controlHeight) : 0
    implicitWidth: 640
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Pinyin candidates")

    background: Rectangle {
        visible: root.visible
        color: Theme.bgCard
        radius: Theme.cornerControl
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    contentItem: Row {
        id: row
        spacing: Theme.dp(6)
        leftPadding: Theme.dp(8)
        rightPadding: Theme.dp(8)
        height: root.availableHeight

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.engine ? root.engine.preedit : ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.underline: true
            color: Theme.textSecondary
            width: Theme.dp(88)
            elide: Text.ElideLeft
        }

        Repeater {
            model: root.engine ? root.engine.pagedCandidates : []
            delegate: Rectangle {
                required property int index
                required property string modelData
                width: Math.max(Theme.dp(36), label.implicitWidth + Theme.dp(16))
                height: Theme.dp(32)
                anchors.verticalCenter: parent.verticalCenter
                radius: Theme.cornerControl
                color: ma.containsPress ? Theme.fillControlTertiary
                     : ma.containsMouse ? Theme.fillControlSecondary
                     : Theme.fillSubtle
                border.width: Theme.strokeHairline
                border.color: Theme.strokeControl

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: (index + 1) + " " + modelData
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    color: Theme.textPrimary
                }
                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: true
                    onClicked: root.engine.pickCandidate(index)
                }
                Accessible.role: Accessible.Button
                Accessible.name: modelData
                Accessible.onPressAction: root.engine.pickCandidate(index)
            }
        }

        Rectangle {
            visible: root.engine && root.engine.candidatePageCount > 1
            width: Theme.dp(32)
            height: Theme.dp(32)
            anchors.verticalCenter: parent.verticalCenter
            radius: Theme.cornerControl
            color: Theme.fillControl
            FontIcon {
                anchors.centerIn: parent
                symbol: FluentIcons.ChevronLeft
                fontSize: Theme.fontCaption
            }
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onClicked: root.engine.prevCandidatePage()
            }
        }
        Rectangle {
            visible: root.engine && root.engine.candidatePageCount > 1
            width: Theme.dp(32)
            height: Theme.dp(32)
            anchors.verticalCenter: parent.verticalCenter
            radius: Theme.cornerControl
            color: Theme.fillControl
            FontIcon {
                anchors.centerIn: parent
                symbol: FluentIcons.ChevronRight
                fontSize: Theme.fontCaption
            }
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onClicked: root.engine.nextCandidatePage()
            }
        }
    }
}
