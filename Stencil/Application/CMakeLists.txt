cmake_minimum_required(VERSION 3.5.1)
project(Stencil_start)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/kanzi-locate.cmake)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_kanzi()
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
endif()

include(kanzi-common)

add_executable(Stencil_start src/stencil.cpp)

if(ANDROID)
    target_link_libraries(Stencil_start -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)

    add_library(XML_data_source SHARED IMPORTED)
    set_target_properties(XML_data_source PROPERTIES IMPORTED_LOCATION
        "${KANZI_ROOT}/Tutorials/Data sources/Completed/Application/lib/android/${CMAKE_BUILD_TYPE}/${ANDROID_ABI}/libXML_data_source.so")
    target_link_libraries(Stencil_start XML_data_source)
else()
    target_link_libraries(Stencil_start Kanzi::kzappfw)
endif()

target_link_libraries(Stencil_start Kanzi::kzui Kanzi::kzcoreui)
if(NOT BUILD_SHARED_LIBS)
    add_subdirectory("../../../Data sources/Completed/Application/src/plugin" xml_data_source)
    target_link_libraries(Stencil_start XML_data_source)
endif()

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application.
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads:
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Stencil_start)

# [CodeBehind libs start]. Do not remove this identifier.
set(Stencil_start_codeBehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Stencil")
if(EXISTS "${Stencil_start_codeBehind_lib_dir}")
    add_subdirectory("${Stencil_start_codeBehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Stencil")
    include_directories(${Stencil_start_codeBehind_lib_dir}/include)
    target_link_libraries(Stencil_start Stencil_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Stencil_start PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Stencil_start PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Stencil_start)
