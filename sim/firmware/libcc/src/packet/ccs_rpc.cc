
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

uint32_t ccs_rpc(ccs_model_t * ccs_model_data, uint32_t *result){
  const char cmdFmt[] = "ccs(%08x,%08x)";
  const int CMD_LEN = 4+8*2+1+1+1;  //based off the format string 2 8 char words, a comma, a ) and a \0
  const int RES_LEN = 8+1;            //+1 for \0 at end of string
  char rpcCmd[CMD_LEN];
  char errorsStr[RES_LEN];
  uint32_t errors = 0;

  pprintf("starting ccs cmodel\n");

  //format the call and call the rpc
  psprintf(rpcCmd, 
	   cmdFmt, 
	   (uint32_t)ccs_model_data,
	   result
	   );
  callRpc(rpcCmd,errorsStr,sizeof(errorsStr));

  pprintf("done with ccs cmodel\n");

  //Deal with the return values
  errors = ConvertHexString2Int(errorsStr,8);

  return errors;
}
