
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


#ifndef  __MSFTDVPKG_APB_INIT_H__
#define 	__MSFTDVPKG_APB_INIT_H__

#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif

extern int apb_init();
extern void rdApb(uint32_t addr, uint32_t *data, uint32_t* error);
extern void wrApb(uint32_t addr, uint32_t  data, uint32_t* error);
extern void clkBus(uint32_t cnt);
extern void setError();

#ifdef __cplusplus
}
#endif

#define __DPI_APB__

static inline uint32_t jc_read32(uint32_t addr)
{
	uint32_t data;
	uint32_t error;

	rdApb(addr, &data, &error);
	return data;
}

static inline void jc_write32(uint32_t addr, uint32_t data)
{
	uint32_t error;
	wrApb(addr, data, &error);
}


#endif
