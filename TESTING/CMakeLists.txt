# local tmg-lib (the one from LAPACK doesnt work, as to expect :-(
SET(TMG_SRC MATGEN/d_lg10.c MATGEN/d_sign.c MATGEN/r_lg10.c
    MATGEN/r_sign.c MATGEN/lsamen.c MATGEN/pow_dd.c)
foreach(prec s d c z)
    if(BUILD_PRECISION MATCHES [${prec}])
        file(GLOB tmg_src MATGEN/${prec}*.c)
        list(APPEND TMG_SRC ${tmg_src})
    endif()
endforeach()
list(REMOVE_DUPLICATES TMG_SRC)
add_library(tmglib_local ${TMG_SRC})
target_link_libraries(tmglib_local PUBLIC blas lapack superlu)
target_compile_options(tmglib_local PRIVATE -std=c99)

macro(ADDTESTM name exec matfile args)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${exec}>
            -DARGS:STRING="${args}"
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/../EXAMPLE/${matfile}
            -P ${SUPERLU_SOURCE_DIR}/testhelper.cmake)
endmacro()
macro(ADDTEST name exec args)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${exec}>
            -DARGS="${args}"
            -P ${SUPERLU_SOURCE_DIR}/testhelper.cmake)
endmacro()

foreach(prec s d c z)
    if(BUILD_PRECISION MATCHES [${prec}])
        file(GLOB src ${prec}*.c)
        add_executable(${prec}test ${src} sp_ienv.c sp_${prec}convert.c)
        target_link_libraries(${prec}test PRIVATE superlu tmglib_local)
        ADDTEST(${prec}testM1 ${prec}test "-t LA -l 0 -n 9 -s 5")
        ADDTEST(${prec}testM2 ${prec}test "-t LA -l 0 -n 19 -s 5")
        ADDTEST(${prec}testM3 ${prec}test "-t LA -l 10000000 -n 9 -s 5")
        ADDTEST(${prec}testM4 ${prec}test "-t LA -l 10000000 -n 19 -s 5")
        ADDTESTM(${prec}testLA1 ${prec}test g20.rua "-t SP -l 0 -s 5")
        ADDTESTM(${prec}testLA2 ${prec}test g20.rua "-t SP -l 10000000 -s 5")
    endif()
endforeach()