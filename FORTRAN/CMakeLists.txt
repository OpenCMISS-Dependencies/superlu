macro(ADDTEST name exec arg matfile)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${exec}>
            -DARGS:STRING=${arg}
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/../EXAMPLE/${matfile}
            -P ${SUPERLU_SOURCE_DIR}/testhelper.cmake)
endmacro()
SET(src-F )
if(BUILD_PRECISION MATCHES [d])
    add_library(f77main_c c_fortran_dgssv.c)
    target_link_libraries(f77main_c PRIVATE superlu)
    add_executable(f77_main f77_main.f hbcode1.f)
    target_link_libraries(f77_main PRIVATE f77main_c superlu)
    ADDTEST(f77_main f77_main -h g20.rua)
endif()
if(BUILD_PRECISION MATCHES [z])
    add_library(z_f77_main_c c_fortran_zgssv.c)
    target_link_libraries(z_f77_main_c PRIVATE superlu)
    add_executable(z_f77_main z_f77_main.f zhbcode1.f)
    target_link_libraries(z_f77_main PRIVATE z_f77_main_c superlu)
    ADDTEST(f77_main_z z_f77_main -h cg20.rua)
endif()