(* CORE_GENERATION_INFO = "clock_generator,clk_wiz_v3_4,{component_name=clock_generator,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,feedback_source=FDBK_AUTO,primtype_sel=MMCM_ADV,num_out_clk=6,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=true,use_locked=false,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=SINGLE,clock_mgr_type=MANUAL,manual_override=false}" *)

module msftDvIp_mmcm_arty7_1
 (// Clock in ports
  input         sysClk_i,
  // Clock out ports
  output        clk25Mhz_o,
  // Status and control signals
  input         RESETn_i
 );

  // Clocking primitive
  //------------------------------------
  // Instantiation of the MMCM primitive
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused
  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_unused;
  wire        clkfbout;
  wire        clkfbout_buf;
  wire        clkfboutb_unused;
  wire        clkout0_unused;
  wire        clkout0b_unused;
  wire        clkout1b_unused;
  wire        clkout2b_unused;
  wire        clkout3_unused;
  wire        clkout3b_unused;
  wire        clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;


`ifdef XILINX_PLL_MODEL__
  // This model is to be used only for simulation when the Xilinx Simulation model is not available. 
  reg [2:0] div_clk;
  reg       clk25Mhz;
  `ifdef VERILATOR
  assign   clk25Mhz_o = sysClk_i;
  `else
  assign    clk25Mhz_o = clk25Mhz;
  `endif

  assign clk200Mhz_o = sysClk_i & RESETn_i;

  always @(posedge sysClk_i)
  begin
    if(~RESETn_i) begin
      div_clk <= 3'h0; 
      clk25Mhz <= 1'b0;
    end else begin
      if(div_clk == 3'h1) begin
        div_clk <= 3'h0;
        clk25Mhz <= ~clk25Mhz;
      end else begin
        div_clk <= div_clk + 1'b1;
      end 
    end
  end

`else

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
//    .CLKOUT4_CASCADE      ("FALSE"),
//    .COMPENSATION         ("ZHOLD"),

    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),

    .CLKFBOUT_MULT_F      (10.000),
    .CLKFBOUT_PHASE       (0.000),
//    .CLKFBOUT_USE_FINE_PS ("FALSE"),

//    .CLKOUT0_DIVIDE_F     (20.000),
//    .CLKOUT0_PHASE        (0.000),
//    .CLKOUT0_DUTY_CYCLE   (0.500),
//    .CLKOUT0_USE_FINE_PS  ("FALSE"),

    .CLKOUT1_DIVIDE       (40),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),

    .CLKOUT2_DIVIDE       (5),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.500),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),

//    .CLKOUT3_DIVIDE       (10),
//    .CLKOUT3_PHASE        (0.000),
//    .CLKOUT3_DUTY_CYCLE   (0.500),
//    .CLKOUT3_USE_FINE_PS  ("FALSE"),

//    .CLKOUT4_DIVIDE       (10),
//    .CLKOUT4_PHASE        (0.000),
//    .CLKOUT4_DUTY_CYCLE   (0.500),
//    .CLKOUT4_USE_FINE_PS  ("FALSE"),

//    .CLKOUT5_DIVIDE       (10),
//    .CLKOUT5_PHASE        (0.000),
//    .CLKOUT5_DUTY_CYCLE   (0.500),
//    .CLKOUT5_USE_FINE_PS  ("FALSE"),

    .CLKIN1_PERIOD        (10.000),
    .REF_JITTER1          (0.010))
  mmcm_adv_inst
    // Output clocks
   (.CLKFBOUT            (clkfbout),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clkout0_unused),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk25Mhz),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf),
//    .CLKIN1              (clkin1),
    .CLKIN1              (sysClk_i),    
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_unused),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (~RESETn_i));

  // Output buffering
  //-----------------------------------
  BUFG clkf_buf
   (.O (clkfbout_buf),
    .I (clkfbout));

  BUFG clkout1_buf
   (.O   (clk25Mhz_o),
    .I   (clk25Mhz));


  BUFG clkout2_buf
   (.O   (clk200Mhz_o),
    .I   (clk200Mhz));

//  BUFG clkout3_buf
//   (.O   (usbClk_o),
//    .I   (usbClk));

//  BUFG clkout4_buf
//   (.O   (phyClk0_o),
//    .I   (phyClk0));

//  BUFG clkout5_buf
//   (.O   (phyClk1_o),
//    .I   (phyClk1));

//  BUFG clkout6_buf
//   (.O   (fftClk_o),
//    .I   (fftClk));

`endif

endmodule
