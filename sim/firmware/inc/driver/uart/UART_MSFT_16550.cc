
// =====================================================
// Copyright (c) Microsoft Corporation.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =====================================================

// Copyright (C) Microsoft Corporation. All rights reserved.
//EXTERN_C_BEGIN

#ifndef __UART_SYNOPSYS_H_INC__ 
#define __UART_SYNOPSYS_H_INC__

#define UART_RBR			        (0x00)	/* Read only */
#define UART_THR			        (0x00)	/* Write only */
#define UART_IER			        (0x04)
#define UART_IIR			        (0x08)	/* Read only */
#define UART_FCR			        (0x08)	/* Write only */
#define UART_LCR			        (0x0c)
#define UART_MCR			        (0x10)
#define UART_LSR			        (0x14)
#define UART_MSR			        (0x18)
#define UART_SCR			        (0x1c)
#define UART_DLL			        (0x00)	/* Only when LCR.DLAB = 1 */
#define UART_DLH			        (0x04)	/* Only when LCR.DLAB = 1 */

#define UART_FAR			        (0x70)	
#define UART_TFR 			        (0x74)	/* Only when LCR = 0xbf */
#define UART_RFW 			        (0x78)	/* Only when LCR = 0xbf */
#define UART_USR  			        (0x7c)	/* Only when LCR = 0xbf */
#define UART_TFL                    (0x80)	/* Only when LCR = 0xbf */
#define UART_RFL                    (0x84)
#define UART_HTX                    (0xa4)
#define UART_DMASA                  (0xa8)
#define UART_CPR                    (0xf4)
#define UART_UCV                    (0xf8)
#define UART_CTR                    (0xfc)

/* IER */
#define UART_IER_ERBFI              (1<<0)
#define UART_IER_ETBEI              (1<<1)
#define UART_IER_ELSI               (1<<2)

/* IIR */
#define UART_IIR_ID_SHIFT           (0)
#define UART_IIR_ID_MASK            (0x3F)
#define UART_IIR_LSR                (0x06)
#define UART_IIR_RXDATA_TMO         (0x0C)
#define UART_IIR_RXDATA_RECEIVED    (0x04)
#define UART_IIR_TX_EMPTY           (0x02)
#define UART_IIR_NO_INTERRUPT       (0x01)

/* FCR */
#define UART_FCR_FIFOE              (1 << 0)
#define UART_FCR_CLRR               (1 << 1)
#define UART_FCR_CLRT               (1 << 2)
#define UART_FCR_DMA1               (1 << 3)
#define UART_FCR_RXFIFO_1B_TRI      (0 << 6)
#define UART_FCR_RXFIFO_6B_TRI      (1 << 6)
#define UART_FCR_RXFIFO_12B_TRI     (2 << 6)
#define UART_FCR_RXFIFO_RX_TRI      (3 << 6)
#define UART_FCR_TXFIFO_1B_TRI      (0 << 4)
#define UART_FCR_TXFIFO_4B_TRI      (1 << 4)
#define UART_FCR_TXFIFO_8B_TRI      (2 << 4)
#define UART_FCR_TXFIFO_14B_TRI     (3 << 4)

#define UART_FCR_FIFO_INIT          (UART_FCR_FIFOE|UART_FCR_CLRR|UART_FCR_CLRT)
#define UART_FCR_NORMAL             (UART_FCR_FIFO_INIT | \
                                     UART_FCR_TXFIFO_4B_TRI| \
                                     UART_FCR_RXFIFO_12B_TRI)
/*---------------------------------------------------------------------------*/
/* LCR */
#define UART_LCR_BREAK              (1 << 6)
#define UART_LCR_DLAB               (1 << 7)

#define UART_WLS_5                  (0 << 0)
#define UART_WLS_6                  (1 << 0)
#define UART_WLS_7                  (2 << 0)
#define UART_WLS_8                  (3 << 0)
#define UART_WLS_MASK               (3 << 0)

#define UART_1_STOP                 (0 << 2)
#define UART_2_STOP                 (1 << 2)
#define UART_1_5_STOP               (1 << 2)    /* Only when WLS=5 */
#define UART_STOP_MASK              (1 << 2)

#define UART_NONE_PARITY            (0 << 3)
#define UART_ODD_PARITY             (0x1 << 3)
#define UART_EVEN_PARITY            (0x3 << 3)
#define UART_MARK_PARITY            (0x5 << 3)
#define UART_SPACE_PARITY           (0x7 << 3)
#define UART_PARITY_MASK            (0x7 << 3)
/*---------------------------------------------------------------------------*/
/* MCR */
#define UART_MCR_DTR                (1 << 0)
#define UART_MCR_RTS                (1 << 1)
#define UART_MCR_OUT1               (1 << 2)
#define UART_MCR_OUT2               (1 << 3)
#define UART_MCR_LOOP               (1 << 4)
#define UART_MCR_DCM_EN             (1 << 5)    /* MT6589 move to bit5 */
#define UART_MCR_XOFF               (1 << 7)    /* read only */
#define UART_MCR_NORMAL	            (UART_MCR_DTR|UART_MCR_RTS)
/*---------------------------------------------------------------------------*/
/* LSR */
#define UART_LSR_DR                 (1 << 0)
#define UART_LSR_OE                 (1 << 1)
#define UART_LSR_PE                 (1 << 2)
#define UART_LSR_FE                 (1 << 3)
#define UART_LSR_BI                 (1 << 4)
#define UART_LSR_THRE               (1 << 5)
#define UART_LSR_TEMT               (1 << 6)
#define UART_LSR_FIFOERR            (1 << 7)

/*---------------------------------------------------------------------------*/
/* MSR */
#define UART_MSR_DCTS               (1 << 0)
#define UART_MSR_DDSR               (1 << 1)
#define UART_MSR_TERI               (1 << 2)
#define UART_MSR_DDCD               (1 << 3)
#define UART_MSR_CTS                (1 << 4)
#define UART_MSR_DSR                (1 << 5)
#define UART_MSR_RI                 (1 << 6)
#define UART_MSR_DCD                (1 << 7)

/*---------------------------------------------------------------------------*/
/* EFR */
#define UART_EFR_RTS                (1 << 6)
#define UART_EFR_CTS                (1 << 7)

//========================================================
// FCR Register
//========================================================
typedef union {
    struct {
        volatile unsigned long  FIFOE   : 1;
        volatile unsigned long  RFIFOR  : 1;
        volatile unsigned long  XFIFOR  : 1;
        volatile unsigned long  DMAM    : 1;
        volatile unsigned long  TET     : 2;
        volatile unsigned long  RC      : 2;
        volatile unsigned long  _pad    : 24;
    };
    volatile unsigned long AsUINT32;

} UARTFCR_t, *PUARTFCR_t;

//========================================================
// LCR Register
//========================================================
typedef union {
    struct {
        volatile unsigned long  DLS   : 2;
        volatile unsigned long  STOP  : 1;
        volatile unsigned long  PEN   : 1;
        volatile unsigned long  EPS   : 1;
        volatile unsigned long  SP    : 1;
        volatile unsigned long  BC    : 1;
        volatile unsigned long  DLAB  : 1;
        volatile unsigned long  _pad  : 24;
    };
    volatile unsigned long AsUINT32;

} UARTLCR_t, *PUARTLCR_t;

//========================================================
// MCR Register
//========================================================
typedef union {
    struct {
        volatile unsigned long  DTR      : 1;
        volatile unsigned long  RTS      : 1;
        volatile unsigned long  OUT1     : 1;
        volatile unsigned long  OUT2     : 1;
        volatile unsigned long  LOOPBACK : 1;
        volatile unsigned long  AFCE     : 1;
        volatile unsigned long  SIRE     : 1;
        volatile unsigned long  _pad     : 25;
    };
    volatile unsigned long AsUINT32;

} UARTMCR_t, *PUARTMCR_t;

//========================================================
// LSR Register
//========================================================
typedef union {
    struct {
        volatile unsigned long  DR    : 1;
        volatile unsigned long  OE    : 1;
        volatile unsigned long  PE    : 1;
        volatile unsigned long  FE    : 1;
        volatile unsigned long  BI    : 1;
        volatile unsigned long  THRE  : 1;
        volatile unsigned long  TEMT  : 1;
        volatile unsigned long  RFE   : 1;
        volatile unsigned long  _pad  : 24;
    };
    volatile unsigned long AsUINT32;

} UARTLSR_t, *PUARTLSR_t;

//========================================================
// MSR Register
//========================================================
typedef union {
    struct {
        volatile unsigned long  DCTS  : 1;
        volatile unsigned long  DDSR  : 1;
        volatile unsigned long  TERI  : 1;
        volatile unsigned long  DCD0  : 1;
        volatile unsigned long  CTS   : 1;
        volatile unsigned long  DSR   : 1;
        volatile unsigned long  RI    : 1;
        volatile unsigned long  DCD   : 1;
        volatile unsigned long  _pad  : 24;
    };
    volatile unsigned long AsUINT32;

} UARTMSR_t, *PUARTMSR_t;

//========================================================
// Synopsys 16550 structure
//========================================================
typedef struct UART16550_s {
	union {
		volatile unsigned long RBR;
		volatile unsigned long THR;
		volatile unsigned long DLL;
	};
	union {
		volatile unsigned long DLH;
		unsigned long IER;
	};
	union {
		volatile unsigned long IIR;
		UARTFCR_t FCR;
	};
	UARTLCR_t LCR;
	UARTMCR_t MCR;
	volatile UARTLSR_t LSR;
	volatile UARTMSR_t MSR;
	unsigned long SCR;
  unsigned long LOOPBACK;
	unsigned long DLF;     // 0x20
	
} MSFT_UART_16550_t, *PMSFT_UART_16550_t;

//! Defaults
#define UART_DEFAULT_BAUD_RATE 		(115200)
#define UART_DEFAULT_DATA_BIT		(UART_WLS_8)
#define UART_DEFAULT_PARITY			(UART_NONE_PARITY)
#define UART_DEFAULT_STOP_BIT		(UART_1_STOP)

#define FRAC_BRG_BITS       4
#define FRAC_BRG_VALUE      (2^FRAC_BRG_BITS)

static PMSFT_UART_16550_t UartBasePtr;

//#define MY_EXTERN_C   extern "C"
#define MY_EXTERN_C  
    
//========================================================
// getLock
//========================================================
MY_EXTERN_C void getLock(unsigned long *addr) {
    return;
}

//========================================================
// releaseLock
//========================================================
MY_EXTERN_C void releaseLock(unsigned long *addr) {
    return;
}

//========================================================
// Flush 
//========================================================
MY_EXTERN_C void _flush(int fd) {
    /* Wait until there is space in the FIFO and Transmitter is empty */
    while ((UartBasePtr->LSR.THRE == 0) || (UartBasePtr->LSR.TEMT == 0)){
    }
}

//========================================================
// Write 
//========================================================
MY_EXTERN_C int _write(int fd, const char* data, int size) {
    for(int i = 0; i<size; i++) {
        /* Wait until there is space in the FIFO */
        while (UartBasePtr->LSR.THRE == 0){
            
        }

	    /* Send the character */
	    UartBasePtr->THR = data[i];
	}

    return size;
}

//========================================================
// Read
//========================================================
MY_EXTERN_C int _read(int fd, char* data, int size) {
    int cnt;
    for(cnt=0;cnt<size;cnt++) {
        while(!(UartBasePtr->LSR.DR)) { continue; }
        data[cnt] = (char)UartBasePtr->RBR;
	}

    return cnt;
}

//========================================================
// Init 
//========================================================
MY_EXTERN_C void uart_init( 
                void *addr,
                unsigned long xtal_freq, 
                unsigned long baudrate=UART_DEFAULT_BAUD_RATE, 
                unsigned long word_size=UART_DEFAULT_DATA_BIT,
                unsigned long parity=UART_DEFAULT_PARITY,
                unsigned long stop=UART_DEFAULT_STOP_BIT
) {
    UartBasePtr = (PMSFT_UART_16550_t)addr;

    // Make sure we finish transmitting 
    while (UartBasePtr->LSR.TEMT != 1 || UartBasePtr->LSR.THRE != 1);
    
    // Enable DLAB
    UARTLCR_t lcr;
    lcr.AsUINT32 = 0;
    lcr.DLAB = 1;
    lcr.STOP = stop;
    lcr.PEN = parity;
    lcr.DLS = word_size;
    UartBasePtr->LCR.AsUINT32 = lcr.AsUINT32;

    // BAUD FRAC
    unsigned long rem;
    unsigned long baudxdiv;
    baudxdiv = 16*baudrate;
    rem = ((xtal_freq % baudxdiv) <<(FRAC_BRG_BITS+1))/baudxdiv;
    rem = (rem>>1) + (rem&0x1);
    UartBasePtr->DLF = rem;

    // BAUD INTEGER
    unsigned long br_int;
    br_int = xtal_freq/(16*baudrate);
    UartBasePtr->DLL = (br_int>>0)&0xff;
    UartBasePtr->DLH = (br_int>>8)&0xff;
    
    // Reset the DLAB 
    lcr.DLAB = 0;
    UartBasePtr->LCR.AsUINT32 = lcr.AsUINT32;

    // Enable the Fifo
    UARTFCR_t fcr;
    fcr.AsUINT32 = 0;
    fcr.FIFOE = 1;
    UartBasePtr->FCR.AsUINT32 = fcr.AsUINT32;

    // Send Autobaud Character (anything with bit zero set)
    const char space = ' ';
    _write(1,&space,1);
    //UartBasePtr->THR = ' '; 
    // Send stupid 2nd char
    //UartBasePtr->THR = ' '; 
    return;
}

#endif
