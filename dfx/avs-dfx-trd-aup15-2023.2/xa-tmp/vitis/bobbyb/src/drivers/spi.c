/*=============================================================================
#
#       Purpose: provides SPI driver functions
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

#include <stdbool.h>
#include <string.h>

#include <xparameters.h>

#include "lib/utils.h"


#include "io.h"
#include "spi.h"


enum eReg_offsets {
	XSP_DGIER_OFFSET = 0x1C, /**< Global Intr Enable Reg */
	XSP_IISR_OFFSET = 0x20, /**< Interrupt status Reg */
	XSP_IIER_OFFSET = 0x28, /**< Interrupt Enable Reg */
	XSP_SRR_OFFSET = 0x40, /**< Software Reset register */
	XSP_CR_OFFSET = 0x60, /**< Control register */
	XSP_SR_OFFSET = 0x64, /**< Status Register */
	XSP_DTR_OFFSET = 0x68, /**< Data transmit */
	XSP_DRR_OFFSET = 0x6C, /**< Data receive */
	XSP_SSR_OFFSET = 0x70, /**< 32-bit slave select */
	XSP_TFO_OFFSET = 0x74, /**< Tx FIFO occupancy */
	XSP_RFO_OFFSET = 0x78, /**< Rx FIFO occupancy */
};


enum eBit_masks {
	XSP_SR_RX_EMPTY_MASK = 0x00000001, /**< Receive Reg/FIFO is empty */
	XSP_SR_RX_FULL_MASK = 0x00000002, /**< Receive Reg/FIFO is full */
	XSP_SR_TX_EMPTY_MASK = 0x00000004, /**< Transmit Reg/FIFO is empty */
	XSP_SR_TX_FULL_MASK = 0x00000008, /**< Transmit Reg/FIFO is full */
	XSP_SR_MODE_FAULT_MASK = 0x00000010, /**< Mode fault error */

	XSP_CR_ENABLE_MASK = 0x00000002, /**< System enable */
	XSP_CR_RXFIFO_RESET_MASK = 0x00000040, /**< Reset receive FIFO */
	XSP_CR_TRANS_INHIBIT_MASK = 0x00000100, /**< Master transaction */
	XSP_CR_MANUAL_SS_MASK = 0x00000080, /**< Manual slave select */
	XSP_CR_MASTER_MODE_MASK = 0x00000004, /**< Enable master mode */
	XSP_CR_CLK_POLARITY_MASK = 0x00000008, /**< Clock polarity high or low */
	XSP_CR_CLK_PHASE_MASK = 0x00000010, /**< Clock phase 0 or 1 */

	XSP_SRR_RESET_MASK = 0x0000000A /* SPI Software Reset Register (SRR) mask. */
};


static tSpiHandle spiHandle[] =
{
	{
		.baseAddr = XPAR_SPI_0_BASEADDR,
		.fifoDepth = XPAR_SPI_0_FIFO_DEPTH,
		.intVecID = XPAR_PERIPHERALS_MICROBLAZE_0_AXI_INTC_PERIPHERALS_AXI_QUAD_SPI_0_IP2INTC_IRPT_INTR,
	}
};

static const int C_SPI_CORES = ARRAY_SIZE(spiHandle);



static inline bool get_status_reg_bit(tSpiHandle *inst, uint32_t mask)
{
	uint32_t statusReg = Io_In32(inst->baseAddr + XSP_SR_OFFSET);
	return (statusReg & mask)?true:false;
}


static inline uint32_t get_tx_fifo_vacancy(tSpiHandle *inst)
{
	return inst->fifoDepth - Io_In32(inst->baseAddr + XSP_TFO_OFFSET);
}


static inline uint32_t get_rx_fifo_occupancy(tSpiHandle *inst)
{
	return Io_In32(inst->baseAddr + XSP_RFO_OFFSET) + 1;
}


static inline bool get_tx_fifo_full(tSpiHandle *inst)
{
	return get_status_reg_bit(inst, XSP_SR_TX_FULL_MASK);
}


static inline bool get_tx_fifo_empty(tSpiHandle *inst)
{
	return get_status_reg_bit(inst, XSP_SR_TX_EMPTY_MASK);
}


static inline bool get_rx_fifo_empty(tSpiHandle *inst)
{
	return get_status_reg_bit(inst, XSP_SR_RX_EMPTY_MASK);
}


static inline void start_transmission(tSpiHandle *inst)
{
	uint32_t control_reg = Io_In32(inst->baseAddr + XSP_CR_OFFSET);
	control_reg &= ~XSP_CR_TRANS_INHIBIT_MASK;
	Io_Out32(inst->baseAddr + XSP_CR_OFFSET, control_reg);
}


static inline void stop_transmission(tSpiHandle *inst)
{
	uint32_t control_reg = Io_In32(inst->baseAddr + XSP_CR_OFFSET);
	control_reg |= XSP_CR_TRANS_INHIBIT_MASK;
	Io_Out32(inst->baseAddr + XSP_CR_OFFSET, control_reg);
}


static void init_spi_controller(uint32_t BaseAddress)
{
	uint16_t control_reg =
		(XSP_CR_MANUAL_SS_MASK | XSP_CR_MASTER_MODE_MASK |
		 XSP_CR_ENABLE_MASK | XSP_CR_TRANS_INHIBIT_MASK);
	Io_Out32(BaseAddress + XSP_CR_OFFSET, control_reg);
	Io_Out32(BaseAddress + XSP_SSR_OFFSET, ~0);
}


void spi_device_select(tSpiHandle *inst, uint8_t nr)
{
	Io_Out32(inst->baseAddr + XSP_SSR_OFFSET, ~(1<<nr));
}

void spi_device_unselect(tSpiHandle *inst)
{
	Io_Out32(inst->baseAddr + XSP_SSR_OFFSET, ~0);
}


static inline bool pop_rx_fifo(tSpiHandle *inst)
{
	uint32_t drr_addr = inst->baseAddr + XSP_DRR_OFFSET;

	if(get_rx_fifo_empty(inst))
		return false;

	inst->stats.rx_bytes++;
	if(inst->RecvBufferPtr == NULL) {
		Io_In32(drr_addr);
	} else {
		*inst->RecvBufferPtr++ = Io_In32(drr_addr);
	}

	return true;
}


int spi_transfer (tSpiHandle *inst, uint8_t *send, uint8_t *recv, size_t nbytes)
{
	uint32_t tfv; /* transmit fifo vacancy */
	uint32_t n;
	inst->SendBufferPtr = send;
	inst->RecvBufferPtr = recv;
	inst->RemainingBytes = nbytes;
	uint32_t dtr_addr = inst->baseAddr + XSP_DTR_OFFSET;


	/* We start the master transfer now. Core should now start clocking once a
	   value is written to the dtr */
	start_transmission(inst);

	while(inst->RemainingBytes) {
		tfv = get_tx_fifo_vacancy(inst);
		n = tfv < inst->RemainingBytes ? tfv:inst->RemainingBytes;
		inst->stats.tx_bytes += n;
		inst->RemainingBytes -= n;

		/* fill tx fifo */
		while(n--) {
			if(inst->SendBufferPtr) {
				Io_Out32(dtr_addr, *inst->SendBufferPtr++);
			} else {
				Io_Out32(dtr_addr, 0);
			}
		}

		/* we wait until tx fifo is empty and read incoming bytes from rx
		 * fifon in the meanwhile to accelerate throughput
		 */
		while(!get_tx_fifo_empty(inst)) {
			pop_rx_fifo(inst);
		}
	}

	/* There might still be data in the rx fifo and arrive after we leave the loop above */
	while(inst->stats.rx_bytes != inst->stats.tx_bytes) {
		pop_rx_fifo(inst);
	}

	/* We are done -> stop transmission */
	stop_transmission(inst);

	return 0;
}


void spi_set_clock_phase(tSpiHandle *inst)
{
	uint32_t spi_cntrl_reg;
	spi_cntrl_reg = Io_In32(inst->baseAddr + XSP_CR_OFFSET);
	spi_cntrl_reg |= XSP_CR_CLK_PHASE_MASK;
	spi_cntrl_reg |= XSP_CR_CLK_POLARITY_MASK;
	Io_Out32(inst->baseAddr + XSP_CR_OFFSET, spi_cntrl_reg);
}


tSpiHandle *init_spi(int core_nr)
{
	tSpiHandle *localSpiHandle = &spiHandle[core_nr];

	if (!(core_nr < C_SPI_CORES))
		return NULL;

	memset(&localSpiHandle->stats, 0, sizeof(tSpiStats));
	localSpiHandle->RecvBufferPtr = NULL;
	localSpiHandle->SendBufferPtr = NULL;


	/* reset core */
	Io_Out32(localSpiHandle->baseAddr + XSP_SRR_OFFSET,
			XSP_SRR_RESET_MASK);

	init_spi_controller(localSpiHandle->baseAddr);


	return localSpiHandle;
}
