
qt_add_executable(appmd3
    main.cpp
)

if(WIN32)
    target_sources(appmd3 PRIVATE app_icon.rc)
endif()

# Find QML files in examples
file(GLOB_RECURSE QML_PAGES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} pages/*.qml)
file(GLOB_RECURSE QML_WIDGETS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} widgets/*.qml)

set_source_files_properties(widgets/DesktopWidgetManager.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appmd3
    URI appmd3
    VERSION 1.0
    QML_FILES
        Main.qml
        ${QML_PAGES}
        ${QML_WIDGETS}
)

# Link against md3 AND its plugin target (required for static builds)
target_link_libraries(appmd3 PRIVATE md3 md3plugin Qt6::Quick)
