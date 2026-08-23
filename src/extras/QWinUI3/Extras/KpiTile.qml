import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// KpiTile — Compact dashboard KPI tile with optional delta and spark trend.
//
//   KpiTile {
//       id: kpi
//       title: qsTr("Latency")
//       value: 42
//       unit: " ms"
//       delta: -3.2
//       deltaUnit: "%"
//       trendValues: [48, 44, 46, 42, 40, 43, 42]
//       cautionThreshold: 60
//       criticalThreshold: 80
//       invertThresholds: true
//       badgeText: qsTr("p95")
//       symbol: FluentIcons.Clock
//   }
//
//   // --- API ---
//   // signals: onClicked
//   // methods: setValue(v), pushTrend(v, maxPoints), clearTrend(), setValueAndTrend(v, maxPoints)
//   // kpi.pushTrend(41); kpi.severity
//
// @notes
//   Dashboard metric tile: title, value, unit, signed delta, optional Fluent symbol and sparkline.
//   Value thresholds drive severity/valueColor; pushTrend appends spark points; badgeText for status chip.
//   Delta color uses Theme success/critical (invertDeltaColors when lower is better).
//   Layout.fillWidth defaults to true inside Column/Row/Grid layouts.

T.Control {
    id: root

    Layout.fillWidth: true

    // Primary title text
    property string title: ""
    // Current value
    property real value: 0
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Value unit label
    property string unit: ""
    // Caption under the value row
    property string caption: ""
    // Footer line under the spark
    property string footer: ""
    // Signed change vs previous period (NaN to hide)
    property real delta: NaN
    // Comparison period value (NaN to hide) — e.g. last week
    property real compareValue: NaN
    // Prefix for the comparison readout
    property string comparePrefix: qsTr("vs ")
    // Suffix for delta text (e.g. "%")
    property string deltaUnit: "%"
    // Digits after decimal for delta
    property int deltaPrecision: 1
    // When true, negative delta is success (lower-is-better metrics)
    property bool invertDeltaColors: false
    // Optional sparkline values (number[])
    property var trendValues: []
    // Show sparkline when trendValues has 2+ points
    property bool showTrend: true
    // Sparkline strip height in px (2.65)
    property real sparklineHeight: 28
    // Absolute caution threshold on value (-1 disables)
    property real cautionThreshold: -1
    // Absolute critical threshold on value (-1 disables)
    property real criticalThreshold: -1
    // When true, low values map to caution/critical
    property bool invertThresholds: false
    // Badge chip text (empty to hide)
    property string badgeText: ""
    // Badge severity override: -1 = follow value severity, else 0/1/2
    property int badgeSeverity: -1
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Primary accent for spark / emphasis
    property color accentColor: Theme.accent
    // Draw card border
    property bool bordered: true
    // Stronger elevation tint
    property bool elevated: false
    // Animate value text changes
    property bool animateValue: true
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive
    // Pressed visual state
    property bool pressed: false

    // Emitted when the tile is activated
    signal clicked()

    readonly property string effectiveIconGlyph: IconSource.resolve(symbol, iconGlyph)

    // Animated display value
    property real animatedValue: value
    Behavior on animatedValue {
        enabled: root.animateValue && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    readonly property bool hasDelta: isFinite(delta)
    readonly property bool deltaPositive: hasDelta && delta >= 0
    readonly property color deltaColor: {
        if (!hasDelta)
            return Theme.textSecondary
        var good = invertDeltaColors ? !deltaPositive : deltaPositive
        if (Math.abs(delta) < 1e-9)
            return Theme.textSecondary
        return good ? Theme.systemSuccess : Theme.systemCritical
    }

    readonly property string formattedDelta: {
        if (!hasDelta)
            return ""
        var sign = delta > 0 ? "+" : ""
        return sign + Number(delta).toFixed(deltaPrecision) + deltaUnit
    }

    readonly property bool hasCompare: isFinite(compareValue)
    readonly property string formattedCompare: {
        if (!hasCompare)
            return ""
        var n = Number(compareValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return comparePrefix + t + (unit.length ? unit : "")
    }

    // 0 = ok, 1 = caution, 2 = critical (from absolute value thresholds)
    readonly property int severity: {
        if (cautionThreshold < 0 && criticalThreshold < 0)
            return 0
        var v = Number(value)
        if (invertThresholds) {
            if (criticalThreshold >= 0 && v <= criticalThreshold)
                return 2
            if (cautionThreshold >= 0 && v <= cautionThreshold)
                return 1
            return 0
        }
        if (criticalThreshold >= 0 && v >= criticalThreshold)
            return 2
        if (cautionThreshold >= 0 && v >= cautionThreshold)
            return 1
        return 0
    }

    readonly property color valueColor: {
        if (severity === 2)
            return Theme.systemCritical
        if (severity === 1)
            return Theme.systemCaution
        return Theme.textPrimary
    }

    readonly property int effectiveBadgeSeverity: badgeSeverity >= 0 ? badgeSeverity : severity
    readonly property color badgeColor: {
        if (effectiveBadgeSeverity === 2)
            return Theme.systemCritical
        if (effectiveBadgeSeverity === 1)
            return Theme.systemCaution
        return Theme.accent
    }

    readonly property bool hasTrend: showTrend && trendValues && trendValues.length > 1

    // Set value
    function setValue(v) { value = Number(v) || 0 }

    // Append a sparkline point (keeps at most maxPoints)
    function pushTrend(v, maxPoints) {
        var cap = Math.max(2, Number(maxPoints) || 36)
        var next = (trendValues && trendValues.slice) ? trendValues.slice() : []
        next.push(Number(v) || 0)
        while (next.length > cap)
            next.shift()
        trendValues = next
    }

    // Clear sparkline
    function clearTrend() { trendValues = [] }

    // Set value and append to trend in one call
    function setValueAndTrend(v, maxPoints) {
        setValue(v)
        pushTrend(v, maxPoints)
    }

    implicitWidth: 200
    implicitHeight: {
        var h = 96
        if (hasTrend)
            h += 28
        if (footer.length)
            h += 18
        if (caption.length)
            h += 4
        if (hasCompare)
            h += 16
        return h
    }
    padding: 12
    hoverEnabled: isInteractive
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: isInteractive ? Accessible.Button : Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("KPI")
    Accessible.description: formattedValue
                            + (hasDelta ? (" " + formattedDelta) : "")
                            + (hasCompare ? (" " + formattedCompare) : "")
    Accessible.onPressAction: if (isInteractive) clicked()

    Keys.onReturnPressed: if (isInteractive) clicked()
    Keys.onEnterPressed: if (isInteractive) clicked()
    Keys.onSpacePressed: if (isInteractive) clicked()

    background: Rectangle {
        radius: Theme.cornerCard
        color: {
            if (root.elevated)
                return Theme.bgCard
            return Theme.dark ? "#12FFFFFF" : "#0A000000"
        }
        border.width: root.bordered ? 1 : 0
        border.color: Theme.strokeCard
        scale: root.isInteractive && root.pressed ? 0.98 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: root.activeFocus && root.isInteractive
            color: "transparent"
            border.width: 2
            border.color: Theme.focusOuter
        }
    }

    contentItem: ColumnLayout {
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                visible: root.effectiveIconGlyph.length > 0
                text: root.effectiveIconGlyph
                font.family: Theme.iconFontFamily
                font.pixelSize: Theme.fontBody
                color: root.accentColor
            }

            Text {
                Layout.fillWidth: true
                text: root.title
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }

            Rectangle {
                visible: root.badgeText.length > 0
                radius: height / 2
                color: Qt.rgba(root.badgeColor.r, root.badgeColor.g, root.badgeColor.b, Theme.dark ? 0.28 : 0.16)
                implicitHeight: Theme.fontCaption + 6
                implicitWidth: badgeLabel.implicitWidth + 12
                Text {
                    id: badgeLabel
                    anchors.centerIn: parent
                    text: root.badgeText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption - 1
                    font.weight: Theme.fontWeightSemiBold
                    color: root.badgeColor
                }
            }

            Text {
                visible: root.hasDelta
                text: root.formattedDelta
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: root.deltaColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: root.valueColor
            }
            Text {
                visible: root.hasCompare
                Layout.fillWidth: true
                text: root.formattedCompare
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.caption.length > 0
            text: root.caption
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        Sparkline {
            Layout.fillWidth: true
            Layout.preferredHeight: root.sparklineHeight
            visible: root.hasTrend
            values: root.trendValues
            strokeColor: root.severity > 0 ? root.valueColor : root.accentColor
            filled: true
            showEndMarker: true
            animated: !Theme.reducedMotion
        }

        Text {
            Layout.fillWidth: true
            visible: root.footer.length > 0
            text: root.footer
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.isInteractive && root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        onPressedChanged: root.pressed = pressed
    }
}
