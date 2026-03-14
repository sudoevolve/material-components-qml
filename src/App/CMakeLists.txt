file(GLOB_RECURSE MD3_APP_QML_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    pages/*.qml
    widgets/*.qml
)

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS pages widgets assets)

foreach(_opt IN ITEMS
    MD3_HAS_EXTRA_CHARTS
    MD3_HAS_EXTRA_DATAGRID
    MD3_HAS_EXTRA_HOTRELOAD
    MD3_HAS_EXTRA_PERFORMANCE
    MD3_HAS_EXTRA_MATHSYMBOLS
    MD3_HAS_EXTRA_MARKDOWN
    MD3_HAS_EXTRA_NODEGRAPH
    MD3_HAS_EXTRA_GANTT
)
    if(NOT DEFINED ${_opt})
        set(${_opt} FALSE)
    endif()
endforeach()

function(md3_remove_app_qml relpath)
    string(REPLACE "/" "\\" relpath_win "${relpath}")
    list(REMOVE_ITEM MD3_APP_QML_FILES "${relpath}" "${relpath_win}")
    set(MD3_APP_QML_FILES "${MD3_APP_QML_FILES}" PARENT_SCOPE)
endfunction()

if(NOT MD3_HAS_EXTRA_CHARTS)
    md3_remove_app_qml("pages/extras/ChartsPage.qml")
endif()

if(NOT MD3_HAS_EXTRA_DATAGRID)
    md3_remove_app_qml("pages/extras/DataGridPage.qml")
endif()

if(NOT MD3_HAS_EXTRA_HOTRELOAD)
    md3_remove_app_qml("pages/extras/HotReloadPage.qml")
    md3_remove_app_qml("pages/extras/LivePreview.qml")
endif()

if(NOT MD3_HAS_EXTRA_MATHSYMBOLS)
    md3_remove_app_qml("pages/extras/MathSymbolsPage.qml")
endif()

if(NOT MD3_HAS_EXTRA_MARKDOWN)
    md3_remove_app_qml("pages/extras/MarkdownPage.qml")
endif()

if(NOT MD3_HAS_EXTRA_NODEGRAPH)
    md3_remove_app_qml("pages/extras/NodeGraphPage.qml")
endif()

if(NOT MD3_HAS_EXTRA_GANTT)
    md3_remove_app_qml("pages/extras/GanttPage.qml")
endif()

qt_add_executable(appmd3
    MANUAL_FINALIZATION
    main.cpp
)

target_compile_definitions(appmd3 PRIVATE
    PROJECT_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
    MD3_HAS_EXTRA_CHARTS=$<BOOL:${MD3_HAS_EXTRA_CHARTS}>
    MD3_HAS_EXTRA_DATAGRID=$<BOOL:${MD3_HAS_EXTRA_DATAGRID}>
    MD3_HAS_EXTRA_HOTRELOAD=$<BOOL:${MD3_HAS_EXTRA_HOTRELOAD}>
    MD3_HAS_EXTRA_PERFORMANCE=$<BOOL:${MD3_HAS_EXTRA_PERFORMANCE}>
    MD3_HAS_EXTRA_MATHSYMBOLS=$<BOOL:${MD3_HAS_EXTRA_MATHSYMBOLS}>
    MD3_HAS_EXTRA_MARKDOWN=$<BOOL:${MD3_HAS_EXTRA_MARKDOWN}>
    MD3_HAS_EXTRA_NODEGRAPH=$<BOOL:${MD3_HAS_EXTRA_NODEGRAPH}>
    MD3_HAS_EXTRA_GANTT=$<BOOL:${MD3_HAS_EXTRA_GANTT}>
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

set(MD3_APP_EXTRA_TARGETS)
if(MD3_HAS_EXTRA_CHARTS)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasCharts)
endif()
if(MD3_HAS_EXTRA_DATAGRID)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasDataGrid)
endif()
if(MD3_HAS_EXTRA_HOTRELOAD)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasHotReload)
endif()
if(MD3_HAS_EXTRA_PERFORMANCE)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasPerformance)
endif()
if(MD3_HAS_EXTRA_MATHSYMBOLS)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasMathSymbols)
endif()
if(MD3_HAS_EXTRA_MARKDOWN)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasMarkdown)
endif()
if(MD3_HAS_EXTRA_NODEGRAPH)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasNodeGraph)
endif()
if(MD3_HAS_EXTRA_GANTT)
    list(APPEND MD3_APP_EXTRA_TARGETS md3ExtrasGantt)
endif()

if(MSVC)
    target_link_libraries(appmd3
        PRIVATE
            md3Core
            ${MD3_APP_EXTRA_TARGETS}
    )

    set(MD3_APP_WHOLEARCHIVE_OPTIONS /WHOLEARCHIVE:md3Core)
    foreach(_target IN LISTS MD3_APP_EXTRA_TARGETS)
        list(APPEND MD3_APP_WHOLEARCHIVE_OPTIONS "/WHOLEARCHIVE:${_target}")
    endforeach()
    target_link_options(appmd3 PRIVATE ${MD3_APP_WHOLEARCHIVE_OPTIONS})
elseif(MINGW OR (UNIX AND NOT APPLE))
    target_link_libraries(appmd3
        PRIVATE
            -Wl,--whole-archive
            md3Core
            ${MD3_APP_EXTRA_TARGETS}
            -Wl,--no-whole-archive
    )
else()
    target_link_libraries(appmd3
        PRIVATE
            md3Core
            ${MD3_APP_EXTRA_TARGETS}
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
