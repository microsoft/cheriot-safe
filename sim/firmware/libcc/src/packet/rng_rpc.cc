
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

uint32_t rng_rpc(uint32_t * txt_ptr, uint32_t num_txt_bytes, uint32_t * key_ptr, uint32_t * val_ptr, uint32_t * result_ptr){
  const char cmdFmt[] = "rng(%08x,%08x,%08x,%08x,%08x)";
  const int CMD_LEN = 4+8*5+1+1+1;  //based off the format string 5 8 char words, a comma, a ) and a \0
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  ////format the call and call the rpc
  psprintf(rpcCmd, 
           cmdFmt, 
           txt_ptr,
           num_txt_bytes,
           key_ptr,
           val_ptr,
           result_ptr
           );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));

  ////Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}

