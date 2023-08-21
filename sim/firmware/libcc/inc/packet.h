
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


#ifndef __PACKET_H_INC__
#define __PACKET_H_INC__

#include <inttypes.h>
#include <pka_types.h>
#include <sha_types.h>
#include <aes_types.h>
#include <ccs_types.h>

#define SendACK()                               WritePacket("ACK")
#define SendNAK()                               WritePacket("NAK")

#define MAGIC_STRING		    {'p', 'k', 't'}
#define RECEIVE_BUFFER_SIZE	    0x1100

#define PACKET_RPC_CHAR            'r' 
#define PACKET_READADDR_CHAR       'R' 
#define PACKET_WRITEADDR_CHAR      'W'
#define PACKET_BINLOAD_CHAR        'B'

//Below defined in stdio.h why duplicate?
//#define pprintf(fmt, args...) pfprintf((FILE *)0, fmt, ## args)


//#ifdef __cplusplus
//extern "C" {
//#endif

uint32_t ConvertHexString2Int(const char * str, const int width);
void ConvertInt2HexString( uint32_t value, char * str, const int width);
uint32_t WritePacket( const char * packet);
uint32_t ReadPacket( char * buffer );

// This is the startup entry point in CRT0
void ResetHandler( void );

uint32_t callRpc(const char* callString, char* result, const uint32_t resultLen);
uint32_t pka_rpc(pka_cmd_t * pka_command,uint32_t *result, int rand, pka_arg_sizes_t pka_sizes);
uint32_t pka_ecc_set_k_rpc(uint32_t *arg, int arg_size_in_bits);

uint32_t upka_rpc(uint32_t upka_command, uint32_t * modulus, uint32_t mod_size, uint32_t *result, uint32_t result_size, uint32_t * arg1, uint32_t arg1_size, uint32_t * arg2, uint32_t arg2_size, uint32_t * arg3, uint32_t arg3_size);

uint32_t sha_rpc(sha_cmd_t * sha_command,uint32_t *result);
uint32_t aes_rpc(aes_cmd_t * aes_command,uint32_t *result);
uint32_t ccs_rpc(ccs_model_t * ccs_model_data,uint32_t *result);
uint32_t rng_rpc(uint32_t * txt_ptr, uint32_t num_txt_bytes, uint32_t * key_ptr, uint32_t * val_ptr, uint32_t * result_ptr);

uint32_t dataopen_rpc(const char* filename);
uint32_t dataload_rpc(const char* key, uint32_t* dest);
uint32_t dataclose_rpc();

uint32_t reset_rpc();
uint32_t hsp_reset_rpc();
uint32_t por_reset_rpc();
uint32_t reset_count_rpc();
uint32_t hsp_reset_count_rpc();
uint32_t por_reset_count_rpc();
uint32_t reset_load();
uint32_t reset_store(uint32_t data);

//Read/WriteCmd duplicates of what is in main.cpp for the client.
//eventually combine. 
int ConvertHexArray2Bin(char * array, int bytes);
int ReadCmd(char * buf, uint32_t size);
int WriteCmd(char * buf, uint32_t size);
int BinLoadCmd(char * buf, uint32_t size);
//End of duplicates


//New bufferless packet handling function
static const char MAGIC_STR_ARRAY[] = MAGIC_STRING;
void putcPktHeader(
  char *buf,              //rough work buffer with at least 4 bytes
  const uint16_t len,     //len of payload, including packet char code
  const char code         //the packet code
);
uint32_t getcPktHeader(
  char *buf,          //rough buf space of at least 5 chars
  char *charCode,     //packet char code
  uint16_t* len       //length of payload excluding pkt code
);
uint32_t getcReadPacketAndRespond(
   char *buf,      //>=8 chars for rought work 
   uint16_t len    //remaining payload length
);
uint32_t getcBinloadPacket(
  char *buf,      //>=8 chars for rought work 
  uint16_t len    //remaining payload length 
);

uint32_t pktGetUint32(
  uint16_t *len,
  int nibbles=8
);

typedef enum SLAVE_CMD_RDY_s {
    SLAVE_CMD_IDLE=0x2543,
    SLAVE_CMD_RDY=0x4793,
} SLAVE_CMD_RDY_t;

typedef struct WRITE_SLAVE_t {
    volatile uint32_t cmd_stat;
    volatile uint32_t packet_length;
    volatile const char *packet;
} WRITE_SLAVE_t, *ptrWRITE_SLAVE_t;

//#ifdef __cplusplus
//}
//#endif

#endif
