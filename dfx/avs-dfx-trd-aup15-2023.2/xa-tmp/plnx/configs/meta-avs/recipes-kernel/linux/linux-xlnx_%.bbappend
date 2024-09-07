FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2024-03-13-09-53-00.cfg \
            file://user_2024-03-13-17-17-00.cfg \
            file://user_2024-03-13-18-15-00.cfg \
            file://user_2024-03-13-18-45-00.cfg \
            file://user_2024-03-13-19-16-00.cfg \
            file://user_2024-03-13-19-34-00.cfg \
            file://user_2024-03-13-20-17-00.cfg \
            file://user_2024-03-13-20-35-00.cfg \
            file://user_2024-03-14-12-44-00.cfg \
            file://user_2024-03-14-13-17-00.cfg \
            file://user_2024-04-01-11-57-00.cfg \
            "

