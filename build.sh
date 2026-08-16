#!/usr/bin/env bash
# Usage: ./build.sh [Debug|Release] [--clean]
# Default: Release. Optional --clean removes the build/ directory first.
set -euo pipefail

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
# Ensure gallery is linked even if the default target set is incomplete.
cmake --build "${BUILD_DIR}" --parallel --target qwinui3_gallery

QML_IMPORTS="${BUILD_DIR}/src/platform/QWinUI3:${BUILD_DIR}/src/extras/QWinUI3:${BUILD_DIR}/src/theme/QWinUI3:${BUILD_DIR}/src/style"

# Prefer the real linked binary (Qt often leaves it under src/gallery/), then
# publish a stable path at build/qwinui3_gallery for run-gallery.sh.
publish_gallery() {
  local src=""
  local candidates=(
    "${BUILD_DIR}/src/gallery/qwinui3_gallery"
    "${BUILD_DIR}/bin/qwinui3_gallery"
    "${BUILD_DIR}/qwinui3_gallery"
  )
  local p
  for p in "${candidates[@]}"; do
    if [[ -f "${p}" && -x "${p}" ]]; then
      src="${p}"
      break
    fi
  done
  if [[ -z "${src}" ]]; then
    src="$(find "${BUILD_DIR}" -maxdepth 5 -type f -name qwinui3_gallery 2>/dev/null | head -n 1 || true)"
  fi
  if [[ -z "${src}" || ! -f "${src}" ]]; then
    return 1
  fi
  if [[ ! -x "${src}" ]]; then
    chmod +x "${src}" || true
  fi

  local dest="${BUILD_DIR}/qwinui3_gallery"
  if [[ "${src}" != "${dest}" ]]; then
    cp -f "${src}" "${dest}"
    chmod +x "${dest}"
  fi
  # Verify the stable path exists before claiming success.
  [[ -f "${dest}" && -x "${dest}" ]] || return 1
  echo "${dest}"
  return 0
}

if ! GALLERY_ABS="$(publish_gallery)"; then
  echo "Build finished but qwinui3_gallery was not found under ${BUILD_DIR}." >&2
  echo "Looked in: build/src/gallery, build/bin, build/" >&2
  echo "Try: find build -name qwinui3_gallery -type f" >&2
  echo "Then: ./build.sh --clean" >&2
  exit 1
fi

GALLERY_REL="qwinui3_gallery"

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
export QT_PLUGIN_PATH="\${QT_PLUGIN_PATH:-${QT_PREFIX}/plugins}"
export QML_IMPORT_PATH="${QML_IMPORTS}\${QML_IMPORT_PATH:+:\$QML_IMPORT_PATH}"
export QML2_IMPORT_PATH="\${QML_IMPORT_PATH}"
export LD_LIBRARY_PATH="${QT_PREFIX}/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
cd "\${HERE}"
if [[ ! -x "\${HERE}/qwinui3_gallery" ]]; then
  echo "Missing \${HERE}/qwinui3_gallery — rebuild with ./build.sh" >&2
  exit 1
fi
exec "\${HERE}/qwinui3_gallery" "\$@"
EOF
chmod +x "${BUILD_DIR}/run-gallery.sh"

echo
echo "Done: ${GALLERY_ABS} (${CONFIG})"
echo "Run:  ${BUILD_DIR}/run-gallery.sh"
