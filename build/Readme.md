Steps to build FPGA for the arty-a7-100 board
1. Install AMD/Xilinx Vivado tool suite
2. Place the firmware images (hex file) at `./firmware/cpu0_irom.vhx` and `./firmware/cpu0_iram.vhx`.
   An example way of generating this hex file from an elf is: `riscv32-unknown-elf-objcopy -O ihex <path_to_elf> <path_to_hex>/image.hex
`
3. Run `./build_arty_a7` to build bit file for arty A7-100 FPGA
4. After the run completes, the resulting bit file is located at `./current_netlist/msftDvIp_cheri_arty7_fpga_cheri_arty7_RUN_*.bit`
5. Use Vivado to download the bitfile (or place it in the flash/microSD)
