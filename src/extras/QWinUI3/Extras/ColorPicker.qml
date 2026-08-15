import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ColorPicker — Spectrum + RGB/Hex color editor.
//
//   ColorPicker { selectedColor: "#005FB8" }

T.Control {
    id: control

    // Currently selected color
    property color selectedColor: "#005FB8"
    // Hue 0..360
    property real hue: 210
    // Saturation 0..1
    property real saturation: 0.85
    // Current value
    property real value: 0.72
    // Show alpha channel editor
    property bool showAlpha: false
    // Alpha 0..1
    property real alpha: 1
    // rgb | hsv | hex editor mode
    property int colorModel: 0 // 0 RGB, 1 HSV, 2 HEX
    // Show color spectrum
    property bool isColorSpectrumVisible: true
    // Show color preview swatch
    property bool isColorPreviewVisible: true
    // Show channel text inputs
    property bool isColorChannelTextInputVisible: true

    // Emitted when a color is chosen
    signal colorChosen(color color)

    property bool _updating: false

    implicitWidth: 312
    implicitHeight: column.implicitHeight + topPadding + bottomPadding
    padding: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.Dial
    Accessible.name: qsTr("Color picker")
    Accessible.description: hexString(selectedColor)

    // Copy Hex
    function copyHex() {
        var t = hexString(selectedColor)
        hexHelper.text = t
        hexHelper.selectAll()
        hexHelper.copy()
        return t
    }

    TextEdit {
        id: hexHelper
        visible: false
        width: 1
        height: 1
        readOnly: true
    }

    // Clamp01
    function clamp01(x) { return Math.max(0, Math.min(1, x)) }

    // Hsv To Rgb
    function hsvToRgb(h, s, v) {
        h = ((h % 360) + 360) % 360
        var c = v * s
        var x = c * (1 - Math.abs(((h / 60) % 2) - 1))
        var m = v - c
        var r = 0, g = 0, b = 0
        if (h < 60) { r = c; g = x }
        else if (h < 120) { r = x; g = c }
        else if (h < 180) { g = c; b = x }
        else if (h < 240) { g = x; b = c }
        else if (h < 300) { r = x; b = c }
        else { r = c; b = x }
        return { r: r + m, g: g + m, b: b + m }
    }

    // Rgb To Hsv
    function rgbToHsv(r, g, b) {
        var max = Math.max(r, g, b)
        var min = Math.min(r, g, b)
        var d = max - min
        var h = 0
        if (d > 0.00001) {
            if (max === r)
                h = 60 * (((g - b) / d) % 6)
            else if (max === g)
                h = 60 * ((b - r) / d + 2)
            else
                h = 60 * ((r - g) / d + 4)
        }
        if (h < 0)
            h += 360
        var s = max <= 0.00001 ? 0 : d / max
        return { h: h, s: s, v: max }
    }

    // Hsv To Color
    function hsvToColor(h, s, v, a) {
        var rgb = hsvToRgb(h, s, v)
        return Qt.rgba(rgb.r, rgb.g, rgb.b, a === undefined ? 1 : a)
    }

    // Hex String
    function hexString(c) {
        // Byte Hex
        function byteHex(n) {
            var v = Math.round(clamp01(n) * 255)
            var s = v.toString(16).toUpperCase()
            return s.length < 2 ? "0" + s : s
        }
        return "#" + byteHex(c.r) + byteHex(c.g) + byteHex(c.b)
    }

    // Parse Hex
    function parseHex(text) {
        var t = (text || "").trim()
        if (t.charAt(0) === "#")
            t = t.slice(1)
        if (t.length === 3) {
            t = t.charAt(0) + t.charAt(0) + t.charAt(1) + t.charAt(1) + t.charAt(2) + t.charAt(2)
        }
        if (t.length !== 6)
            return null
        var n = parseInt(t, 16)
        if (isNaN(n))
            return null
        return Qt.rgba(((n >> 16) & 255) / 255,
                       ((n >> 8) & 255) / 255,
                       (n & 255) / 255, control.alpha)
    }

    function applyHsv(emitSignal) {
        control._updating = true
        selectedColor = hsvToColor(hue, saturation, value, showAlpha ? alpha : 1)
        control._updating = false
        spectrum.requestPaint()
        valueTrack.requestPaint()
        if (emitSignal !== false)
            colorChosen(selectedColor)
        syncInputsFromColor()
    }

    function syncFromColor(c, emitSignal) {
        if (!c)
            return
        var hsv = rgbToHsv(c.r, c.g, c.b)
        control._updating = true
        hue = hsv.h
        saturation = hsv.s
        value = Math.max(0.001, hsv.v)
        if (showAlpha)
            alpha = c.a
        selectedColor = Qt.rgba(c.r, c.g, c.b, showAlpha ? alpha : 1)
        control._updating = false
        spectrum.requestPaint()
        valueTrack.requestPaint()
        if (emitSignal)
            colorChosen(selectedColor)
        syncInputsFromColor()
    }

    function syncInputsFromColor() {
        if (hexField && !hexField.activeFocus)
            hexField.text = hexString(selectedColor)
        if (rField && !rField.activeFocus)
            rField.text = String(Math.round(selectedColor.r * 255))
        if (gField && !gField.activeFocus)
            gField.text = String(Math.round(selectedColor.g * 255))
        if (bField && !bField.activeFocus)
            bField.text = String(Math.round(selectedColor.b * 255))
        if (hField && !hField.activeFocus)
            hField.text = String(Math.round(hue))
        if (sField && !sField.activeFocus)
            sField.text = String(Math.round(saturation * 100))
        if (vField && !vField.activeFocus)
            vField.text = String(Math.round(value * 100))
    }

    function commitRgbFields() {
        var r = clamp01(parseInt(rField.text, 10) / 255)
        var g = clamp01(parseInt(gField.text, 10) / 255)
        var b = clamp01(parseInt(bField.text, 10) / 255)
        if (isNaN(r) || isNaN(g) || isNaN(b))
            return
        syncFromColor(Qt.rgba(r, g, b, showAlpha ? alpha : 1), true)
    }

    function commitHsvFields() {
        var h = parseFloat(hField.text)
        var s = parseFloat(sField.text) / 100
        var v = parseFloat(vField.text) / 100
        if (isNaN(h) || isNaN(s) || isNaN(v))
            return
        hue = ((h % 360) + 360) % 360
        saturation = clamp01(s)
        value = clamp01(v)
        applyHsv(true)
    }

    onSelectedColorChanged: {
        if (_updating)
            return
        syncFromColor(selectedColor, false)
    }

    Component.onCompleted: {
        syncFromColor(selectedColor, false)
    }

    background: Item {}

    contentItem: ColumnLayout {
        id: column
        spacing: 12

        // Spectrum + vertical preview
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Item {
                id: spectrumHost
                visible: control.isColorSpectrumVisible
                Layout.fillWidth: true
                Layout.preferredHeight: 180

                Canvas {
                    id: spectrum
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        var w = width
                        var h = height
                        if (w < 2 || h < 2)
                            return
                        ctx.clearRect(0, 0, w, h)
                        var stepX = Math.max(1, Math.floor(w / 96))
                        var stepY = Math.max(1, Math.floor(h / 72))
                        for (var y = 0; y < h; y += stepY) {
                            var sat = 1 - (y / Math.max(1, h - 1))
                            for (var x = 0; x < w; x += stepX) {
                                var hu = (x / Math.max(1, w - 1)) * 360
                                var rgb = control.hsvToRgb(hu, sat, control.value)
                                ctx.fillStyle = Qt.rgba(rgb.r, rgb.g, rgb.b, 1)
                                ctx.fillRect(x, y, stepX + 1, stepY + 1)
                            }
                        }
                    }

                    // Rounded clip via OpacityMask alternative: overlay corners
                    layer.enabled: true
                    layer.smooth: true
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.cornerControl
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.strokeControl
                    z: 2
                }

                // Thumb
                Rectangle {
                    id: spectrumThumb
                    width: 16
                    height: 16
                    radius: 8
                    z: 3
                    x: Math.round((control.hue / 360) * (spectrumHost.width - 1)) - width / 2
                    y: Math.round((1 - control.saturation) * (spectrumHost.height - 1)) - height / 2
                    color: "transparent"
                    border.width: 2
                    border.color: "#FFFFFF"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: width / 2
                        color: "transparent"
                        border.width: 1
                        border.color: "#000000"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.CrossCursor
                    preventStealing: true
                    function pick(mx, my) {
                        control.hue = control.clamp01(mx / Math.max(1, width - 1)) * 360
                        control.saturation = 1 - control.clamp01(my / Math.max(1, height - 1))
                        control.applyHsv(true)
                    }
                    onPressed: function (mouse) { pick(mouse.x, mouse.y) }
                    onPositionChanged: function (mouse) {
                        if (pressed)
                            pick(mouse.x, mouse.y)
                    }
                }
            }

            // Selected color preview strip (WinUI ColorPreviewer)
            Rectangle {
                visible: control.isColorPreviewVisible
                Layout.preferredWidth: 28
                Layout.fillHeight: true
                radius: Theme.cornerControl
                color: control.selectedColor
                border.width: 1
                border.color: Theme.strokeControl
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        // Value (brightness) slider — black → full color at current H/S
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 28

            Canvas {
                id: valueTrack
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 12
                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height
                    if (w < 2)
                        return
                    ctx.clearRect(0, 0, w, h)
                    var step = Math.max(1, Math.floor(w / 64))
                    for (var x = 0; x < w; x += step) {
                        var vv = x / Math.max(1, w - 1)
                        var rgb = control.hsvToRgb(control.hue, control.saturation, vv)
                        ctx.fillStyle = Qt.rgba(rgb.r, rgb.g, rgb.b, 1)
                        ctx.fillRect(x, 0, step + 1, h)
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.strokeControl
                }
            }

            Rectangle {
                id: valueThumb
                width: 20
                height: 20
                radius: 10
                y: (parent.height - height) / 2
                x: control.value * (parent.width - width)
                color: control.selectedColor
                border.width: 2
                border.color: "#FFFFFF"

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    radius: width / 2
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.dark ? "#CC000000" : "#66000000"
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                preventStealing: true
                function pick(mx) {
                    control.value = control.clamp01(mx / Math.max(1, width))
                    control.applyHsv(true)
                }
                onPressed: function (mouse) { pick(mouse.x) }
                onPositionChanged: function (mouse) {
                    if (pressed)
                        pick(mouse.x)
                }
            }
        }

        // Model + Hex
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ComboBox {
                id: modelBox
                Layout.preferredWidth: 96
                model: [qsTr("RGB"), qsTr("HSV"), qsTr("HEX")]
                currentIndex: control.colorModel
                onActivated: control.colorModel = currentIndex
            }

            TextField {
                id: hexField
                Layout.fillWidth: true
                text: "#005FB8"
                selectByMouse: true
                validator: RegularExpressionValidator {
                    regularExpression: /#?[0-9A-Fa-f]{0,6}/
                }
                onEditingFinished: {
                    var c = control.parseHex(text)
                    if (c)
                        control.syncFromColor(c, true)
                    else
                        text = control.hexString(control.selectedColor)
                }
            }
            CopyButton {
                iconOnly: true
                textToCopy: control.hexString(control.selectedColor)
                Accessible.name: qsTr("Copy hex")
            }
        }

        // Channel inputs
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: control.isColorChannelTextInputVisible && control.colorModel === 0

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: rField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitRgbFields()
                }
                Label {
                    text: qsTr("Red")
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: gField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitRgbFields()
                }
                Label {
                    text: qsTr("Green")
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: bField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitRgbFields()
                }
                Label {
                    text: qsTr("Blue")
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: control.isColorChannelTextInputVisible && control.colorModel === 1

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: hField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitHsvFields()
                }
                Label { text: qsTr("Hue"); color: Theme.textPrimary; Layout.fillWidth: true }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: sField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitHsvFields()
                }
                Label { text: qsTr("Saturation"); color: Theme.textPrimary; Layout.fillWidth: true }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: vField
                    Layout.preferredWidth: 72
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    onEditingFinished: control.commitHsvFields()
                }
                Label { text: qsTr("Value"); color: Theme.textPrimary; Layout.fillWidth: true }
            }
        }

        // HEX-only model: emphasize hex field, hide channel rows (already hidden)
        Label {
            visible: control.colorModel === 2
            text: qsTr("Enter a hex color above.")
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
        }
    }
}
