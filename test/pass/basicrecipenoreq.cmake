
set(_cmake_get_configure_reqs On)
cmake_get(${TEST_DIR}/basicrecipes PREFIX ${TMP_DIR} CMAKE_ARGS -DCGET_TEST_DIR=${TEST_DIR})
test_expect_install_count(1)
cmake_get(basicappnoreq PREFIX ${TMP_DIR})
test_expect_install_count(3)
