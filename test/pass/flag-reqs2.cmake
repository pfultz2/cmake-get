
file(WRITE ${TMP_DIR}/reqs.txt "
${TEST_DIR}/libsimpleflag --define CGET_FLAG=On --define CGET_EXTRA_FLAG=On
")
cmake_get_from(${TMP_DIR}/reqs.txt PREFIX ${TMP_DIR})
