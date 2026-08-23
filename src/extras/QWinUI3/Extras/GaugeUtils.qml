pragma Singleton
import QtQuick

// Shared pointer → value helpers for interactive gauges.

QtObject {
    function mapToItem(dragArea, target, mx, my) {
        if (!dragArea || !target)
            return Qt.point(mx, my)
        return dragArea.mapToItem(target, mx, my)
    }

    // Map a pointer on a circular/arc gauge to 0..1 along [startAngle, startAngle+sweep].
    // Angles use PathAngleArc convention (degrees, 0° at 3 o'clock, clockwise positive via atan2).
    //
    // Outside the active sweep (the "gap"), snap to the nearer endpoint — the old
    // wrap-and-clamp logic mapped points near minimum into maximum (and vice versa).
    // Optional previousNorm (0..1) keeps an in-progress drag from jumping across the gap.
    function normFromAngle(px, py, cx, cy, startAngle, sweepTotal, previousNorm) {
        var ang = Math.atan2(py - cy, px - cx) * 180 / Math.PI
        return normFromDeg(ang, startAngle, sweepTotal, previousNorm)
    }

    function normFromDeg(ang, startAngle, sweepTotal, previousNorm) {
        var sweep = Number(sweepTotal) || 0
        var start = Number(startAngle) || 0
        if (Math.abs(sweep) < 1e-6)
            return 0

        var reverse = sweep < 0
        if (reverse) {
            start = start + sweep
            sweep = -sweep
        }

        // Relative angle from start, wrapped into [0, 360)
        var rel = ang - start
        rel = ((rel % 360) + 360) % 360

        // Near-full circle: treat as continuous (tiny gap still uses endpoint snap below)
        if (rel <= sweep + 1e-4) {
            var n = rel / Math.max(1e-6, sweep)
            return reverse ? (1 - n) : n
        }

        // Dead zone between max and min: choose nearer endpoint by arc distance.
        var pastEnd = rel - sweep
        var toStart = 360 - rel
        var preferMax = pastEnd <= toStart

        if (previousNorm !== undefined && previousNorm !== null && isFinite(previousNorm)) {
            var p = Math.max(0, Math.min(1, Number(previousNorm)))
            if (reverse)
                p = 1 - p
            // Stick to the side the drag came from so a tiny overshoot past min
            // does not jump to maximum (and the reverse).
            if (p <= 0.35)
                preferMax = false
            else if (p >= 0.65)
                preferMax = true
        }

        var out = preferMax ? 1 : 0
        return reverse ? (1 - out) : out
    }

    function valueFromNorm(norm, minimum, maximum) {
        return minimum + Math.max(0, Math.min(1, norm)) * (maximum - minimum)
    }
}
