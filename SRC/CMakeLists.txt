SET(ALLAUX superlu_timer.c util.c memory.c get_perm_c.c mmd.c 
	  sp_coletree.c sp_preorder.c sp_ienv.c relax_snode.c 
	  heap_relax_snode.c colamd.c 
	  ilu_relax_snode.c ilu_heap_relax_snode.c mark_relax.c 
	  mc64ad.c qselect.c lsame.c xerbla.c)
	  
SET(sLUSRC sgssv.c sgssvx.c 
	ssp_blas2.c ssp_blas3.c sgscon.c  
	slangs.c sgsequ.c slaqgs.c spivotgrowth.c 
	sgsrfs.c sgstrf.c sgstrs.c scopy_to_ucol.c 
	ssnode_dfs.c ssnode_bmod.c 
	spanel_dfs.c spanel_bmod.c 
	sreadhb.c sreadrb.c sreadtriple.c 
	scolumn_dfs.c scolumn_bmod.c spivotL.c spruneL.c 
	smemory.c sutil.c smyblas2.c 
	sgsisx.c sgsitrf.c sldperm.c 
	ilu_sdrop_row.c ilu_ssnode_dfs.c 
	ilu_scolumn_dfs.c ilu_spanel_dfs.c ilu_scopy_to_ucol.c 
	ilu_spivotL.c sdiagonal.c
	slacon.c slamch.c)

SET(dLUSRC dgssv.c dgssvx.c 
	dsp_blas2.c dsp_blas3.c dgscon.c 
	dlangs.c dgsequ.c dlaqgs.c dpivotgrowth.c  
	dgsrfs.c dgstrf.c dgstrs.c dcopy_to_ucol.c 
	dsnode_dfs.c dsnode_bmod.c dpanel_dfs.c dpanel_bmod.c 
	dreadhb.c dreadrb.c dreadtriple.c 
	dcolumn_dfs.c dcolumn_bmod.c dpivotL.c dpruneL.c 
	dmemory.c dutil.c dmyblas2.c 
	dgsisx.c dgsitrf.c dldperm.c 
	ilu_ddrop_row.c ilu_dsnode_dfs.c 
	ilu_dcolumn_dfs.c ilu_dpanel_dfs.c ilu_dcopy_to_ucol.c 
	ilu_dpivotL.c ddiagonal.c
	dlacon.c dlamch.c)
        ## dgstrsL.c dgstrsU.c

SET(cLUSRC scomplex.c cgssv.c cgssvx.c csp_blas2.c csp_blas3.c cgscon.c 
	clangs.c cgsequ.c claqgs.c cpivotgrowth.c  
	cgsrfs.c cgstrf.c cgstrs.c ccopy_to_ucol.c 
	csnode_dfs.c csnode_bmod.c 
	cpanel_dfs.c cpanel_bmod.c 
	creadhb.c creadrb.c creadtriple.c 
	ccolumn_dfs.c ccolumn_bmod.c cpivotL.c cpruneL.c 
	cmemory.c cutil.c cmyblas2.c 
	cgsisx.c cgsitrf.c cldperm.c 
	ilu_cdrop_row.c ilu_csnode_dfs.c 
	ilu_ccolumn_dfs.c ilu_cpanel_dfs.c ilu_ccopy_to_ucol.c 
	ilu_cpivotL.c cdiagonal.c
	clacon.c scsum1.c icmax1.c
)

SET(zLUSRC dcomplex.c zgssv.c zgssvx.c zsp_blas2.c zsp_blas3.c zgscon.c 
	zlangs.c zgsequ.c zlaqgs.c zpivotgrowth.c  
	zgsrfs.c zgstrf.c zgstrs.c zcopy_to_ucol.c 
	zsnode_dfs.c zsnode_bmod.c 
	zpanel_dfs.c zpanel_bmod.c 
	zreadhb.c zreadrb.c zreadtriple.c 
	zcolumn_dfs.c zcolumn_bmod.c zpivotL.c zpruneL.c 
	zmemory.c zutil.c zmyblas2.c 
	zgsisx.c zgsitrf.c zldperm.c 
	ilu_zdrop_row.c ilu_zsnode_dfs.c 
	ilu_zcolumn_dfs.c ilu_zpanel_dfs.c ilu_zcopy_to_ucol.c 
	ilu_zpivotL.c zdiagonal.c
	zlacon.c dzsum1.c izmax1.c
)

set_source_files_properties(superlu_timer.c dlamch.c slamch.c
    PROPERTIES COMPILE_FLAGS -O0)

add_library(superlu_common OBJECT ${ALLAUX})
SET(OBJS "$<TARGET_OBJECTS:superlu_common>")
foreach(prec s d c z)
    if(BUILD_PRECISION MATCHES [${prec}])
        message(STATUS "Building precision '${prec}'")
        add_library(${prec}superlu OBJECT ${${prec}LUSRC} ../FORTRAN/c_fortran_${prec}gssv.c )
        target_compile_definitions(${prec}superlu PUBLIC USE_VENDOR_BLAS)
        target_include_directories(${prec}superlu PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
        LIST(APPEND OBJS "$<TARGET_OBJECTS:${prec}superlu>")
    endif()
endforeach()

add_library(superlu ${OBJS})
target_compile_definitions(superlu PRIVATE USE_VENDOR_BLAS)
target_link_libraries(superlu PUBLIC blas)
if (UNIX)
    target_link_libraries(superlu PRIVATE m)
endif()
target_include_directories(superlu PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
set_target_properties(superlu PROPERTIES
    OUTPUT_NAME superlu-${SUPERLU_VERSION})

install(TARGETS superlu EXPORT superlu-config
    DESTINATION lib
    INCLUDES DESTINATION include/superlu)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ DESTINATION include/superlu
    FILES_MATCHING PATTERN "*.h")    
install(EXPORT superlu-config DESTINATION ${PACKAGE_CONFIG_DIR})
include(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(${CMAKE_CURRENT_BINARY_DIR}/superlu-config-version.cmake
    COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/superlu-config-version.cmake
    DESTINATION ${PACKAGE_CONFIG_DIR})