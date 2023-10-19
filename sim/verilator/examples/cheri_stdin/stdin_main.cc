#include <stdlib.h>
#include <fcntl.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vswci_vtb.h"
#include "Vswci_vtb___024root.h"

#define MAX_SIM_TIME 2000000000        // 100M cycles
// #define VCD_TRACE
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    unsigned char exit_flag, exit_code;
    unsigned char din[4];

    Verilated::commandArgs(argc, argv);
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

    dut->uart_rx_wr_i = 0;
    dut->uart_rx_data_i = 0;

   // dut->ssel0_i = 0;
   // dut->sck0_i = 0;
   // dut->mosi0_i = 0;
   // dut->TCK_i = 0;
   // dut->TMS_i = 0;
   // dut->TDI_i = 0;
   // dut->TDI_i = 0;
   // dut->TDO_io = 0;
   // dut->rxd_dvp_i = 0;

    exit_flag = 0;
    exit_code = 0xfe;

    while (sim_time < MAX_SIM_TIME && (exit_flag==0)) {
    // while (!Verilated::gotFinish()) {
        dut->sysclk_i ^= 1;
        dut->eval();

        exit_code = dut->uart_tx_data_o;
        exit_flag = (exit_code & 0x80);
        exit_code = exit_code & 0x7f;

        dut->uart_rx_wr_i = 0;
        dut->uart_rx_data_i = 0;
        if ((dut->uart_rx_full_o == 0) && dut->sysclk_i) {
          fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);
          if (read (0, din, 1) > 0) {
            dut->uart_rx_wr_i = 1;
            dut->uart_rx_data_i = din[0];
            // printf("-------time = %d, din=%c\n", sim_time, din[0]);
          }
        }

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

    printf ("swci_main exiting with return code %02x\n", exit_code);
    exit(exit_code);
}
