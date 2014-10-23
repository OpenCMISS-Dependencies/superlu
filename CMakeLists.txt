cmake_minimum_required (VERSION 3.0)
project (SUPERLU VERSION 4.3 LANGUAGES C Fortran)

if (OPENCMISS_DEPENDENCIES_LIBRARIES)
    SET(CMAKE_PREFIX_PATH ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR} ${CMAKE_PREFIX_PATH})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OPENCMISS_DEPENDENCIES_LIBRARIES})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OPENCMISS_DEPENDENCIES_LIBRARIES})
else()
    SET(CMAKE_PREFIX_PATH ../cmake ${CMAKE_PREFIX_PATH})
    SET(OPENCMISS_DEPENDENCIES_CONFIGS_DIR ${CMAKE_CURRENT_BINARY_DIR})
endif()
set(BUILD_TESTING ON)

find_package(BLAS CONFIG REQUIRED)
#if (BUILD_TESTING)
#    enable_testing()
#    find_package(LAPACK CONFIG REQUIRED)
#    find_package(tmglib CONFIG REQUIRED)
#endif()

FILE(GLOB src SRC/*.c FORTRAN/*.c FORTRAN/*.f)
add_library(superlu STATIC ${src})
target_compile_definitions(superlu PUBLIC USE_VENDOR_BLAS Add_)
target_link_libraries(superlu PUBLIC blas)
target_include_directories(superlu PUBLIC SRC)
set_target_properties(superlu PROPERTIES OUTPUT_NAME superlu-${SUPERLU_VERSION})

export(TARGETS superlu FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/superlu-${SUPERLU_VERSION}/superlu-config.cmake)
include(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/superlu-${SUPERLU_VERSION}/superlu-config-version.cmake
    VERSION ${SUPERLU_VERSION} COMPATIBILITY AnyNewerVersion)
    
add_subdirectory(TESTING)