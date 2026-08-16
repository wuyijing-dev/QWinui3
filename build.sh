#!/usr/bin/env bash
# Usage: ./build.sh [Debug|Release] [--clean] [--force]
# Default: Release.
# QWINUI3_BUILD_SH_REV=5
set -euo pipefail

echo "=========================================="
echo " QWinUI3 build.sh rev=5"
echo "=========================================="

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT}/build"
CONFIG="Release"
CLEAN=0
FORCE=0

for arg in "$@"; do
  case "${arg}" in
    Debug|Release|RelWithDebInfo|MinSizeRel)
      CONFIG="${arg}"
      ;;
    --clean|-c)
      CLEAN=1
      ;;
    --force|-f)
      FORCE=1
      ;;
    -h|--help)
      echo "Usage: $0 [Debug|Release] [--clean] [--force]"
      echo "  --force   touch platform/gallery sources so Ninja must relink"
      exit 0
      ;;
    *)
      echo "Unknown argument: ${arg}" >&2
      exit 1
      ;;
  esac
done

# Refuse to proceed on a stale checkout (common cause of “unstable” Linux runs).
WH_CPP="${ROOT}/src/platform/QWinUI3/Platform/WindowHelper.cpp"
if [[ ! -f "${WH_CPP}" ]] || ! grep -q 'removed broken' "${WH_CPP}"; then
  echo "ERROR: source tree is outdated (missing Linux qt.conf fix)." >&2
  echo "Run:" >&2
  echo "  git fetch origin && git reset --hard origin/master" >&2
  exit 1
fi

if [[ ! -f "${ROOT}/build.sh" ]] || ! grep -q 'QWINUI3_BUILD_SH_REV=5' "${ROOT}/build.sh"; then
  echo "ERROR: build.sh on disk is not rev=5. Did git pull fail?" >&2
  exit 1
fi

GIT_REV="$(git -C "${ROOT}" rev-parse --short HEAD 2>/dev/null || echo unknown)"
echo "Git:     ${GIT_REV}"

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
    [[ -d "${c}" ]] && { echo "${c}"; return 0; }
  done
  if [[ -d /usr/lib/x86_64-linux-gnu/cmake/Qt6 ]] || [[ -d /usr/lib/cmake/Qt6 ]]; then
    echo "/usr"
    return 0
  fi
  if command -v qmake6 >/dev/null 2>&1; then
    qmake6 -query QT_INSTALL_PREFIX
    return 0
  fi
  if command -v qtpaths6 >/dev/null 2>&1; then
    qtpaths6 --install-prefix
    return 0
  fi
  return 1
}

detect_qt_plugin_dir() {
  if command -v qtpaths6 >/dev/null 2>&1; then
    local d
    d="$(qtpaths6 --plugin-dir 2>/dev/null || true)"
    if [[ -n "${d}" && -d "${d}/platforms" ]]; then
      echo "${d}"
      return 0
    fi
  fi
  local candidates=(
    "${QT_PREFIX}/plugins"
    "${QT_PREFIX}/lib/qt6/plugins"
    /usr/lib/x86_64-linux-gnu/qt6/plugins
    /usr/lib/aarch64-linux-gnu/qt6/plugins
    /usr/lib/qt6/plugins
    /usr/lib64/qt6/plugins
  )
  local c
  for c in "${candidates[@]}"; do
    if [[ -d "${c}/platforms" ]]; then
      echo "${c}"
      return 0
    fi
  done
  return 1
}

find_linked_gallery() {
  local p
  for p in \
    "${BUILD_DIR}/src/gallery/qwinui3_gallery" \
    "${BUILD_DIR}/bin/qwinui3_gallery" \
    "${BUILD_DIR}/qwinui3_gallery"
  do
    [[ -f "${p}" ]] && { echo "${p}"; return 0; }
  done
  p="$(find "${BUILD_DIR}" -maxdepth 6 -type f -name qwinui3_gallery 2>/dev/null | head -n 1 || true)"
  [[ -n "${p}" && -f "${p}" ]] && { echo "${p}"; return 0; }
  return 1
}

publish_gallery_to_root() {
  local src="$1"
  local dest="${BUILD_DIR}/qwinui3_gallery"
  chmod +x "${src}" 2>/dev/null || true
  [[ "${src}" != "${dest}" ]] && cp -f "${src}" "${dest}"
  chmod +x "${dest}"
  [[ -f "${dest}" ]] || return 1
  echo "${dest}"
}

force_relink_gallery() {
  echo "Forcing relink of qwinui3_platform + qwinui3_gallery ..."
  rm -f \
    "${BUILD_DIR}/qwinui3_gallery" \
    "${BUILD_DIR}/bin/qwinui3_gallery" \
    "${BUILD_DIR}/src/gallery/qwinui3_gallery"
  if command -v ninja >/dev/null 2>&1 && [[ -f "${BUILD_DIR}/build.ninja" ]]; then
    ninja -C "${BUILD_DIR}" -t restat >/dev/null 2>&1 || true
  fi
  touch "${ROOT}/src/platform/QWinUI3/Platform/WindowHelper.cpp"
  touch "${ROOT}/src/gallery/main.cpp"
  cmake --build "${BUILD_DIR}" --parallel --target qwinui3_platform
  cmake --build "${BUILD_DIR}" --parallel --target qwinui3_gallery
  cmake --build "${BUILD_DIR}" --parallel --target publish_qwinui3_gallery || true
}

if ! QT_PREFIX="$(detect_qt_prefix)"; then
  echo "Could not find Qt 6.8+. Set CMAKE_PREFIX_PATH or QTDIR." >&2
  exit 1
fi

GENERATOR=( -G Ninja )
if ! command -v ninja >/dev/null 2>&1; then
  echo "ninja not found; falling back to Unix Makefiles."
  GENERATOR=( -G "Unix Makefiles" )
fi

if ! QT_PLUGINS="$(detect_qt_plugin_dir)"; then
  echo "WARNING: Qt platforms/ plugins not found." >&2
  echo "  sudo apt install qt6-wayland qt6-qpa-plugins" >&2
  QT_PLUGINS=""
fi

echo "Config:  ${CONFIG}"
echo "Source:  ${ROOT}"
echo "Build:   ${BUILD_DIR}"
echo "Qt:      ${QT_PREFIX}"
echo "Plugins: ${QT_PLUGINS:-<missing>}"
echo

# Always kill the Windows-style qt.conf that breaks Linux QPA discovery.
rm -f "${BUILD_DIR}/qt.conf"

if [[ "${CLEAN}" -eq 1 && -d "${BUILD_DIR}" ]]; then
  echo "Removing ${BUILD_DIR} ..."
  rm -rf "${BUILD_DIR}"
fi

# After a git pull, Ninja often says "no work to do" while the binary is still
# old. Stamp forces one platform/gallery rebuild per new git revision.
STAMP="${BUILD_DIR}/.qwinui3_linux_plugin_stamp"
if [[ "${FORCE}" -eq 1 ]] || [[ ! -f "${STAMP}" ]] || ! grep -qx "${GIT_REV}" "${STAMP}" 2>/dev/null; then
  echo "Stamp miss (force=${FORCE}) — will rebuild platform/gallery."
  mkdir -p "${BUILD_DIR}"
  touch "${ROOT}/src/platform/QWinUI3/Platform/WindowHelper.cpp"
  touch "${ROOT}/src/gallery/main.cpp"
fi

cmake -S "${ROOT}" -B "${BUILD_DIR}" \
  "${GENERATOR[@]}" \
  -DCMAKE_BUILD_TYPE="${CONFIG}" \
  -DCMAKE_PREFIX_PATH="${QT_PREFIX}" \
  -DQWINUI3_BUILD_EXAMPLES=ON

cmake --build "${BUILD_DIR}" --parallel
cmake --build "${BUILD_DIR}" --parallel --target qwinui3_platform
cmake --build "${BUILD_DIR}" --parallel --target qwinui3_gallery
cmake --build "${BUILD_DIR}" --parallel --target publish_qwinui3_gallery || true

LINKED=""
if ! LINKED="$(find_linked_gallery)"; then
  force_relink_gallery
  LINKED="$(find_linked_gallery)" || {
    echo "ERROR: qwinui3_gallery was not produced." >&2
    find "${BUILD_DIR}" -name 'qwinui3_gallery*' 2>/dev/null || true
    exit 1
  }
fi

echo "Linked:  ${LINKED}"
GALLERY_ABS="$(publish_gallery_to_root "${LINKED}")"
[[ -f "${BUILD_DIR}/qwinui3_gallery" ]] || { echo "ERROR: publish failed"; exit 1; }
BYTES="$(wc -c < "${GALLERY_ABS}" | tr -d ' ')"

# IMPORTANT: do NOT write Prefix=./Plugins=plugins qt.conf on Linux.
# QML imports are provided via env in run-gallery.sh instead.
rm -f "${BUILD_DIR}/qt.conf"

QML_IMPORTS="${BUILD_DIR}/src/platform/QWinUI3:${BUILD_DIR}/src/extras/QWinUI3:${BUILD_DIR}/src/theme/QWinUI3:${BUILD_DIR}/src/style"

# Pick a safe QPA: xcb unless wayland plugin is actually present.
QPA="xcb"
if [[ -n "${QT_PLUGINS}" ]]; then
  if [[ -e "${QT_PLUGINS}/platforms/libqwayland-generic.so" \
     || -e "${QT_PLUGINS}/platforms/libqwayland.so" ]]; then
    QPA="wayland;xcb"
  fi
fi

cat > "${BUILD_DIR}/run-gallery.sh" <<EOF
#!/usr/bin/env bash
# Generated by build.sh rev=5 — safe Linux launcher
set -euo pipefail
HERE="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
BIN="\${HERE}/qwinui3_gallery"
if [[ ! -f "\${BIN}" && -f "\${HERE}/src/gallery/qwinui3_gallery" ]]; then
  BIN="\${HERE}/src/gallery/qwinui3_gallery"
fi
if [[ ! -f "\${BIN}" ]]; then
  echo "Missing gallery binary. Run: ./build.sh" >&2
  exit 1
fi

# Broken Windows-style qt.conf must never sit next to the binary.
rm -f "\${HERE}/qt.conf"

EOF

if [[ -n "${QT_PLUGINS}" ]]; then
  cat >> "${BUILD_DIR}/run-gallery.sh" <<EOF
export QT_PLUGIN_PATH="${QT_PLUGINS}"
EOF
else
  cat >> "${BUILD_DIR}/run-gallery.sh" <<EOF
unset QT_PLUGIN_PATH || true
EOF
fi

cat >> "${BUILD_DIR}/run-gallery.sh" <<EOF
export QT_QPA_PLATFORM="\${QT_QPA_PLATFORM:-${QPA}}"
export QML_IMPORT_PATH="${QML_IMPORTS}\${QML_IMPORT_PATH:+:\$QML_IMPORT_PATH}"
export QML2_IMPORT_PATH="\${QML_IMPORT_PATH}"
if [[ "${QT_PREFIX}" != "/usr" && -d "${QT_PREFIX}/lib" ]]; then
  export LD_LIBRARY_PATH="${QT_PREFIX}/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
fi
echo "QWinUI3 launcher: PLUGIN_PATH=\${QT_PLUGIN_PATH:-<default>} QPA=\${QT_QPA_PLATFORM}"
cd "\${HERE}"
exec "\${BIN}" "\$@"
EOF
chmod +x "${BUILD_DIR}/run-gallery.sh"

echo "${GIT_REV}" > "${STAMP}"

echo
echo "Done: ${GALLERY_ABS} (${CONFIG})  [${BYTES} bytes]"
echo "Run:  ${BUILD_DIR}/run-gallery.sh"
echo "QPA:  ${QPA}"
if [[ "${QPA}" == "xcb" ]]; then
  echo "Note: using xcb (install qt6-wayland for native Wayland)." >&2
fi
