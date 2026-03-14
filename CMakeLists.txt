cmake_minimum_required(VERSION 3.16)

project(md3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

find_package(Qt6 REQUIRED COMPONENTS Quick Gui Svg SerialPort Network WebSockets)

qt_standard_project_setup(REQUIRES 6.8)

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
    "${CMAKE_SOURCE_DIR}/src/Extras/Charts/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/DataGrid/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/HotReload/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/Performance/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/MathSymbols/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/Markdown/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/NodeGraph/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/src/Extras/Gantt/CMakeLists.txt"
)

add_subdirectory(src/Core)

set(MD3_HAS_EXTRA_CHARTS FALSE)
set(MD3_HAS_EXTRA_DATAGRID FALSE)
set(MD3_HAS_EXTRA_HOTRELOAD FALSE)
set(MD3_HAS_EXTRA_PERFORMANCE FALSE)
set(MD3_HAS_EXTRA_MATHSYMBOLS FALSE)
set(MD3_HAS_EXTRA_MARKDOWN FALSE)
set(MD3_HAS_EXTRA_NODEGRAPH FALSE)
set(MD3_HAS_EXTRA_GANTT FALSE)

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/Charts/CMakeLists.txt")
    add_subdirectory(src/Extras/Charts)
    set(MD3_HAS_EXTRA_CHARTS TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/DataGrid/CMakeLists.txt")
    add_subdirectory(src/Extras/DataGrid)
    set(MD3_HAS_EXTRA_DATAGRID TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/HotReload/CMakeLists.txt")
    add_subdirectory(src/Extras/HotReload)
    set(MD3_HAS_EXTRA_HOTRELOAD TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/Performance/CMakeLists.txt")
    if(MD3_HAS_EXTRA_CHARTS)
        add_subdirectory(src/Extras/Performance)
        set(MD3_HAS_EXTRA_PERFORMANCE TRUE)
    else()
        message(WARNING "Performance extra found, but Charts extra is missing. Performance is disabled.")
    endif()
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/MathSymbols/CMakeLists.txt")
    add_subdirectory(src/Extras/MathSymbols)
    set(MD3_HAS_EXTRA_MATHSYMBOLS TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/Markdown/CMakeLists.txt")
    add_subdirectory(src/Extras/Markdown)
    set(MD3_HAS_EXTRA_MARKDOWN TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/NodeGraph/CMakeLists.txt")
    add_subdirectory(src/Extras/NodeGraph)
    set(MD3_HAS_EXTRA_NODEGRAPH TRUE)
endif()

if(EXISTS "${CMAKE_SOURCE_DIR}/src/Extras/Gantt/CMakeLists.txt")
    add_subdirectory(src/Extras/Gantt)
    set(MD3_HAS_EXTRA_GANTT TRUE)
endif()

message(STATUS "MD3 extras availability:")
message(STATUS "  Charts      : ${MD3_HAS_EXTRA_CHARTS}")
message(STATUS "  DataGrid    : ${MD3_HAS_EXTRA_DATAGRID}")
message(STATUS "  HotReload   : ${MD3_HAS_EXTRA_HOTRELOAD}")
message(STATUS "  Performance : ${MD3_HAS_EXTRA_PERFORMANCE}")
message(STATUS "  MathSymbols : ${MD3_HAS_EXTRA_MATHSYMBOLS}")
message(STATUS "  Markdown    : ${MD3_HAS_EXTRA_MARKDOWN}")
message(STATUS "  NodeGraph   : ${MD3_HAS_EXTRA_NODEGRAPH}")
message(STATUS "  Gantt       : ${MD3_HAS_EXTRA_GANTT}")

add_subdirectory(src/App)
