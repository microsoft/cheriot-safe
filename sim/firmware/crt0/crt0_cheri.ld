
/*
=====================================================
Copyright (c) Microsoft Corporation.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=====================================================
*/

ENTRY(__start)

MEMORY
{
  IROM    (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00004000
  IRAM    (rwx) : ORIGIN = 0x20040000, LENGTH = 0x00010000
  DRAM    (rwx) : ORIGIN = 0x200F0000, LENGTH = 0x00008000
}

REGION_ALIAS("REGION_PCC", 	IRAM);
REGION_ALIAS("REGION_CGP", 	DRAM);

CAPSIZE = 8;

SECTIONS
{
	.init 		:
	{
		KEEP (*(.boot.init0))
		KEEP (*(.boot.init1))
		KEEP (*(.boot.init2))
		KEEP (*(.boot.init3))
	} >REGION_PCC

  __cap_relocs : 
  {
    __cap_relocs = .;
    
	} >REGION_PCC

  __cap_relocs_end = .;

	.text : CAPALIGN
	{
        _pcc_start = .;
        _code_start = .;
		*(.text .text.*)
        _code_end = .;
        _rodata_start = .;
		*(.rodata .rodata.*)
		*(.data.rel.ro)
        _rodata_end = .;
	} >REGION_PCC
	. = ALIGN(CAPSIZE);
	_pcc_end = .;

	.data : AT (_pcc_end) CAPALIGN
	{
		_cgp_start = .;
		_data_start = .;
		*(.data .data.* .sdata .sdata.*)
		_data_end = .;
		_bss_start = .;
		*(.sbss .sbss.* .bss .bss.*)
		_bss_end = .;
	} >REGION_CGP
	. = ALIGN(CAPSIZE);

	_cgp_end = .;

	_heap_start = .;
	/* Stack start and end must align at 16-byte boundaries per RISC-V. */
	_stack_start = ORIGIN(DRAM) + LENGTH(DRAM);
	__stack_size = 0x1000;
	_stack_end = _stack_start - __stack_size;
	_heap_end = _stack_end;
}
