Steps to build FPGA for the arty-a7-100 board:
1. Install AMD/Xilinx Vivado tool suite
2. Place the firmware images (hex file) at ./firmware/cpu0_irom.vhx and ./firmware/cpu0_iram.vhx.
4. Build the FPGA bit file
   -  ./build_arty_a7 builds bit file with 20MHz sysclk frequency. If you would like to try other frequencies, simply change the SysclkFreq variable to the desired value.
   -  Note, in cheriot-safe design the UART baudrate is derived from the FPGA sysclk. As a result, builds with different sysclk frequencies needs different baudrate settings (and hence different firmware images)
   -  Other examples: ./build_arty_a7_30mhz (30MHz sysclk frequency) and ./build_arty_a7_33mhz (33MHz sysclk frequency).
   -  Also please note that the run time signficantly increases beyond 33MHz
5. After the run completes, the resulting bit file is located at ./current_netlist/msftDvIp_cheri_arty7_fpga_cheri_arty7_RUN_*.bit
6. Use Vivado to download the bitfile to the A7 board (or place it in the flash/microSD)
