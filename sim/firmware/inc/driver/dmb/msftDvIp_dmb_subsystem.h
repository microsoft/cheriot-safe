#ifndef __DMB_SUBSYSTEM_H__
#define __DMB_SUBSYSTEM_H__

#define DMB_MAX_SEGMENTS   (32)
#define DMB_FIRST_SEGMENT  (18)

//  Offsets (from the base address) for the various regions.
//      These were extracted from Table 10:
//      DMB Configuration Register Address Map
//
#define DMB_SEGMENT_REGISTERS      0x0000
//#define DMB_SEGMENT_ATTRIBUTES     0x0080
#define DMB_UPPER_ADDRESS          0x0180
#define DMB_EXTENDED_SEGMENT       0x0200
//  The above are arrays of 31 values (only 18~31 are valid to use)
//  The following are single 32-bit registers.
#define DMB_PRIV_PERM_REGISTER     0x0300
#define DMB_USER_PERM_REGISTER     0x0304
#define DMB_CRYPTO_PERM_REGISTER   0x0308
#define DMB_ACCESS_ENABLE_REGISTER 0x030C
#define DMB_ERROR_LOG_1_REGISTER   0x0310
#define DMB_ERROR_LOG_2_REGISTER   0x0314

//  For fortress this is in the subsystem YAML file
//  - It tells the driver what segments it can use.
//
#define DMB_VALID_SEGMENT_MAP      0xfffc0000

//#define PRIV_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + 0x300))
//#define USER_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + 0x304))
//#define CRYPTO_PERM_DATA_PTR *((volatile uint32_t*)(dmb_base + 0x308))
//#define UM_SEG_ACCESS_EN_DATA_PTR *((volatile uint32_t*)(dmb_base + 0x30C))

//  DMB Pointer
//
typedef struct {
  uint32_t offset : 27;
  uint32_t index  :  5;
} dmb_ptr_t;

//  Segment Register Entry
//
typedef struct {
  uint32_t addr   : 13;    //  Address bits [39:27]
  uint32_t rsvd   :  1;    //  Was the coherent bit
  uint32_t window :  4;
  uint32_t offset : 10;
  uint32_t secure :  1;
  uint32_t xtra   :  3;
} dmb_seg_reg_t;

#define DMB_WINDOW_128K  0
#define DMB_WINDOW_256K  1
#define DMB_WINDOW_512K  2
#define DMB_WINDOW_1M    3
#define DMB_WINDOW_2M    4
#define DMB_WINDOW_4M    5
#define DMB_WINDOW_8M    6
#define DMB_WINDOW_16M   7
#define DMB_WINDOW_32M   8
#define DMB_WINDOW_64M   9
#define DMB_WINDOW_128M 10

#define DMB_SECURE    0
#define DMB_NONSECURE 1

//  Segment Upper Address Registers
//
typedef struct {
  uint32_t up_addr  : 24;  //  Address bits [63:40]
  uint32_t user     :  8;  //  AxUSER bits
} dmb_useg_t;

//  Extended Segment Configuration Registers
//
typedef struct {
  uint32_t rcache   :  4;  // RdCache bits
  uint32_t wcache   :  4;  // WrCache bits
  uint32_t esegrsvd : 24;
} dmb_eseg_t;

//  DMB Error Log Two
//
typedef struct {
  uint32_t user     :  4;  // AxUSER[11:8]  (Should be 8 bits)
  uint32_t blength  :  8;
  uint32_t bsize    :  3;
  uint32_t vtype    :  4;
  uint32_t rwrite   :  1;
  uint32_t elogrsvd : 12;
} dmb_elog2_t;

#endif // __DMB_SUBSYSTEM_H__
