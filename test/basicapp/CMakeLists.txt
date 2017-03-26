cmake_minimum_required (VERSION 2.8)

include(CTest)

add_executable (basicapp main.cpp)
find_path(SIMPLE_INCLUDE simple.h)
include_directories(${SIMPLE_INCLUDE})
install(TARGETS basicapp DESTINATION bin)

add_executable (basciapptest main.cpp)
target_link_libraries(basciapptest ${BASICAPP_PKGS_LDFLAGS})
if(WIN32)
    add_test(NAME basicapptest WORKING_DIRECTORY ${LIBRARY_OUTPUT_PATH} COMMAND basciapptest${CMAKE_EXECUTABLE_SUFFIX})
else()
    add_test(NAME basicapptest COMMAND basciapptest)
endif()



