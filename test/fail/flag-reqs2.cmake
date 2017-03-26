
file(WRITE ${TMP_DIR}/reqs.txt "
${TEST_DIR}/libsimpleflag -DCGET_EXTRA_FLAG=On
")
cmake_get_from(${TMP_DIR}/reqs.txt PREFIX ${TMP_DIR})
