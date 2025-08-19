##Steps to build FPGA for the arty-a7-100 board:
1. Install AMD/Xilinx Vivado tool suite
2. Place the firmware images (hex file) at ./firmware/cpu0_iram.vhx, or /firmware/cpu0_iram64.vhx if you are using configuration conf1 or conf2.
4. Build the FPGA bit file
   -  ./build_arty_a7 [-conf1] [-conf2] [-rv32] [-freq num] 
   -  currently supported frequency: 20, 30, 33 (MHz)
      -- Note, in cheriot-safe design the UART baudrate is derived from the FPGA sysclk. As a result, builds with different sysclk frequencies needs different baudrate settings (and hence different firmware images)
      -- Also please note that the run time signficantly increases beyond 33MHz
5. After the run completes, the resulting bit file is located at ./current_netlist/msftDvIp_cheri_arty7_fpga_cheri_arty7_RUN_*.bit
6. Use Vivado to download the bitfile to the A7 board (or place it in the flash/microSD)
