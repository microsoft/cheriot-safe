
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

// Copyright (C) Microsoft Corporation. All rights reserved.

#include <inttypes.h>

#ifndef __LINKER_HEADER_INC__
#define __LINKER_HEADER_INC__


extern uint32_t _stack_start;
extern uint32_t _heap_start;
extern uint32_t _heap_end;

extern uint32_t _code_start;
extern uint32_t _text_data_size;
extern uint32_t _text_data_word_size;

extern uint32_t _data_start;
extern uint32_t _data_size;
extern uint32_t _data_word_size;
extern uint32_t _start_text_data;

extern uint32_t _bss_start;
extern uint32_t _bss_size;
extern uint32_t _bss_word_size;


#define LD_CODE_START           ((uint32_t*)&_code_start)
#define LD_TEXT_DATA_SIZE       ((uint32_t )&_text_data_size)
#define LD_TEXT_DATA_WORD_SIZE  ((uint32_t )&_text_data_word_size)

#define LD_DATA_START           ((uint32_t*)&_data_start)
#define LD_DATA_SIZE            ((uint32_t )&_data_size )
#define LD_DATA_WORD_SIZE       ((uint32_t )&_data_word_size)
#define LD_START_TEXT_DATA      ((uint32_t*)&_start_text_data)

#define LD_BSS_START            ((uint32_t*)&_bss_start)
#define LD_BSS_SIZE             ((uint32_t )&_bss_size)
#define LD_BSS_WORD_SIZE        ((uint32_t )&_bss_word_size)

#endif
