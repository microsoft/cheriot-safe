# Copyright (C) Microsoft Corporation. All rights reserved.

#MAKEFILE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

$(info MAKEDIR: ${MAKEFILE_LIST})
$(info CURDIR: ${CURDIR})

PROJECT =
TEST = 
C_DEFINES =
#OUTDIR = ${CURDIR}
OUTDIR = ${CHERIOT_SAFE_DIR}/out/run/${TEST}

#==================================
# PATHS
#==================================
MAKEFILE_DIR 				:= $(dir $(firstword $(MAKEFILE_LIST)))
$(info MAKEFILE_DIR: ${MAKEFILE_DIR})
SIM_DIR							 := ${CHERIOT_SAFE_DIR}/sim
FW_DIR							 := ${SIM_DIR}/firmware
LIBC_DIR             := ${FW_DIR}/libcc
RULE_DIR        		 := ${FW_DIR}/rules
INC_DIR              := ${FW_DIR}/inc
DRIVER_DIR           := ${INC_DIR}/driver
CRT0_PATH            := ${MAKEFILE_DIR}/crt0

TEST_PATH = ${CHERIOT_SAFE_DIR}/sim/test/${TEST}

#==================================
# Include CPU Rule files
#==================================
include $(RULE_DIR)/cpu_rule_cheri.imk

#==================================
# Include LIBC IMK
#==================================
include ${LIBC_DIR}/Makefile.libc.imk

#==================================
# Include Test IMK
#==================================
include ${TEST_PATH}/Makefile.imk

#==================================
# Include DIR
#==================================
INC_DIRS := -I$(MAKEFILE_DIR)/inc -I$(LIBC_DIR)/inc -I$(INC_DIR) -I${DRIVER_DIR} ${TEST_INCLUDES}

#==================================
# FLAGS
#==================================
CFLAGS = $(ARCH_CFLAGS) $(INC_DIRS) $(C_DEFINES)
CXXFLAGS = $(ARCH_CXXFLAGS) $(INC_DIRS) $(CXX_DEFINES) -DCHERI_ARCH
LDFLAGS = $(ARCH_LDFLAGS)

#==================================
# CFILES
#==================================
ASMFILES = $(MAKEFILE_DIR)/crt0/startup_cheri.S ${ASM_SOURCES}
#CFILES = ${LIBC_SOURCES} ${SOURCES}
CXXFILES = ${LIBCXX_SOURCES} $(MAKEFILE_DIR)/crt0/crt0_cheri.cc ${CXXSOURCES} ${SOURCES}
CXXFILES += $(DRIVER_DIR)/uart/UART_MSFT_16550.cc

#==================================
# Linker script
#==================================
LDSCRIPT = -T$(MAKEFILE_DIR)/crt0/crt0_cheri.ld

ASMOBJECTS := $(patsubst %.S, ${OUTDIR}/%.S.o, ${ASMFILES})
COBJECTS   := $(patsubst %.c, ${OUTDIR}/%.c.o, ${CFILES})
CXXOBJECTS := $(patsubst %.cc, ${OUTDIR}/%.cc.o, ${CXXFILES}) 

DEPS := $(patsubst %.o, %.d, $(COBJECTS)) $(patsubst %.o, %.d, $(CXXOBJECTS)) $(patsubst %.o, %.d, $(ASMOBJECTS))

VNCSTR = vnc run -Ix -Ir -wl -r redhat8 


#==================================
# Targets
#==================================
.PHONY: default all clean
all: ${OUTDIR}/../${CPU}_iram.vhx $(OUTDIR)/$(TEST).dis GENIROM
#all: ${OUTDIR}/../${CPU}_iram.vhx $(OUTDIR)/$(TEST).dis
default: all

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(info ASMFILES:    $(ASMFILES))
$(info CFILES:      $(CFILES))
$(info CXXFILES:    $(CXXFILES))
$(info ASMOBJECTS:  $(ASMOBJECTS))
$(info COBJECTS:    $(COBJECTS))
$(info CXXOBJECTS:  $(CXXOBJECTS))
$(info ===============================================)

clean:
	rm -rf $(OUTDIR)

$(OUTDIR)/$(TEST).elf: $(ASMOBJECTS) $(COBJECTS) $(CXXOBJECTS)
	$(ARCH_LD) $(ARCH_LDFLAGS) $(LDSCRIPT) $^ -o $@

-include $(DEPS)


#==================================
# Rules
#==================================
$(OUTDIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(ARCH_CC) $(CFLAGS) -MMD -c $< -o $@

$(OUTDIR)/%.S.o: %.S
	mkdir -p $(dir $@)
	$(ARCH_CC) $(CFLAGS) -MMD -c $< -o $@

$(OUTDIR)/%.cc.o: %.cc
	mkdir -p $(dir $@)
	$(ARCH_CXX) $(CXXFLAGS) -MMD -c $< -o $@

$(OUTDIR)/$(TEST).dis: $(OUTDIR)/$(TEST).elf
	$(ARCH_OBJDUMP) ${ARCH_OBJDUMP_FLAGS} $< > $@

$(OUTDIR)/$(TEST).vhx: $(OUTDIR)/$(TEST).elf
	$(ARCH_OBJCOPY) -O verilog --set-section-flags .bss=alloc,load,contents $^ $@

%.bin: %.elf
	$(ARCH_OBJCOPY) -O binary --gap-fill 0 $< $@

# Execute ECC GEN
${OUTDIR}/${CPU}_iram.vhx: ${OUTDIR}/${TEST}.vhx
	${ECC_GEN_PATH} -a 16 -b 32 -m 64 -e -t 20040000 -o $@ $<

# Copy file to the execution place
${OUTDIR}/../${CPU}_iram.vhx: ${OUTDIR}/${CPU}_iram.vhx
	cp $^ ../.
 
# Generate IROM
#            IMM     	RD    OPCODE
#            0x00080  0x5   0x17
AUIPC_INST = "00080297"
JAL_INST   = "000282E7"
.PHONY: GENIROM
GENIROM:
	rm -f ${OUTDIR}/../${CPU}_irom.vhx
	number=0 ; while [[ $$number -lt 32 ]] ; do 						\
	  echo "00000000" >>  ${OUTDIR}/../${CPU}_irom.vhx ;	\
		((number = number + 1)) ; 													\
	done
	echo ${AUIPC_INST}    >> ${OUTDIR}/../${CPU}_irom.vhx
	echo ${JAL_INST}    	>> ${OUTDIR}/../${CPU}_irom.vhx
	echo "00000000"     	>> ${OUTDIR}/../${CPU}_irom.vhx
	echo "GENROM Done"

