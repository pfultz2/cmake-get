
cmake_get(${TEST_DIR}/simpleinclude PREFIX ${TMP_DIR} CMAKE_FILE header)
test_expect_install_count(1)
