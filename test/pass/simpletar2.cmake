
set(_cmake_get_configure_reqs On)

function(create_ar DIR TAR_FILE)
    file(GLOB_RECURSE FILES ${DIR}/*)
    cget_exec(COMMAND ${CMAKE_COMMAND} -E tar cfvz "${TMP_DIR}/simple.tar.gz" "${FILES}" WORKING_DIRECTORY "${DIR}")
endfunction()

file(COPY ${TEST_DIR}/libsimple DESTINATION ${TMP_DIR}/simple/)
create_ar(${TMP_DIR}/simple ${TMP_DIR}/simple.tar.gz)
cmake_get(simple,${TMP_DIR}/simple.tar.gz PREFIX ${TMP_DIR}/usr)
test_expect_install_count(1)
