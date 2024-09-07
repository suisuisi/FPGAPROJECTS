

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <inttypes.h>

#include <stdarg.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <sys/mman.h>

#include "sysnode.h"

#include "drivers/icap/xhwicap.h"

#define ARRAYSIZE(arr) (sizeof(arr) / sizeof(arr[0]))


typedef struct bitstream {
	char *filepath;
	size_t filesize;
	uint8_t *ram_ptr;
} t_bitstream;

t_bitstream arr_bitstream[] = {
		{ .filepath = "/usr/share/avs/bitstreams/up.bin" },
		{ .filepath = "/usr/share/avs/bitstreams/down.bin" },
		{ .filepath = "/usr/share/avs/bitstreams/left.bin" },
		{ .filepath = "/usr/share/avs/bitstreams/right.bin" },

};

void exit_on_error(const char *format, ...)
{
	char* string;
	va_list args;

	va_start(args, format);
	if(0 > vasprintf(&string, format, args)) string = NULL;

	va_end(args);

	if(string)
		printf("%s\n", string);

	exit(1);
}


void show_buffer(void)
{
	int fd_udmabuf;
	void *udmabuf0 = NULL;
	uint32_t *read_back_ptr;

	size_t udmabuf0_size = (size_t) read_sysnode("/sys/class/u-dma-buf/udmabuf0/", "size", eDec);

	if ((fd_udmabuf = open("/dev/udmabuf0", O_RDWR)) != -1) {
		udmabuf0 = mmap(NULL, udmabuf0_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd_udmabuf, 0);
	}

	read_back_ptr = (uint32_t *) udmabuf0;
	for(uint8_t i=0; i<16; i++)
	{
		printf("%d: 0x%" PRIx32 "\n", i, *read_back_ptr++);
	}

	close(fd_udmabuf);
	munmap(udmabuf0, udmabuf0_size);
}


void load_bitsteams(void)
{
	int fd_udmabuf;
	void *udmabuf0 = NULL;
	FILE *fp;
	size_t ret;
	uint8_t *ramptr;

	size_t udmabuf0_size = (size_t) read_sysnode("/sys/class/u-dma-buf/udmabuf0/", "size", eDec);

	if ((fd_udmabuf = open("/dev/udmabuf0", O_RDWR)) != -1) {
		udmabuf0 = mmap(NULL, udmabuf0_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd_udmabuf, 0);
	} else {
		exit_on_error("Could not open /dev/udmabuf0\n");
	}

	ramptr = (uint8_t *) udmabuf0;
	for(int i=0; i<4; i++) {
		fp = fopen(arr_bitstream[i].filepath, "rb");

		if (!fp)
		{
			exit_on_error("unable to open %s\n", arr_bitstream[i].filepath);
		}
		fseek(fp, 0, SEEK_END);
		arr_bitstream[i].filesize = ftell(fp);
		rewind(fp);

		ret = fread(ramptr, 1, udmabuf0_size, fp);
		if(ret != arr_bitstream[i].filesize) {
			exit_on_error("unable to copy %s to buffer\n", arr_bitstream[i].filepath);
		}
		arr_bitstream[i].ram_ptr = ramptr;
		ramptr += arr_bitstream[i].filesize;

		printf("copied %s to buffer @ %p (%d bytes)\n", arr_bitstream[i].filepath, arr_bitstream[i].ram_ptr, arr_bitstream[i].filesize);
	}
}

void initIcap(const char *uio_path)
{
	int fd_uio;
	int Status;
	u32 DeviceIdCode;

	XHwIcap Icap;
	XHwIcap_Config Icap_Conf;
	t_bitstream *bitstream;

	if ((fd_uio = open(uio_path, O_RDWR)) != -1) {
		Icap_Conf.BaseAddress = (UINTPTR) mmap(NULL, 0x10000, PROT_READ | PROT_WRITE, MAP_SHARED, fd_uio, 0);
	} else {
		exit_on_error("Could not open %s\n", uio_path);
	}

	Icap_Conf.DeviceId = 0;
	Icap_Conf.IcapWidth = 32;
	Icap_Conf.IsLiteMode = 0;

	Status = XHwIcap_CfgInitialize(&Icap, &Icap_Conf, Icap_Conf.BaseAddress);
	if(Status == XST_FAILURE) {
		exit_on_error("Could not initialize Icap\n");
	}

	XHwIcap_GetConfigReg(&Icap, XHI_IDCODE, &DeviceIdCode);
	if(Status == XST_FAILURE) {
		exit_on_error("Could not initialize Icap\n");
	}
	printf("DeviceIdCode: 0x%08x\n\r", DeviceIdCode);

	while(1) {
		for(int i=0; i<ARRAYSIZE(arr_bitstream); i++) {
			sleep(5);
			bitstream = &arr_bitstream[i];
			printf("pushing partial bitstream #%d: %s\n", i, bitstream->filepath);
			Status = XHwIcap_DeviceWrite(&Icap, (u32 *) bitstream->ram_ptr, bitstream->filesize/sizeof(u32));
			if(Status == XST_FAILURE) {
				exit_on_error("Could not write bitstream\n");
			}
		}
	}
}

int main()
{
    load_bitsteams();

    initIcap("/dev/uio0");

    //show_buffer();

    return 0;
}
