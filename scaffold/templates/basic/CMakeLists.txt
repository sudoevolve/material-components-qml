cmake_minimum_required(VERSION 3.16)

# Qt Creator may pass a package-manager bootstrap script path that does not exist.
# If missing, clear it before `project()` to avoid configure failure.
if(DEFINED CMAKE_PROJECT_INCLUDE_BEFORE AND NOT EXISTS "${CMAKE_PROJECT_INCLUDE_BEFORE}")
    message(WARNING "Ignoring missing CMAKE_PROJECT_INCLUDE_BEFORE: ${CMAKE_PROJECT_INCLUDE_BEFORE}")
    unset(CMAKE_PROJECT_INCLUDE_BEFORE CACHE)
    unset(CMAKE_PROJECT_INCLUDE_BEFORE)
endif()

project({{PROJECT_ID}} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    # Reduce generated object/dep file path length for MinGW on deep build dirs.
    set(CMAKE_OBJECT_PATH_MAX 128)
endif()

# ── Auto-discover Qt6 ──────────────────────────────────────────────────────
# Qt6_DIR or CMAKE_PREFIX_PATH can be set externally (env/presets/cmake args).
# If neither provides a valid Qt6, search for it automatically.
#
# Search order:
#   1. $ENV{QT6_DIR} / $ENV{CMAKE_PREFIX_PATH}  (environment variables)
#   2. $ENV{QTDIR}  (legacy Qt env var)
#   3. Registry query (Windows only)
#   4. $HOME/Qt/<version>/<platform>   (macOS / Linux)
#   5. C:\Qt\<version>\<platform>       (Windows default)
#   6. D:\Qt\<version>\<platform> ...   (Windows alternative drives)
if(NOT DEFINED Qt6_DIR AND NOT DEFINED CMAKE_PREFIX_PATH)

    # ── Try env vars ─────────────────────────────────────────────────────
    if(DEFINED ENV{CMAKE_PREFIX_PATH})
        set(CMAKE_PREFIX_PATH "$ENV{CMAKE_PREFIX_PATH}" CACHE PATH "" FORCE)
    elseif(DEFINED ENV{QT6_DIR})
        set(CMAKE_PREFIX_PATH "$ENV{QT6_DIR}" CACHE PATH "" FORCE)
    elseif(DEFINED ENV{QTDIR})
        # QTDIR usually points to the version root (e.g. C:\Qt\6.11.0\msvc2022_64)
        set(CMAKE_PREFIX_PATH "$ENV{QTDIR}" CACHE PATH "" FORCE)
    else()

        # ── Platform-specific platform subdirectory name ─────────────────
        if(WIN32)
            # Try msvc2022_64 first, then common alternatives
            set(_qt_platform_names
                "msvc2022_64" "msvc2022_arm64"
                "msvc2019_64" "msvc2019"
                "mingw_64" "mingw"
            )
        elseif(APPLE)
            set(_qt_platform_names "macos" "clang_64")
        else()
            set(_qt_platform_names "gcc_64" "clang_64" "linux_gcc_64")
        endif()

        # ── Search Qt installation roots ─────────────────────────────────
        set(_qt_search_roots "")

        # macOS/Linux: ~/Qt/
        if(DEFINED ENV{HOME})
            list(APPEND _qt_search_roots "$ENV{HOME}/Qt")
        endif()

        # Windows: C:\, D:\, E:\ Qt
        if(WIN32)
            foreach(_drv C D E F G)
                if(EXISTS "${_drv}:/Qt")
                    list(APPEND _qt_search_roots "${_drv}:/Qt")
                endif()
            endforeach()
            # Also check PROGRAMFILES
            if(DEFINED ENV{ProgramFiles})
                list(APPEND _qt_search_roots "$ENV{ProgramFiles}/Qt")
            endif()
        endif()

        # ── Search each root, prefer highest version ────────────────────
        set(_qt_auto_found FALSE)
        foreach(_qt_root ${_qt_search_roots})
            if(NOT EXISTS "${_qt_root}")
                continue()
            endif()
            file(GLOB _qt_versions LIST_DIRECTORIES true "${_qt_root}/*")
            # Sort descending by version so highest is preferred
            list(SORT _qt_versions)
            list(REVERSE _qt_versions)

            foreach(_qt_ver_dir ${_qt_versions})
                if(NOT IS_DIRECTORY "${_qt_ver_dir}")
                    continue()
                endif()
                # Try each platform name under this version
                foreach(_plat ${_qt_platform_names})
                    set(_qt_prefix "${_qt_ver_dir}/${_plat}")
                    if(EXISTS "${_qt_prefix}/lib/cmake/Qt6/Qt6Config.cmake")
                        set(CMAKE_PREFIX_PATH "${_qt_prefix}" CACHE PATH
                            "Auto-discovered Qt6 prefix" FORCE)
                        message(STATUS "Auto-discovered Qt6 at: ${_qt_prefix}")
                        set(_qt_auto_found TRUE)
                        break()
                    endif()
                endforeach()
                if(_qt_auto_found)
                    break()
                endif()
            endforeach()
            if(_qt_auto_found)
                break()
            endif()
        endforeach()

        if(NOT _qt_auto_found)
            message(WARNING "Could not auto-discover Qt6. "
                            "Set CMAKE_PREFIX_PATH or Qt6_DIR manually "
                            "(e.g. -DCMAKE_PREFIX_PATH=C:/Qt/6.11.0/msvc2022_64).")
        endif()

        # Clean up
        unset(_qt_auto_found)
        unset(_qt_versions)
        unset(_qt_ver_dir)
        unset(_qt_prefix)
        unset(_qt_platform_names)
        unset(_qt_search_roots)
        unset(_plat)
    endif()
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Gui)
qt_standard_project_setup(REQUIRES 6.8)

set(MD3_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/third_party/md3")

if(NOT EXISTS "${MD3_SOURCE_DIR}/src/Core/CMakeLists.txt")
    message(FATAL_ERROR "Bundled md3 not found at: '${MD3_SOURCE_DIR}'. Recreate the project with scaffold.")
endif()

add_subdirectory("${MD3_SOURCE_DIR}/src/Core" md3Core_build)

# ── Extras: auto-detect every module under src/Extras/ ─────────────────
# The template ships WITHOUT any Extras source folders by default.
# To add a module later, copy its folder into third_party/md3/src/Extras/<Name>/
# and reconfigure — it will be picked up automatically.
set(_MD3_EXTRAS_BASE "${MD3_SOURCE_DIR}/src/Extras")

# Discover all subdirectories that contain a CMakeLists.txt
file(GLOB _MD3_EXTRA_DIRS LIST_DIRECTORIES true "${_MD3_EXTRAS_BASE}/*")

set(MD3_EXTRA_TARGETS "")
set(MD3_EXTRA_DEFINES "")
foreach(_dir ${_MD3_EXTRA_DIRS})
    if(IS_DIRECTORY "${_dir}" AND EXISTS "${_dir}/CMakeLists.txt")
        get_filename_component(_name "${_dir}" NAME)
        string(TOUPPER "${_name}" _upper)
        message(STATUS "  ✓ Extras/${_name} found — building")
        add_subdirectory("${_dir}" md3Extras${_name}_build)
        list(APPEND MD3_EXTRA_TARGETS md3Extras${_name})
        list(APPEND MD3_EXTRA_DEFINES "MD3_HAS_${_upper}=1")
        set(MD3_HAS_EXTRAS ON)
    endif()
endforeach()

file(GLOB_RECURSE APP_QML_FILES 
    CONFIGURE_DEPENDS
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "src/App/*.qml"
)

qt_add_executable({{PROJECT_ID}}App
    MANUAL_FINALIZATION
    src/main.cpp
    src/app_icon.rc
)

qt_add_qml_module({{PROJECT_ID}}App
    URI {{PROJECT_URI}}
    VERSION 1.0
    QML_FILES
        ${APP_QML_FILES}
)

target_compile_definitions({{PROJECT_ID}}App
    PRIVATE
        $<$<BOOL:${MD3_HAS_EXTRAS}>:MD3_HAS_EXTRAS=1>
        ${MD3_EXTRA_DEFINES}
        PROJECT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
)

if(MSVC)
    target_link_libraries({{PROJECT_ID}}App
        PRIVATE
            Qt6::Quick
            md3Core
            ${MD3_EXTRA_TARGETS}
    )

    set(MD3_WHOLEARCHIVE_OPTIONS /WHOLEARCHIVE:md3Core)
    foreach(_target IN LISTS MD3_EXTRA_TARGETS)
        list(APPEND MD3_WHOLEARCHIVE_OPTIONS "/WHOLEARCHIVE:${_target}")
    endforeach()
    target_link_options({{PROJECT_ID}}App PRIVATE ${MD3_WHOLEARCHIVE_OPTIONS})
elseif(MINGW OR (UNIX AND NOT APPLE))
    target_link_libraries({{PROJECT_ID}}App
        PRIVATE
            Qt6::Quick
            -Wl,--whole-archive
            md3Core
            ${MD3_EXTRA_TARGETS}
            -Wl,--no-whole-archive
    )
elseif(APPLE)
    target_link_libraries({{PROJECT_ID}}App
        PRIVATE
            Qt6::Quick
            md3Core
            ${MD3_EXTRA_TARGETS}
    )

    set(MD3_FORCE_LOAD_TARGETS md3Core ${MD3_EXTRA_TARGETS})
    foreach(_target IN LISTS MD3_FORCE_LOAD_TARGETS)
        target_link_options({{PROJECT_ID}}App PRIVATE "LINKER:SHELL:-force_load $<TARGET_FILE:${_target}>")
    endforeach()
else()
    target_link_libraries({{PROJECT_ID}}App
        PRIVATE
            Qt6::Quick
            md3Core
            ${MD3_EXTRA_TARGETS}
    )
endif()

qt_import_qml_plugins({{PROJECT_ID}}App)
qt_finalize_executable({{PROJECT_ID}}App)
