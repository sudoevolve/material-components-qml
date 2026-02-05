
cmake_minimum_required(VERSION 3.16)

project(md3 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(src)
add_subdirectory(examples)
