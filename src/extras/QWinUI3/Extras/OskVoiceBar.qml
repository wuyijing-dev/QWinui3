import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OskVoiceBar — cross-platform speech-to-text strip (Windows System.Speech / Linux whisper|vosk).
T.Control {
    id: root

    property KeyboardEngine engine
    property OskSpeechService speech
    property var onClose: null
    property var onFlash: null

    implicitWidth: 640
    implicitHeight: Theme.dp(72)
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    contentItem: Column {
        spacing: Theme.dp(6)
        leftPadding: Theme.dp(10)
        rightPadding: Theme.dp(10)
        topPadding: Theme.dp(8)
        bottomPadding: Theme.dp(8)

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            wrapMode: Text.WordWrap
            text: speech && speech.available
                  ? qsTr("Voice input (%1)").arg(speech.platformBackend)
                  : (speech ? speech.statusText : qsTr("Speech not available"))
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        Row {
            spacing: Theme.dp(8)
            OskPanelButton {
                width: Theme.dp(120)
                height: Theme.dp(36)
                label: speech && speech.listening ? qsTr("Stop") : qsTr("Listen")
                accent: speech && speech.listening
                enabled: speech && speech.available
                onTapped: {
                    if (!speech)
                        return
                    if (speech.listening)
                        speech.stopListening()
                    else
                        speech.startListening()
                }
            }
            OskPanelButton {
                width: Theme.dp(88)
                height: Theme.dp(36)
                label: qsTr("Close")
                onTapped: {
                    if (onClose)
                        onClose()
                }
            }
        }

        Text {
            visible: speech && speech.statusText.length > 0 && !speech.listening
            width: parent.width - parent.leftPadding - parent.rightPadding
            text: speech ? speech.statusText : ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }

    Connections {
        target: root.speech
        function onRecognized(text) {
            if (root.engine && text.length)
                root.engine.commitText(text)
            if (root.onClose)
                root.onClose()
        }
        function onErrorOccurred(msg) {
            if (root.onFlash)
                root.onFlash(msg)
        }
    }
}
