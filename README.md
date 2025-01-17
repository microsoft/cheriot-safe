# Project

Cheriot-safe (CHERIoT small and fast FPGA emulator)  is an complete FPGA platform for CHERIoT hardware prototyping and embedded software development. It contains a [cheriot-ibex](https://github.com/microsoft/cheriot-ibex) core, CHERIoT-enabled risc-v debug modules, TCM memories, an AXI-based internal bus fabric, and a collection of commonly used peripherals. 

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.


## Setting up Access
```
In a browser go to: https://github.com/microsoft/cheriot-safe
Click on the purple squigily item in the upper right corner. 
Select Settings
Select SSH and GPG keys
Add your SSH key
Authenticate key.
```
## Checking out the Repo
```
git clone git@github.com:microsoft/cheriot-safe.git  <ws>
cd <ws>
git submodule update --init --recursive
```

## Running a verilator simulation
See the readme and examples under [sim/verilator](https://github.com/microsoft/cheriot-safe/tree/main/sim/verilator).

## Running a VCS simulation
1. Review the ./sim/Makefile for the correct path to the vcs simulator.
2. Execute: ./trun hello_world
3. Test output is in ./out/run/hello_world/...

## Building FPGA bitfile
See the readme under [build/](https://github.com/microsoft/cheriot-safe/tree/main/build)

## Board Support
Currently cheriot-safe supports the Diligent Arty A7-100T board. 

## Design documentation
See the [wiki section](https://github.com/microsoft/cheriot-safe/wiki) for more information about the cheri_safe FPGA design

## 65-bit datapath support
For now the 65-bit memory support lives on the "65bit" branch. The only change needed there is to convert the firmware vhx files to 64-bit format (There is a python script at sim/vcs/vhx32to64.py to help with file conversion). 

The FPGA now by default looks for "cpu0_irom64.vhx" and "cpu0_iram64.vhx" for initial memory content. No changes to the FPGA building and the vcs/verilator simulation flow. The UART loader should also work as before. 

