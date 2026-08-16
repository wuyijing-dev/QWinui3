# CMake helper: locate or use vendored Microsoft.Web.WebView2 NuGet layout.
#
# Expected layout (after scripts/fetch_webview2.ps1):
#   third_party/webview2/pkg/build/native/include/WebView2.h
#   third_party/webview2/pkg/build/native/x64/WebView2Loader.dll.lib
#   third_party/webview2/pkg/build/native/x64/WebView2Loader.dll

function(qwinui3_find_webview2)
    set(QWINUI3_WEBVIEW2_FOUND FALSE PARENT_SCOPE)
    set(_root "${CMAKE_SOURCE_DIR}/third_party/webview2/pkg/build/native")
    if(DEFINED ENV{WEBVIEW2_SDK_PATH} AND EXISTS "$ENV{WEBVIEW2_SDK_PATH}/include/WebView2.h")
        set(_root "$ENV{WEBVIEW2_SDK_PATH}")
    endif()

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(_arch x64)
    else()
        set(_arch x86)
    endif()

    set(_inc "${_root}/include")
    set(_lib "${_root}/${_arch}/WebView2Loader.dll.lib")
    set(_dll "${_root}/${_arch}/WebView2Loader.dll")
    if(NOT EXISTS "${_inc}/WebView2.h" OR NOT EXISTS "${_lib}")
        return()
    endif()

    add_library(qwinui3_webview2_loader SHARED IMPORTED GLOBAL)
    set_target_properties(qwinui3_webview2_loader PROPERTIES
        IMPORTED_IMPLIB "${_lib}"
        IMPORTED_LOCATION "${_dll}"
        INTERFACE_INCLUDE_DIRECTORIES "${_inc}"
    )
    set(QWINUI3_WEBVIEW2_FOUND TRUE PARENT_SCOPE)
    set(QWINUI3_WEBVIEW2_DLL "${_dll}" PARENT_SCOPE)
endfunction()
