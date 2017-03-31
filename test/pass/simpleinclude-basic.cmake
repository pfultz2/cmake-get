
cmake_get(simple,${TEST_DIR}/simpleinclude PREFIX ${TMP_DIR} CMAKE_FILE binary)
test_expect_install_count(1)
