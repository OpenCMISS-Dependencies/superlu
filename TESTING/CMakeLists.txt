# local tmg-lib (the one from LAPACK doesnt work, as to expect :-(
file(GLOB tmg_src MATGEN/*.c)
add_library(tmglib_local STATIC ${tmg_src})

file(GLOB stest_src s*.c)
add_executable(stest ${stest_src})
target_link_libraries(stest PRIVATE superlu tmglib_local)

file(GLOB dtest_src d*.c)
add_executable(dtest ${dtest_src} sp_dconvert.c)
target_link_libraries(dtest PRIVATE superlu tmglib_local)

file(GLOB ctest_src c*.c)
add_executable(ctest ${ctest_src} sp_cconvert.c)
target_link_libraries(ctest PRIVATE superlu tmglib_local)

file(GLOB ztest_src z*.c)
add_executable(ztest ${ztest_src} sp_zconvert.c)
target_link_libraries(ztest PRIVATE superlu tmglib_local)