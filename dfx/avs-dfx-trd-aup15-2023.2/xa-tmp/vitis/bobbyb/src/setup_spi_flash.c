/*=============================================================================
#
#       Purpose: Hooks up spi flash driver and spi driver
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


#include <stdint.h>
#include <stdlib.h>

#include "drivers/spi.h"
#include "drivers/spi_flash.h"





static void spi_flash_device_select(void *callback)
{
	tSpiHandle *h = (tSpiHandle *) callback;
	spi_device_select(h, 0);
}

static void spi_flash_device_unselect(void *callback)
{
	tSpiHandle *h = (tSpiHandle *) callback;
	spi_device_unselect(h);
}


static int spi_flash_transfer(void *callback, uint8_t *tx, uint8_t *rx, size_t n_words)
{
	tSpiHandle *h = (tSpiHandle *) callback;
	spi_transfer(h, tx, rx, n_words);
	return 0;
}


int init_spi_flash(void)
{
	tSpiHandle *spiHandle = init_spi(0);
	tSpiFlashHandle *h = get_spiflash_handle(0);

	h->spi_callback = (void *) spiHandle;
	h->spi_transfer = spi_flash_transfer;
	h->spi_select = spi_flash_device_select;
	h->spi_unselect = spi_flash_device_unselect;

	spi_set_clock_phase(spiHandle);
	spi_flash_reset(h);

	get_spi_flash_info(h);


	if(h->flash_type == NULL)
		return -1;


	return 0;
}
