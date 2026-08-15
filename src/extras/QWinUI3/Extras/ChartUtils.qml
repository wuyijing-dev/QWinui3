pragma Singleton
import QtQuick

// ChartUtils — LOD helpers for large chart series.
//
//   ChartUtils.downsample(values, maxPoints)

QtObject {
    // Point count that triggers LOD
    readonly property int largeSeriesThreshold: 50000

    // As Number
    function asNumber(v, fallback) {
        var n = Number(v)
        return isFinite(n) ? n : (fallback !== undefined ? fallback : 0)
    }

    // Value Count
    function valueCount(input) {
        if (!input)
            return 0
        if (typeof input.count === "number")
            return input.count | 0
        if (typeof input.length === "number")
            return input.length | 0
        return 0
    }

    // Read one numeric sample without allocating a flattened copy.
    function valueAt(input, index, fallback) {
        if (!input || index < 0)
            return fallback !== undefined ? fallback : 0
        if (typeof input.valueAt === "function")
            return asNumber(input.valueAt(index), fallback)
        if (typeof input.length === "number" && index >= input.length)
            return fallback !== undefined ? fallback : 0
        var it = input[index]
        if (typeof it === "number")
            return isFinite(it) ? it : (fallback !== undefined ? fallback : 0)
        if (it && typeof it === "object") {
            if (it.value !== undefined)
                return asNumber(it.value, fallback)
            if (it.y !== undefined)
                return asNumber(it.y, fallback)
        }
        return asNumber(it, fallback)
    }

    // Point X
    function pointX(input, index) {
        if (!input || index < 0)
            return index
        if (typeof input.xAt === "function")
            return asNumber(input.xAt(index), index)
        if (typeof input.length === "number" && index >= input.length)
            return index
        var it = input[index]
        if (it && typeof it === "object" && it.x !== undefined)
            return asNumber(it.x, index)
        return index
    }

    // Point Y
    function pointY(input, index) {
        if (input && typeof input.yAt === "function")
            return asNumber(input.yAt(index))
        return valueAt(input, index)
    }

    // Point Color
    function pointColor(input, index) {
        if (!input || index < 0 || index >= input.length)
            return undefined
        var it = input[index]
        if (it && typeof it === "object" && it.color !== undefined)
            return it.color
        return undefined
    }

    // Prefer valueAt/valueCount for large series. Dense number arrays are returned as-is.
    function flattenValues(input) {
        var n = valueCount(input)
        if (!n)
            return []
        if (typeof input[0] === "number")
            return input
        var out = new Array(n)
        for (var i = 0; i < n; ++i)
            out[i] = valueAt(input, i)
        return out
    }

    // Extents
    function extents(values) {
        var n = valueCount(values)
        if (!n)
            return { min: 0, max: 1 }
        var lo = valueAt(values, 0)
        var hi = lo
        for (var i = 1; i < n; ++i) {
            var v = valueAt(values, i)
            if (v < lo)
                lo = v
            if (v > hi)
                hi = v
        }
        if (lo === hi) {
            lo -= 1
            hi += 1
        }
        return { min: lo, max: hi }
    }

    // Extents XY
    function extentsXY(points) {
        var n = valueCount(points)
        if (!n)
            return { minX: 0, maxX: 1, minY: 0, maxY: 1 }
        var loX = pointX(points, 0)
        var hiX = loX
        var loY = pointY(points, 0)
        var hiY = loY
        for (var i = 1; i < n; ++i) {
            var x = pointX(points, i)
            var y = pointY(points, i)
            if (x < loX) loX = x
            if (x > hiX) hiX = x
            if (y < loY) loY = y
            if (y > hiY) hiY = y
        }
        if (hiX <= loX) {
            loX -= 1
            hiX += 1
        }
        if (hiY <= loY) {
            loY -= 1
            hiY += 1
        }
        return { minX: loX, maxX: hiX, minY: loY, maxY: hiY }
    }

    // Pixel-aware draw budget. Default keeps ~2 samples per horizontal pixel.
    function lodBudget(plotWidth, maxPoints, factor) {
        if (maxPoints > 0)
            return Math.max(2, Math.floor(maxPoints))
        var f = factor > 0 ? factor : 2
        return Math.max(64, Math.floor(Math.max(1, plotWidth) * f))
    }

    // Min/max bucket LOD — one O(n) scan, O(budget) allocation, keeps envelope peaks.
    // Returns { values, min, max, sourceCount, shared }.
    // Prefers ChartSeries.lod (C++) when available.
    function buildLod(values, maxPoints) {
        if (values && typeof values.lod === "function") {
            var nativePack = values.lod(Math.max(2, Math.floor(maxPoints || 0)))
            return {
                values: nativePack.values || [],
                min: nativePack.min,
                max: nativePack.max,
                sourceCount: nativePack.sourceCount || 0,
                shared: false
            }
        }

        var n = valueCount(values)
        var budget = Math.max(2, Math.floor(maxPoints || 0))
        if (!n)
            return { values: [], min: 0, max: 1, sourceCount: 0, shared: false }

        if (n <= budget) {
            if (typeof values[0] === "number") {
                var exShared = extents(values)
                return {
                    values: values,
                    min: exShared.min,
                    max: exShared.max,
                    sourceCount: n,
                    shared: true
                }
            }
            var exact = flattenValues(values)
            var exExact = extents(exact)
            return {
                values: exact,
                min: exExact.min,
                max: exExact.max,
                sourceCount: n,
                shared: false
            }
        }

        var buckets = Math.max(1, Math.floor(budget / 2))
        var out = []
        var glo = valueAt(values, 0)
        var ghi = glo
        for (var b = 0; b < buckets; ++b) {
            var start = Math.floor(b * n / buckets)
            var end = Math.floor((b + 1) * n / buckets)
            if (end <= start)
                end = start + 1
            var lo = valueAt(values, start)
            var hi = lo
            var loIdx = start
            var hiIdx = start
            for (var i = start + 1; i < end && i < n; ++i) {
                var v = valueAt(values, i)
                if (v < lo) {
                    lo = v
                    loIdx = i
                }
                if (v > hi) {
                    hi = v
                    hiIdx = i
                }
            }
            if (lo < glo)
                glo = lo
            if (hi > ghi)
                ghi = hi
            if (loIdx <= hiIdx) {
                out.push(lo)
                if (hiIdx !== loIdx)
                    out.push(hi)
            } else {
                out.push(hi)
                out.push(lo)
            }
        }
        if (out.length > budget)
            out.length = budget
        if (glo === ghi) {
            glo -= 1
            ghi += 1
        }
        return {
            values: out,
            min: glo,
            max: ghi,
            sourceCount: n,
            shared: false
        }
    }

    // Back-compat for Sparkline / older call sites.
    function downsample(values, maxPoints) {
        return buildLod(values, maxPoints).values
    }

    // Density binning for scatter — collapses N points into ≤ binsX*binsY cells.
    function densitySample(points, binsX, binsY, minX, maxX, minY, maxY) {
        var n = valueCount(points)
        var bx = Math.max(2, Math.floor(binsX || 64))
        var by = Math.max(2, Math.floor(binsY || 48))
        if (!n)
            return []

        if (n <= bx * by && n < 4000) {
            var direct = []
            for (var i = 0; i < n; ++i) {
                direct.push({
                    x: pointX(points, i),
                    y: pointY(points, i),
                    color: pointColor(points, i),
                    count: 1,
                    index: i
                })
            }
            return direct
        }

        var spanX = Math.max(1e-9, maxX - minX)
        var spanY = Math.max(1e-9, maxY - minY)
        var cells = {}
        var keys = []
        for (i = 0; i < n; ++i) {
            var x = pointX(points, i)
            var y = pointY(points, i)
            var cx = Math.min(bx - 1, Math.max(0, Math.floor(((x - minX) / spanX) * bx)))
            var cy = Math.min(by - 1, Math.max(0, Math.floor(((y - minY) / spanY) * by)))
            var key = cx + "," + cy
            var cell = cells[key]
            if (!cell) {
                cell = {
                    sx: 0,
                    sy: 0,
                    count: 0,
                    color: pointColor(points, i),
                    index: i
                }
                cells[key] = cell
                keys.push(key)
            }
            cell.sx += x
            cell.sy += y
            cell.count++
        }
        var out = []
        for (i = 0; i < keys.length; ++i) {
            cell = cells[keys[i]]
            out.push({
                x: cell.sx / cell.count,
                y: cell.sy / cell.count,
                color: cell.color,
                count: cell.count,
                index: cell.index
            })
        }
        return out
    }

    // Build a large numeric series (call from a button — not from a binding).
    function makeWave(count, seed) {
        var n = Math.max(0, Math.floor(count || 0))
        var a = new Array(n)
        var s = seed !== undefined ? seed : 1.7
        for (var i = 0; i < n; ++i) {
            var t = i * 0.0008
            a[i] = Math.sin(t * s) * 42
                  + Math.sin(t * 2.3 + 0.4) * 18
                  + Math.cos(t * 0.17) * 8
                  + ((i * 17) % 23) * 0.15
        }
        return a
    }

    function makeCloud(count, seed) {
        var n = Math.max(0, Math.floor(count || 0))
        var a = new Array(n)
        var s = seed !== undefined ? seed : 0.37
        for (var i = 0; i < n; ++i) {
            a[i] = {
                x: Math.sin(i * s) * 40 + Math.cos(i * 0.11) * 20 + i * (120 / Math.max(1, n)),
                y: Math.cos(i * 0.29) * 30 + Math.sin(i * 0.17) * 18 + 40
                    + ((i * 13) % 11) * 0.4
            }
        }
        return a
    }

    function palette(theme, index) {
        var colors = [
            theme.accent,
            theme.systemSuccess,
            theme.systemCaution,
            theme.systemCritical,
            theme.accentLight1,
            theme.accentDark1
        ]
        return colors[index % colors.length]
    }

    function withAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    function formatNumber(v, digits) {
        var n = asNumber(v)
        var d = digits !== undefined ? digits : (Math.abs(n - Math.round(n)) < 1e-6 ? 0 : 1)
        return Number(n).toFixed(d)
    }

    function lerp(a, b, t) {
        return a + (b - a) * Math.max(0, Math.min(1, t))
    }

    function formatCount(n) {
        n = Math.floor(asNumber(n))
        if (n >= 1000000)
            return (n / 1000000).toFixed(n % 1000000 === 0 ? 0 : 1) + "M"
        if (n >= 1000)
            return (n / 1000).toFixed(n % 1000 === 0 ? 0 : 1) + "k"
        return String(n)
    }
}
