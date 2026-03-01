file(GLOB_RECURSE MD3_APP_QML_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    pages/*.qml
    widgets/*.qml
)

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS pages widgets assets)

qt_add_executable(appmd3
    MANUAL_FINALIZATION
    main.cpp
)

target_compile_definitions(appmd3 PRIVATE
    PROJECT_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
)

if(WIN32)
    target_sources(appmd3 PRIVATE app_icon.rc)
endif()

set_source_files_properties(widgets/DesktopWidgetManager.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appmd3
    URI md3.App
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/md3/App"
    NO_LINT
    QML_FILES
        Main.qml
        AppRoot.qml
        ${MD3_APP_QML_FILES}

)

set_target_properties(appmd3 PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmd3
    PRIVATE
        Qt6::Quick
)

if(MSVC)
    target_link_libraries(appmd3
        PRIVATE
            md3Core
    )

    target_link_options(appmd3 PRIVATE
        /WHOLEARCHIVE:md3Core
    )
elseif(MINGW OR (UNIX AND NOT APPLE))
    target_link_libraries(appmd3
        PRIVATE
            -Wl,--whole-archive
            md3Core
            -Wl,--no-whole-archive
    )
else()
    target_link_libraries(appmd3
        PRIVATE
            md3Core
    )
endif()

qt_import_qml_plugins(appmd3)
qt_finalize_executable(appmd3)

include(GNUInstallDirs)
install(TARGETS appmd3
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
