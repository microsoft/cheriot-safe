Steps to run a verilog simulation
0. place the firmware hex images under ./firmware/
1. run ./vgen to convert verilog source files to c++
2. run ./vcomp to compile/link into an executable
3. run the executable (by default it is obj_dir/Vswci_vtb)

You can run the scripts from any where as long as the $DesignRoot in vgen script points to the right locaiton of verilog files. 
The verilog wrapper (swci_vtb) takes care of printing out UART messages.

This simulation setup looks for 2 hex images, ./firmware/cpu0_irom.hex and ./firmware/cpu0_iram.hex. 
IROM is read-only and limited in size, so best just jump to iram right away after booting. The following example of cpu0_irom.hex jumps to 20040080. 
Note, CPU boot address remains at 0x2000_0080.

      1 00000000
      2 00000000
      3 00000000
      4 00000000
      5 00000000
      6 00000000
      7 00000000
      8 00000000
      9 00000000
     10 00000000
     11 00000000
     12 00000000
     13 00000000
     14 00000000
     15 00000000
     16 00000000
     17 00000000
     18 00000000
     19 00000000
     20 00000000
     21 00000000
     22 00000000
     23 00000000
     24 00000000
     25 00000000
     26 00000000
     27 00000000
     28 00000000
     29 00000000
     30 00000000
     31 00000000
     32 00000000
     33 00080297
     34 000282E7
     35 00000000

First instructions executed after boot:
        3505000          5      20000080        00080297        CH.auipcc       c5, 0x80          x5=0x20040080+0x15e3e0000
        3555000          6      20000084        000282e7        CH.cjalr        c5,0(c5)          x5:0x20040080+0x15e3e0000  x5=0x20000088+0x15ebe0000
