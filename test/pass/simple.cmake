
set(_cmake_get_configure_reqs On)
cmake_get(${TEST_DIR}/basicapp PREFIX ${TMP_DIR})
test_expect_install_count(2)
cmake_get(simple,${TEST_DIR}/libsimple PREFIX ${TMP_DIR})
test_expect_install_count(2)
