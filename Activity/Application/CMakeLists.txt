cmake_minimum_required(VERSION 3.5.1)
project(Activity)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/kanzi-locate.cmake)

if(NOT KANZI_ENGINE_BUILD)
    find_kanzi()
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
endif()

include(kanzi-common)

add_executable(Activity
                         # This file is only needed because cmake does not allow an executable without any sources.
                         src/activity.cpp)

target_link_libraries(Activity -Wl,--whole-archive Kanzi::kzdroidfw -Wl,--no-whole-archive)

target_link_libraries(Activity Kanzi::kzui Kanzi::kzcoreui Kanzi::kzjava Kanzi::kzinterop)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application. 
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads: 
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Activity)

# [CodeBehind libs start]. Do not remove this identifier.
set(Activity_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Activity")
if(EXISTS "${Activity_codebehind_lib_dir}")
    add_subdirectory("${Activity_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Activity")
    include_directories(${Activity_codebehind_lib_dir}/include)
    target_link_libraries(Activity Activity_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Activity PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Activity PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Activity)
