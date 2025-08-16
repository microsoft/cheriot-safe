// .globl cheri_fault_handler
.section .text
.globl cheri_intr_init
.globl cheri_sw_intr_test
.globl cheri_tmr_intr_test
.globl cheri_tsafe_test
.globl cheri_tbre_test
.globl cheri_stkclr_test
.globl cheri_dmb_test
.globl get_mmreg_base 
.globl read_mcycle

read_mcycle:
    csrr a0, mcycle
    cret

/////////////////////////////////////////////////////////
//  ISR
/////////////////////////////////////////////////////////


.align 4    # mtvec must align to 4-byte boundary
cheri_fault_handler:  
    cincoffset csp, csp, -32    
    csc cra, 0(csp)
    csc ct0, 8(csp)
    csc ct1, 16(csp)
    nop
    
    csrr t0, mcause
    andi t0, t0, 0xff
    li   t1, 3 
    bne  t0, t1, isr_n1
    li    t1, 0x8             // clear the sw mie bit
    csrrc t0, mie, t1
    j isr_done

isr_n1:
    li   t1, 7
    bne  t0, t1, isr_n2
    li    t1, 0x80            // clear the tmr mie bit
    csrrc t0, mie, t1
    j isr_done

isr_n2:
    li   t1, 11 
    bne  t0, t1, isr_done
    li    t1, 0x800           // clear the tmr mie bit
    csrrc t0, mie, t1
    j isr_done

isr_done:
    nop
    clc cra, 0(csp)
    clc ct0, 8(csp)
    clc ct1, 16(csp)
    cincoffset csp, csp, 32     
    mret

/////////////////////////////////////////////////////////
// Setting up interrupt 
/////////////////////////////////////////////////////////

cheri_intr_init:
    cincoffset csp, csp, -32
    csc ct0, 0(csp)
    csc ct1, 8(csp)
    csc ct2, 16(csp)

    // setup ISR vector
    cspecialr ct0, mtcc
1:    auipcc  ct1, %cheri_compartment_pccrel_hi(cheri_fault_handler)
    cincoffset ct1, ct1, %cheri_compartment_pccrel_lo(1b)
    csetaddr ct0, ct0, t1
    cspecialw mtcc, ct0                 # bit0 = 1'b0: single ISR mode

    // setup PLIC 
    cspecialr ct0, mtdc
    li t1, 0x10000000                  # PLIC PRI registers 
    csetaddr ct0, ct0, t1
    li t1, 7 
    csw t1, 4(ct0)                      # source ID 1 (irqs 0, tbre)
    li t1, 5
    csw t1, 8(ct0)                      # source ID 2 (irqs 1, periph)

    li t1, 0x10200000                  # PLIC intr threshold
    csetaddr ct0, ct0, t1
    li t1, 5 
    csw t1, (ct0)                       

    li t1, 0x10002000                  # PLIC intr enable
    csetaddr ct0, ct0, t1
    li t1, 3
    csw t1, (ct0)                        

    li t1, 0x800                        # enable machine-mode ext(/tmr/sw) interrupts
    csrs mie, t1

    clc ct0, 0(csp)
    clc ct1, 8(csp)
    clc ct2, 16(csp)
    cincoffset csp, csp, 32 
    cret

/////////////////////////////////////////////////////////
// SW interrupt test
/////////////////////////////////////////////////////////

cheri_sw_intr_test:
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)

    li x9, 0x008                        # enable machine-mode ext/tmr/sw interrupts
    csrs mie, x9

    cspecialr c5, mtdc
    li x11, 0x14001000                  # CLINT reg base
    csetaddr c5, c5, x11
    li x11, 1
    csw x11, (c5)                       # set software interrupt

    nop
    nop
    nop
    csrr x9, mcause
    andi x9, x9, 0xff
    li   x8, 0x3
    bne x8, x9, sw_intr_fail
    li a0, 0
    j sw_intr_done

sw_intr_fail:
    li a0, 0xf1
    j sw_intr_done

sw_intr_done:
    li x11, 0
    csw x11, (c5)                         # clear software interrupt
    
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 
    cret

/////////////////////////////////////////////////////////
//  Timer interrupt test
/////////////////////////////////////////////////////////

cheri_tmr_intr_test:
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)


    cspecialr c5, mtdc
    li x11, 0x14001010                  # CLINT mtimecmp_lo
    csetaddr c5, c5, x11
    li x11, 0xffffffff                  # set mtimecmp to a large value to clear timer interrupt
    csw x11, 8(c5)                       

    li x9, 0x080                        # enable machine-mode ext/tmr/sw interrupts
    csrs mie, x9

    clw x11, (c5)
    addi x11, x11, 0xff
    csw x11, 8(c5)                      # set mtimecmp = mtime+255
    nop
    wfi
    nop
    csrr x9, mcause
    andi x9, x9, 0xff
    li   x8, 0x7
    bne x8, x9, tmr_intr_fail
    li a0, 0
    j tmr_intr_done

tmr_intr_fail:
    li a0, 0xf1
    j tmr_intr_done

tmr_intr_done:
    li x11, 0xffffffff                  # set mtimecmp to a large value to clear timer interrupt
    csw x11, 8(c5)                       
    
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 
    cret

/////////////////////////////////////////////////////////
// test tsafe revocation
/////////////////////////////////////////////////////////

cheri_tsafe_test:
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)

    
    cspecialrw c6, 29, c0         # read MTDC address 'd29, memory root
    lui x11, 0x20048
    csetaddr c6, c6, x11          # set address to 0x2004_8000
    cmove c8, c6

    # build a new capability in c11
    li x11, 0x2004daf0
    csetaddr c11, c6, x11
    csetboundsimm c11, c11, 0x800    

    # store + load, unrevoked
    csc c11, 32(c8)
    clc c9, 32(c8)
    csetequalexact x12, c9, c11
    beq x12, x0, tsafe_fail1

    # revoke the memory pointed by c11
    li x12, 0x200fe36b
    csetaddr c13, c6, x12      # set address to revocation map 
    li x12, 0x40
    csb x12, 0(c13)            # set revocation map bit

    clc c9, 32(c8)
    cgettag x12, c9
    bne x12, x0, tsafe_fail2   # returned cap.tag should be cleared

    addi a0, x0, 0x0
    j tsafe_done

tsafe_fail1: 
    addi a0, x0, 0xf1
    j tsafe_done

tsafe_fail2: 
    addi a0, x0, 0xf2
    j tsafe_done

tsafe_done:
    //
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 

    cret

/////////////////////////////////////////////////////////
// test TBRE
/////////////////////////////////////////////////////////

cheri_tbre_test: 
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)

    cspecialrw c6, 29, c0    # read MTDC address 'd29, memory root
    lui x11, 0x20048
    csetaddr c6, c6, x11          # set address to 0x2008_0000
    cmove c8, c6

    # build a new capability in c11 (again)
    li x11, 0x2004daf0
    csetaddr c11, c6, x11
    csetboundsimm c11, c11, 0x800    # set lengths to 0x800, base/address to 0x2001_1000

    # store it to memory starting 0x20048000 
    li x9, 256 
tbre_init:
    csc c11, 0(c8)
    cincoffset c8, c8, 8
    addi x9, x9, -1
    bne x9, x0, tbre_init

    cspecialrw c5, mtdc, c0       # read MTDC address 'd29, memory root
    li x11, 0x14000000
    csetaddr c5, c5, x11          # set address to tbre_regs

    clw x11, 8(c5)
    srli x11, x11, 24
    addi x12, x0, 0x55
    bne x11, x12, tbre_fail1      # TBRE not implemented, don't run

    #kick of TBRE engine
    li x11, 0x20048000
    csw x11, (c5)          # TBRE start address
    li x11, 0x200483fc
    csw x11, 4(c5)          # TBRE end address

    li x11, 0x1
    csw x11, 8(c5)          # TBRE kick

    li x11, 0x1
    csw x11, 20(c5)         # TBRE interrupt enable

    wfi
 
    csrr x9, mcause
    andi x9, x9, 0xff
    li   x8, 11
    bne x8, x9, tbre_fail2
    
    cspecialr c4, mtdc
    li x11, 0x10200004                  # PLIC claim register
    csetaddr c4, c4, x11
    clw x11, (c4)
    li x12, 1
    bne x11, x12, tbre_fail2            # claim ID must = 1
    csw x11, (c4)                       # send completion to PLIC

    clw x11, 16(c5)         # interrupt status
    bne x11, x0, tbre_fail2
    

    clw x11, 12(c5)         # epoch
    andi x11, x11, 0xff
    li x12, 0x2
    bne x11, x12, tbre_fail3

    cmove c8, c6
    clc c9, 0(c8)
    cgettag x12, c9
    bne x12, x0, tbre_fail3   # returned cap.tag should be cleared

    addi a0, x0, 0
    j tbre_done

tbre_fail1: 
    addi a0, x0, 0xe1
    j tbre_done

tbre_fail2: 
    addi a0, x0, 0xe2
    j tbre_done

tbre_fail3: 
    addi a0, x0, 0xe3
    j tbre_done

tbre_done:
    //
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 

    cret

/////////////////////////////////////////////////////////
// test stkclr
/////////////////////////////////////////////////////////

cheri_stkclr_test: 
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)

    cspecialr c8, mtdc
    li x12, 0x20050020          
    li x11, 0x2005007c           
    csetaddr c8, c8, x11
    li x11, 0xffffffff
fill_stack:
    csw x11, (c8)
    cincoffset c8, c8, -4
    bne x8, x12, fill_stack

    # test stack clearing with CPU activity
    li x11, 0x20050020
    csetaddr c8, c8, x11

    li x11, 0x20050020
    csetaddr c9, c8, x11
    csetboundsimm c9, c9, 0x60    # stack 
    li x11, 0x20050080
    csetaddr c9, c9, x11

    cspecialw 27, c9              # kickoff stkclr


    li x13, 0xaa5555aa            # this should go through immediately
    csw x13, 188(c8)
              
    li x14, 0xdeadbeef            # this should stall till aborted then restart
    csw x14, (c8)               

    clw x11, 188(c8)              # check CPU write value
    clw x12, (c8)
    bne x13, x11, stkclr_fail
    bne x14, x12, stkclr_fail

    
    li x11, 0x20050020            # check stack clearing 
    csetaddr c9, c9, x11
    ccleartag c9, c9
    cspecialr c11, 27             # progress 
    csetequalexact x11, c11, c9 
    beq x11, x0, stkclr_fail
    
    li x12, 0x20050024
    li x11, 0x2005007c            # check stack clearing 
    csetaddr c8, c8, x11
chk_clr:
    cincoffset c8, c8, -4
    clw x11, (c8)
    bne x11, x0, stkclr_fail
    bne x8, x12, chk_clr

    j stkclr_done

stkclr_fail: 
    addi a0, x0, 0xe1
    j stkclr_done

stkclr_done:
    //
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 

    cret

/////////////////////////////////////////////////////////
// DMB (ext memory) test
/////////////////////////////////////////////////////////

cheri_dmb_test:
    cincoffset csp, csp, -88    # SP-16
    csc c1, 0(csp)
    csc c3, 8(csp)
    csc c4, 16(csp)
    csc c5, 24(csp)
    csc c6, 32(csp)
    csc c7, 40(csp)
    csc c8, 48(csp)
    csc c9, 56(csp)

    cspecialrw c6, 29, c0         # read MTDC address 'd29, memory root
    li x11, 0x8f0f0000            # DMB base
    csetaddr c6, c6, x11          

    # configuring DMB
    #*(dmbBase + 0x48/4)  = 0x00028012;     // seg 18 (0x9000_0000)
    li x11, 0x00028012
    csw x11, 72(c6)
    #*(dmbBase + 0x110/4) = 0xffffffff;
    li x11, 0xffffffff
    csw x11, 272(c6)
    #*(dmbBase + 0x114/4) = 0xffffffff;
    li x11, 0xffffffff
    csw x11, 276(c6)
    #*(dmbBase + 0x4c/4)  = 0x00028014;     // seg 19 (0x9800_0000)
    li x11, 0x00028014
    csw x11, 76(c6)
    #*(dmbBase + 0x118/4) = 0xffffffff;
    li x11, 0xffffffff
    csw x11, 280(c6)
    #*(dmbBase + 0x11c/4) = 0xffffffff;
    li x11, 0xffffffff
    csw x11, 284(c6)
    #*(dmbBase + 0x300/4) = 0x000c0000;     // privilege permission
    li x11, 0x000c0000
    csw x11, 768(c6)
    #*(dmbBase + 0x304/4) = 0x000c0000;
    li x11, 0x000c0000
    csw x11, 772(c6)
    #*(dmbBase + 0x308/4) = 0x000c0000; 
    li x11, 0x000c0000
    csw x11, 776(c6)

    li x11, 0x90000000            # exmem base
    csetaddr c6, c6, x11         
    li x8, 0x12345678
    csw x8, (c6)
    clw x9, (c6)
    li x8, 0xdeadbeef
    csw x8, 4(c6)   
    clw x9, 4(c6)
    li x8, 0x55aaaa55
    csw x8, 8(c6)   
    clw x9, 8(c6)
    li x8, 0x33444433
    csw x8, 12(c6)
    csw x8, 16(c6)
    clw x9, 12(c6)
    clw x9, 16(c6)


    li x11, 0x90000000            # exmem base
    csetaddr c6, c6, x11         
    li x8, 0x00abcdef          
    csw x8, (c6)

    li x8, 0x12345678
    csw x8, 4(c6)

    clw x9, (c6) 
    li x8, 0x00abcdef          
    bne x8, x9, dmb_fail

    clw x9, 4(c6) 
    li x8, 0x12345678
    bne x8, x9, dmb_fail

    li a0, 0
    j dmb_done

dmb_fail:
    li a0, 0xd1
    j dmb_done

dmb_done:
    clc c1, 0(csp)
    clc c3, 8(csp)
    clc c4, 16(csp)
    clc c5, 24(csp)
    clc c6, 32(csp)
    clc c7, 40(csp)
    clc c8, 48(csp)
    clc c9, 56(csp)
    cincoffset csp, csp, 88 
    cret

/////////////////////////////////////////////////////////
// get base for MMREG 
/////////////////////////////////////////////////////////

get_mmreg_base:
    cincoffset csp, csp, -8    # SP-16
    csc ca1, (csp)

    cspecialr ca0, mtdc
    li a1, 0x14000000            # begining of MAC regs
    csetaddr ca0, ca0, a1         

    clc ca1, (csp)
    cincoffset csp, csp, 8 
    cret

.section .rodata

//hello_msg :
//  .string "I am CHERI.. Hello world!\n"
