
set(_cmake_get_configure_reqs On)
cmake_get(simple,${TEST_DIR}/simpleinclude PREFIX ${TMP_DIR} CMAKE_FILE binary)
test_expect_install_count(1)
cmake_get(${TEST_DIR}/basicapp PREFIX ${TMP_DIR})
test_expect_install_count(2)
