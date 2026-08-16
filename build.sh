#!/usr/bin/env bash
# Usage: ./build.sh [Debug|Release] [--clean]
# Default: Release. Optional --clean removes the build/ directory first.
# Marker used to detect stale copies of this script on disk:
# QWINUI3_BUILD_SH_REV=3
set -euo pipefail

echo "QWinUI3 build.sh rev=3"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT}/build"
CONFIG="Release"
CLEAN=0

for arg in "$@"; do
  case "${arg}" in
    Debug|Release|RelWithDebInfo|MinSizeRel)
      CONFIG="${arg}"
      ;;
    --clean|-c)
      CLEAN=1
      ;;
    -h|--help)
      echo "Usage: $0 [Debug|Release|RelWithDebInfo|MinSizeRel] [--clean]"
      echo "  CMAKE_PREFIX_PATH / QTDIR  Qt kit root (optional; auto-detected when possible)"
      exit 0
      ;;
    *)
      echo "Unknown argument: ${arg}" >&2
      echo "Usage: $0 [Debug|Release] [--clean]" >&2
      exit 1
      ;;
  esac
done

detect_qt_prefix() {
  if [[ -n "${CMAKE_PREFIX_PATH:-}" ]]; then
    echo "${CMAKE_PREFIX_PATH%%:*}"
    return 0
  fi
  if [[ -n "${QTDIR:-}" && -d "${QTDIR}" ]]; then
    echo "${QTDIR}"
    return 0
  fi

  local candidates=(
    "${HOME}/Qt/6.8.0/gcc_64"
    "${HOME}/Qt/6.8.1/gcc_64"
    "${HOME}/Qt/6.8.2/gcc_64"
    "${HOME}/Qt/6.8.3/gcc_64"
    "${HOME}/Qt/6.9.0/gcc_64"
    "${HOME}/Qt/6.10.0/gcc_64"
    /opt/Qt/6.8.0/gcc_64
  )
  local c
  for c in "${candidates[@]}"; do
    if [[ -d "${c}" ]]; then
      echo "${c}"
      return 0
    fi
  done

  if [[ -d /usr/lib/x86_64-linux-gnu/cmake/Qt6 ]] || [[ -d /usr/lib/cmake/Qt6 ]]; then
    echo "/usr"
    return 0
  fi

  if command -v qmake6 >/dev/null 2>&1; then
    qmake6 -query QT_INSTALL_PREFIX
    return 0
  fi
  if command -v qmake >/dev/null 2>&1; then
    local ver
    ver="$(qmake -query QT_VERSION 2>/dev/null || true)"
    if [[ "${ver}" == 6.* ]]; then
      qmake -query QT_INSTALL_PREFIX
      return 0
    fi
  fi
  if command -v qtpaths6 >/dev/null 2>&1; then
    qtpaths6 --install-prefix
    return 0
  fi
  return 1
}

# Real linked binary (not the published build/ copy). Prefer src/gallery.
find_linked_gallery() {
  local p
  for p in \
    "${BUILD_DIR}/src/gallery/qwinui3_gallery" \
    "${BUILD_DIR}/bin/qwinui3_gallery" \
    "${BUILD_DIR}/qwinui3_gallery"
  do
    # Must be a regular file (directories can be +x and fool -x checks).
    if [[ -f "${p}" ]]; then
      echo "${p}"
      return 0
    fi
  done
  p="$(find "${BUILD_DIR}" -maxdepth 6 -type f -name qwinui3_gallery 2>/dev/null | head -n 1 || true)"
  if [[ -n "${p}" && -f "${p}" ]]; then
    echo "${p}"
    return 0
  fi
  return 1
}

publish_gallery_to_root() {
  local src="$1"
  local dest="${BUILD_DIR}/qwinui3_gallery"
  chmod +x "${src}" 2>/dev/null || true
  if [[ "${src}" != "${dest}" ]]; then
    cp -f "${src}" "${dest}"
  fi
  chmod +x "${dest}"
  if [[ ! -f "${dest}" ]]; then
    echo "Failed to publish ${dest}" >&2
    return 1
  fi
  echo "${dest}"
}

force_relink_gallery() {
  echo "Gallery binary missing or stale — forcing relink of qwinui3_gallery ..."
  # Ninja skips link if it still thinks the output exists. Drop outputs + restat.
  rm -f \
    "${BUILD_DIR}/qwinui3_gallery" \
    "${BUILD_DIR}/bin/qwinui3_gallery" \
    "${BUILD_DIR}/src/gallery/qwinui3_gallery"
  if command -v ninja >/dev/null 2>&1 && [[ -f "${BUILD_DIR}/build.ninja" ]]; then
    ninja -C "${BUILD_DIR}" -t restat >/dev/null 2>&1 || true
  fi
  # Touch main so the target is definitely out of date even if restat is a no-op.
  touch "${ROOT}/src/gallery/main.cpp"
  cmake --build "${BUILD_DIR}" --parallel --target qwinui3_gallery
  # Ensure publish ALL target runs.
  cmake --build "${BUILD_DIR}" --parallel --target publish_qwinui3_gallery || true
}

if ! QT_PREFIX="$(detect_qt_prefix)"; then
  echo "Could not find Qt 6.8+. Set CMAKE_PREFIX_PATH or QTDIR to your kit (e.g. ~/Qt/6.8.0/gcc_64)." >&2
  exit 1
fi

GENERATOR=( -G Ninja )
if ! command -v ninja >/dev/null 2>&1; then
  echo "ninja not found; falling back to Unix Makefiles."
  GENERATOR=( -G "Unix Makefiles" )
fi

echo "Config:  ${CONFIG}"
echo "Source:  ${ROOT}"
echo "Build:   ${BUILD_DIR}"
echo "Qt:      ${QT_PREFIX}"
echo

if [[ "${CLEAN}" -eq 1 && -d "${BUILD_DIR}" ]]; then
  echo "Removing ${BUILD_DIR} ..."
  rm -rf "${BUILD_DIR}"
fi

cmake -S "${ROOT}" -B "${BUILD_DIR}" \
  "${GENERATOR[@]}" \
  -DCMAKE_BUILD_TYPE="${CONFIG}" \
  -DCMAKE_PREFIX_PATH="${QT_PREFIX}" \
  -DQWINUI3_BUILD_EXAMPLES=ON

cmake --build "${BUILD_DIR}" --parallel
cmake --build "${BUILD_DIR}" --parallel --target qwinui3_gallery
cmake --build "${BUILD_DIR}" --parallel --target publish_qwinui3_gallery || true

LINKED=""
if ! LINKED="$(find_linked_gallery)"; then
  force_relink_gallery
  if ! LINKED="$(find_linked_gallery)"; then
    echo "ERROR: qwinui3_gallery was not produced." >&2
    echo "Searched under ${BUILD_DIR} (maxdepth 6)." >&2
    echo "Debug listing:" >&2
    find "${BUILD_DIR}" -name 'qwinui3_gallery*' 2>/dev/null || true
    echo >&2
    echo "If configure warned about Qt6::QuickEffects, install:" >&2
    echo "  sudo apt install qml6-module-qtquick-effects libqt6quickeffects6" >&2
    exit 1
  fi
fi

echo "Linked:  ${LINKED}"
GALLERY_ABS="$(publish_gallery_to_root "${LINKED}")"

# Hard gate — never print Done unless the launcher path is a real file.
if [[ ! -f "${BUILD_DIR}/qwinui3_gallery" ]]; then
  echo "ERROR: ${BUILD_DIR}/qwinui3_gallery is missing after publish." >&2
  exit 1
fi

BYTES="$(wc -c < "${GALLERY_ABS}" | tr -d ' ')"

QML_IMPORTS="${BUILD_DIR}/src/platform/QWinUI3:${BUILD_DIR}/src/extras/QWinUI3:${BUILD_DIR}/src/theme/QWinUI3:${BUILD_DIR}/src/style"

cat > "${BUILD_DIR}/qt.conf" <<EOF
[Paths]
Prefix = .
Libraries = .
Binaries = .
Plugins = plugins
QmlImports = ${BUILD_DIR}/src/platform/QWinUI3,${BUILD_DIR}/src/extras/QWinUI3,${BUILD_DIR}/src/theme/QWinUI3,qml
EOF

cat > "${BUILD_DIR}/run-gallery.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
HERE="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
BIN="\${HERE}/qwinui3_gallery"
# Fallback if only the Qt-default path exists (older builds).
if [[ ! -f "\${BIN}" && -f "\${HERE}/src/gallery/qwinui3_gallery" ]]; then
  BIN="\${HERE}/src/gallery/qwinui3_gallery"
fi
if [[ ! -f "\${BIN}" ]]; then
  echo "Missing gallery binary. Run: ./build.sh" >&2
  echo "Expected: \${HERE}/qwinui3_gallery or \${HERE}/src/gallery/qwinui3_gallery" >&2
  exit 1
fi
export QT_PLUGIN_PATH="\${QT_PLUGIN_PATH:-${QT_PREFIX}/plugins}"
export QML_IMPORT_PATH="${QML_IMPORTS}\${QML_IMPORT_PATH:+:\$QML_IMPORT_PATH}"
export QML2_IMPORT_PATH="\${QML_IMPORT_PATH}"
export LD_LIBRARY_PATH="${QT_PREFIX}/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
cd "\${HERE}"
exec "\${BIN}" "\$@"
EOF
chmod +x "${BUILD_DIR}/run-gallery.sh"

echo
echo "Done: ${GALLERY_ABS} (${CONFIG})  [${BYTES} bytes]"
echo "Run:  ${BUILD_DIR}/run-gallery.sh"
