
include(CMakeParseArguments)

foreach(dir "$ENV{TMP}" "$ENV{TMPDIR}" "${CMAKE_CURRENT_LIST_DIR}/tmp")
    if(EXISTS "${dir}" AND NOT "${dir}" STREQUAL "")
        set(_cget_tmp_dir ${dir})
        break()
    endif()
endforeach()
set(_tmp_dir_count 0)

macro(cget_mktemp_dir OUT)
    string(TIMESTAMP cget_mktemp_dir_STAMP)
    string(RANDOM cget_mktemp_dir_RAND)
    set(cget_mktemp_dir_PREFIX "${_cget_tmp_dir}/cget-${cget_mktemp_dir_STAMP}-${cget_mktemp_dir_RAND}")
    math(EXPR _tmp_dir_count "${_tmp_dir_count} + 1")
    set(${OUT} "${cget_mktemp_dir_PREFIX}-${_tmp_dir_count}")
    file(MAKE_DIRECTORY ${${OUT}})
endmacro()

macro(cget_set_parse_flag VAR OPT)
    foreach(FLAG --build -b)
        if(${VAR}_private_${FLAG})
            set(${VAR}_${OPT} ${${VAR}_private_${FLAG}})
        endif()
    endforeach()
endmacro()

macro(cget_parse_requirement VAR PKG)
    set(${VAR}_PKG ${PKG})
    set(${VAR}_private_options --build -b --test -t)
    set(${VAR}_private_oneValueArgs -D --define -H --hash -X --cmake)
    set(${VAR}_private_multiValueArgs)

    cmake_parse_arguments(${VAR}_private "${${VAR}_private_options}" "${${VAR}_private_oneValueArgs}" "${${VAR}_private_multiValueArgs}" ${ARGN})

    cget_set_parse_flag(${VAR} BUILD --build -b)
    cget_set_parse_flag(${VAR} TEST --test -t)
    cget_set_parse_flag(${VAR} CMAKE --cmake -X)
    cget_set_parse_flag(${VAR} HASH --hash -H)
    cget_set_parse_flag(${VAR} DEFINE --define -D)
endmacro()

function(cget_install_dir DIR)
    set(options)
    set(oneValueArgs PREFIX BUILD_DIR)
    set(multiValueArgs CMAKE_ARGS)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(PREFIX ${PARSE_PREFIX})
    set(BUILD_DIR ${PARSE_BUILD_DIR})
    if(NOT EXISTS ${BUILD_DIR})
        file(MAKE_DIRECTORY ${BUILD_DIR})
    endif()

    execute_process(COMMAND ${CMAKE_COMMAND} 
        -DCMAKE_PREFIX_PATH=${PREFIX} 
        -DCMAKE_INSTALL_PREFIX=${PREFIX}
        ${CMAKE_ARGS}
        ${DIR}
        WORKING_DIRECTORY ${BUILD_DIR}
    )
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR} --target install)

    file(REMOVE_RECURSE ${BUILD_DIR})
endfunction()

function(cget_parse_src_name URL VARIANT SRC)
    if(SRC MATCHES "@")
        string(REPLACE "@" ";" SRC_LIST ${SRC})
        list(GET SRC_LIST 0 _URL)
        list(GET SRC_LIST 1 _VARIANT)
        set(${URL} ${_URL} PARENT_SCOPE)
        set(${VARIANT} ${_VARIANT} PARENT_SCOPE)
    else()
        set(${URL} ${SRC} PARENT_SCOPE)
        set(${VARIANT} ${ARGN} PARENT_SCOPE)
    endif()
endfunction()

function(cget_parse_pkg URL PKG)
    string(REPLACE "," ";" PKG_NAMES ${PKG})
    list(GET PKG_NAMES -1 PKG_SRC)
    if(PKG_SRC MATCHES "://")
        set(${URL} ${PKG_SRC} PARENT_SCOPE)
    else()
        if(EXISTS ${PKG_SRC})
            get_filename_component(PKG_SRC_FULL ${PKG_SRC} ABSOLUTE)
            set(${URL} file://${PKG_SRC_FULL} PARENT_SCOPE)
        else()
            # Parse github url
            cget_parse_src_name(GH_NAME GH_BRANCH ${PKG_SRC} HEAD)
            if(GH_NAME MATCHES "/")
                set(${URL} "https://github.com/${GH_NAME}/archive/${GH_BRANCH}.tar.gz" PARENT_SCOPE)
            else()
                set(${URL} "https://github.com/${GH_NAME}/${GH_NAME}/archive/${GH_BRANCH}.tar.gz" PARENT_SCOPE)
            endif()
        endif()
    endif()
endfunction()

function(cget_fetch DIR DOWNLOAD_DIR URL)
    if(URL MATCHES "file://")
        string(REPLACE "file://" "" LOCAL_DIR ${URL})
        file(COPY ${LOCAL_DIR} DESTINATION ${DOWNLOAD_DIR}/)
    else()
        string(REPLACE "/" ";" PATH_LIST ${URL})
        list(GET PATH_LIST -1 FILENAME)
        message("Downloading ${FILENAME}")
        file(DOWNLOAD ${URL} ${DOWNLOAD_DIR}/${FILENAME} ${ARGN})
        execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${DOWNLOAD_DIR}/${FILENAME}
            WORKING_DIRECTORY ${DOWNLOAD_DIR}
        )
        file(REMOVE ${DOWNLOAD_DIR}/${FILENAME})
    endif()
    file(GLOB FILES LIST_DIRECTORIES true RELATIVE ${DOWNLOAD_DIR} ${DOWNLOAD_DIR}/*)
    list(GET FILES 0 _DIR)
    set(${DIR} ${DOWNLOAD_DIR}/${_DIR} PARENT_SCOPE)
endfunction()

function(cmake_get PKG)
    set(options)
    set(oneValueArgs PREFIX HASH)
    set(multiValueArgs CMAKE_ARGS)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cget_parse_pkg(URL ${PKG})

    cget_mktemp_dir(TMP_DIR)

    if(PREFIX_HASH)
        string(TOUPPER ${PREFIX_HASH} _HASH)
        string(REPLACE ":" "=" _HASH ${_HASH})
        set(HASH EXPECTED_HASH ${_HASH})
    endif()

    cget_fetch(DIR ${TMP_DIR}/download ${URL} ${HASH} SHOW_PROGRESS)
    cget_install_dir(${DIR} BUILD_DIR ${TMP_DIR}/build PREFIX ${PARSE_PREFIX} CMAKE_ARGS ${PARSE_CMAKE_ARGS})

    file(REMOVE_RECURSE ${TMP_DIR})
endfunction()
