OUTPUT_ARCH( "riscv" ) 
/*ENTRY(_start) */ 
 
SECTIONS 
{ 
  . = 0x20040000; 
  .text.start : {startup.o(.text)} 
  . = ALIGN(0x100); 
  .tohost : { *(.tohost) } 
  . = ALIGN(0x0100); 
  .text : { *(.text) } 
  . = ALIGN(0x0100); 
  . = 0x20044000; 
  .sbss : { *(.sbss) } 
  .rodata : { *(.rodata*) } 
  .data : { *(.data) } 
  .bss : { *(.bss) } 
  _end = .; 
} 
