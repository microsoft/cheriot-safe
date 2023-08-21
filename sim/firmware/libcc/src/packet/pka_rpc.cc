
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

uint32_t pka_rpc(pka_cmd_t * pka_command, uint32_t *result, int rand, pka_arg_sizes pka_sizes){
  const char cmdFmt[] = "pka(%08x,%08x,%08x,%08x,%08x,%08x,%08x)";
  const int CMD_LEN = 4+(9*7-1)+1+1;  //based off the format string
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  //format the call and call the rpc
  psprintf(rpcCmd, 
	   cmdFmt, 
	   (uint32_t)pka_command,
	   result, 
	   rand, 
	   pka_sizes.result_size, 
	   pka_sizes.arg1_size,
	   pka_sizes.arg2_size,
	   pka_sizes.arg3_size
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}


uint32_t pka_ecc_set_k_rpc(uint32_t *arg, int arg_size_in_bits){

  const char cmdFmt[] = "pka_ecc_set_k(%08x,%08x)";
  const int CMD_LEN = 14+(9*2-1)+1+1;  //based off the format string
  const int RES_LEN = 8+1;             //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  //format the call and call the rpc
  psprintf(rpcCmd, 
	   cmdFmt, 
	   (uint32_t)arg,
	   arg_size_in_bits 
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));

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
//const uint32_t SIM_RPC_PKA_CALL_WORD = 0x0;
//const uint32_t SIM_RPC_SET_K_CALL_WORD = 0x1;
//const uint32_t SIM_RPC_LAST_WORD  = 0xc001ffff;
//const uint32_t SIM_RPC_VERILOG_DONE_WORD = 0xf1f1f1f1;

uint32_t wait_for_rpc_done(){
  pprintf("waiting on verilog to finish rpc()\n");
  while(SIM_DDR0_BASE[0] != SIM_RPC_VERILOG_DONE_WORD);

  pprintf("verilog finished rpc()\n");

  return SIM_DDR0_BASE[1];
}

uint32_t pka_rpc(pka_cmd_t * pka_command, uint32_t *result, int rand, pka_arg_sizes pka_sizes){
  volatile uint32_t* ptr = SIM_DDR0_BASE;
  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_PKA_CALL_WORD;
  *ptr++ = (uint32_t)pka_command;
  *ptr++ = (uint32_t)result;
  *ptr++ = rand;
  *ptr++ = pka_sizes.result_size;
  *ptr++ = pka_sizes.arg1_size;
  *ptr++ = pka_sizes.arg2_size;
  *ptr++ = pka_sizes.arg3_size;
  *ptr++ = SIM_RPC_LAST_WORD;
  return wait_for_rpc_done();
}

uint32_t pka_ecc_set_k_rpc(uint32_t *arg, int arg_size_in_bits){
  volatile uint32_t* ptr = SIM_DDR0_BASE;
  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_SET_K_CALL_WORD;
  *ptr++ = (uint32_t)arg;
  *ptr++ = arg_size_in_bits;
  *ptr++ = SIM_RPC_LAST_WORD;

  return wait_for_rpc_done();
}

#endif


