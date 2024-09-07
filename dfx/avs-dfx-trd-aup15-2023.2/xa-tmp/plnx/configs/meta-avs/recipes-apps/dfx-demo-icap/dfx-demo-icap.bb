
SUMMARY = "Avnet-Silica DFX Example"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI = "\
	file://dfx-demo.init \
	file://src \
	"

S = "${WORKDIR}/src"

B = "${WORKDIR}/build"

#inherit update-rc.d pkgconfig cmake
inherit pkgconfig cmake

RDEPENDS:${PN} = "bash"

#INITSCRIPT_NAME = "dfx-demo"
#INITSCRIPT_PARAMS = "start 99 3 5 . stop 20 0 1 2 6 ."


do_install() {
	install -d ${D}/${bindir}
	install -m 0644 ${B}/dfx-demo ${D}/${bindir}

#	install -d ${D}${sysconfdir}/init.d
#	install -m 0755 ${WORKDIR}/dfx-demo.init ${D}${sysconfdir}/init.d/dfx-demo.init
}

FILES:${PN} = "/usr/bin/dfx-demo"
#FILES:${PN} += "${sysconfdir}/init.d/dfx-demo.init"
