
cmake_get(${TEST_DIR}/libsimpleflag PREFIX ${TMP_DIR} CMAKE_ARGS -DCGET_FLAG=On)
test_expect_install_count(1)
