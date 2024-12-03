cmake_minimum_required(VERSION 3.5.1)
project(HelloWorld)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/kanzi-locate.cmake)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_kanzi()
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
endif()

include(kanzi-common)

add_executable(HelloWorld src/helloworld.cpp)

if(ANDROID)
    target_link_libraries(HelloWorld -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(HelloWorld Kanzi::kzappfw)
endif()

target_link_libraries(HelloWorld Kanzi::kzui Kanzi::kzcoreui)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application. 
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads: 
# FontEngine=freetype|itype|none
target_link_font_engine_backends(HelloWorld)

# [CodeBehind libs start]. Do not remove this identifier.
set(HelloWorld_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/HelloWorld")
if(EXISTS "${HelloWorld_codebehind_lib_dir}")
    add_subdirectory("${HelloWorld_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/HelloWorld")
    include_directories(${HelloWorld_codebehind_lib_dir}/include)
    target_link_libraries(HelloWorld HelloWorld_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(HelloWorld PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(HelloWorld PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(HelloWorld)
