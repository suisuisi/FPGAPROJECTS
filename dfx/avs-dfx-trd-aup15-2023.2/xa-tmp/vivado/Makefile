DIR_PRJ = $(shell pwd)
DIR_BUILD = ${DIR_PRJ}/build
DIR_BUILD_VIVAO = ${DIR_PRJ}/build/prj
DIR_TCL = ${DIR_PRJ}/tcl
DIR_SRC = ${DIR_PRJ}/sources
DIR_IP_GEN = ${DIR_PRJ}/build/ip

VIVADO_ROOT := $(XILINX_VIVADO)
HLS_ROOT := $(XILINX_HLS)

RM = rm -f
RMDIR = rm -rf

VIVADO:=${VIVADO_ROOT}/bin/vivado
VITIS_HLS:=${HLS_ROOT}/bin/vitis_hls


ifndef VIVADO_ROOT
$(error Please source Xilinx Vivado 2023.2 tools first)
endif

.PHONY: all clean

all : create bitstream xsa



# generating HLS cores directly used in Vivado
hls_version_ip_gen:
	mkdir -p ${DIR_IP_GEN}/avs_version
	cd ${DIR_IP_GEN}/avs_version; $(VITIS_HLS) -f ${DIR_SRC}/hls/avs_version/gen_hls_ip.tcl

create:
	@mkdir -p ${DIR_BUILD_VIVAO}
	cd ${DIR_BUILD_VIVAO}; $(VIVADO) -mode batch -nojournal -nolog -notrace -source ${DIR_TCL}/001-create_proj.tcl


bitstream:
	cd ${DIR_BUILD_VIVAO}; $(VIVADO) -mode batch -nojournal -nolog -notrace -source ${DIR_TCL}/002-build-the-bitstream.tcl


xsa:
	cd ${DIR_BUILD_VIVAO}; $(VIVADO) -mode batch -nojournal -nolog -notrace -source ${DIR_TCL}/003-export_xsa.tcl


clean:
	${RMDIR} build
