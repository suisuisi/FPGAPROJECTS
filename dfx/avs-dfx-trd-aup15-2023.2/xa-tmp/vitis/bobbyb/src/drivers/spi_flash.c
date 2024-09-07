/*=============================================================================
#
#       Purpose: provides SPI flash driver functions
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

#include <string.h>

#include "spi_flash.h"


enum eFlash_opcodes {
	WREN        = 0x06,  // Write Enable
	WRDI        = 0x04,  // Write Disable
	RDID        = 0x9F,  // Read Identification
	RDSR        = 0x05,  // Read Status Register 1
	RDSR2       = 0x35,  // Read Status Register 2
	WRSR        = 0x01,  // Write Status Register
	READ        = 0x03,  // Read Data Bytes
	FAST_READ   = 0x0B,  // Read Data Bytes at Higher Speed
	FAST_READ4  = 0x0C,  // Fast Read (4-byte address)
	QOR         = 0x6B,  // Quad Output Read
	PP          = 0x02,  // Page Program
	PP4         = 0x12,  // Page Program (4-byte address)
	SSE         = 0x20,  // Sub Sector Erase
	SSE4        = 0x21,  // Sub Sector Erase (4-byte address)
	SE          = 0xD8,  // Sector Erase
	SE4         = 0xDC,  // Sector Erase (4-byte address)
	BE          = 0xC7,  // Bulk Erase
	DP          = 0xB9,  // Deep Power-down
	RES         = 0xAB,  // Read 8-bit Electronic Signature and/or Release from Deep power-down
	RSTEN       = 0x66,  // Reset Enable
	RSTMEM      = 0x99,  // Reset
	WREAR       = 0xC5   // write extended address register. Used to switch between upper and lower 16MB address space
};

#define DUMMY_BYTE 				0xAA

#define WRITE_IN_PROGRESS_MASK		0x01


tFlashType const flash_type[] = {
	{	/*Micron memory (MT25QL256) 256Mbit */
		.man_code = 0x20,
		.mem_type = 0xBA,
		.mem_size = 0x19,
		.name = "MT25QL256",
		.spi_flash_size = 33554432,
		.sector_size = 65536,
		.subsector_size = 4096,
		.page_size = 256,
		.n_sectors = 512,
		.n_subsectors = 8192,
		.n_pages = 131072
	},
	{	/*Micron memory (N25Q128) 128Mbit */
		.man_code = 0x20,
		.mem_type = 0xBA,
		.mem_size = 0x18,
		.name = "N25Q128",
		.spi_flash_size = 16777216,
		.sector_size = 65536,
		.subsector_size = 4096,
		.page_size = 256,
		.n_sectors = 256,
		.n_subsectors = 4096,
		.n_pages = 65536
	},
	{	/*Micron memory (MT25QU02GCBB) 2Gbit */
		.man_code = 0x20,
		.mem_type = 0xBB,
		.mem_size = 0x22,
		.name = "MT25QU02GCBB",
		.spi_flash_size = 268435456,
		.sector_size = 65536,
		.subsector_size = 4096,
		.page_size = 256,
		.n_sectors = 4096,
		.n_subsectors = 4096,
		.n_pages = 1048576
	},
	{	/*Cypress memory (S25FL512S) 512Mbit*/
		.man_code = 0x01,
		.mem_type = 0x02,
		.mem_size = 0x20,
		.name = "S25FL512S",
		.spi_flash_size = 67108864,
		.sector_size = 262144,
		.subsector_size = 0,
		.page_size = 512,
		.n_sectors = 256,
		.n_subsectors = 0,
		.n_pages = 131072
	},
	{	/*Cypress memory (S25FL128S) 128Mbit*/
		.man_code = 0x01,
		.mem_type = 0x20,
		.mem_size = 0x18,
		.name = "S25FL128S",
		.spi_flash_size = 16777216,
		.sector_size = 262144,
		.subsector_size = 0,
		.page_size = 512,
		.n_sectors = 64,
		.n_subsectors = 0,
		.n_pages = 32768
	},
	{	/*ISSI (S25W P512M) 512Mbit*/
		.man_code = 0x9d,
		.mem_type = 0x70,
		.mem_size = 0x1A,
		.name = "IS25LP512M",
		.spi_flash_size = 536870912,
		.sector_size = 262144,
		.subsector_size = 0,
		.page_size = 16,
		.n_sectors = 64,
		.n_subsectors = 0,
		.n_pages = 32768
	}
};

static const int N_REGISTERED_FLASHES = sizeof(flash_type)/sizeof(flash_type)[0];

static tSpiFlashHandle spiFlashHandle[1];


static void wait_loops(uint32_t loops)
{
	volatile uint32_t i = loops;
	while(i--);
}


static void inline spi_flash_write_enable (tSpiFlashHandle *h)
{
	uint8_t op_code = WREN;

	h->spi_select(h->spi_callback);
	h->spi_transfer(h->spi_callback, &op_code, NULL, 1);
	h->spi_unselect(h->spi_callback);
}

static uint8_t spi_flash_status(tSpiFlashHandle *h)
{
	uint8_t status_reg;
	uint8_t op_code = RDSR;

	h->spi_select(h->spi_callback);
	h->spi_transfer(h->spi_callback, &op_code, NULL, 1);
	h->spi_transfer(h->spi_callback, NULL, &status_reg, 1);
	h->spi_unselect(h->spi_callback);

	return status_reg;
}


static inline void poll_until_complete (tSpiFlashHandle *spiFlashHandle)
{
	while((spi_flash_status(spiFlashHandle) & WRITE_IN_PROGRESS_MASK) == WRITE_IN_PROGRESS_MASK) {
		//mdelay(1);
	}
}


void spi_flash_reset(tSpiFlashHandle *h)
{
	uint8_t op_code = RSTEN;

	spi_flash_write_enable(h);

	h->spi_unselect(h->spi_callback);
	wait_loops(10);
	h->spi_select(h->spi_callback);
	wait_loops(10);
	h->spi_unselect(h->spi_callback);
	wait_loops(10);
	h->spi_select(h->spi_callback);
	wait_loops(10);
	h->spi_transfer(h->spi_callback, &op_code, NULL, 1);
	wait_loops(10);
	h->spi_unselect(h->spi_callback);

	op_code = RSTMEM;
	wait_loops(10);
	h->spi_select(h->spi_callback);
	wait_loops(10);
	h->spi_transfer(h->spi_callback, &op_code, NULL, 1);
	wait_loops(10);
	h->spi_unselect(h->spi_callback);
}


int get_spi_flash_info(tSpiFlashHandle *h)
{
	uint8_t send_data[1], recv_data[3];

	send_data[0] = RDID;

	h->spi_select(h->spi_callback);
	h->spi_transfer(h->spi_callback, send_data, NULL, 1);
	h->spi_transfer(h->spi_callback, NULL, recv_data, 3);
	h->spi_unselect(h->spi_callback);

	spiFlashHandle->flash_type = NULL;

	for(uint8_t i=0; i<N_REGISTERED_FLASHES; i++) {
		if (flash_type[i].man_code == recv_data[0] &&
			flash_type[i].mem_type== recv_data[1] &&
			flash_type[i].mem_size == recv_data[2])
		{
			spiFlashHandle->flash_type = &flash_type[i];
			return 0;
		}

	}
	return -1;
}






int spi_flash_read(tSpiFlashHandle *h, uint32_t addr, uint8_t *recv, size_t nbytes)
{
	uint8_t op_code[5];
	size_t n;
	uint32_t page_size = h->flash_type->page_size;
	int ret = 0;

	if(!nbytes)
		return -1;

	if(!h)
		return -1;

	op_code[0] = FAST_READ;
	op_code[1] = (uint8_t) (addr >> 16);
	op_code[2] = (uint8_t) (addr >> 8);
	op_code[3] = (uint8_t) (addr);
	op_code[4] = DUMMY_BYTE;

	h->spi_select(h->spi_callback);

	ret = h->spi_transfer(h->spi_callback, op_code, NULL, sizeof(op_code));
	if(ret) {
		return ret;
	}

	while(nbytes) {
		n = (nbytes > page_size) ? page_size:nbytes;
		ret = h->spi_transfer(h->spi_callback, NULL, recv, n);
		if(ret) {
			return ret;
		}

		recv += n;
		nbytes -= n;
	}

	h->spi_unselect(h->spi_callback);

	return 0;
}




tSpiFlashHandle *get_spiflash_handle(int flash_nr)
{
	return &spiFlashHandle[flash_nr];
}
