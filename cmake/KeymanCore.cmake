# Build SIL Keyman Core (MIT) as a static lib without meson/ICU.
# Sources: third_party/keyman (sparse clone of keymanapp/keyman core + common).
# NFC/NFD uses Qt (util_normalize_qt.cpp). LDML regex is stubbed; .kmx still works.

set(QWINUI3_HAVE_KEYMAN OFF)
set(_qwinui3_keyman_root "${CMAKE_SOURCE_DIR}/third_party/keyman")
set(_qwinui3_keyman_src "${_qwinui3_keyman_root}/core/src")

if(NOT DEFINED QWINUI3_FETCH_KEYMAN)
    option(QWINUI3_FETCH_KEYMAN "Sparse-clone SIL Keyman Core when third_party/keyman is missing" ON)
endif()

if(NOT EXISTS "${_qwinui3_keyman_src}/km_core_keyboard_api.cpp")
    if(QWINUI3_FETCH_KEYMAN)
        find_program(_qwinui3_python NAMES python3 python)
        if(_qwinui3_python)
            message(STATUS "QWinUI3: fetching Keyman Core (MIT) into third_party/keyman")
            execute_process(
                COMMAND "${_qwinui3_python}" "${CMAKE_SOURCE_DIR}/scripts/fetch_keyman_core.py"
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                RESULT_VARIABLE _qwinui3_km_fetch
            )
            if(NOT _qwinui3_km_fetch EQUAL 0)
                message(WARNING "QWinUI3: fetch_keyman_core.py failed (${_qwinui3_km_fetch})")
            endif()
        endif()
    endif()
endif()

if(NOT EXISTS "${_qwinui3_keyman_src}/km_core_keyboard_api.cpp")
    message(STATUS "QWinUI3: Keyman Core sources missing — run scripts/fetch_keyman_core.py")
    return()
endif()

set(_qwinui3_keyman_gen "${CMAKE_BINARY_DIR}/keyman_gen")
file(MAKE_DIRECTORY "${_qwinui3_keyman_gen}/keyman")

file(READ "${_qwinui3_keyman_root}/core/CORE_API_VERSION.md" _qwinui3_core_api_ver)
string(STRIP "${_qwinui3_core_api_ver}" _qwinui3_core_api_ver)
string(REPLACE "." ";" _qwinui3_core_api_parts "${_qwinui3_core_api_ver}")
list(GET _qwinui3_core_api_parts 0 _lib_curr)
list(GET _qwinui3_core_api_parts 1 _lib_age)
list(GET _qwinui3_core_api_parts 2 _lib_rev)

file(READ "${_qwinui3_keyman_root}/VERSION.md" _qwinui3_km_ver)
string(STRIP "${_qwinui3_km_ver}" _qwinui3_km_ver)
string(REPLACE "." ";" _qwinui3_km_parts "${_qwinui3_km_ver}")
list(GET _qwinui3_km_parts 0 _km_major)
list(GET _qwinui3_km_parts 1 _km_minor)
list(GET _qwinui3_km_parts 2 _km_patch)

file(READ "${_qwinui3_keyman_root}/core/include/keyman/keyman_core_api_version.h.in" _ver_in)
string(REPLACE "@lib_curr@" "${_lib_curr}" _ver_in "${_ver_in}")
string(REPLACE "@lib_age@" "${_lib_age}" _ver_in "${_ver_in}")
string(REPLACE "@lib_rev@" "${_lib_rev}" _ver_in "${_ver_in}")
string(REPLACE "@majorver@" "${_km_major}" _ver_in "${_ver_in}")
string(REPLACE "@minorver@" "${_km_minor}" _ver_in "${_ver_in}")
string(REPLACE "@patchver@" "${_km_patch}" _ver_in "${_ver_in}")
file(WRITE "${_qwinui3_keyman_gen}/keyman/keyman_core_api_version.h" "${_ver_in}")

set(_qwinui3_keyman_sources
    ${_qwinui3_keyman_src}/actions_normalize.cpp
    ${_qwinui3_keyman_src}/action.cpp
    ${_qwinui3_keyman_src}/context_helpers.cpp
    ${_qwinui3_keyman_src}/option.cpp
    ${_qwinui3_keyman_src}/keyboard.cpp
    ${_qwinui3_keyman_src}/state.cpp
    ${_qwinui3_keyman_src}/debuglog.cpp
    ${_qwinui3_keyman_src}/vkey_to_contextreset.cpp
    ${_qwinui3_keyman_src}/km_core_action_api.cpp
    ${_qwinui3_keyman_src}/km_core_context_api.cpp
    ${_qwinui3_keyman_src}/km_core_keyboard_api.cpp
    ${_qwinui3_keyman_src}/km_core_options_api.cpp
    ${_qwinui3_keyman_src}/km_core_state_api.cpp
    ${_qwinui3_keyman_src}/km_core_state_context_set_if_needed.cpp
    ${_qwinui3_keyman_src}/km_core_debug_api.cpp
    ${_qwinui3_keyman_src}/km_core_processevent_api.cpp
    ${_qwinui3_keyman_src}/jsonpp.cpp
    ${_qwinui3_keyman_src}/core_icu.cpp
    ${_qwinui3_keyman_src}/ldml/ldml_processor.cpp
    ${_qwinui3_keyman_src}/ldml/ldml_transforms.cpp
    ${_qwinui3_keyman_src}/ldml/ldml_markers.cpp
    ${_qwinui3_keyman_src}/ldml/ldml_vkeys.cpp
    ${_qwinui3_keyman_src}/mock/mock_processor.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_consts.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_processevent.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_actions.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_capslock.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_context.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_conversion.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_debugger.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_environment.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_file.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_modifiers.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_options.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_plus.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_processor.cpp
    ${_qwinui3_keyman_src}/kmx/kmx_xstring.cpp
    ${_qwinui3_keyman_root}/common/cpp/utfcodec.cpp
    ${_qwinui3_keyman_root}/common/cpp/km_u16.cpp
    ${_qwinui3_keyman_root}/common/cpp/vkeys.cpp
    ${CMAKE_SOURCE_DIR}/src/extras/keyman_shims/util_normalize_qt.cpp
    ${CMAKE_SOURCE_DIR}/src/extras/keyman_shims/util_regex_stub.cpp
)

add_library(qwinui3_keymancore STATIC ${_qwinui3_keyman_sources})
set_target_properties(qwinui3_keymancore PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE ON
    AUTOMOC OFF
    AUTOUIC OFF
    AUTORCC OFF
)
# PUBLIC: consumers (KeyboardEngine) must not dllimport a static lib.
target_compile_definitions(qwinui3_keymancore PUBLIC
    KM_CORE_LIBRARY_STATIC
)
target_compile_definitions(qwinui3_keymancore PRIVATE
    KM_CORE_LIBRARY
    KMN_NO_ICU=1
    UNICODE
    _UNICODE
)
if(MSVC)
    target_compile_options(qwinui3_keymancore PRIVATE /utf-8 /wd4244 /wd4267 /wd4996 /FImemory)
else()
    target_compile_options(qwinui3_keymancore PRIVATE -include memory)
endif()
target_include_directories(qwinui3_keymancore PUBLIC
    "${_qwinui3_keyman_root}/core/include"
    "${_qwinui3_keyman_root}/common/include"
    "${_qwinui3_keyman_gen}"
)
target_include_directories(qwinui3_keymancore PRIVATE
    "${_qwinui3_keyman_src}"
    "${_qwinui3_keyman_root}/common/include"
    "${_qwinui3_keyman_root}/core/include"
)
target_link_libraries(qwinui3_keymancore PRIVATE Qt6::Core)
set(QWINUI3_HAVE_KEYMAN ON)
message(STATUS "QWinUI3: Keyman Core (MIT) static, KMN_NO_ICU, version ${_qwinui3_km_ver}")
