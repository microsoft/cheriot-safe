

VCS_CMD = vcs
SIM_DIR = ${CHERIOT_SAFE_DIR}/sim
BUILD_DIR = ${CHERIOT_SAFE_DIR}/out/sim/vcs
TEST_DIR  = ${CHERIOT_SAFE_DIR}/out/run/${TEST}


RTL_SOURCES  = -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_core/msft_cheri_core.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_subsystem/msft_cheri_subsystem.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_arty7/msft_cheri_arty7.vf
RTL_SOURCES += -f ${CHERIOT_SAFE_DIR}/src/msft_cheri_tb/msft_cheri_tb.vf

UCLI = ${CHERIOT_SAFE_DIR}/sim/dump.ucli
LIB_SO = -sv_lib Apb

all:


build:
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR} && ${VCS_CMD} ${RTL_SOURCES} -sverilog -debug_access+all -timescale=1ns/10ps -l sim.log

run:
	mkdir -p ${TEST_DIR}
	make -f ${CHERIOT_SAFE_DIR}/sim/firmware/Makefile TEST=${TEST}
	cd ${TEST_DIR} && make -f ${PACKAGE_DIR}/include/Makefile.dpi.so PACKAGE=Apb
	rm -f ${TEST_DIR}/simv
	rm -f ${TEST_DIR}/simv.daidir
	ln -s ${BUILD_DIR}/simv ${TEST_DIR}/.
	ln -s ${BUILD_DIR}/simv.daidir ${TEST_DIR}/.
	cd $(TEST_DIR) && ./simv -ucli -i ${UCLI} ${LIB_SO} -l sim.log | tee test.log; exit $${PIPESTATUS[0]}


clean:
	rm -rf ${BUILD_DIR}
