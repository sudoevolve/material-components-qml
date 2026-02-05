
find_package(Qt6 REQUIRED COMPONENTS Quick)

# Material Color Utilities
set(MCU_DIR "${CMAKE_CURRENT_SOURCE_DIR}/material-color-utilities")

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

# QML Components
file(GLOB_RECURSE QML_COMPONENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} components/*.qml)

set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# Option to embed resources
option(MD3_EMBED_RESOURCES "Embed resources into the library" ON)

set(MD3_RESOURCES "")
if(MD3_EMBED_RESOURCES)
    set(MD3_RESOURCES
        assets/MaterialIconsRound-Regular.otf
        assets/IconData.js
    )
endif()

qt_add_library(md3 STATIC)

target_sources(md3 PRIVATE 
    stylemanager.cpp 
    stylemanager.h
    ${MCU_SOURCES}
)

target_include_directories(md3 PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${MCU_DIR}>
    $<INSTALL_INTERFACE:include/md3>
)

target_link_libraries(md3 PRIVATE Qt6::Quick)

qt_add_qml_module(md3
    URI md3
    VERSION 1.0
    QML_FILES
        Theme.qml
        ${QML_COMPONENTS}
    RESOURCES
        ${MD3_RESOURCES}
    OUTPUT_TARGETS md3_targets
)

# Create alias for consistent usage
add_library(md3::md3 ALIAS md3)

# Installation
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS md3 md3plugin ${md3_targets}
    EXPORT md3Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES stylemanager.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/md3)

# Export targets
install(EXPORT md3Targets
    FILE md3Targets.cmake
    NAMESPACE md3::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md3
)

# Config file generation
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/md3ConfigVersion.cmake"
    VERSION 1.0
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/md3Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/md3Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md3
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/md3Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/md3ConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md3
)
