
set(_cmake_get_configure_reqs On)

function(create_ar DIR TAR_FILE)
    file(GLOB_RECURSE FILES ${DIR}/*)
    cget_exec(COMMAND ${CMAKE_COMMAND} -E tar cfvz "${TMP_DIR}/simple.tar.gz" "${FILES}" WORKING_DIRECTORY "${DIR}")
endfunction()

create_ar(${TEST_DIR}/libsimple ${TMP_DIR}/simple.tar.gz)
cmake_get(simple,${TMP_DIR}/simple.tar.gz PREFIX ${TMP_DIR}/usr)
test_expect_install_count(1)
