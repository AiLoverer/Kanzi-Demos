cmake_minimum_required(VERSION 3.5.1)
project(XML_data_source_start)

if(MSVC)
    option(BUILD_SHARED_LIBS "Selects whether to build and link to shared or static libraries" ON)
endif()

if(NOT KANZI_ENGINE_BUILD)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH
        HINTS "$ENV{KANZI_HOME}/Engine/lib/cmake/Kanzi")
endif()

include(kanzi-common)

set(sources_plugin
    src/data_object_static_list.cpp
    src/data_object_static_list.hpp
    src/xmldatasource.cpp
    src/xmldatasource.hpp
    src/xmldatasource.rc
    src/xmldatasource_module.cpp
    src/xmldatasource_module.hpp
    src/tinyxml2.cpp
    src/tinyxml2.h)

add_library(XML_data_source_start ${sources_plugin})
target_link_libraries(XML_data_source_start PUBLIC Kanzi::kzcoreui Kanzi::kzui)

target_include_directories(XML_data_source_start PUBLIC ${CMAKE_CURRENT_LIST_DIR}/src)

if(BUILD_SHARED_LIBS AND MSVC)
    target_compile_definitions(XML_data_source_start PRIVATE "XML_DATA_SOURCE_API=__declspec(dllexport)")
    target_compile_definitions(XML_data_source_start INTERFACE "XML_DATA_SOURCE_API=__declspec(dllimport)")
    target_compile_definitions(XML_data_source_start PRIVATE "XML_DATA_SOURCE_API_EXPORT")
else()
    target_compile_definitions(XML_data_source_start PUBLIC "XML_DATA_SOURCE_API=")
endif()

# Copy the plugin dll for the Kanzi Studio project.
if(BUILD_SHARED_LIBS AND MSVC)
    set(KANZI_PROJECT_PLUGIN_PATH "${PROJECT_SOURCE_DIR}/../../lib/${PLATFORM_TARGET}/${MSVC_TAG}_$<CONFIG>_DLL")
    add_custom_command(TARGET XML_data_source_start POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${KANZI_PROJECT_PLUGIN_PATH}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "$<TARGET_FILE:XML_data_source_start>" "${KANZI_PROJECT_PLUGIN_PATH}/XML_data_source.dll")
endif()

if(BUILD_SHARED_LIBS AND ANDROID)
    set_target_properties(XML_data_source_start
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/../../lib/android/${CMAKE_BUILD_TYPE}/${ANDROID_ABI}")
endif()

install_target_to_output_directory(XML_data_source_start)
