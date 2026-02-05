cmake_minimum_required(VERSION 3.16)

project({{PROJECT_NAME}} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(app{{PROJECT_NAME}}
    main.cpp
    stylemanager.cpp
    stylemanager.h
)

target_include_directories(app{{PROJECT_NAME}} PRIVATE charts)

if(WIN32)
    target_sources(app{{PROJECT_NAME}} PRIVATE app_icon.rc)
endif()

# Material Color Utilities
set(MCU_DIR "${CMAKE_CURRENT_SOURCE_DIR}/material-color-utilities")
target_include_directories(app{{PROJECT_NAME}} PRIVATE ${MCU_DIR})

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

target_sources(app{{PROJECT_NAME}} PRIVATE ${MCU_SOURCES})

file(GLOB_RECURSE QML_COMPONENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} components/*.qml)
file(GLOB_RECURSE QML_PAGES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} pages/*.qml)
file(GLOB_RECURSE QML_WIDGETS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} widgets/*.qml)

# Trigger CMake re-configure when new files are added
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS components pages widgets assets)

set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(widgets/DesktopWidgetManager.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(app{{PROJECT_NAME}}
    URI md3
    VERSION 1.0
    QML_FILES
        Main.qml
        Theme.qml
        ${QML_COMPONENTS}
        ${QML_PAGES}
        ${QML_WIDGETS}
    RESOURCES
        assets/MaterialIconsRound-Regular.otf
        assets/IconData.js
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app{{PROJECT_NAME}} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.app{{PROJECT_NAME}}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(app{{PROJECT_NAME}}
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS app{{PROJECT_NAME}}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
