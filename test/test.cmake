
string(RANDOM _TEST_RAND)
set(TEST ${CMAKE_ARGV3})
set(TEST_DIR ${CMAKE_CURRENT_LIST_DIR})
set(TMP_DIR ${CMAKE_ARGV4}-${_TEST_RAND})
file(MAKE_DIRECTORY ${TMP_DIR})

include(${CMAKE_CURRENT_LIST_DIR}/../share/cmake/cmakeget/CMakeGet.cmake)

include(${TEST})

file(REMOVE_RECURSE ${TMP_DIR})
