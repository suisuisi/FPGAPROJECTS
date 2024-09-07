cmake_minimum_required(VERSION 3.3)

project(dfx-demo C ASM)

set(PROJECT_SOURCES
    main.c
    sysnode.c
    drivers/common/xil_assert.c
    drivers/icap/xhwicap_device_read_frame.c
    drivers/icap/xhwicap_device_write_frame.c
    drivers/icap/xhwicap.c
    drivers/icap/xhwicap_srp.c
    drivers/icap/xhwicap_sinit.c
    drivers/icap/xhwicap_selftest.c
    drivers/icap/xhwicap_intr.c
    drivers/icap/xhwicap_g.c
)

set(TARGET ${PROJECT_NAME})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/drivers/common)

add_executable(${TARGET} ${PROJECT_SOURCES})

#target_compile_options(${TARGET} PRIVATE -Werror -Wall -Wextra)

