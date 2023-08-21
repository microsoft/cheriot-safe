
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


#include <stdlib.h>
#include <packet.h> 

#ifndef BACKDOOR_RPC
//========================================================================================
//Non Simulation Version
//========================================================================================

uint32_t upka_rpc(uint32_t upka_command, uint32_t * modulus, uint32_t mod_size, uint32_t *result, uint32_t result_size, uint32_t * arg1, uint32_t arg1_size, uint32_t * arg2, uint32_t arg2_size, uint32_t * arg3, uint32_t arg3_size){
  const char cmdFmt[] = "upka(%08x,%08x,%08x,%08x,%08x,%08x,%08x,%08x,%08x,%08x,%08x)";
  const int CMD_LEN = 5+(9*11-1)+1+1;  //based off the format string
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;
  //format the call and call the rpc
  pprintf("Calling the upka_rpc\n");
  psprintf(rpcCmd, 
	   cmdFmt, 
	   upka_command,
	   (uint32_t) modulus, 
	   mod_size, 
	   (uint32_t) result, 
	   result_size, 
     (uint32_t) arg1, 
	   arg1_size, 
	   (uint32_t) arg2, 
	   arg2_size, 
	   (uint32_t) arg3, 
	   arg3_size
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));
  // pprintf("UPKA-RPC Returned:\n");
  // pprintf("   modulus="); for (uint32_t ii=0;ii<mod_size/32   ;ii++) pprintf("%08x ",*((((uint32_t*) modulus)+ii))); pprintf("\n");
  // pprintf("   result ="); for (uint32_t ii=0;ii<result_size/32;ii++) pprintf("%08x ",*((((uint32_t *) result)+ii))); pprintf("\n");
  // pprintf("   arg1   ="); for (uint32_t ii=0;ii<arg1_size/32  ;ii++) pprintf("%08x ",*((((uint32_t *) arg1)+ii))); pprintf("\n");
  // pprintf("   arg2   ="); for (uint32_t ii=0;ii<arg2_size/32  ;ii++) pprintf("%08x ",*((((uint32_t *) arg2)+ii))); pprintf("\n");
  // pprintf("   arg3   ="); for (uint32_t ii=0;ii<arg3_size/32  ;ii++) pprintf("%08x ",*((((uint32_t *) arg3)+ii))); pprintf("\n");

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}

#else
#include <subsystem_defs.h>
//========================================================================================
//Simulation Version
//========================================================================================
volatile uint32_t * const SIM_DDR0_BASE = (volatile uint32_t*)(GLOBAL_RPC_BASE_ADDR);
//const uint32_t SIM_RPC_FIRST_WORD = 0xc0010000;
//const uint32_t SIM_RPC_UPKA_CALL_WORD = 0x0;
//const uint32_t SIM_RPC_SET_K_CALL_WORD = 0x1;
//const uint32_t SIM_RPC_LAST_WORD  = 0xc001ffff;
//const uint32_t SIM_RPC_VERILOG_DONE_WORD = 0xf1f1f1f1;

uint32_t wait_for_rpc_done(){
  pprintf("waiting on verilog to finish rpc()\n");
  while(SIM_DDR0_BASE[0] != SIM_RPC_VERILOG_DONE_WORD);

  pprintf("verilog finished rpc()\n");

  return SIM_DDR0_BASE[1];
}

uint32_t upka_rpc(const uint32_t upka_command, uint32_t * modulus, const uint32_t mod_size, uint32_t *result, const uint32_t result_size, uint32_t * arg1, const uint32_t arg1_size, uint32_t * arg2, const uint32_t arg2_size, uint32_t * arg3, const uint32_t arg3_size){
  
  volatile uint32_t* ptr = SIM_DDR0_BASE;
  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_UPKA_CALL_WORD; // NEED TO DEFINE SOMEWHERE
  *ptr++ = upka_cmd;
  *ptr++ = (uint32_t)result;
  *ptr++ = result_size;
  *ptr++ = (uint32_t)arg1;
  *ptr++ = arg1_size;
  *ptr++ = (uint32_t)arg2;
  *ptr++ = arg2_size;
  *ptr++ = (uint32_t)arg3;
  *ptr++ = arg3_size;
  *ptr++ = SIM_RPC_LAST_WORD;
  return wait_for_rpc_done();
}


#endif


