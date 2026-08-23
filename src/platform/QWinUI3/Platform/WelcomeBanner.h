#pragma once

namespace QWinUI3 {

/// Print a one-shot colorful welcome banner to stderr.
/// Skipped when QWINUI3_NO_BANNER / QWINUI3_QUIET is set, or when already printed.
void printWelcomeBanner();

} // namespace QWinUI3
