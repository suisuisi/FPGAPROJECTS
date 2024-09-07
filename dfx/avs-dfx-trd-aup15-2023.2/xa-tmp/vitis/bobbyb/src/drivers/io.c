/*=============================================================================
#
#       Purpose: provides general IO routine used in drivers
#
#    Limitation:
#
#          Note:
#
#        Author: Marco Hoefle
#                marco.hoefle@avnet.eu
#                +41 78 790 93 62
#
#============================================================================*/

#include "io.h"

void Io_Out32(uint32_t addr, uint32_t val)
{
	uint32_t *LocalAddr = (uint32_t *)addr;
	*LocalAddr = val;
}

