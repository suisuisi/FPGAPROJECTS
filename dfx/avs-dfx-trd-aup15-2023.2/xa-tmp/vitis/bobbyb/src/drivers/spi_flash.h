/*=============================================================================
#
#       Purpose: provides SPI flash driver function prototypes and SPI flash
#                Information.
#
#    Limitation:
#
#          Note:
#
#        Author: Marco Höfle
#                marco.hoefle@avnet.eu
#                +41 78 790 93 62
#
#============================================================================*/
#ifndef SRC_DRIVERS_SPI_FLASH_H_
#define SRC_DRIVERS_SPI_FLASH_H_


#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>


typedef struct {
	uint8_t man_code;
	uint8_t mem_type;
	uint8_t mem_size;
	char *name;
	uint32_t spi_flash_size;
	uint32_t sector_size;
	uint32_t subsector_size;
	uint32_t page_size;
	uint32_t n_sectors;
	uint32_t n_subsectors;
	uint32_t n_pages;
} tFlashType;


typedef struct
{
	const tFlashType *flash_type;
	void *sub_sector_buf;
	void *spi_callback;
	int (*spi_transfer)(void *callback, uint8_t *tx, uint8_t *rx, size_t n_words);
	void (*spi_select)(void *callback);
	void (*spi_unselect)(void *callback);
} tSpiFlashHandle;


tSpiFlashHandle *get_spiflash_handle(int flash_nr);


int get_spi_flash_info(tSpiFlashHandle *h);
int spi_flash_read(tSpiFlashHandle *h, uint32_t addr, uint8_t *recv, size_t nbytes);
void spi_flash_reset(tSpiFlashHandle *h);




#endif /* SRC_DRIVERS_SPI_FLASH_H_ */
