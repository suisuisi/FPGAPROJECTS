/*=============================================================================
#
#       Purpose: provides i/o driver function prototypes
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

#ifndef IO_H_
#define IO_H_

#include <stdint.h>

#define Io_In32(InputPtr) (*(volatile uint32_t *)(InputPtr))


void Io_Out32(uint32_t addr, uint32_t val);



#endif /* IO_H_ */
