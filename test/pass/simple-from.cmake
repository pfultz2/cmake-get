
set(_cmake_get_configure_reqs On)
file(WRITE ${TMP_DIR}/reqs.txt "
${TEST_DIR}/basicapp
")
cmake_get_from(${TMP_DIR}/reqs.txt PREFIX ${TMP_DIR}/build)
test_expect_install_count(2)
cmake_get(simple,${TEST_DIR}/libsimple PREFIX ${TMP_DIR}/build)
test_expect_install_count(2)
