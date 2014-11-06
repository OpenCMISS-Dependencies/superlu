macro(ADDTEST name exec arg matfile)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${exec}>
            -DARGS:STRING=${arg}
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/${matfile}
            -P ${SUPERLU_SOURCE_DIR}/testhelper.cmake)
endmacro()
macro(ADDEXEC name)
    foreach(prec s d c z)
        if(BUILD_PRECISION MATCHES [${prec}])
            SET(pextra )
            if (NOT ${extra} STREQUAL "")
                SET(pextra ${prec}${extra}.c)
            endif()
            SET(pname ${prec}${name})
            add_executable(${pname} ${pname}.c ${pextra})
            target_link_libraries(${pname} superlu)
            
            ADDTEST(${pname}r ${pname} -r g20.rua)
            ADDTEST(${pname}h ${pname} -h cg20.cua)
        endif()
    endforeach()
endmacro()
SET(extra "")
ADDEXEC(linsol)
ADDEXEC(linsol1)
ADDEXEC(linsolx)
ADDEXEC(linsolx1)
ADDEXEC(linsolx2)
SET(extra fgmr)
ADDEXEC(itersol)
ADDEXEC(itersol1)

if(BUILD_PRECISION MATCHES [d])
    add_executable(superlu_ex superlu.c sp_ienv.c)
    target_link_libraries(superlu_ex superlu)
    ADDTEST(superlu superlu_ex -h g20.rua)
endif()