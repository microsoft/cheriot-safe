
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

#ifndef __SPI_TYPES_INC_H__
#define __SPI_TYPES_INC_H__

#ifdef __cplusplus
extern "C" {
#endif

#define SPI_BASE_ADDR       0x8F00C000

#define SPI_RX_FIFO_SIZE 8
#define SPI_TX_FIFO_SIZE 8

// SPI Master CTRL0 offsets
#define CTRL0_LOOPBACK_OFFSET  1
#define CTRL0_MODE_OFFSET      2
#define CTRL0_BITS_OFFSET      4
#define CTRL0_TXTYPE_OFFSET    9
#define CTRL0_SUB_SEL_OFFSET  11
#define CTRL0_DUMMY_OFFSET    14
#define CTRL0_CLKDIV_OFFSET   20

// SPI Master CTRL1 offsets
#define CTRL1_WRITE_START_OFFSET     1
#define CTRL1_FLASH_START_OFFSET     2
#define CTRL1_CMD_OFFSET             3
#define CTRL1_CMDTYPE_OFFSET        11
#define CTRL1_TRANSACTIONS_OFFSET   13

// SPI Master FLASHCTRL offsets

// SPI Master Status offsets
#define SPI_MST_TX_FIFO_EMPTY_OFFSET   0
#define SPI_MST_TX_FIFO_FULL_OFFSET    1
#define SPI_MST_TX_FIFO_UDR_OFFSET     2
#define SPI_MST_TX_FIFO_OVR_OFFSET     3
#define SPI_MST_TX_FIFO_CNT_OFFSET     4
#define SPI_MST_IDLE_BIT_OFFSET       15
#define SPI_MST_RX_FIFO_EMPTY_OFFSET  16
#define SPI_MST_RX_FIFO_FULL_OFFSET   17
#define SPI_MST_RX_FIFO_UDR_OFFSET    18
#define SPI_MST_RX_FIFO_OVR_OFFSET    19
#define SPI_MST_RX_FIFO_CNT_OFFSET    20

// SPI Master control values
#define SPI_MST_TX_ENABLE      0x00000001  // Enables spi master to transmit
#define SPI_MST_TX_LOOPBACK    0x00000002  // Enables loopback for testing
#define SPI_MST_TX_32_BITS     0x000001F0  // Specifies 32 bit transmit word
#define SPI_MST_TX_16_BITS     0x000000F0  // Specifies 16 bit transmit word
#define SPI_MST_TX_8_BITS      0x00000070  // Specifies 8 bit transmit word
#define SPI_MST_REG_RESET      0x00000000  // Value to write to register to set to zeros 
#define ENABLE  1
#define DISABLE 0

// SPI_MST_STATUS Offsets
#define SPI_MST_STATUS_IDLE_OFFSET   15
#define SPI_MST_RX_FIFO_EMPTY_OFFSET 16
#define SPI_MST_RX_FIFO_FULL_OFFSET  17

enum {
    SPI_08_BIT_WORD     = 0x07,
    SPI_16_BIT_WORD     = 0x0F,
    SPI_24_BIT_WORD     = 0x17,
    SPI_32_BIT_WORD     = 0x1F,
    DUMMY_4_CYCLES  = 0x4,
    DUMMY_6_CYCLES  = 0x6,
    DUMMY_8_CYCLES  = 0x8,
    DUMMY_10_CYCLES = 0x10,
};

// enum {
//     SPI_08_BIT_WORD     = 0x07,
//     SPI_16_BIT_WORD     = 0x0F,
//     SPI_24_BIT_WORD     = 0x17,
//     SPI_32_BIT_WORD     = 0x1F,
//     SINGLE_4_DUMMY_CYCLES  = 0x03,
//     SINGLE_6_DUMMY_CYCLES  = 0x05,
//     SINGLE_8_DUMMY_CYCLES  = 0x07,
//     SINGLE_10_DUMMY_CYCLES = 0x09,
//     DUAL_6_DUMMY_CYCLES  = 0x0B,
//     DUAL_8_DUMMY_CYCLES  = 0x0f,
//     QUAD_4_DUMMY_CYCLES  = 0x0F,
//     QUAD_8_DUMMY_CYCLES  = 0x1F,
//     QUAD_10_DUMMY_CYCLES = 0x27
// };

// TODO: Necessary?
typedef enum {
    SPI_ADDR_LEN_0  = 0,
    SPI_ADDR_LEN_8  = 2,
    SPI_ADDR_LEN_16 = 4,
    SPI_ADDR_LEN_24 = 6,
    SPI_ADDR_LEN_32 = 8,
} SPI_ADDR_LEN_t;

typedef enum SPI_MODE_e { // SPI MODE
    SPI_SINGLE_MODE  = 0,
    SPI_DUAL_MODE    = 1,
    SPI_QUAD_MODE    = 2,
} SPI_MODE_t; 

typedef enum SPI_SEL_VAL_e {
    // SPI_SEL_NONE = 0x00,
    SPI_SEL_0 = 0x0,
    SPI_SEL_1 = 0x1,
    SPI_SEL_2 = 0x2,
    SPI_SEL_3 = 0x3,
    SPI_SEL_4 = 0x4,
    SPI_SEL_5 = 0x5,
} SPI_SEL_VAL_t;

typedef enum SPI_TXTYPE_e { // Transfer Mode
    SPI_TXRX = 0,  // Transmit/Receive
    SPI_RX   = 1,  // Receive only
    SPI_TX   = 2,  // Transmit only, 3 is reserved
} SPI_TXTYPE_t;

//TSS: QUESTION: Are these transmission types supported in this design?
typedef enum SPI_TRANS_TYPE_e { // One Wire:               All Wires (STD/Dual/Quad/Octal):
   SPI_TX_STANDARD      = 0,    // Instruction + Address | Data
   SPI_TX_ENHANCED_ADDR = 1,    // Instruction           | Address + Data
   SPI_TX_ENHANCED_ALL  = 2,    //                       | Instruction + Address + Data
} SPI_TRANS_TYPE_t;

/* Type of Flash commands for Flash Control0 */
typedef enum FLASH_CMD_TYPE_e {
    CMD                = 0X0,
    CMD_ADDR3_DUMMY    = 0X2,
    CMD_ADDR4_DUMMY_WR = 0X3,
} FLASH_CMD_TYPE_t;

/* Typedef for Addressmap: DVIP SPI Master */
typedef struct {
    uint32_t      CTRL0;          /**< Offset 0x0  (R/W) */
    uint32_t      CTRL1;          /**< Offset 0x4  (R/W) */
    uint32_t      FLASHCTRL;      /**< Offset 0x8  (R/W) */
    uint32_t      STATUS;         /**< Offset 0xc  (R/W) */
    uint32_t      FIFO;           /**< Offset 0x10 (R/W) */
    uint32_t      INTEN;          /**< Offset 0x14 (R/W) */
    uint32_t      FLASHADDR;      /**< Offset 0x18 (R/W) */
} REGS_SPI;

typedef struct SPI_TRANS_STRUCT_s {
    bool              enable;        // Transmit enable
    bool              loopback;      // Loopback mode
    SPI_MODE_t        spiMode;       // single, dual, quad
    uint8_t           txNumBits;     // Number of bits to transmit. 5 bits for number limits max to 32 bits
    SPI_TXTYPE_t      txType;        // tx/rx=oo, rx=01, tx=10
    SPI_SEL_VAL_t     sub;           // Subordinate Select
    uint8_t           dummy;         // Number of dummy cycles after read command
    uint16_t          clkDiv;        // Clock divide value, 16 bits
    bool              rdStart;       // 0 = no effect, 1=Start Read only spi transaction
    bool              wrStart;       // 0 = no effect, 1=Start Write only spi transaction
    bool              flashStart;    // 0 = no effect, 1=Start Write only spi transaction
    uint8_t           cmd;           // Flash command code
    FLASH_CMD_TYPE_t  cmdType;       // Flash command type
    uint32_t          transactions;  // This is the number of subordinate receive transactions to occur.
} SPI_TRANS_STRUCT_t;


#ifdef __cplusplus
}
#endif

#endif
