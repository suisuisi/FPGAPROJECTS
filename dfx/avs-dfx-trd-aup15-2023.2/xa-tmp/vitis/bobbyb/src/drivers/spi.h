/*=============================================================================
#
#       Purpose: provides SPI driver function prototypes and access structures.
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

#ifndef SPI_H_
#define SPI_H_

#include <stdint.h>



typedef struct {
	uint32_t rx_bytes;	/**< Number of rx bytes transferred */
	uint32_t tx_bytes;
} tSpiStats;



typedef struct {
	tSpiStats stats;
	uint32_t baseAddr;
	uint8_t intVecID;
	uint32_t fifoDepth;
	uint8_t *SendBufferPtr;
	uint8_t *RecvBufferPtr;
	size_t RemainingBytes;
} tSpiHandle;




int spi_transfer (tSpiHandle *inst, uint8_t *send, uint8_t *recv, size_t nbytes);
void spi_device_select(tSpiHandle *inst, uint8_t nr);
void spi_device_unselect(tSpiHandle *inst);
void spi_set_clock_phase(tSpiHandle *inst);
tSpiHandle *init_spi(int core_nr);


#endif /* SPI_H_ */
