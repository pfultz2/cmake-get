
set(TEST ${CMAKE_ARGV3})
include(${CMAKE_CURRENT_LIST_DIR}/../share/cmake/cmakeget/CMakeGet.cmake)
cget_mktemp_dir(TMP_DIR)
set(TEST_DIR ${CMAKE_CURRENT_LIST_DIR})
include(${TEST})
file(REMOVE_RECURSE ${TMP_DIR})
