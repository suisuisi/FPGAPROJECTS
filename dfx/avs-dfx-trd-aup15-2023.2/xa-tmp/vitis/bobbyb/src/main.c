/*=============================================================================
#
#       Purpose: Hooks up spi flash driver and spi driver
#
#    Limitation:
#
#          Note: The flash parameters for the AU15P board are not correct.
#                Also the page size of 256 doesn't work -> Maybe SPI driver
#                problem,
#
#        Author: Marco Hoefle
#                marco.hoefle@avnet.eu
#                +41 78 790 93 62
#
#============================================================================*/


#include <stdio.h>
#include <string.h>

#include <xil_cache.h>
#include "setup_spi_flash.h"

#include "drivers/spi.h"
#include "drivers/spi_flash.h"

#define C_CHUNK_SIZE 4096

#define C_U_BOOT
//#define C_VERIFY
#define CACHE


#ifdef C_U_BOOT
#define C_FLASH_START 0x000000600000
#define C_IMAGE_LEN 0x100000
#define C_RAM_START 0x80100000
#else
#define C_FLASH_START 0x6100000
#define C_IMAGE_LEN 0x700000
#define C_RAM_START 0x80000000
#endif


#define C_CRC
#ifdef C_CRC
#define CRC_
#include "lib/crc.h"
#include "lib/utils.h"
#endif


#define GO(addr) { ((void(*)(void))(addr))(); }



static void error_loop(void)
{
	while(1);
}


int main(void)
{
	uint32_t flash_addr = C_FLASH_START;
	uint32_t len = C_IMAGE_LEN;
	uint8_t *ram_ptr = (uint8_t *) C_RAM_START;
	uint32_t n = 0, n_chunks = 0;
	int ret;
	tSpiFlashHandle *flash;

	#ifdef CACHE
		Xil_ICacheEnable();
		Xil_DCacheEnable();
	#else
		Xil_ICacheDisable();
		Xil_DCacheDisable();
	#endif

	print("\n\rBobby's Bootloader\n\r");
	print("built: ");
	print(__DATE__ ", " __TIME__);
	print("\n\r");

	ret = init_spi_flash();
	if(ret) {
		print("Flash init error!");
		error_loop();
	}
	flash = get_spiflash_handle(0);

	char *flash_name = flash->flash_type->name;
	print("Found flash: ");
	print(flash_name);
	print("\n\r");

	while(len) {
		n = (len > C_CHUNK_SIZE) ? C_CHUNK_SIZE:len;
		ret = spi_flash_read(flash, flash_addr, ram_ptr, n);
		len -= n;
		flash_addr += n;
		ram_ptr += n;

		print(".");
		if((++n_chunks % 80) == 0)
			print("\n\r");
	}

	//#ifdef C_VERIFY
	//	print("\n\rVerifying\n\r");
	//	len = C_IMAGE_LEN;
	//	flash_addr = C_FLASH_START;
	//	ram_ptr = (uint8_t *) ram_addr;
	//	while(len) {
	//		uint8_t buf[256];
	//		n = (len > sizeof(buf)) ? sizeof(buf):len;
	//		ret = spi_flash_read(flash, flash_addr, buf, n);
	//
	//		for(int i=0; i<n; i++) {
	//			if(buf[i] != ram_ptr[i]) {
	//				print("Verification error!\n\r");
	//				xil_printf("flash addr: %d\n\r", flash_addr);
	//				return -1;
	//			}
	//		}
	//
	//		len -= n;
	//		flash_addr += n;
	//		ram_ptr += n;
	//	}
	//#endif
	//
	//
	//#ifdef C_CRC
	//	uint16_t crc = 0;
	//	const char *string_crc = NULL;
	//	ram_ptr = (uint8_t *) ram_addr;
	//	crc = crc16_update(ram_ptr, C_IMAGE_LEN, crc);
	//	string_crc = utostr( crc, 16);
	//	print("\n\rcrc: ");
	//	print(string_crc);
	//	print("\n\r");
	//#endif

	print("\n\r");
	print("starting u-boot...\n\r");
	GO(C_RAM_START);

	while(1);
}

