cmake_minimum_required(VERSION 3.5.1)
project(Rotate_a_3D_model)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/kanzi-locate.cmake)

if(NOT KANZI_ENGINE_BUILD)
    find_kanzi()
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
endif()

include(kanzi-common)

add_executable(Rotate_a_3D_model
                         # This file is only needed because cmake does not allow an executable without any sources.
                         src/rotate_a_3d_model.cpp)

target_link_libraries(Rotate_a_3D_model -Wl,--whole-archive Kanzi::kzdroidfw -Wl,--no-whole-archive)

target_link_libraries(Rotate_a_3D_model Kanzi::kzui Kanzi::kzcoreui Kanzi::kzjava Kanzi::kzinterop)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application. 
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads: 
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Rotate_a_3D_model)

# [CodeBehind libs start]. Do not remove this identifier.
set(Rotate_a_3D_model_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Rotate a 3D model")
if(EXISTS "${Rotate_a_3D_model_codebehind_lib_dir}")
    add_subdirectory("${Rotate_a_3D_model_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Rotate_a_3D_model")
    include_directories(${Rotate_a_3D_model_codebehind_lib_dir}/include)
    target_link_libraries(Rotate_a_3D_model Rotate_a_3D_model_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Rotate_a_3D_model PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Rotate_a_3D_model PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Rotate_a_3D_model)
