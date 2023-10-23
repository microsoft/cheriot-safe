SECTIONS
{

  . = 0x20040000;
  .pcc : 
  {
    HIDDEN(__pcc_start = .);
  . = 0x20040080;
    startup.o(.text)
    . = ALIGN(0x100);
    *(.text .text.*);
    *(.data.rel.ro);
    *(.rodata .rodata.*);
    HIDDEN(__pcc_end = .);
  }

  . = 0x20042000;
  .cgp : ALIGN(0x8)
  {
    HIDDEN(__cgp_start = .);
    *(.data .data.*);
    *(.sdata .sdata.*);
    *(.bss .bss.*);
    *(.sbss .sbss.*);
    HIDDEN(__cgp_end = .);
  }

  __cap_relocs :
  {
    __cap_relocs = .;
  }
  __cap_relocs_end = .;

}
