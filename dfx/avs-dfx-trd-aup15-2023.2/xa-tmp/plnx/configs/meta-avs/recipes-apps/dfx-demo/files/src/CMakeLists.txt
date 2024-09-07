cmake_minimum_required(VERSION 3.3)

project(dfx-demo C ASM)

set(PROJECT_SOURCES
    main.c
    sysnode.c
    drivers/common/xil_assert.c
    drivers/prc/xprc.c
    drivers/prc/xprc_g.c
    drivers/prc/xprc_sinit.c
    drivers/prc/xprc_selftest.c
)

set(TARGET ${PROJECT_NAME})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/drivers/common)

add_executable(${TARGET} ${PROJECT_SOURCES})

#target_compile_options(${TARGET} PRIVATE -Werror -Wall -Wextra)

