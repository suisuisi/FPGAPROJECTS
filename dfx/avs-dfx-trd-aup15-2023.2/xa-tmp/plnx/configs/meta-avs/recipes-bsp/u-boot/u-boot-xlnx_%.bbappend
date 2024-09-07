FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://platform-top.h file://bsp.cfg"
SRC_URI += "file://user_2024-03-28-13-01-00.cfg \
            file://user_2024-03-28-13-04-00.cfg \
            "

