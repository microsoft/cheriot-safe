#ifndef __SPI_FLASH_TYPES_INC__
#define __SPI_FLASH_TYPES_INC__

//===================================================
// Flash Vendor Class
//===================================================

class FLASH_VENDOR_TABLE {
  public:
  #define VENDORS   3


  typedef enum {
    MICRON=0x20,
    WINBOND=0xEF,
    MACRONIX=0xC2,
  } FLASH_VENDOR_t;

  typedef enum {
    MEM_3p3V=0xba,
    MEM_1p8Volt=0xbb,
  } MEM_VOLTAGE_t;

  typedef enum {
    MEM_CAP_2Gb=0x22,
    MEM_CAP_1Gb=0x21,
    MEM_CAP_512Mb=0x20,
    MEM_CAP_256Mb=0x19,
    MEM_CAP_128Mb=0x18,
    MEM_CAP_064Mb=0x17,
  } MEM_CAP_t;

  typedef struct {
    uint8_t mfg_id;
    uint8_t mem_type;
    uint8_t mem_capacity;
    uint8_t remaining;
    uint8_t ext_id;
    uint8_t dev_conf;
    uint8_t factory_data[14]; 
    const char * vendor;
  } FLASH_ID_t;

  FLASH_ID_t flash_id[VENDORS];
  FLASH_ID_t *vptr;

  FLASH_VENDOR_TABLE()
  {
    flash_id[0] = { MICRON,   MEM_3p3V, MEM_CAP_256Mb, 0x10, 0x40, 0x00, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0x1f, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0x10, "Micron FLASH 256Mb Memory"};
    flash_id[1] = { WINBOND,  0x70,     MEM_CAP_256Mb, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, "Winbond FLASH 256Mb Memory"};
    flash_id[2] = { MACRONIX, 0x20,     MEM_CAP_256Mb, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, 0x19, 0xc2, 0x20, "Macronix FLASH 256Mb Memory"};
    vptr = NULL;
  }

  int getFlashVendor(uint8_t *varray)
  {
    int ret_vendor = -1;
    for(int i=0;i<VENDORS;i++) {
      if(varray[0] == flash_id[i].mfg_id) {
        ret_vendor = varray[0];
        vptr = flash_id+i;
        break;
      }
    }
    printFlashVendor(ret_vendor);
    return ret_vendor;
  }

  void printFlashVendor(int vendor)
  {
    if(vptr == NULL) {
      printf("FLASH VENDOR: Unknown\n");
    } else {
      printf("FLASH VENDOR: %s\n", vptr->vendor);
    }
  }
  
};

//===================================================
// Typedefs
//===================================================

typedef enum {
SPI_ADDR_LEN_0  = 0,
SPI_ADDR_LEN_24 = 6,
SPI_ADDR_LEN_32 = 8,
} SPI_ADDR_LEN_t;

typedef enum SPI_TRANS_TYPE_e { // One Wire:               All Wires (STD/Dual/Quad/Octal):
  SPI_TX_STANDARD      = 0,    // Instruction + Address | Data
  SPI_TX_ENHANCED_ADDR = 1,    // Instruction           | Address + Data
  SPI_TX_ENHANCED_ALL  = 2,    //                       | Instruction + Address + Data
} SPI_TRANS_TYPE_t;

typedef enum {
  SINGLE_MODE=0,
  DUAL_MODE=1,
  QUAD_MODE=2,
} SPI_MODE_t;

typedef enum {
  TXRX_TYPE=0,
  TX_TYPE=1,
  RX_TYPE=2,
} SPI_TYPE_t;

#define SET_TYPE(type)					(type<<10)
#define SET_MODE(mode_in)         (mode_in<<22)
#define SET_BITS(bits)   				((bits)&0x1f)
#define SET_POLARITY(polarity)	(polarity<<9)
#define SET_PHASE(phase)        (phase<<8)
#define SET_DUMMY(dum)					((dum)<<11)
#define SPI_PHASE    0 /**< 0/1: Capture data on first/second clock edge */
#define SPI_POLARITY 0 /**< Inactive SPI clock level */
#define SPI_TX_FIFO_SIZE 32
#define SPI_RX_FIFO_SIZE 16
#define INST_L       0x2<<8  /**< Instuction length is always 8 bits */
#define FLASH_4BYTE_MODE        true
#define FLASH_PAGE_SIZE   256 /**< Can only program one page at a time. It wraps around if not starting at a boundary! */


enum {
    SPI_08_BIT_WORD = 0x07,
    SPI_16_BIT_WORD = 0x0F,
    SPI_32_BIT_WORD = 0x1F,
};


/**
 * Micron(MT25QU256)        - Datasheet : 128Mb, 3V, Multiple I/O Serial Flash Memory (sharepoint.com)
 * Winbond(W25Q256JVxIM)    - Datasheet : W25Q512JV Datasheet (winbond.com)
 * Macronix(MX25U3272FWAJ42)- Datasheet : Manticore - MX25U3232F J-grade, 1.8V, 32Mb, v0.00.pdf - All Documents (sharepoint.com)
*/

typedef enum FLASH_CMDS_e {

  // Reset Memory
  FLASH_CMD_RESET_ENABLE                     = 0x66,
  FLASH_CMD_RESET_MEMORY                     = 0x99,

  // Read ID
  FLASH_CMD_READ_ID                          = 0x9F, /**< STD */
  FLASH_CMD_READ_ID_MULTI_IO                 = 0xAF, /**< Dual/Quad */
  FLASH_CMD_READ_ID_WB_STD                   = 0x90, /**< STD */
  FLASH_CMD_READ_ID_WB_DUAL                  = 0x92, /**< Dual */
  FLASH_CMD_READ_ID_WB_QUAD                  = 0x94, /**< Quad */

  // Enter/Exit QUAD Mode
  FLASH_CMD_ENTER_QUAD_IO_MODE               = 0x35,
  FLASH_CMD_EXIT_QUAD_IO_MODE                = 0xF5,
  FLASH_CMD_WINB_ENTER_QUAD_IO_MODE          = 0x38,
  FLASH_CMD_WINB_EXIT_QUAD_IO_MODE           = 0xFF,

  // Enter 4 Byte Mode
  FLASH_CMD_ENTER_4BYTE_ADDR_MODE            = 0xB7,
  FLASH_CMD_EXIT_4BYTE_ADDR_MODE             = 0xE9,

  // STATUS Register
  FLASH_CMD_READ_STATUS_REGISTER             = 0x05,
  FLASH_CMD_WRITE_STATUS_REGISTER            = 0x01,

  // Write Enable
  FLASH_CMD_WRITE_DISABLE                    = 0x04,
  FLASH_CMD_WRITE_ENABLE                     = 0x06,

  // SUSPEND/RESUME Program Erase
  FLASH_CMD_SUSPEND_PROG_ERASE               = 0x75,
  FLASH_CMD_RESUME_PROG_ERASE                = 0x7A,
  FLASH_CMD_MACR_SUSPEND_PROG_ERASE          = 0xB0,  // Macronix Only
  FLASH_CMD_MACR_RESUME_PROG_ERASE           = 0x30,  // Macronix Only

  // READ
  FLASH_CMD_READ                             = 0x03,
  FLASH_CMD_FAST_READ                        = 0x0B,
  FLASH_CMD_DUAL_OUTPUT_FAST_READ            = 0x3B,
  FLASH_CMD_QUAD_OUTPUT_FAST_READ            = 0x6B,
  FLASH_CMD_DUAL_IO_FAST_READ                = 0xBB,
  FLASH_CMD_QUAD_IO_FAST_READ                = 0xEB,
  FLASH_CMD_QUAD_IO_FAST_WORD_READ           = 0xE7,

  // READ 4Byte
  FLASH_CMD_4BYTE_READ                       = 0x13,
  FLASH_CMD_4BYTE_FAST_READ                  = 0x0C,
  FLASH_CMD_4BYTE_DUAL_OUTPUT_FAST_READ      = 0x3C,
  FLASH_CMD_4BYTE_QUAD_OUTPUT_FAST_READ      = 0x6C,
  FLASH_CMD_4BYTE_DUAL_IO_FAST_READ          = 0xBC,
  FLASH_CMD_4BYTE_QUAD_IO_FAST_READ          = 0xEC,

  // ERASE Commands
  FLASH_CMD_ERASE_4KB_SUBSECTOR              = 0x20, /**< Microchip Sector Erase */
  FLASH_CMD_ERASE_32KB_SUBSECTOR             = 0x52,
  FLASH_CMD_4BYTE_ERASE_4KB_SUBSECTOR        = 0x21,
  FLASH_CMD_ERASE_SECTOR                     = 0xD8, /**< Microchip Block  Erase */
  FLASH_CMD_4BYTE_ERASE_SECTOR               = 0xDC,
  FLASH_CMD_BULK_ERASE                       = 0xC7,

  FLASH_CMD_ERASE_CHIP                       = 0xC4,  /**< Not Micron */

  FLASH_CMD_MCHP_ERASE_BLOCK                 = 0xD8, /**< Microchip Specific */
  FLASH_CMD_MCHP_ERASE_CHIP                  = 0xC7,
  FLASH_CMD_MCHP_ERASE_SECTOR                = 0x20,
  FLASH_CMD_MCHP_GLOBAL_BLOCK_PROT_UNLOCK    = 0x98,
  FLASH_CMD_MCHP_PAGE_PROGRAM                = 0x02,
  FLASH_CMD_MCHP_PAGE_PROGRAM_QUAD           = 0x32,
  FLASH_CMD_MCHP_READ_BLOCK_PROT_REGISTER    = 0x72,
  FLASH_CMD_MCHP_WRITE_BLOCK_PROT_REGISTER   = 0x42,

  // PROGRAM
  FLASH_CMD_PAGE_PROGRAM                     = 0x02, /**< Micron can also use 0x02 */
  FLASH_CMD_DUAL_INPUT_FAST_PROGRAM          = 0xA2,
  FLASH_CMD_QUAD_INPUT_FAST_PROGRAM          = 0x32,
  FLASH_CMD_MAC_QUAD_INPUT_FAST_PROGRAM      = 0x38, // Macronix
  //TODO: REMOVE: remove command below after drivers are modified. Fast programming doesn't exist in single mode.
  FLASH_CMD_4BYTE_FAST_PROGRAM               = 0x12,
  FLASH_CMD_4BYTE_PAGE_PROGRAM               = 0x12,
  FLASH_CMD_4BYTE_QUAD_FAST_PROGRAM          = 0x34,
  FLASH_CMD_MAC_4BYTE_QUAD_FAST_PROGRAM      = 0x3E,


  // EXT Address
  FLASH_CMD_READ_EXT_ADDR                    = 0xC8,
  FLASH_CMD_WRITE_EXT_ADDR                   = 0xC5,

  // READ/CLEAR Flag Status
  FLASH_CMD_READ_FLAG_STATUS_REGISTER        = 0x70,
  FLASH_CMD_CLEAR_FLAG_STATUS_REGISTER       = 0x50,  // micron

  // Enhanced Volatile Config (Micron)
  FLASH_CMD_READ_ENHANCED_VOLATILE_CONF      = 0x65,
  FLASH_CMD_WRITE_ENHANCED_VOLATILE_CONF     = 0x61,

  // Lock Register
  FLASH_CMD_READ_LOCK_REGISTER               = 0xE8, 
  FLASH_CMD_WRITE_LOCK_REGISTER              = 0xE5,

  // NON Volatile Config (Micron)
  FLASH_CMD_READ_NON_VOLATILE_CONF           = 0xB5,
  FLASH_CMD_WRITE_NON_VOLATILE_CONF          = 0xB1,

  // VOLATILE Config (Micron)
  FLASH_CMD_READ_VOLATILE_CONF               = 0x85,
  FLASH_CMD_WRITE_VOLATILE_CONF              = 0x81,

  FLASH_CMD_SFDP                             = 0x5A,

  

  // Windbond Commands
  FLASH_CMD_WINB_ENTER_QPI_MODE              = 0x38, /**< WinBond Specific */
  FLASH_CMD_WINB_EXIT_QPI_MODE               = 0xFF, /**< WinBond Specific */
  FLASH_CMD_WINB_SET_READ_PARAMS             = 0xc0, /**< WinBond Specific */

  FLASH_CMD_WINB_QUAD_IO_FAST_READ           = 0xEB,

  FLASH_CMD_WINB_READ_STATUS_REGISTER1       = 0x05,  // Common Status Register
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER1      = 0x01,

  FLASH_CMD_WINB_READ_STATUS_REGISTER2       = 0x35,
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER2      = 0x31,

  FLASH_CMD_WINB_READ_STATUS_REGISTER3       = 0x15,
  FLASH_CMD_WINB_WRITE_STATUS_REGISTER3      = 0x11,

  FLASH_CMD_WINB_VOLATILE_SR_WRITE_ENABLE    = 0x50,

} FLASH_CMDS_t;

#endif
