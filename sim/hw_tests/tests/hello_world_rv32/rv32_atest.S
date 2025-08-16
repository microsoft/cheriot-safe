#.option norelax

.section .text
.globl rv32_atest

#
#  Register allocation for this test
#


#  ///////////////////////////////////////
#  init
#  ///////////////////////////////////////

test_init:
    addi sp, sp, -16
    sw ra, (sp)
    
    lw ra, (sp)
    addi sp, sp, 16 
    ret

#  ///////////////////////////////////////
#  --- cheri_test (main test for CHERI instructions)
#  ///////////////////////////////////////

rv32_atest:
    addi sp, sp, -16
    sw ra, (sp)
       
    # save register context so that we won't have issue talking with the C program 
    # note RISC-V uses x10/x11 (a0/a1) for args/return values, and x12-x17 (a2-7) for args

    call test_init

    j test_exit

test_exit:
    # restore register context
    addi a0, x0, 0
    addi a1, x0, 0
    lw ra, (sp)
    addi sp, sp, 16 
    ret

.section .rodata

hello_msg :
  .string "Doing something in assembly..\n"

#.section .tohost
#tohost :
#  .dword 0
#fromhost :
#  .dword 0
