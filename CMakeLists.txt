cmake_minimum_required (VERSION 2.8)

project(cmakeget)

install(DIRECTORY share DESTINATION .)

enable_testing()
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C ${CMAKE_CFG_INTDIR})
add_subdirectory(test)
