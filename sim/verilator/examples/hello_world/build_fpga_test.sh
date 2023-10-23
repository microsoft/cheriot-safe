#!/bin/bash 
 
set -e 

#source ../scripts/common_setup.sh
mkdir -p firmware
cd firmware
pwd

export TESTNAME=hello_world
export SIM_HOME=.
export CSRC=$SIM_HOME/csrc_cheri
export SRC=$SIM_HOME/
export C_COMMON="$CSRC/cstart.c $CSRC/util.c"
export C_FILES="$SRC/hello_world.c $C_COMMON"
export S_FILES="$CSRC/startup.S"
export OBJ_FILES="startup.o"
export C_INC="-I$SRC -I$CSRC"
export LD_FILE=$SIM_HOME/link_fpga_test.ld

export ELF_OUTPUT=$TESTNAME.elf
export BIN_OUTPUT=$TESTNAME.bin
export HEX_OUTPUT=cpu0_iram.vhx
 
# run the compile 
echo "Start compilation" 
 
CLANG_FLAGS="-target riscv32-unknown-unknown -mcpu=cheriot -mabi=cheriot -mxcheri-rvc -mrelax -Oz -nostdlib -DCHERIOT" 
#CLANG_FLAGS="-target riscv32-unknown-unknown -mcmodel=small -mcpu=pluton -mabi=pluton -mxcheri-rvc -mno-relax -Oz -nostdlib" 
 
 
echo "compile and linking.."
$CLANG $CLANG_FLAGS $C_INC -c $S_FILES
$CLANG $CLANG_FLAGS $C_INC -T$LD_FILE -o $ELF_OUTPUT $C_FILES $OBJ_FILES
 
$GCC_OBJCOPY -O binary -S $ELF_OUTPUT $BIN_OUTPUT

$BIN2HEX $BIN_OUTPUT > $HEX_OUTPUT


echo "Generating disassembled text.."
$LLVM_HOME/llvm-objdump -xdCS --mcpu=cheriot $ELF_OUTPUT > $TESTNAME.dis 

