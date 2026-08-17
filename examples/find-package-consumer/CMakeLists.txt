cmake_minimum_required(VERSION 3.21)
project(QWinUI3FindPackageConsumer LANGUAGES CXX)

# Standalone tiny consumer for the 1.61 find_package sketch.
# Not part of the monorepo `examples/` CMake build — configure against a
# packaged shared kit:
#
#   cmake -S examples/find-package-consumer -B build-fpc -DCMAKE_BUILD_TYPE=Release ^
#     -DCMAKE_PREFIX_PATH="D:/Qt/6.8.0/msvc2022_64;D:/deps/qwinui3-…-shared"
#   cmake --build build-fpc --config Release
#
# See docs/packaging-consumer.md (Path C) and examples/find-package-consumer/README.md.

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
find_package(QWinUI3 CONFIG REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(qwinui3_find_package_consumer main.cpp)

qt_add_qml_module(qwinui3_find_package_consumer
    URI QWinUI3.Examples.FindPackageConsumer
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(qwinui3_find_package_consumer PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    QWinUI3::theme
    QWinUI3::style
    QWinUI3::platform
)

# Prefer meta-target when the kit has extras too:
#   target_link_libraries(... PRIVATE QWinUI3::QWinUI3)

qwinui3_target_setup(qwinui3_find_package_consumer)

set_target_properties(qwinui3_find_package_consumer PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
