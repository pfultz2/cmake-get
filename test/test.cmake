

string(RANDOM _TEST_RAND)
set(TEST ${CMAKE_ARGV3})
set(TEST_DIR ${CMAKE_CURRENT_LIST_DIR})
set(TMP_DIR ${CMAKE_ARGV4}-${_TEST_RAND})
file(MAKE_DIRECTORY ${TMP_DIR})

include(${CMAKE_CURRENT_LIST_DIR}/../share/cmake/cmakeget/CMakeGet.cmake)

macro(test_expect_eq X Y)
    if(NOT ${X} EQUAL ${Y})
        message(FATAL_ERROR "EXPECT FAILURE: ${X} != ${Y}")
    endif()
endmacro()

macro(test_expect_install_count X)
    get_property(_tmp_count GLOBAL PROPERTY _cget_install_dir_count)
    if(NOT ${X} EQUAL ${_tmp_count})
        message(FATAL_ERROR "EXPECT FAILURE: install count ${_tmp_count} != ${X}")
    endif()
endmacro()

include(${TEST})

file(REMOVE_RECURSE ${TMP_DIR})
