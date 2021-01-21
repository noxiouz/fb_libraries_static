cmake_minimum_required(VERSION 3.10)
project(folly_playground_project)

set(CMAKE_CXX_STANDARD 17)

set(DEPS ${CMAKE_CURRENT_BINARY_DIR}/deps)

include(Cmake/FBLibraries.cmake)
BuildFBEnvironment(ROOT ${DEPS})

find_package(Threads REQUIRED)

add_executable(main main.cpp)
add_dependencies(main FB_wangle)

target_link_libraries(main
    ${FB_folly_LIBRARIES}
    Threads::Threads
    dl
)
