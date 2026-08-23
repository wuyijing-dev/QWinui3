import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ColorPicker — Spectrum + RGB/Hex color editor.
//
//   ColorPicker {
//       id: colorPicker
//       selectedColor: "#005FB8"
//   }
//
//   // --- API ---
//   // signals: onColorChosen
//   // methods: copyHex(), clamp01(x), hsvToRgb(h, s, v), rgbToHsv(r, g, b), hsvToColor(h, s, v, a), hexString(c), parseHex(text), applyHsv(emitSignal), syncFromColor(c, emitSignal), syncInputsFromColor()
//   // colorPicker.copyHex()
//   // colorPicker.clamp01(x)
//   // colorPicker.hsvToRgb(h, s, v)
//   // colorPicker.rgbToHsv(r, g, b)
//
// @notes
//   Edits selectedColor via spectrum + RGB/HSV/hex fields.
//   copyHex() writes #RRGGBB to the clipboard.
//   Bind selectedColor; channel props (hue/saturation/value/alpha) stay in sync.
//   previousColor + isPreviousColorVisible show a restore swatch (WinUI PreviousColor).
//   colorSpectrumShape: box | ring; isAlphaEnabled aliases showAlpha.

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
    // WinUI IsAlphaEnabled
    property alias isAlphaEnabled: control.showAlpha
    // Alpha 0..1
    property real alpha: 1
    // rgb | hsv | hex editor mode
    property int colorModel: 0 // 0 RGB, 1 HSV, 2 HEX
    // Show color spectrum
    property bool isColorSpectrumVisible: true
    // WinUI ColorSpectrumShape: box | ring
    property string colorSpectrumShape: "box"
    // Show color preview swatch
    property bool isColorPreviewVisible: true
    // Show channel text inputs
    property bool isColorChannelTextInputVisible: true
    // Show value (brightness) slider
    property bool isColorSliderVisible: true
    // Show hex field row
    property bool isHexInputVisible: true
    // WinUI PreviousColor — shown above the current swatch; click restores it
    property color previousColor: "#00000000"
    // When true, always show the previous-color half of the previewer
    property bool isPreviousColorVisible: false

    readonly property bool _showPrevious: isPreviousColorVisible || previousColor.a > 0.001
    readonly property bool _ringSpectrum: String(colorSpectrumShape).toLowerCase() === "ring"

    // Emitted when a color is chosen
    signal colorChosen(color color)

    property bool _updating: false

    implicitWidth: 312
    implicitHeight: column.implicitHeight + topPadding + bottomPadding
    padding: 12
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.Dial
    Accessible.name: qsTr("Color picker")
    Accessible.description: hexString(selectedColor)

    // Copy the current color hex to the clipboard
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

    // Clamp to 0..1
    function clamp01(x) { return Math.max(0, Math.min(1, x)) }

    // Convert HSV to RGB components
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

    // Convert RGB to HSV components
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

    // Convert HSV to a QColor
    function hsvToColor(h, s, v, a) {
        var rgb = hsvToRgb(h, s, v)
        return Qt.rgba(rgb.r, rgb.g, rgb.b, a === undefined ? 1 : a)
    }

    // Format color as #RRGGBB[AA]
    function hexString(c) {
        // Format a 0..255 channel as two hex digits
        function byteHex(n) {
            var v = Math.round(clamp01(n) * 255)
            var s = v.toString(16).toUpperCase()
            return s.length < 2 ? "0" + s : s
        }
        return "#" + byteHex(c.r) + byteHex(c.g) + byteHex(c.b)
    }

    // Parse a hex color string
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

    // Apply HSV channels to selectedColor
    function applyHsv(emitSignal) {
        control._updating = true
        selectedColor = hsvToColor(hue, saturation, value, showAlpha ? alpha : 1)
        control._updating = false
        // Spectrum Canvas only repaints on value/size/shape — not every hue/sat drag.
        if (emitSignal !== false)
            colorChosen(selectedColor)
        syncInputsFromColor()
    }

    // Sync From color
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
        if (emitSignal)
            colorChosen(selectedColor)
        syncInputsFromColor()
    }

    // Sync Inputs From color
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

    // Commit RGB text fields into selectedColor
    function commitRgbFields() {
        var r = clamp01(parseInt(rField.text, 10) / 255)
        var g = clamp01(parseInt(gField.text, 10) / 255)
        var b = clamp01(parseInt(bField.text, 10) / 255)
        if (isNaN(r) || isNaN(g) || isNaN(b))
            return
        syncFromColor(Qt.rgba(r, g, b, showAlpha ? alpha : 1), true)
    }

    // Commit HSV text fields into selectedColor
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

    onColorSpectrumShapeChanged: {
        if (spectrum)
            spectrum.requestPaint()
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
            Layout.preferredHeight: 180
            spacing: 12

            Item {
                id: spectrumHost
                visible: control.isColorSpectrumVisible
                // Prefer a real 2D spectrum; do not let the preview strip steal width.
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 160
                Layout.preferredWidth: 240
                Layout.maximumWidth: 65535
                implicitWidth: 240
                implicitHeight: 180

                Item {
                    id: spectrumPaintHost
                    anchors.fill: parent

                    // Canvas.Image + putImageData (FBO path blanks on D3D11).
                    // Repaint only when value / size / shape change — not on hue/sat drag.
                    Canvas {
                        id: spectrum
                        anchors.fill: parent
                        antialiasing: true
                        renderTarget: Canvas.Image
                        renderStrategy: Canvas.Cooperative
                        property real _paintValue: control.value
                        on_PaintValueChanged: spectrumPaintTimer.restart()
                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()
                        Timer {
                            id: spectrumPaintTimer
                            interval: 16
                            onTriggered: spectrum.requestPaint()
                        }
                        onPaint: {
                            var ctx = getContext("2d")
                            var w = Math.floor(width)
                            var h = Math.floor(height)
                            if (w < 2 || h < 2)
                                return
                            ctx.clearRect(0, 0, width, height)
                            if (typeof ctx.imageSmoothingEnabled !== "undefined")
                                ctx.imageSmoothingEnabled = true

                            if (control._ringSpectrum) {
                                var cx = w / 2
                                var cy = h / 2
                                var rMax = Math.min(w, h) / 2 - 2
                                var img = ctx.createImageData(w, h)
                                var data = img.data
                                for (var yy = 0; yy < h; ++yy) {
                                    for (var xx = 0; xx < w; ++xx) {
                                        var dx = xx + 0.5 - cx
                                        var dy = yy + 0.5 - cy
                                        var dist = Math.sqrt(dx * dx + dy * dy)
                                        var idx = (yy * w + xx) * 4
                                        if (dist > rMax + 1.25) {
                                            data[idx + 3] = 0
                                            continue
                                        }
                                        var edge = 1
                                        if (dist > rMax - 1.25)
                                            edge = Math.max(0, (rMax + 1.25 - dist) / 2.5)
                                        var ang = Math.atan2(dy, dx) * 180 / Math.PI
                                        if (ang < 0)
                                            ang += 360
                                        var sat = control.clamp01(dist / Math.max(1, rMax))
                                        var rgb = control.hsvToRgb(ang, sat, control.value)
                                        data[idx] = Math.round(rgb.r * 255)
                                        data[idx + 1] = Math.round(rgb.g * 255)
                                        data[idx + 2] = Math.round(rgb.b * 255)
                                        data[idx + 3] = Math.round(edge * 255)
                                    }
                                }
                                ctx.putImageData(img, 0, 0)
                                return
                            }

                            var rad = Math.min(Theme.cornerControl, Math.min(w, h) / 2)
                            var imgBox = ctx.createImageData(w, h)
                            var boxData = imgBox.data
                            for (var y = 0; y < h; ++y) {
                                var satBox = 1 - (y / Math.max(1, h - 1))
                                var py = y + 0.5
                                for (var x = 0; x < w; ++x) {
                                    var hu = (x / Math.max(1, w - 1)) * 360
                                    var rgbBox = control.hsvToRgb(hu, satBox, control.value)
                                    var bidx = (y * w + x) * 4
                                    var px = x + 0.5
                                    var cdx = 0
                                    var cdy = 0
                                    if (px < rad)
                                        cdx = rad - px
                                    else if (px > w - rad)
                                        cdx = px - (w - rad)
                                    if (py < rad)
                                        cdy = rad - py
                                    else if (py > h - rad)
                                        cdy = py - (h - rad)
                                    var cover = 1
                                    if (cdx > 0 && cdy > 0) {
                                        var cdist = Math.sqrt(cdx * cdx + cdy * cdy)
                                        if (cdist >= rad + 1.25)
                                            cover = 0
                                        else if (cdist > rad - 1.25)
                                            cover = Math.max(0, (rad + 1.25 - cdist) / 2.5)
                                    }
                                    boxData[bidx] = Math.round(rgbBox.r * 255)
                                    boxData[bidx + 1] = Math.round(rgbBox.g * 255)
                                    boxData[bidx + 2] = Math.round(rgbBox.b * 255)
                                    boxData[bidx + 3] = Math.round(cover * 255)
                                }
                            }
                            ctx.putImageData(imgBox, 0, 0)
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: control._ringSpectrum ? width / 2 : Theme.cornerControl
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.strokeControl
                    z: 2
                }

                // Thumb
                Item {
                    id: spectrumThumb
                    width: 16
                    height: 16
                    z: 3
                    layer.enabled: true
                    layer.smooth: true
                    x: {
                        if (control._ringSpectrum) {
                            var rMax = Math.min(spectrumHost.width, spectrumHost.height) / 2 - 1
                            var ang = control.hue * Math.PI / 180
                            var rr = control.saturation * rMax
                            return spectrumHost.width / 2 + Math.cos(ang) * rr - width / 2
                        }
                        return Math.round((control.hue / 360) * (spectrumHost.width - 1)) - width / 2
                    }
                    y: {
                        if (control._ringSpectrum) {
                            var rMaxY = Math.min(spectrumHost.width, spectrumHost.height) / 2 - 1
                            var angY = control.hue * Math.PI / 180
                            var rrY = control.saturation * rMaxY
                            return spectrumHost.height / 2 + Math.sin(angY) * rrY - height / 2
                        }
                        return Math.round((1 - control.saturation) * (spectrumHost.height - 1)) - height / 2
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
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
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.CrossCursor
                    preventStealing: true
                    function pick(mx, my) {
                        if (control._ringSpectrum) {
                            var cx = width / 2
                            var cy = height / 2
                            var rMax = Math.min(width, height) / 2 - 1
                            var dx = mx - cx
                            var dy = my - cy
                            var dist = Math.sqrt(dx * dx + dy * dy)
                            var ang = Math.atan2(dy, dx) * 180 / Math.PI
                            if (ang < 0)
                                ang += 360
                            control.hue = ang
                            control.saturation = control.clamp01(dist / Math.max(1, rMax))
                        } else {
                            control.hue = control.clamp01(mx / Math.max(1, width - 1)) * 360
                            control.saturation = 1 - control.clamp01(my / Math.max(1, height - 1))
                        }
                        control.applyHsv(true)
                    }
                    onPressed: function (mouse) { pick(mouse.x, mouse.y) }
                    onPositionChanged: function (mouse) {
                        if (pressed)
                            pick(mouse.x, mouse.y)
                    }
                }

                WheelHandler {
                    enabled: control.enabled
                    onWheel: function (event) {
                        var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                        if (dir === 0)
                            return
                        var step = (event.modifiers & Qt.ControlModifier) ? 12 : 4
                        control.hue = ((control.hue + (dir > 0 ? step : -step)) % 360 + 360) % 360
                        control.applyHsv(true)
                        event.accepted = true
                    }
                }
            }

            // WinUI ColorPreviewer: fixed-width strip (previous on top, current below)
            Item {
                id: previewStrip
                visible: control.isColorPreviewVisible
                Layout.preferredWidth: 28
                Layout.minimumWidth: 28
                Layout.maximumWidth: 28
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: 28
                implicitHeight: 180

                Column {
                    anchors.fill: parent
                    spacing: 2

                    Rectangle {
                        visible: control._showPrevious
                        width: parent.width
                        height: visible
                                ? Math.floor((parent.height - parent.spacing) / 2)
                                : 0
                        radius: Theme.cornerControl
                        color: control.previousColor
                        border.width: 1
                        border.color: Theme.strokeControl
                        Accessible.name: qsTr("Previous color")
                        MouseArea {
                            id: prevArea
                            anchors.fill: parent
                            enabled: control._showPrevious
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                control.syncFromColor(control.previousColor, true)
                                control.colorChosen(control.selectedColor)
                            }
                        }
                        ToolTip.visible: prevArea.containsMouse
                        ToolTip.text: qsTr("Restore previous")
                        ToolTip.delay: 400
                    }
                    Rectangle {
                        width: parent.width
                        height: control._showPrevious
                                ? Math.ceil((parent.height - parent.spacing) / 2)
                                : parent.height
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
            }
        }

        // Value (brightness) slider — black -> full color at current H/S
        Item {
            id: valueSliderHost
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            visible: control.isColorSliderVisible

            Canvas {
                id: valueTrack
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 12
                antialiasing: true
                renderTarget: Canvas.Image
                renderStrategy: Canvas.Cooperative
                property real _paintHue: control.hue
                property real _paintSat: control.saturation
                on_PaintHueChanged: requestPaint()
                on_PaintSatChanged: requestPaint()
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height
                    if (w < 2 || h < 2)
                        return
                    ctx.clearRect(0, 0, w, h)
                    if (typeof ctx.imageSmoothingEnabled !== "undefined")
                        ctx.imageSmoothingEnabled = true
                    var rad = h / 2
                    ctx.beginPath()
                    ctx.moveTo(rad, 0)
                    ctx.arcTo(w, 0, w, h, rad)
                    ctx.arcTo(w, h, 0, h, rad)
                    ctx.arcTo(0, h, 0, 0, rad)
                    ctx.arcTo(0, 0, w, 0, rad)
                    ctx.closePath()
                    var rgb = control.hsvToRgb(control.hue, control.saturation, 1)
                    var grd = ctx.createLinearGradient(0, 0, w, 0)
                    grd.addColorStop(0, "#000000")
                    grd.addColorStop(1, "rgb("
                            + Math.round(rgb.r * 255) + ","
                            + Math.round(rgb.g * 255) + ","
                            + Math.round(rgb.b * 255) + ")")
                    ctx.fillStyle = grd
                    ctx.fill()
                }

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: "transparent"
                    border.width: 1
                    border.color: Theme.strokeControl
                }
            }

            Item {
                id: valueThumb
                width: 20
                height: 20
                y: (parent.height - height) / 2
                x: control.value * (parent.width - width)

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
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

            WheelHandler {
                enabled: control.enabled
                onWheel: function (event) {
                    var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                    if (dir === 0)
                        return
                    var step = (event.modifiers & Qt.ControlModifier) ? 0.05 : 0.02
                    control.value = control.clamp01(control.value + (dir > 0 ? step : -step))
                    control.applyHsv(true)
                    event.accepted = true
                }
            }
        }

        // Model + Hex
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: control.isHexInputVisible || control.isColorChannelTextInputVisible

            ComboBox {
                id: modelBox
                Layout.preferredWidth: 96
                visible: control.isColorChannelTextInputVisible || control.isHexInputVisible
                model: [qsTr("RGB"), qsTr("HSV"), qsTr("HEX")]
                currentIndex: control.colorModel
                onActivated: control.colorModel = currentIndex
            }

            TextField {
                id: hexField
                Layout.fillWidth: true
                visible: control.isHexInputVisible
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
                visible: control.isHexInputVisible
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
