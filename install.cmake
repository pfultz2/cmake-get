#!/usr/bin/env cmake -P

include(CMakeParseArguments)

set(ARGS)
foreach(i RANGE 4 ${CMAKE_ARGC})
    list(APPEND ARGS ${CMAKE_ARGV${i}})
endforeach()

set(options help)
set(oneValueArgs -r)
set(multiValueArgs)

cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGS})

set(FILENAME master.tar.gz)
if(PARSE_-r)
    set(FILENAME ${PARSE_-r}.tar.gz)
endif()

set(_PREFIX ${CMAKE_ARGV3})
get_filename_component(PREFIX ${_PREFIX} ABSOLUTE)
set(URL "https://github.com/pfultz2/cmake-get/archive/${FILENAME}")

string(TIMESTAMP _tmp_dir_STAMP "%H-%M-%S")
string(RANDOM _tmp_dir_RAND)
set(TMP_DIR "${PREFIX}/tmp/cmake-get-install-${_tmp_dir_STAMP}-${_tmp_dir_RAND}")
set(DOWNLOAD_DIR "${TMP_DIR}/download")
set(BUILD_DIR "${TMP_DIR}/build")

function(cget_exec)
    execute_process(${ARGN} RESULT_VARIABLE RESULT)
    if(NOT RESULT EQUAL 0)
        message(FATAL_ERROR "Process failed: ${ARGN}")
    endif()
endfunction()

file(DOWNLOAD ${URL} ${DOWNLOAD_DIR}/${FILENAME})
cget_exec(COMMAND ${CMAKE_COMMAND} -E tar xzf ${DOWNLOAD_DIR}/${FILENAME}
    WORKING_DIRECTORY ${DOWNLOAD_DIR}
)
file(REMOVE ${DOWNLOAD_DIR}/${FILENAME})
file(GLOB FILES LIST_DIRECTORIES true RELATIVE ${DOWNLOAD_DIR} ${DOWNLOAD_DIR}/*)
list(LENGTH FILES NFILES)
if(NFILES GREATER 0)
    list(GET FILES 0 _DIR)
    set(SOURCE_DIR ${DOWNLOAD_DIR}/${_DIR})
else()
    message(FATAL_ERROR "Failed to fetch: ${URL}")
endif()
file(MAKE_DIRECTORY ${BUILD_DIR})
cget_exec(COMMAND ${CMAKE_COMMAND}
    -DCMAKE_INSTALL_PREFIX=${PREFIX}
    ${SOURCE_DIR}
    WORKING_DIRECTORY ${BUILD_DIR}
)
cget_exec(COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR} --target install)

file(REMOVE_RECURSE ${TMP_DIR})
