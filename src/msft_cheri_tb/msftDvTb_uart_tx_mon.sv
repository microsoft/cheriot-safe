// Copyright (C) Microsoft Corporation. All rights reserved.

module msftDvTb_uart_tx_mon #(
    parameter DO_PRINT = 0,
    parameter TEST_ARG_PREFIX = "HSP",
    parameter BROM_FILE = "hsp_firmware/FLASH.mem",
    parameter BAUD_RATE = 115200,
    parameter ENABLE_ROM_CODE = 1
  ) (
  input        rstn_i,
  input        rxd_i,
  output       txd_o,
  input        testDisabled_i,
  output       testEnd_o,
  output       testFail_o
);
//timescale is required because different projects will have different timescale
//and this monitor uses absolute delays.
timeunit 1ns;
timeprecision 1ps;

string PROMPT = $sformatf("%s> ",TEST_ARG_PREFIX);

reg [7:0]     rx_data;
reg [2:0]     rx_cnt;
reg           testEnd_ff = 0;
reg           testFail_ff = 0;
reg           txd_ff = 1;
bit [7:0]     tx_data;
reg [2:0]     tx_cnt;
reg [31:0]    char_cnt = 0;

reg [31:0]    rom_size;
reg [31:0]    rom_idx;

assign        testEnd_o = testEnd_ff | testDisabled_i;
assign        testFail_o = testFail_ff;

assign        txd_o = txd_ff;
event         sample;
event         d_sample;

reg auto_baud;
reg rx_error = 0;

event         break_det;
bit           ab_done = 0;
bit           do_print;
         
  
realtime  ab_start;
realtime  ab_stop;
realtime  ab_dly;

reg baud_check_enable = 0;
string run_arg;
string print_str = PROMPT;
string test_arg_prefix_str = TEST_ARG_PREFIX;
int unsigned test_baud_rate; //baud rate pass from run arg
int unsigned test_exp_baud_rate; //expected baud rate passed from test used for checking

always @(break_det)
begin
  auto_baud = 0;
end

initial begin
  auto_baud = 0; //for auto baud calculation this is set to 0 and after baud rate is calculated set to 1.
  //prefix for arg required to have different arg for different instantiation of monitor
  // paramter TEST_ARG_PREFIX is used for run time arg prefix e.g. <TEST_ARG_PREFIX>_TEST_BAUD_RATE
  // if TEST_ARG_PREFIX is HSP then args are
  //runopts:
  // - "HSP_TEST_BAUD_RATE=2304000" => test provided baudrate
  // - "HSP_AUTO_BAUD_DISABLE=1" => disable auto baud caluculation use default BAUD_RATE
  // - "HSP_TEST_EXP_BAUD_RATE=2304000" => used for checking the baud rate
  run_arg = {test_arg_prefix_str,"_","TEST_BAUD_RATE=%d"};
  if($value$plusargs(run_arg,test_baud_rate)) begin
    ab_dly = (real'(1000000000)/real'(test_baud_rate)) * 1ns;
    $display("%f: %s ab_dly (bit time period) = %t baud_rate = %d", $time,PROMPT,ab_dly,test_baud_rate);
    auto_baud = 1; //set to 1 so auto baud calculation is disabled
  end else if ($value$plusargs({test_arg_prefix_str,"_","AUTO_BAUD_DISABLE=%d"},auto_baud)) begin
    $display("%f: %s Auto baud calculation disabled from test using default baud rate = %d", $time,PROMPT,BAUD_RATE);
    ab_dly = (real'(1000000000)/real'(BAUD_RATE)) * 1ns;
    auto_baud = 1; //set to 1 so auto baud calculation is disabled
  end
  do_print = DO_PRINT;
  if($value$plusargs({test_arg_prefix_str,"_","DO_PRINT=%d"},do_print)) begin
    $display("%f: %s do_print = %d printing enabled from uart mon", $time,PROMPT,do_print);
  end
  run_arg = {test_arg_prefix_str,"_","TEST_EXP_BAUD_RATE=%d"};
  if($value$plusargs(run_arg,test_exp_baud_rate)) begin
    $display("%f: %s TEST_EXP_BAUD_RATE = %d ", $time,PROMPT,test_exp_baud_rate);
    baud_check_enable = 1;
  end 
end

//==========================================
// Auto Baud
// Looking for a SPACE which is 0x20
// So from Start fall to bit[5] rise is 6
// bit times hence the divide by 6
// reset auto_baud when HSP sees reset
//==========================================
assign auto_baud_edge = auto_baud | rxd_i;
always @(negedge auto_baud_edge)
begin
  if(!auto_baud_edge) begin
    ab_start = $time;
    @(posedge rxd_i);
    ab_stop = $time;
    ab_dly = (ab_stop - ab_start)/6;
    ab_done = 1; //Set this bit to one after ab_dly is set
    #(ab_dly/2);
    -> d_sample;
    repeat (2) begin
      #ab_dly;
      -> d_sample;
    end
    #ab_dly;
    -> sample;
    if(rxd_i) begin
      auto_baud = 1'b1;
    end
  end else if (!rstn_i)
    auto_baud = 1'b0;
end

reg [7:0] rxbyte;
event     rxbyte_rcvd;
event     txbyte_done;
event     txbyte_start;
reg [7:0] txbyte;

assign auto_bauded_edge = auto_baud ? rxd_i : (~auto_baud | rxd_i);
//==========================================
// check baud rate 
//==========================================

final 
begin
    if(baud_check_enable)
      check_baud_rate();
end

task check_baud_rate;
begin
  test_baud_rate = (1000000000/ab_dly);
  $display("%f: %s test baud_rate = %d ab_dly = %t", $time,PROMPT, test_baud_rate,ab_dly);
  if(test_baud_rate == test_exp_baud_rate) begin
    $display("test is running at expected baud rate %d",test_exp_baud_rate);
  end else begin
    $display("ERROR: test is running at baud rate %d expected baud rate is %d",test_baud_rate,test_exp_baud_rate);
  end
end
endtask

//==========================================
// State machine
//==========================================
always @(negedge auto_bauded_edge)
begin
  rx_error = 0;
  #(ab_dly/2);
  -> sample;
  if(~rxd_i) begin
    //Received Start bit so resetting count to 0
    rx_data = 0;
    rx_cnt = 0;
    //Capture the 8 data bits
    repeat (8) begin
      if(~auto_baud) begin
        rx_data = 8'h2D; //'-' character
        break;
      end
      #(ab_dly);
      -> d_sample;
      rx_data[rx_cnt] = rxd_i;
      rx_cnt = rx_cnt + 1'b1;
      //$display($time, " %s rx_data[%0d] = %0b",PROMPT,rx_cnt,rx_data);
    end
    #(ab_dly);
    -> sample;
    //If detected Start bit then pass the 8 bits to rxbyte
    if(rxd_i) begin
      rxbyte = rx_data;
      //$display($time, "%s rxbyte = %0b | %0d",PROMPT,rxbyte,rxbyte);
      -> rxbyte_rcvd;
    end else begin
      if(rxbyte == 8'h00) begin
        $display("%f: %s Received BREAK waiting for posedge of RXD", $time, PROMPT);
        -> break_det;
      end else begin
        $display("%f: ERROR...%s ASCI Stop Bit Error", $time, PROMPT);
        rx_error = 1'b1;
      end
    end
  end
end


// Eliminate the possibility of false positive, passing the test on a reset
// This can happen if:
//  1. the start bit happens before reset
//  2. the UART gets reset and drives one on rxd_i
//  3. one on rxd_i is interpreted as 0xFF
//  4. 0xFF causes test to end and pass when it should not!
logic saw_reset;  
always@(negedge rstn_i) begin
  saw_reset  = 1;
  repeat(10) begin
    #(ab_dly);    
  end
  saw_reset  = 0;  
end
  
//==========================================
// Print the data
//==========================================
always @(rxbyte_rcvd iff !saw_reset) begin
  if(rxbyte == 8'h0a) begin
    if(do_print) begin
      $display(print_str);
    end
    print_str = PROMPT;

  end else if(rxbyte[7:1] == 7'h7f) begin
    repeat (100) #4ns;
    testFail_ff = ~rxbyte[0];
    testEnd_ff  = 1;
  end else begin
    print_str = $sformatf("%s%c", print_str, rxbyte[7:0]);
  end
end

//==========================================
// Transmit Data at byte at a time
//==========================================
always @(txbyte_start)
begin
  txd_ff = 1'b0;
  tx_cnt = 0;
  //tx_data = txdatastr[char_cnt];
  char_cnt = char_cnt + 1;
  repeat (8) begin
    #(ab_dly);
    //txd_ff = tx_data[tx_cnt];
    txd_ff = txbyte[tx_cnt];
    tx_cnt = tx_cnt + 1;
  end
  #(ab_dly);
  txd_ff = 1'b1;
  #(ab_dly);
  ->> txbyte_done;
end

//string txID = "+pkt0001I-"

/*
always @(posedge auto_baud)
begin
  txbyte = "+";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "p";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "k";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "t";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "0";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "0";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "0";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "1";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "I";
  -> txbyte_start;
  @txbyte_done;
  txbyte = "-";
  -> txbyte_start;
  @txbyte_done;
end
*/


//===============================================================================================
// UART recover mode
//===============================================================================================

string recovery_str = "\nRECOVERY\n"; //TODO chip-id, version can be added for comparison once known.
initial begin
  run_arg = {test_arg_prefix_str,"_","RECOVERY_STRING=%s"};
  if($value$plusargs(run_arg,recovery_str)) begin
    $display("%f: %s RECOVERY_STRING = %s ", $time,PROMPT,recovery_str);
    baud_check_enable = 1;
  end 
end

int comp_idx = 0;
always @(rxbyte_rcvd)
begin
   //$display("%f: DEBUG...rom recovery mode rcd = %s %x exp = %s %x", $time, rx_data,rx_data,recovery_str[comp_idx],recovery_str[comp_idx]);
   //$write("%s",rx_data);
  if(ENABLE_ROM_CODE) begin
   if(recovery_str[comp_idx] == rx_data) begin
     comp_idx++;
     //$display("%f: INFO...MATCH", $time);
     if(comp_idx==recovery_str.len()) begin
        $display("%f: INFO...%s Message detected on UART", $time, recovery_str);
        read_rom_code();
     end
   end else begin
     comp_idx = 0;
   end
  end
end

//===========================================
// read rom code
//===========================================
bit [7:0] txdatastr [];
string bromfile;
task read_rom_code;
begin
  if($test$plusargs({test_arg_prefix_str,"_","FIXED_BROM_UART_DATA"})) begin
    $display("%f: using fixed boot data = +pkt0001I-",$time);
    txdatastr = new[10];
    txdatastr = {"+","p","k","t","0","0","0","1","I","-"};
  end else if($value$plusargs({test_arg_prefix_str,"_","BROM_FILE=%s"},bromfile)) begin
    int fh;
    int num_bytes;
    bit [7:0] image_copy [1024*64];
    $display("%f: Reading boot code from user file %s", $time, bromfile);
    fh = $fopen(bromfile,"r");
    while ($fscanf(fh,"%x",image_copy[num_bytes]) == 1) begin
      num_bytes = num_bytes+1;
    end
    $fclose(fh);

    txdatastr = new[num_bytes];
    $readmemh(bromfile,txdatastr);
  end else begin
     $display("%f: Reading boot code from file %s", $time, BROM_FILE);
     $readmemh(BROM_FILE,txdatastr);
     if(!txdatastr.size()) begin
       $display("%f: Could not read boot code from file using default data = +pkt0001I-",$time);
       txdatastr = new[10];
       txdatastr = {"+","p","k","t","0","0","0","1","I","-"};
     end
  end
  foreach(txdatastr[i]) begin
    $display("%f: %s boot code = %x) %x %s", $time, PROMPT,i,txdatastr[i],txdatastr[i]);
  end
  rom_idx = 0;
  rom_size = txdatastr.size();
  #40us;
  if(rom_size) begin
    send_tx_data();
  end else begin
    $display("%f: %s ERROR... 0 byte boot code", $time, PROMPT);
  end
end
endtask

//===========================================
// send boot code on uart interface
//===========================================
task send_tx_data;
begin
  while(rom_idx<rom_size) begin
    txd_ff = 1'b0;
    tx_cnt = 0;
    tx_data = txdatastr[rom_idx];
    $display("%f: %x driving boot code on uart interface", $time, tx_data);
    rom_idx = rom_idx + 1;
    repeat (8) begin
      #(ab_dly);
      txd_ff = tx_data[tx_cnt];
      tx_cnt = tx_cnt + 1;
    end
    #(ab_dly);
    txd_ff = 1'b1;
    #(ab_dly);
  end
  $display("%f: %s DONE driving boot code on uart interface", $time, PROMPT);
end
endtask
endmodule
