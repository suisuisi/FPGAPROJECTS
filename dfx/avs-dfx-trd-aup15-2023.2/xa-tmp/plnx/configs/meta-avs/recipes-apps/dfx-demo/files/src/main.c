

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <inttypes.h>

#include <stdarg.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/time.h>

#include <fcntl.h>



#include "sysnode.h"

#include "drivers/prc/xprc.h"

#include "drivers/common/xparameters.h"

#define ARRAYSIZE(arr) (sizeof(arr) / sizeof(arr[0]))

#define BASE_DIR_BITSTREAMS "/usr/share/avs/bitstreams"


typedef struct bitstream {
	char *filepath;
	size_t filesize;
	uint8_t *data;
	uint32_t phys_addr;
	uint8_t vs_id; //Virtual Socket ID
	uint8_t rm_id; //Removable Module ID
} t_bitstream;


t_bitstream arr_bitstream[] = {
		{
				.filepath = BASE_DIR_BITSTREAMS"/left.bin",
				.vs_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID,
				.rm_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_RM_SHIFT_LEFT_ID
		},
		{
				.filepath = BASE_DIR_BITSTREAMS"/right.bin",
				.vs_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID,
				.rm_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_RM_SHIFT_RIGHT_ID
		},
		{
				.filepath = BASE_DIR_BITSTREAMS"/up.bin",
				.vs_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID,
				.rm_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_RM_COUNT_UP_ID
		},
		{
				.filepath = BASE_DIR_BITSTREAMS"/down.bin",
				.vs_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID,
				.rm_id = XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_RM_COUNT_DOWN_ID
		},
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
	uint64_t phys_addr;

	uint64_t udmabuf_phys_addr = read_sysnode("/sys/class/u-dma-buf/udmabuf0/", "phys_addr", eHex);
	size_t udmabuf0_size = (size_t) read_sysnode("/sys/class/u-dma-buf/udmabuf0/", "size", eDec);

	printf("base addr 0x%08x\n", (unsigned) udmabuf_phys_addr);


	if ((fd_udmabuf = open("/dev/udmabuf0", O_RDWR)) != -1) {
		udmabuf0 = mmap(NULL, udmabuf0_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd_udmabuf, 0);
	} else {
		exit_on_error("Could not open /dev/udmabuf0\n");
	}

	ramptr = (uint8_t *) udmabuf0;
	phys_addr = 0xa7d00000; // problem: udmabuf_phys_addr;


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
		arr_bitstream[i].data = ramptr;
		arr_bitstream[i].phys_addr = phys_addr;


		ramptr += arr_bitstream[i].filesize;
		phys_addr += arr_bitstream[i].filesize;


		printf("copied %s to buffer @ 0x%08x (%d bytes)\n", arr_bitstream[i].filepath, arr_bitstream[i].phys_addr, arr_bitstream[i].filesize);
	}
}

float elapsed_ms(struct timeval tv[2])
{
	float elapsed_ms =
			(float) (tv[1].tv_sec - tv[0].tv_sec)*1000.0 +
			(float) ((tv[1].tv_usec - tv[0].tv_usec) / 1000.0);

	return elapsed_ms;
}

void dxfDemo(const char *uio_path)
{
	int fd_uio;
	int Status;

	XPrc dxfc;
	XPrc_Config *dxfCntrl_Conf = XPrc_LookupConfig(XPAR_PERIPHERALS_DFX_CONTROLLER_0_DEVICE_ID);

	t_bitstream *bitstream;

	static struct timeval tv[2] = {0};

	if ((fd_uio = open(uio_path, O_RDWR)) != -1) {
		dxfCntrl_Conf->BaseAddress = (UINTPTR) mmap(NULL, 0x10000, PROT_READ | PROT_WRITE, MAP_SHARED, fd_uio, 0);
	} else {
		exit_on_error("Could not open %s\n", uio_path);
	}


	Status = XPrc_CfgInitialize(&dxfc, dxfCntrl_Conf, dxfCntrl_Conf->BaseAddress);
	if(Status == XST_FAILURE) {
		exit_on_error("Could not initialize Icap\n");
	}


	printf("Baseaddr: 0x%08x\n", dxfc.Config.BaseAddress);


	printf("Sending shutdown commands to dfx controller...\n");
	XPrc_SendShutdownCommand(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID);
	while(XPrc_IsVsmInShutdown(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID) == XPRC_SR_SHUTDOWN_OFF);

	XPrc_SendShutdownCommand(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID);
	while(XPrc_IsVsmInShutdown(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID) == XPRC_SR_SHUTDOWN_OFF);


	printf("writing addresses and sizes of partial bitstreams to dfx controller...\n");
	for(int i=0; i<ARRAYSIZE(arr_bitstream); i++) {
		bitstream = &arr_bitstream[i];
		XPrc_SetBsSize   (&dxfc, bitstream->vs_id, bitstream->rm_id,  bitstream->filesize);
		XPrc_SetBsAddress(&dxfc, bitstream->vs_id, bitstream->rm_id,  bitstream->phys_addr);

	}


	XPrc_SendRestartWithNoStatusCommand(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID);
	while(XPrc_IsVsmInShutdown(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_SHIFT_ID) == XPRC_SR_SHUTDOWN_ON);

	XPrc_SendRestartWithNoStatusCommand(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID);
	while(XPrc_IsVsmInShutdown(&dxfc, XPAR_PERIPHERALS_DFX_CONTROLLER_0_VS_COUNT_ID) == XPRC_SR_SHUTDOWN_ON);


	while(1) {
		for(int i=0; i<ARRAYSIZE(arr_bitstream); i++) {
			sleep(5);
			bitstream = &arr_bitstream[i];
			if (XPrc_IsSwTriggerPending(&dxfc, bitstream->vs_id, NULL) == XPRC_NO_SW_TRIGGER_PENDING)
			{
				printf("pushing partial bitstream #%d: %s\n", i, bitstream->filepath);

				gettimeofday(&tv[0], NULL);
				XPrc_SendSwTrigger(&dxfc, bitstream->vs_id, bitstream->rm_id);

				while(1) {
					uint32_t prc_status = XPrc_ReadStatusReg(&dxfc, bitstream->vs_id);
					if( (prc_status&0x07) == 7 )
						break;
				}
				gettimeofday(&tv[1], NULL);
				printf("Configuration time %.0f us\n\n", elapsed_ms(tv)*1000.0);
			}
		}
	}

	printf("Done\n");
	close(fd_uio);
}


int main()
{
    load_bitsteams();

    dxfDemo("/dev/uio0");

    //show_buffer();

    return 0;
}
