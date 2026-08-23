pragma Singleton
import QtQuick
import QWinUI3.Theme

// ChartUtils — LOD helpers for large chart series.
//
//   ChartUtils.downsample(values, maxPoints)
//
//   // --- API ---
//   // methods: asNumber(v, fallback), valueCount(input), valueAt(input, index, fallback), pointX(input, index), pointY(input, index), pointColor(input, index), flattenValues(input), extents(values), extentsXY(points), lodBudget(plotWidth, maxPoints, factor), boxPlotStats(values), paretoRows(values), treemapRects(slices, x, y, w, h), violinWidths(values, binCount)
//   // chartUtils.asNumber(v, fallback)
//   // chartUtils.valueCount(input)
//   // chartUtils.valueAt(input, index, fallback)
//   // chartUtils.pointX(input, index)
//
// @notes
//   Internal helpers: downsample, extents, palette, formatNumber (used by chart controls).

QtObject {
    // Point count that triggers LOD
    readonly property int largeSeriesThreshold: 50000
    // Reveal animation runs only up to this many points (1.25 / 1.89)
    readonly property int revealAnimationPointBudget: 500
    // Coalesce canvas repaints during reveal / hover (ms)
    readonly property int redrawCoalesceMs: 16

    // True when entrance reveal should animate (not snap)
    function shouldAnimateReveal(pointCount, animated) {
        return !!animated && !Theme.reducedMotion
               && (pointCount | 0) <= revealAnimationPointBudget
    }

    // Coerce input to number with fallback
    function asNumber(v, fallback) {
        var n = Number(v)
        return isFinite(n) ? n : (fallback !== undefined ? fallback : 0)
    }

    // Number of values in the series input
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

    // X coordinate for a series point
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

    // Y coordinate for a series point
    function pointY(input, index) {
        if (input && typeof input.yAt === "function")
            return asNumber(input.yAt(index))
        return valueAt(input, index)
    }

    // Color for a series point
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

    // Min/max extents of a value series
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

    // Histogram bins from a numeric series. Returns [{ from, to, count, value }].
    function histogramBins(values, binCount) {
        var n = valueCount(values)
        var bins = Math.max(1, binCount | 0)
        if (!n) {
            var empty = []
            for (var e = 0; e < bins; ++e)
                empty.push({ from: e, to: e + 1, count: 0, value: 0 })
            return empty
        }
        var ext = extents(values)
        var span = ext.max - ext.min
        if (span <= 0)
            span = 1
        var counts = []
        for (var b = 0; b < bins; ++b)
            counts.push(0)
        for (var i = 0; i < n; ++i) {
            var v = valueAt(values, i)
            var idx = Math.floor(((v - ext.min) / span) * bins)
            if (idx >= bins)
                idx = bins - 1
            if (idx < 0)
                idx = 0
            counts[idx] += 1
        }
        var out = []
        for (b = 0; b < bins; ++b) {
            var from = ext.min + (span * b) / bins
            var to = ext.min + (span * (b + 1)) / bins
            out.push({ from: from, to: to, count: counts[b], value: counts[b] })
        }
        return out
    }

    // X/Y extents of a point series
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

    // Douglas–Peucker for y-series (x = index). Returns ≤ maxPoints samples.
    function douglasPeucker(values, maxPoints) {
        var n = valueCount(values)
        var budget = Math.max(2, Math.floor(maxPoints || 0))
        if (!n)
            return []
        if (n <= budget) {
            var exact = flattenValues(values)
            return exact
        }
        var pts = []
        for (var i = 0; i < n; ++i)
            pts.push({ x: i, y: valueAt(values, i), keep: false })
        pts[0].keep = true
        pts[n - 1].keep = true

        var stack = [[0, n - 1]]
        while (stack.length) {
            var seg = stack.pop()
            var left = seg[0]
            var right = seg[1]
            if (right <= left + 1)
                continue
            var x1 = pts[left].x
            var y1 = pts[left].y
            var x2 = pts[right].x
            var y2 = pts[right].y
            var best = -1
            var bestDist = -1
            for (var j = left + 1; j < right; ++j) {
                var dx = x2 - x1
                var dy = y2 - y1
                var denom = dx * dx + dy * dy
                var t = denom > 0
                        ? ((pts[j].x - x1) * dx + (pts[j].y - y1) * dy) / denom
                        : 0
                if (t < 0) t = 0
                if (t > 1) t = 1
                var px = x1 + t * dx
                var py = y1 + t * dy
                var ddx = pts[j].x - px
                var ddy = pts[j].y - py
                var dist = ddx * ddx + ddy * ddy
                if (dist > bestDist) {
                    bestDist = dist
                    best = j
                }
            }
            if (best < 0)
                continue
            pts[best].keep = true
            stack.push([left, best])
            stack.push([best, right])
            var kept = 0
            for (var k = 0; k < n; ++k)
                if (pts[k].keep)
                    ++kept
            if (kept >= budget)
                break
        }

        var out = []
        for (var p = 0; p < n && out.length < budget; ++p) {
            if (pts[p].keep)
                out.push(pts[p].y)
        }
        if (out.length < 2) {
            out = [pts[0].y, pts[n - 1].y]
        }
        return out
    }

    function buildLodDouglas(values, maxPoints) {
        var n = valueCount(values)
        if (!n)
            return { values: [], min: 0, max: 1, sourceCount: 0, shared: false }
        var simplified = douglasPeucker(values, maxPoints)
        var ex = extents(simplified)
        return {
            values: simplified,
            min: ex.min,
            max: ex.max,
            sourceCount: n,
            shared: false
        }
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

    // Build a soft cloud brush / fill path
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

    // Resolve a chart palette color by index
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

    // Return color with overridden alpha
    function withAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    // Format a number for axis / tooltip text
    function formatNumber(v, digits) {
        var n = asNumber(v)
        var d = digits !== undefined ? digits : (Math.abs(n - Math.round(n)) < 1e-6 ? 0 : 1)
        return Number(n).toFixed(d)
    }

    // Linear interpolate between two numbers
    function lerp(a, b, t) {
        return a + (b - a) * Math.max(0, Math.min(1, t))
    }

    // Format count
    function formatCount(n) {
        n = Math.floor(asNumber(n))
        if (n >= 1000000)
            return (n / 1000000).toFixed(n % 1000000 === 0 ? 0 : 1) + "M"
        if (n >= 1000)
            return (n / 1000).toFixed(n % 1000 === 0 ? 0 : 1) + "k"
        return String(n)
    }

    // Tukey five-number summary for a numeric series
    function boxPlotStats(values) {
        var arr = flattenValues(values)
        arr.sort(function (a, b) { return a - b })
        var n = arr.length
        if (!n)
            return { min: 0, q1: 0, median: 0, q3: 0, max: 0, n: 0 }
        function pct(p) {
            var i = (n - 1) * p
            var lo = Math.floor(i)
            var hi = Math.ceil(i)
            if (lo === hi)
                return arr[lo]
            return arr[lo] + (arr[hi] - arr[lo]) * (i - lo)
        }
        return {
            min: arr[0],
            q1: pct(0.25),
            median: pct(0.5),
            q3: pct(0.75),
            max: arr[n - 1],
            n: n
        }
    }

    // Sorted Pareto rows with cumulative share (0..1)
    function paretoRows(values) {
        var vals = flattenValues(values)
        var n = vals.length
        var order = []
        var total = 0
        for (var i = 0; i < n; ++i) {
            order.push(i)
            total += Math.max(0, asNumber(vals[i]))
        }
        order.sort(function (a, b) { return asNumber(vals[b]) - asNumber(vals[a]) })
        var cum = 0
        var out = []
        for (i = 0; i < n; ++i) {
            var idx = order[i]
            var v = asNumber(vals[idx])
            cum += Math.max(0, v)
            out.push({
                index: idx,
                value: v,
                cumulative: total > 0 ? cum / total : 0
            })
        }
        return out
    }

    // Slice-and-dice treemap rectangles { x, y, w, h, index }
    function treemapRects(slices, x, y, w, h) {
        var n = slices && slices.length ? slices.length : 0
        var out = []
        if (!n || w < 1 || h < 1)
            return out
        var weights = []
        var total = 0
        for (var i = 0; i < n; ++i) {
            var wt = Math.max(0, asNumber(slices[i].value, slices[i]))
            weights.push(wt)
            total += wt
        }
        if (total <= 0)
            return out
        function layout(start, end, rx, ry, rw, rh, vertical) {
            if (start >= end || rw < 0.5 || rh < 0.5)
                return
            if (end - start === 1) {
                out.push({ x: rx, y: ry, w: rw, h: rh, index: start })
                return
            }
            var sub = 0
            for (var k = start; k < end; ++k)
                sub += weights[k]
            if (sub <= 0)
                return
            var acc = 0
            var split = start
            for (k = start; k < end - 1; ++k) {
                acc += weights[k]
                split = k
                if (acc >= sub * 0.5)
                    break
            }
            var frac = acc / sub
            if (vertical) {
                var left = rw * frac
                layout(start, split + 1, rx, ry, left, rh, false)
                layout(split + 1, end, rx + left, ry, rw - left, rh, false)
            } else {
                var top = rh * frac
                layout(start, split + 1, rx, ry, rw, top, true)
                layout(split + 1, end, rx, ry + top, rw, rh - top, true)
            }
        }
        layout(0, n, x, y, w, h, w >= h)
        return out
    }

    // Histogram bins with a 0..1 width for violin / density charts
    function violinWidths(values, binCount) {
        var bins = histogramBins(values, binCount)
        var maxC = 1
        for (var i = 0; i < bins.length; ++i)
            maxC = Math.max(maxC, asNumber(bins[i].count))
        for (i = 0; i < bins.length; ++i)
            bins[i].width = maxC > 0 ? asNumber(bins[i].count) / maxC : 0
        return bins
    }
}
