cmake_minimum_required(VERSION 3.10)
project(folly_playground_project)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE "Release")

set(DEPS ${CMAKE_CURRENT_BINARY_DIR}/deps)

include(Cmake/FBLibraries.cmake)
BuildFBEnvironment(${DEPS})

find_package(Threads REQUIRED)

add_executable(main main.cpp)
add_dependencies(main fb_folly)

target_include_directories(main PUBLIC ${DEPS}/include/)
target_link_directories(main PUBLIC ${DEPS}/lib/ ${DEPS}/lib64)

target_link_libraries(main
    ${FB_Libraries}
    Threads::Threads
    dl
)