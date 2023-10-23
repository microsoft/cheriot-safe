The hello_world example prints out a hello message on the UART and blinks 2 LEDs (J5 and T9 on arty A7 board). 

1. The hello_world.c contains the main function for the example.
2. the csrc_cheri/ directory contains common startup files and utilities (uart communcation, etc) that may be reused to develop other applications. 
3. Build script (./build_fpga_test.sh) and link script (./link_fpga_test.ld) are also provided as examples. The build script needs to be modified to match your tool installation paths.


