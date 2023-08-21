
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
#include <string.h>


#ifndef BACKDOOR_RPC
//========================================================================================
//Non Simulation Version
//========================================================================================

uint32_t dataopen_rpc(const char* filename){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[256];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  psprintf(rpcCmd,"dataopen(\"%s\")",filename);
  callRpc(rpcCmd,errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;

}
uint32_t dataload_rpc(const char* key, uint32_t* dest){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[100];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  psprintf(rpcCmd,"dataload(\"%s\",%08x)",key, dest);
  callRpc(rpcCmd,errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}
uint32_t dataclose_rpc(){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  callRpc("dataclose()",errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;

}
#else
#include <subsystem_defs.h>
//========================================================================================
//Simulation Version
//========================================================================================
uint32_t dataopen_rpc(const char* filename){
  volatile uint32_t* ptr = SIM_DDR0_BASE;
  int u32s = strlen(filename)/4 + ((strlen(filename) % 4 == 0) ? 0 : 1);

  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_DATAOPEN_CALL_WORD;
  strcpy((char*)ptr, filename);
  ptr += u32s;
  *ptr++ = SIM_RPC_LAST_WORD;
  return wait_for_rpc_done();
}
uint32_t dataload_rpc(const char* key, uint32_t* dest){
  volatile uint32_t* ptr = SIM_DDR0_BASE;
  int u32s = strlen(key)/4 + ((strlen(key) % 4 == 0) ? 0 : 1);

  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_DATALOAD_CALL_WORD;
  *ptr++ = (uint32_t)dest;
  strcpy((char*)ptr, key);
  ptr += u32s;
  *ptr++ = SIM_RPC_LAST_WORD;
  return wait_for_rpc_done();

}
uint32_t dataclose_rpc(){
  volatile uint32_t* ptr = SIM_DDR0_BASE;

  *ptr++ = SIM_RPC_FIRST_WORD;
  *ptr++ = SIM_RPC_DATACLOSE_CALL_WORD;
  *ptr++ = SIM_RPC_LAST_WORD;
  return wait_for_rpc_done();
}

#endif
