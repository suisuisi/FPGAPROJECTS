//https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1399-vitis-hls.pdf


#include <cstdint>
#include <inttypes.h>

#include "version.h"

const char version_string[] = \
	"vivado version: " TOOL_VERSION "\n\r" \
	"built: " BUILT "\n\r" \
	"builder: " BUILDER "\n\r" \
	"git hash: " GIT_HASH "\n\r" \
	"git tag: " GIT_TAG "\n\r" \
	"git branch: " GIT_BRANCH "\n\r" \
;


void avs_version(char *reg0_char, const uint8_t *reg1_index)
{
#pragma HLS INTERFACE mode=s_axilite port=reg0_char
#pragma HLS INTERFACE mode=s_axilite port=reg1_index
#pragma HLS INTERFACE mode=s_axilite port=return


	*reg0_char = version_string[*reg1_index];
}

