
file(GLOB TESTS tests/*.cmake)
foreach(TEST ${TESTS})
    add_test(NAME ${TEST} COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/test.cmake ${TEST})
endforeach()
