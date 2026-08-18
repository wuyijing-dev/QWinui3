# QWinUI3 vcpkg port (2.11) — shared Release kit + find_package layout.
#
# Overlay from this repo (recommended for development):
#   vcpkg install qwinui3 --overlay-ports=./ports --triplet x64-windows
#
# Registry / GitHub fetch (after vX.YY tag + SHA512 update):
#   vcpkg install qwinui3
#
# See docs/packaging-vcpkg-conan.md

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

set(_local_source "${CMAKE_CURRENT_LIST_DIR}/../..")
if(EXISTS "${_local_source}/CMakeLists.txt"
        AND EXISTS "${_local_source}/scripts/package_release_libs.py")
    set(SOURCE_PATH "${_local_source}")
    message(STATUS "qwinui3: overlay source ${SOURCE_PATH}")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO wuyijing-dev/QWinui3
        REF "v${VERSION}"
        SHA512 0
        HEAD_REF master
    )
endif()

set(_cmake_media OFF)
set(_cmake_webview2 OFF)
if("media" IN_LIST FEATURES)
    set(_cmake_media ON)
endif()
if("webview2" IN_LIST FEATURES)
    set(_cmake_webview2 ON)
endif()

set(_cmake_opts
    -DQWINUI3_BUILD_SHARED=ON
    -DQWINUI3_BUILD_EXAMPLES=OFF
)
if(_cmake_media)
    list(APPEND _cmake_opts -DQWINUI3_BUILD_MEDIA=ON)
else()
    list(APPEND _cmake_opts -DQWINUI3_BUILD_MEDIA=OFF)
endif()
if(_cmake_webview2)
    list(APPEND _cmake_opts -DQWINUI3_BUILD_WEBVIEW2=ON)
else()
    list(APPEND _cmake_opts -DQWINUI3_BUILD_WEBVIEW2=OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${_cmake_opts}
)

vcpkg_cmake_build()

if("extras" IN_LIST FEATURES)
    set(_preset "all")
else()
    set(_preset "shell")
endif()

vcpkg_find_acquire_program(PYTHON3)

set(_pkg_cmd
    "${PYTHON3}" "${SOURCE_PATH}/scripts/package_release_libs.py"
    --shared
    --no-build
    --build-dir "${CURRENT_BUILDS_DIR}/${TARGET_TRIPLET}-rel"
    --out "${CURRENT_PACKAGES_DIR}"
    --preset "${_preset}"
)
if(_cmake_media)
    list(APPEND _pkg_cmd --media on)
else()
    list(APPEND _pkg_cmd --media off)
endif()
if(_cmake_webview2)
    list(APPEND _pkg_cmd --webview2 on)
else()
    list(APPEND _pkg_cmd --webview2 off)
endif()

vcpkg_execute_required_process(
    COMMAND ${_pkg_cmd}
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME "package-qwinui3-${TARGET_TRIPLET}"
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
