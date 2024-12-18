cmake_minimum_required(VERSION 3.5.1)

# Locate Kanzi's libraries.
function(find_kanzi)
    set(found_dir "")
    set(found_message "")
    if((DEFINED Kanzi_DIR) AND NOT ("${Kanzi_DIR}" STREQUAL "Kanzi_DIR-NOTFOUND") AND NOT ("${Kanzi_DIR}" STREQUAL ""))
        set(start_dir "${Kanzi_DIR}")
        set(found_message "Using Kanzi from Kanzi_DIR definition")
    elseif((DEFINED KANZI_HOME) AND NOT ("${KANZI_HOME}" STREQUAL ""))
        set(start_dir "${KANZI_HOME}/Engine/lib/cmake/Kanzi/")
        set(found_message "Using Kanzi from KANZI_HOME definition")
    elseif((DEFINED ENV{KANZI_HOME}) AND (NOT $ENV{KANZI_HOME} STREQUAL ""))
        string(CONCAT start_dir $ENV{KANZI_HOME} "/Engine/lib/cmake/Kanzi/")
        set(found_message "Using Kanzi from KANZI_HOME environment variable")
    elseif((1 LESS ${ARGC}) AND NOT ("${ARGV1}" STREQUAL ""))
        get_filename_component(start_dir "${ARGV1}" ABSOLUTE)
        set(found_message "Using Kanzi from parent directory search")
    else()
        get_filename_component(start_dir "." ABSOLUTE)
        set(found_message "Using Kanzi from parent directory search")
    endif()
    # First check if the starting directory exists.
    get_filename_component(curr_dir "${start_dir}" ABSOLUTE)
    if(NOT EXISTS "${curr_dir}")
        # If starting directory does not exist, search upward for a location that does.
        # Do not look indefinitely.
        set(prepend_dir "../")
        foreach(it RANGE 8)
            get_filename_component(curr_dir "${prepend_dir}/${start_dir}" ABSOLUTE)
            if(EXISTS "${curr_dir}")
                break()
            endif()
            set(prepend_dir "../${prepend_dir}")
        endforeach()
    endif()
    # If the current directory is valid, look for valid config files.
    if(EXISTS "${curr_dir}")
        while(NOT "${last_dir}" STREQUAL "${curr_dir}")
            if((EXISTS "${curr_dir}/KanziConfig.cmake") OR (EXISTS "${curr_dir}/kanzi-config.cmake"))
                set(found_dir "${curr_dir}")
                break()
            endif()
            if((EXISTS "${curr_dir}/Engine/lib/cmake/Kanzi/KanziConfig.cmake") OR (EXISTS "${curr_dir}/Engine/lib/cmake/Kanzi/kanzi-config.cmake"))
                set(found_dir "${curr_dir}/Engine/lib/cmake/Kanzi")
                break()
            endif()
            set(last_dir "${curr_dir}")
            # Iterate upwards until topmost directory.
            get_filename_component(curr_dir "${last_dir}/.." ABSOLUTE)
        endwhile()
        if (NOT found_dir STREQUAL "")
            message("-- ${found_message}: '${found_dir}'")
            set(Kanzi_DIR "${found_dir}" CACHE STRING "Location of KanziConfig.cmake")
            set(Kanzi_DIR "${found_dir}" PARENT_SCOPE)
            set(KANZI_ROOT "${Kanzi_DIR}/../../../.." PARENT_SCOPE)
        else()
            message("ERROR: Could not locate Kanzi_DIR.")
        endif()
    else()
        message("ERROR: Could not locate Kanzi_DIR. Input '${start_dir}' is probably invalid.")
    endif()
endfunction()
