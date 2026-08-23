pragma Singleton
import QtQuick
import QWinUI3.Theme

// FeedbackSeverity — Shared severity palette + glyphs for InfoBar / Toast / TeachingTip (2.70 A7).
//
//   color: FeedbackSeverity.colorFor(FeedbackSeverity.error)
//   glyph: FeedbackSeverity.glyphFor(FeedbackSeverity.warning)
//
// @notes
//   Aligns systemSuccess / Caution / Critical / Attention tokens and FluentIcons.

QtObject {
    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

    function colorFor(severity) {
        switch (severity) {
        case success: return Theme.systemSuccess
        case warning: return Theme.systemCaution
        case error: return Theme.systemCritical
        default: return Theme.systemAttention
        }
    }

    function backgroundFor(severity) {
        switch (severity) {
        case success: return Theme.systemSuccessBg
        case warning: return Theme.systemCautionBg
        case error: return Theme.systemCriticalBg
        default: return Theme.systemAttentionBg
        }
    }

    function glyphFor(severity) {
        switch (severity) {
        case success: return FluentIcons.Accept
        case warning: return FluentIcons.Warning
        case error: return FluentIcons.Error
        default: return FluentIcons.Info
        }
    }

    function nameFor(severity) {
        switch (severity) {
        case success: return qsTr("Success")
        case warning: return qsTr("Warning")
        case error: return qsTr("Error")
        default: return qsTr("Information")
        }
    }

    function fromString(name) {
        var s = String(name || "").toLowerCase()
        if (s === "success")
            return success
        if (s === "warning" || s === "caution")
            return warning
        if (s === "error" || s === "critical")
            return error
        return informational
    }
}
