

VCS_CMD = vcs
SIM_DIR = ${CHERIOT_SAFE_DIR}/sim
BUILD_DIR = ${CHERIOT_SAFE_DIR}/out/sim/vcs
TEST_DIR  = ${CHERIOT_SAFE_DIR}/out/run/${TEST}


RTL_SOURCES  = -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_core/msft_cheri_core.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_subsystem/msft_cheri_subsystem.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_arty7/msft_cheri_arty7.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_tb/msft_cheri_tb.vf

all:


build:
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR} && ${VCS_CMD} ${RTL_SOURCES} -sverilog -timescale=1ns/10ps -l sim.log

run:
	mkdir -p ${TEST_DIR}


clean:
	rm -rf ${BUILD_DIR}
