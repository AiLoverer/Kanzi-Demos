cmake_minimum_required(VERSION 3.5.1)
project(Theming_start)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH
        HINTS "../../../../Engine/lib/cmake/Kanzi")
endif()

include(kanzi-common)

add_executable(Theming_start src/theming.cpp)

if(ANDROID)
    target_link_libraries(Theming_start -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(Theming_start Kanzi::kzappfw)
endif()

target_link_libraries(Theming_start Kanzi::kzui Kanzi::kzcoreui)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application.
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads:
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Theming_start)

# [CodeBehind libs start]. Do not remove this identifier.
set(Theming_start_codeBehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Theming")
if(EXISTS "${Theming_start_codeBehind_lib_dir}")
    add_subdirectory("${Theming_start_codeBehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Theming")
    include_directories(${Theming_start_codeBehind_lib_dir}/include)
    target_link_libraries(Theming_start Theming_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Theming_start PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Theming_start PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Theming_start)
