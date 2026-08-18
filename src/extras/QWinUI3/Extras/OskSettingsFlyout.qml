import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OskSettingsFlyout — Win11-style keyboard settings (size, voice/handwriting, user lexicon).
T.Control {
    id: root

    property KeyboardEngine engine
    property OskSpeechService speech
    property OskHandwritingService handwriting
    property string keyboardSize: "default"
    property var onKeyboardSizeChanged: null
    property var onOpenVoice: null
    property var onOpenHandwriting: null

    implicitWidth: 640
    implicitHeight: col.implicitHeight + Theme.dp(16)
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    contentItem: Column {
        id: col
        spacing: Theme.dp(8)
        leftPadding: Theme.dp(10)
        rightPadding: Theme.dp(10)
        topPadding: Theme.dp(10)
        bottomPadding: Theme.dp(10)

        Text {
            text: qsTr("Keyboard size")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Row {
            spacing: Theme.dp(6)
            Repeater {
                model: [
                    { id: "small", label: qsTr("Small") },
                    { id: "default", label: qsTr("Default") },
                    { id: "wide", label: qsTr("Large") }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: chipLabel.implicitWidth + Theme.dp(16)
                    height: Theme.dp(28)
                    radius: height / 2
                    color: root.keyboardSize === modelData.id ? Theme.fillAccent : Theme.fillControl
                    Text {
                        id: chipLabel
                        anchors.centerIn: parent
                        text: modelData.label
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: root.keyboardSize === modelData.id ? Theme.textOnAccent : Theme.textPrimary
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.onKeyboardSizeChanged)
                                root.onKeyboardSizeChanged(modelData.id)
                        }
                    }
                }
            }
        }

        Text {
            text: qsTr("Input modes")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Row {
            spacing: Theme.dp(6)
            OskPanelButton {
                width: Theme.dp(100)
                height: Theme.dp(32)
                label: qsTr("Voice")
                enabled: speech && speech.available
                onTapped: { if (root.onOpenVoice) root.onOpenVoice() }
            }
            OskPanelButton {
                width: Theme.dp(110)
                height: Theme.dp(32)
                label: qsTr("Handwriting")
                enabled: handwriting && handwriting.available
                onTapped: { if (root.onOpenHandwriting) root.onOpenHandwriting() }
            }
        }

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            wrapMode: Text.WordWrap
            text: qsTr("Voice: in-process Vosk (Kaldi) or Windows SAPI. Handwriting: in-process Zinnia or Windows Ink. No command-line tools.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        Text {
            text: qsTr("Learning")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Row {
            spacing: Theme.dp(6)
            OskPanelButton {
                width: Theme.dp(140)
                height: Theme.dp(32)
                label: qsTr("Clear learned words")
                enabled: engine && engine.pinyin
                onTapped: { if (engine) engine.clearUserLexicon() }
            }
        }

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            wrapMode: Text.WordWrap
            text: qsTr("Long-press letter hints for digits; long-press punctuation for alternatives. Ctrl / Alt / Win latch for chords.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }
}
