
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

uint32_t reset_rpc(){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  callRpc("reset()",errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;

}

uint32_t hsp_reset_rpc(){
  const int RES_LEN = 12+1;            //+1 for \0 at end of string
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  callRpc("hsp_reset()",errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;

}

uint32_t por_reset_rpc(){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  callRpc("por_reset()",errorsStr,RES_LEN);

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;

}

uint32_t reset_count_rpc(){
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char countStr[RES_LEN];
  uint32_t count;
  callRpc("reset_count()",countStr,RES_LEN);
  count = ConvertHexString2Int(countStr,8);
  return count;
}

uint32_t hsp_reset_count_rpc(){
  const int RES_LEN = 4+1;            //+1 for \0 at end of string
  char countStr[RES_LEN];
  uint32_t count;
  callRpc("hsp_reset_count()",countStr,RES_LEN);
  count = ConvertHexString2Int(countStr,8);
  return count;
}

uint32_t por_reset_count_rpc(){
  const int RES_LEN = 4+1;            //+1 for \0 at end of string
  char countStr[RES_LEN];
  uint32_t count;
  callRpc("por_reset_count()",countStr,RES_LEN);
  count = ConvertHexString2Int(countStr,8);
  return count;
}

uint32_t reset_load() {
  const char cmdFmt[] = "loadstore(LW,%08x)";
  const int CMD_LEN = 12+8+1+1+1;  //based off the format string, 1 8 char words, a comma, a ) and a \0
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;
  volatile uint32_t data;

  //format the call and call the rpc
  psprintf(rpcCmd, 
	   cmdFmt, 
	   &data
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);
  
  if(errors) {
    pprintf("ERROR: reset_load returned non zero value %d\n",errors);
  }

  return data;
}

uint32_t reset_store(uint32_t data) {
  const char cmdFmt[] = "loadstore(SW,%08x)";
  const int CMD_LEN = 12+8+1+1+1;  //based off the format string, 1 8 char words, a comma, a ) and a \0
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;
  
  //format the call and call the rpc
  psprintf(rpcCmd, 
	   cmdFmt, 
	   data
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));
  
  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}

#else
DIE.  reset rpc not supported for backdoor rpc.  backdoor rpc is legacy
#endif
