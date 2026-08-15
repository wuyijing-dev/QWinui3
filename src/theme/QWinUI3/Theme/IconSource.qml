pragma Singleton
import QtQuick

// Resolves icon inputs so callers can pass FluentIcons.Save, "Save", or "\uE74E".
QtObject {
    id: root

    function isRawGlyph(value) {
        if (typeof value !== "string" || value.length === 0)
            return false
        if (value.length === 1) {
            var code = value.charCodeAt(0)
            return code >= 0xE000
        }
        if (value.length <= 2) {
            var c0 = value.charCodeAt(0)
            return c0 >= 0xE000
        }
        return false
    }

    function toPascalCase(name) {
        if (!name || typeof name !== "string")
            return ""
        var cleaned = name.replace(/([a-z])([A-Z])/g, "$1 $2")
                          .replace(/[-_\s]+/g, " ")
                          .trim()
        if (!cleaned.length)
            return ""
        var parts = cleaned.split(" ")
        var out = ""
        for (var i = 0; i < parts.length; ++i) {
            var p = parts[i]
            if (!p.length)
                continue
            out += p.charAt(0).toUpperCase() + p.slice(1)
        }
        return out
    }

    function lookupName(name) {
        if (!name || typeof name !== "string")
            return ""
        if (FluentIcons.has && FluentIcons.has(name))
            return FluentIcons.of(name)
        // QQmlPropertyMap also supports value lookup via []
        if (FluentIcons[name] !== undefined && typeof FluentIcons[name] === "string")
            return FluentIcons[name]
        var pascal = toPascalCase(name)
        if (pascal.length) {
            if (FluentIcons.has && FluentIcons.has(pascal))
                return FluentIcons.of(pascal)
            if (FluentIcons[pascal] !== undefined && typeof FluentIcons[pascal] === "string")
                return FluentIcons[pascal]
        }
        return ""
    }

    // value: FluentIcons.X | "Save" | "\uE74E" | codepoint | { glyph|symbol|icon|name }
    function resolve(value, fallback) {
        var fb = (fallback === undefined || fallback === null) ? "" : fallback
        if (value === undefined || value === null || value === "")
            return typeof fb === "string" ? fb : resolve(fb, "")

        if (typeof value === "number") {
            if (value <= 0)
                return typeof fb === "string" ? fb : ""
            return String.fromCharCode(value)
        }

        if (typeof value === "string") {
            if (isRawGlyph(value))
                return value
            var named = lookupName(value)
            if (named.length)
                return named
            return typeof fb === "string" ? fb : ""
        }

        if (typeof value === "object") {
            if (value.glyph !== undefined && value.glyph !== null && value.glyph !== "")
                return resolve(value.glyph, fb)
            if (value.symbol !== undefined && value.symbol !== null && value.symbol !== "")
                return resolve(value.symbol, fb)
            if (value.icon !== undefined && value.icon !== null && value.icon !== "")
                return resolve(value.icon, fb)
            if (value.name !== undefined && value.name !== null && value.name !== "")
                return resolve(value.name, fb)
        }

        return typeof fb === "string" ? fb : ""
    }

    function has(value) {
        return resolve(value, "").length > 0
    }
}
