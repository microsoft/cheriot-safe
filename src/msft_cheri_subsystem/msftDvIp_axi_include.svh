
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



typedef struct packed {
  logic [3:0]                     region;
  logic [AXI_USER_WIDTH-1:0]      user;
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_ADDR_WIDTH-1:0]      addr;
  logic [AXI_LEN_WIDTH-1:0]       len;
  logic [2:0]                     size;
  logic [1:0]                     burst;
  logic [3:0]                     cache;
  logic [1:0]                     lock;
  logic [2:0]                     prot;
  logic [3:0]                     qos;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} ADDR_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_DATA_WIDTH-1:0]      data;
  logic [(AXI_DATA_WIDTH/8)-1:0]  strb;
  logic                           last;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} WDATA_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_DATA_WIDTH-1:0]      data;
  logic                           last;
  logic [1:0]                     resp;
  logic [MGR_ID_BITS-1:0]         mgrnum;
  //logic [$clog2(NUM_SLAVES)-1:0]  slvnum;
} RDATA_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [1:0]                     resp;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} RESP_PHASE_t;


