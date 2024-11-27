cmake_minimum_required(VERSION 3.5.1)
project(Center_stack)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH
        HINTS "../../../../../Engine/lib/cmake/Kanzi")
endif()

include(kanzi-common)

add_executable(Center_stack src/center_stack.cpp)

if(ANDROID)
    target_link_libraries(Center_stack -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(Center_stack Kanzi::kzappfw)
endif()

target_link_libraries(Center_stack Kanzi::kzui Kanzi::kzcoreui)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application.
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads:
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Center_stack)

# [CodeBehind libs start]. Do not remove this identifier.
set(Center_stack_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Center stack")
if(EXISTS "${Center_stack_codebehind_lib_dir}")
    add_subdirectory("${Center_stack_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Center_stack")
    include_directories(${Center_stack_codebehind_lib_dir}/include)
    target_link_libraries(Center_stack Center_stack_CodeBehind)
endif()
# [Resources CodeBehind lib start]. Do not remove or change this identifier.
set(Resources_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Resources/CodeBehind/Resources")
if(EXISTS "${Resources_codebehind_lib_dir}")
    add_subdirectory("${Resources_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Resources")
    include_directories(${Resources_codebehind_lib_dir}/include)
    target_link_libraries(Center_stack Resources_CodeBehind)
endif()
# [Resources CodeBehind lib end]. Do not remove or change this identifier.
# [Stats CodeBehind lib start]. Do not remove or change this identifier.
set(Stats_codebehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Stats/CodeBehind/Stats")
if(EXISTS "${Stats_codebehind_lib_dir}")
    add_subdirectory("${Stats_codebehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Stats")
    include_directories(${Stats_codebehind_lib_dir}/include)
    target_link_libraries(Center_stack Stats_CodeBehind)
endif()
# [Stats CodeBehind lib end]. Do not remove or change this identifier.
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Center_stack PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Center_stack PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Center_stack)
