import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OskHandwritingPad — Zinnia CLI handwriting panel (Windows + Linux).
//
//   OskHandwritingPad { engine: kbd; handwriting: hwSvc }
//
T.Control {
    id: root

    property KeyboardEngine engine
    property OskHandwritingService handwriting

    signal closeRequested()
    signal flashRequested(string message)

    implicitWidth: 640
    implicitHeight: padArea.height + candRow.height + Theme.dp(52)
    focusPolicy: Qt.NoFocus

    property var _currentStroke: []

    function closePanel() {
        closeRequested()
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    Column {
        anchors.fill: parent
        anchors.margins: Theme.dp(8)
        spacing: Theme.dp(6)

        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: handwriting && handwriting.available
                  ? qsTr("Handwriting (%1) — draw a character").arg(handwriting.platformBackend)
                  : (handwriting ? handwriting.statusText : qsTr("Handwriting not configured"))
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        Rectangle {
            id: padArea
            width: parent.width
            height: Theme.dp(120)
            radius: Theme.cornerControl
            color: Theme.bgLayer
            border.width: Theme.strokeHairline
            border.color: Theme.strokeControl

            Canvas {
                id: ink
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.lineWidth = 2.5
                    ctx.strokeStyle = Theme.dark ? "#FFFFFF" : "#1A1A1A"
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    for (let si = 0; si < strokeModel.count; ++si) {
                        const stroke = strokeModel.get(si).points
                        if (!stroke || stroke.length < 2)
                            continue
                        ctx.beginPath()
                        ctx.moveTo(stroke[0].x, stroke[0].y)
                        for (let pi = 1; pi < stroke.length; ++pi)
                            ctx.lineTo(stroke[pi].x, stroke[pi].y)
                        ctx.stroke()
                    }
                    if (_currentStroke.length >= 2) {
                        ctx.beginPath()
                        ctx.moveTo(_currentStroke[0].x, _currentStroke[0].y)
                        for (let i = 1; i < _currentStroke.length; ++i)
                            ctx.lineTo(_currentStroke[i].x, _currentStroke[i].y)
                        ctx.stroke()
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: handwriting && handwriting.available
                preventStealing: true
                onPressed: function(mouse) {
                    _currentStroke = [{ x: mouse.x, y: mouse.y }]
                    ink.requestPaint()
                }
                onPositionChanged: function(mouse) {
                    if (!pressed)
                        return
                    _currentStroke.push({ x: mouse.x, y: mouse.y })
                    ink.requestPaint()
                }
                onReleased: {
                    if (_currentStroke.length >= 2) {
                        strokeModel.append({ points: _currentStroke.slice() })
                        if (handwriting)
                            handwriting.addStroke(_currentStroke)
                    }
                    _currentStroke = []
                    ink.requestPaint()
                }
            }
        }

        Row {
            spacing: Theme.dp(6)
            OskPanelButton {
                width: Theme.dp(88)
                height: Theme.dp(32)
                label: qsTr("Recognize")
                enabled: handwriting && handwriting.available
                onTapped: {
                    if (handwriting)
                        handwriting.recognize()
                }
            }
            OskPanelButton {
                width: Theme.dp(72)
                height: Theme.dp(32)
                label: qsTr("Clear")
                onTapped: {
                    strokeModel.clear()
                    _currentStroke = []
                    ink.requestPaint()
                    if (handwriting)
                        handwriting.clearStrokes()
                }
            }
            OskPanelButton {
                width: Theme.dp(72)
                height: Theme.dp(32)
                label: qsTr("Close")
                onTapped: root.closePanel()
            }
        }

        Row {
            id: candRow
            spacing: Theme.dp(4)
            width: parent.width
            Repeater {
                model: handwriting ? handwriting.candidates : []
                delegate: OskPanelButton {
                    required property int index
                    required property string modelData
                    width: Math.max(Theme.dp(40), implicitWidth + Theme.dp(12))
                    height: Theme.dp(32)
                    label: modelData
                    onTapped: {
                        if (handwriting)
                            handwriting.pickCandidate(index)
                    }
                }
            }
        }
    }

    ListModel { id: strokeModel }

    Connections {
        target: root.handwriting
        function onCandidatePicked(text) {
            if (root.engine && text.length)
                root.engine.commitText(text)
            strokeModel.clear()
            _currentStroke = []
            ink.requestPaint()
        }
        function onErrorOccurred(msg) {
            root.flashRequested(msg)
        }
    }
}
