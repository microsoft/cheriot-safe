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
