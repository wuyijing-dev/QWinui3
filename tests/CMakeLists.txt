# Unit tests for the header-only Qt compat layer (QTest).
find_package(Qt6 REQUIRED COMPONENTS Test)

qt_add_executable(test_qtcompatdpi test_qtcompatdpi.cpp)
target_include_directories(test_qtcompatdpi PRIVATE
    ${CMAKE_SOURCE_DIR}/src/compat/QWinUI3/Compat
)
# QtCompatDpi.h uses QtGui types (QGuiApplication) — link Gui so the
# target carries its include dirs and dependency semantics properly.
target_link_libraries(test_qtcompatdpi PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Test
)

add_test(NAME qtcompatdpi COMMAND test_qtcompatdpi)
