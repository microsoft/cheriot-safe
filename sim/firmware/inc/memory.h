
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

#define IMEM_START_ADDR       0x20000000
#define IMEM_END_ADDR         0x2007FFFF
#define DVP_IROM_ADDR_START   0x20000000
#define DVP_IROM_ADDR_END     0x20010000
#define DVP_IRAM_ADDR_START   0x20040000
#define DVP_IRAM_ADDR_END     0x2007FFFF

#define DMEM_START_ADDR       0x20080000
#define DMEM_END_ADDR         0x200FFFFF

#define DVP_DRAM_ADDR_START   0x200F0000
#define DVP_DRAM_ADDR_END     0x200FFFFF

#define DVP_APB_ADDR_START    0x200E0000
#define DVP_APB_ADDR_END      0x200EFFFF

#define DVP_MSPI_ADDR         DVP_APB_ADDR_START
