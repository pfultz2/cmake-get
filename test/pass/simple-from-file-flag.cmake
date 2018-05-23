
set(_cmake_get_configure_reqs On)
file(WRITE ${TMP_DIR}/reqs1.txt "
${TEST_DIR}/basicapp
")
file(WRITE ${TMP_DIR}/reqs2.txt "
-f ${TMP_DIR}/reqs1.txt
")
cmake_get_from(${TMP_DIR}/reqs2.txt PREFIX ${TMP_DIR}/build)
test_expect_install_count(2)
cmake_get(simple,${TEST_DIR}/libsimple PREFIX ${TMP_DIR}/build)
test_expect_install_count(2)
