FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
	file://system-bsp.dtsi \
	file://zynqmp-openamp.dtsi \
"

do_configure:append () {
	if [ -e ${WORKDIR}/system-bsp.dtsi ]; then
		cp ${WORKDIR}/system-bsp.dtsi ${DT_FILES_PATH}/system-bsp.dtsi
		echo '#include "system-bsp.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
	fi
}

