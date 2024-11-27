cmake_minimum_required(VERSION 3.5.1)
project(Data_trigger_start)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH
        HINTS "../../../../Engine/lib/cmake")
endif()

include(kanzi-common)

add_executable(Data_trigger_start src/data_trigger.cpp)

if(ANDROID)
    target_link_libraries(Data_trigger_start -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(Data_trigger_start Kanzi::kzappfw)
endif()

target_link_libraries(Data_trigger_start Kanzi::kzui Kanzi::kzcoreui)

# KANZI_LINK_FREETYPE and KANZI_LINK_ITYPE options determine which font backends are explicitly linked to your application.
# By default including Kanzi config sets the following:
#  - KANZI_LINK_FREETYPE=ON in static build.
#  - Both OFF in dynamic build.
#
# In case you are working with dynamic libraries, Kanzi engine can load available font engine backend at runtime.
# Use FontEngine application configuration to choose which font engine backend Kanzi loads:
# FontEngine=freetype|itype|none
target_link_font_engine_backends(Data_trigger_start)

# [CodeBehind libs start]. Do not remove this identifier.
set(CodeBehind_lib_dir "${CMAKE_CURRENT_SOURCE_DIR}/../Tool_project/CodeBehind/Data trigger")
if(EXISTS "${CodeBehind_lib_dir}")
    add_subdirectory("${CodeBehind_lib_dir}" "${CMAKE_CURRENT_BINARY_DIR}/CodeBehind/Data_trigger")
    include_directories(${CodeBehind_lib_dir}/include)
    target_link_libraries(Data_trigger_start Data_trigger_CodeBehind)
endif()
# [CodeBehind libs end]. Do not remove this identifier.

set_target_properties(Data_trigger_start PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(Data_trigger_start PROPERTIES VS_DEBUGGER_ENVIRONMENT "${KANZI_VS_DEBUGGER_ENVIRONMENT}")

install_kanzi_libs_to_output_directory()
install_kzbs_to_output_directory(${CMAKE_SOURCE_DIR}/bin)
install_target_to_output_directory(Data_trigger_start)
