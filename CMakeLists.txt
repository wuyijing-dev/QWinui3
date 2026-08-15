cmake_minimum_required(VERSION 3.16)

# Single-config generators (Ninja/Makefiles): default to Release unless specified.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
endif()

project(QWinUI3
    VERSION 0.1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels)

qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(src/theme/QWinUI3/Theme)
add_subdirectory(src/platform/QWinUI3/Platform)
add_subdirectory(src/style/QWinUI3)
add_subdirectory(src/extras/QWinUI3/Extras)
add_subdirectory(src/gallery)
