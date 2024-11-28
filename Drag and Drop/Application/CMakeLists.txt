cmake_minimum_required(VERSION 3.5.1)
project(Drag_and_drop_start)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH
        HINTS "$ENV{KANZI_HOME}/Engine/lib/cmake/Kanzi")
endif()

include(kanzi-common)

add_executable(Drag_and_drop_start src/drag_and_drop.cpp)

if(ANDROID)
    target_link_libraries(Drag_and_drop_start -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(Drag_and_drop_start Kanzi::kzappfw)
endif()

target_link_libraries(Drag_and_drop_start Kanzi::kzui Kanzi::kzcoreui)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application.
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads:
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Drag_and_drop_start)

# [CodeBehind libs start]. Do not remove this identifier.
set(Drag_and_drop_start_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Drag and drop")
if(EXISTS "${Drag_and_drop_start_codebehind_lib_dir}")
    add_subdirectory("${Drag_and_drop_start_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Drag_and_drop")
    include_directories(${Drag_and_drop_start_codebehind_lib_dir}/include)
    target_link_libraries(Drag_and_drop_start Drag_and_drop_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Drag_and_drop_start PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Drag_and_drop_start PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Drag_and_drop_start)
