Steps to build FPGA for the arty-a7-100 board
1. Install AMD/Xilinx Vivado tool suite
2. Place the firmware images (hex file) at ./firmware/cpu0_irom.vhx and ./firmware/cpu0_iram.vhx.
3. Use either of the options below to build FPGA bit flie
   -  ./build_arty_a7 to build with 20MHz sysclk frequency
   -  ./build_arty_a7_33mhz to build with 33MHz sysclk frequency (the run time could be longer compared with the 20MHz case)
5. After the run completes, the resulting bit file is located at ./current_netlist/msftDvIp_cheri_arty7_fpga_cheri_arty7_RUN_*.bit
6. Use Vivado to download the bitfile (or place it in the flash/microSD)
