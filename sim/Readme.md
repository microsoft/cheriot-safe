The cheriot-safe simulation environment uses 2 hex images for code execution.
- for MCU configuration 0 (ibex 33 bit), ./firmware/cpu0_irom.hex and ./firmware/cpu0_iram.hex 
- for MCU configuration 1 and 2, ./firmware/cpu0_irom64.hex and ./firmware/cpu0_iram64.hex
- See [../hw_tests](https://github.com/microsoft/cheriot-safe/tree/main/sim/hw_tests) for examples on genearating the images.

As a convention, writing any value >= 0x80 to UART (0x8f00b000) stops the simulation.

### Steps to run a verilog simulation using VCS

1. cd sim/vcs
2. place the irom/iram firmware hex images under ./firmware/
3. compile/link into an executable: 
   - ./vcscomp [-conf1] [-conf2] [-rv32] 
4. run the executable (./simv) 

### Steps to run a verilog simulation using Verilator
1. cd sim/verilator
2. place the irom/iram firmware hex images under ./firmware/
3. compile/link into an executable: 
   - ./vgen [-conf1] [-conf2] [-rv32] 
   - ./vcomp
4. run the executable (./obj_dir/Vswci_vtb)
   - The testbenches exit value is the lower 7-bit of the byte written to UART. There is also a timeout (defined MAX_SIM_TIME in swci_main.cc) which defaults to 100M cycles, the exit code for timeout is 0xfe.



