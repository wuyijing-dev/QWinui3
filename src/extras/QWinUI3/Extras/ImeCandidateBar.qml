import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ImeCandidateBar — Win11-style in-app IME candidate strip (1.74).
//
//   ImeCandidateBar { engine: osk.engine }
//
// @notes
//   Host above OnScreenKeyboard. Theme tokens only. No focus steal.
//   Shared by pinyin / romaji-kana / hangul. Digits 1–9 / Space via engine.
//   Not Microsoft IME.

T.Control {
    id: root

    property KeyboardEngine engine

    visible: engine && (engine.composing || engine.candidates.length > 0)
    implicitHeight: visible ? Math.max(Theme.dp(40), Theme.controlHeight) : 0
    implicitWidth: 640
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("IME candidates")
    Accessible.description: {
        if (!engine || engine.candidatePageCount <= 0)
            return qsTr("Space confirms the first candidate. Digits 1 to 9 pick on the current page.")
        return qsTr("Page %1 of %2. Space confirms the first candidate. Digits 1 to 9 pick on the current page.")
            .arg(engine.candidatePage + 1)
            .arg(engine.candidatePageCount)
    }

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
            Accessible.role: Accessible.StaticText
            Accessible.name: qsTr("Composition %1").arg(text)
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
                    Accessible.ignored: true
                }
                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: true
                    onClicked: root.engine.pickCandidate(index)
                }
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("Candidate %1 %2").arg(index + 1).arg(modelData)
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
                Accessible.ignored: true
            }
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onClicked: root.engine.prevCandidatePage()
            }
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Previous candidate page")
            Accessible.onPressAction: root.engine.prevCandidatePage()
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
                Accessible.ignored: true
            }
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onClicked: root.engine.nextCandidatePage()
            }
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Next candidate page")
            Accessible.onPressAction: root.engine.nextCandidatePage()
        }
    }
}
