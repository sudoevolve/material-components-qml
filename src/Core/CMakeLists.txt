file(GLOB_RECURSE MD3_CORE_QML_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    Controls/*.qml
    Styles/*.qml
)

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS Controls Styles)

qt_add_library(md3Core STATIC)

target_link_libraries(md3Core PRIVATE Qt6::Quick)
target_include_directories(md3Core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Cpp)

set_source_files_properties(Styles/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

target_sources(md3Core
    PRIVATE
        Cpp/stylemanager.cpp
        Cpp/stylemanager.h
)

qt_add_qml_module(md3Core
    URI md3.Core
    VERSION 1.0
    NO_PLUGIN
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/md3/Core"
    NO_LINT
    QML_FILES
        ${MD3_CORE_QML_FILES}
    RESOURCES
        Styles/assets/MaterialIconsRound-Regular.otf
        Styles/assets/IconData.js
)

set(MCU_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../3rdparty/material-color-utilities")
target_include_directories(md3Core PRIVATE ${MCU_DIR})

file(GLOB_RECURSE MCU_SOURCES
    "${MCU_DIR}/blend/*.cc"
    "${MCU_DIR}/cam/*.cc"
    "${MCU_DIR}/contrast/*.cc"
    "${MCU_DIR}/dislike/*.cc"
    "${MCU_DIR}/dynamiccolor/*.cc"
    "${MCU_DIR}/palettes/*.cc"
    "${MCU_DIR}/quantize/*.cc"
    "${MCU_DIR}/scheme/*.cc"
    "${MCU_DIR}/score/*.cc"
    "${MCU_DIR}/temperature/*.cc"
    "${MCU_DIR}/utils/*.cc"
)

list(FILTER MCU_SOURCES EXCLUDE REGEX "_test\\.cc$")
target_sources(md3Core PRIVATE ${MCU_SOURCES})
