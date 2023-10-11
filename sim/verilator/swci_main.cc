#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vswci_vtb.h"
#include "Vswci_vtb___024root.h"

#define MAX_SIM_TIME 2000000
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    //VmsftDvIp_cheri_arty7_fpga *dut = new VmsftDvIp_cheri_arty7_fpga;
    Vswci_vtb *dut = new Vswci_vtb;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
#ifdef VCD_TRACE
    dut->trace(m_trace, 10);
    m_trace->open("waveform.vcd");
#endif
    uint64_t sim_time = 0;

    dut->sysclk_i = 0;
    dut->rstn_i = 1;
   // dut->ssel0_i = 0;
   // dut->sck0_i = 0;
   // dut->mosi0_i = 0;
   // dut->TCK_i = 0;
   // dut->TMS_i = 0;
   // dut->TDI_i = 0;
   // dut->TDI_i = 0;
   // dut->TDO_io = 0;
   // dut->rxd_dvp_i = 0;

    while (sim_time < MAX_SIM_TIME) {
    // while (!Verilated::gotFinish()) {
        dut->sysclk_i ^= 1;
        dut->eval();
#ifdef VCD_TRACE
        m_trace->dump(sim_time);
#endif
        sim_time++;
        if (sim_time == 10) {
            dut->rstn_i = 0;
        } else if (sim_time == 20) {
            dut->rstn_i = 1;
        }
    }

#ifdef VCD_TRACE
    m_trace->close();
#endif
    delete dut;
    exit(EXIT_SUCCESS);
}
