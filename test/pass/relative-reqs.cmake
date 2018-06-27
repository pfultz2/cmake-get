
set(_cmake_get_configure_reqs On)
cmake_get_from(${TEST_DIR}/relative-reqs.txt PREFIX ${TMP_DIR})
test_expect_install_count(1)
