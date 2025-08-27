## Project

Cheriot-safe (CHERIoT small and fast FPGA emulator)  is an complete FPGA platform for CHERIoT hardware prototyping and embedded software development. It contains a CHERIoT-enabled MCU core ([cheriot-ibex](https://github.com/microsoft/cheriot-ibex) or [cheriot-kudu](https://github.com/microsoft/cheriot-kudu)), CHERIoT-enabled risc-v debug modules, TCM memories, an AXI-based internal bus fabric, and a collection of commonly used peripherals. 

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
Select SSH and GPG keys,
Add your SSH key
Authenticate key.
```
## Checking out the Repo
```
git clone git@github.com:microsoft/cheriot-safe.git  <ws>
cd <ws>
git submodule update --init --recursive
```
## MCU configurations supported
cheriot-safe currently support 3 MCU configurations:
- configuation 0 (default): cheriot-ibex with 33-bit data interface
- configuation 1: cheriot-ibex with 65-bit data interface
- configuation 2: cheriot-kudu (always use 65-bit data interface)

The simulation and build scripts allows
- choosing configurations via command line swithces (-conf1, -conf2).
- selecting between the CHERIoT mode and RV32 mode (which runs rv32imc images) by -rv32 switch.

## Running a vcs or verilator simulation
See the readme and examples under [sim/](https://github.com/microsoft/cheriot-safe/tree/main/sim).

## Building FPGA bitfile
See the readme under [build/](https://github.com/microsoft/cheriot-safe/tree/main/build)

## Board Support
Currently cheriot-safe runs on the Diligent Arty A7-100T board. 

## Design documentation
See the [wiki section](https://github.com/microsoft/cheriot-safe/wiki) for more information about the cheriot-safe FPGA design

