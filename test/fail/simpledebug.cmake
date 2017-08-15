
set(_cmake_get_configure_reqs On)
cmake_get(simple,${TEST_DIR}/libsimpledebug PREFIX ${TMP_DIR} CMAKE_ARGS -DCMAKE_BUILD_TYPE=release)
test_expect_install_count(1)
