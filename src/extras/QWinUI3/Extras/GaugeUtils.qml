pragma Singleton
import QtQuick

// Shared pointer → value helpers for interactive gauges.

QtObject {
    function mapToItem(dragArea, target, mx, my) {
        if (!dragArea || !target)
            return Qt.point(mx, my)
        return dragArea.mapToItem(target, mx, my)
    }

    function normFromAngle(px, py, cx, cy, startAngle, sweepTotal) {
        var ang = Math.atan2(py - cy, px - cx) * 180 / Math.PI
        var rel = ang - startAngle
        while (rel < 0)
            rel += 360
        while (rel > sweepTotal + 1)
            rel -= 360
        return Math.max(0, Math.min(1, rel / Math.max(1e-6, sweepTotal)))
    }

    function valueFromNorm(norm, minimum, maximum) {
        return minimum + Math.max(0, Math.min(1, norm)) * (maximum - minimum)
    }
}
