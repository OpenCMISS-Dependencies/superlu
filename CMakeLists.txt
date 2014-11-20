cmake_minimum_required (VERSION 3.0)
project (SUPERLU VERSION 4.3 LANGUAGES C Fortran)

option(BUILD_TESTS "${PROJECT_NAME} - Build tests" ON)
set(BUILD_PRECISION sdcz CACHE STRING "${PROJECT_NAME} - Build precisions (sdcz)")

find_package(BLAS ${BLAS_VERSION} REQUIRED)

add_subdirectory(SRC)

if (BUILD_TESTS)
    enable_testing()
    find_package(LAPACK ${LAPACK_VERSION} REQUIRED)    
    add_subdirectory(TESTING)
    add_subdirectory(EXAMPLE)
    add_subdirectory(FORTRAN)
endif()