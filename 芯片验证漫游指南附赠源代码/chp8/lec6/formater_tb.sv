
`timescale 1ns/1ns

module formater_tb;

reg clk;
reg rstn;
reg[1:0]   a2f_id;
reg        a2f_val;
reg[31:0]  a2f_dat;
reg[2:0]   slv0_len;
reg[2:0]   slv1_len;
reg[2:0]   slv2_len;


wire       f2a_ack;

wire[1:0]  fmt_chid;
reg        fmt_grant;
wire[4:0]  fmt_length;
wire       fmt_req;
wire[31:0] fmt_data;
wire       fmt_start;
wire       fmt_end;

event build_end_e;
event connect_end_e;

import fmt_pkg::*;

fmt_ini_mon ini_mon;
fmt_rsp_mon rsp_mon;
fmt_checker chk;

fmt_ini_if  ini_if(clk, rstn);
fmt_rsp_if  rsp_if(clk, rstn);

assign ini_if.a2f_val  = a2f_val;
assign ini_if.a2f_id   = a2f_id;
assign ini_if.a2f_dat  = a2f_dat;
assign ini_if.slv0_len = slv0_len;
assign ini_if.slv1_len = slv1_len;
assign ini_if.slv2_len = slv2_len;
assign ini_if.f2a_ack  = f2a_ack;

assign rsp_if.fmt_chid   = fmt_chid;
assign rsp_if.fmt_grant  = fmt_grant;
assign rsp_if.fmt_length = fmt_length;
assign rsp_if.fmt_req    = fmt_req;
assign rsp_if.fmt_data   = fmt_data;
assign rsp_if.fmt_start  = fmt_start;
assign rsp_if.fmt_end    = fmt_end;



initial begin: build
  ini_mon = new();
  rsp_mon = new();
  chk = new();

  // config 
  chk.en_chk_rst = 0;
  chk.en_chk_len = 0;
  chk.en_chk_data = 0;
  ini_if.en_chk_prot = 0;
  rsp_if.en_chk_prot = 1;

  -> build_end_e;
end

initial begin: connect
  wait(build_end_e.triggered());

  // interface connection
  ini_mon.vif = ini_if;
  rsp_mon.vif = rsp_if;
  chk.ini_vif = ini_if;
  chk.rsp_vif = rsp_if;
  // event assignment
  chk.reset_e = ini_mon.reset_e;
  chk.req_trans_e = rsp_mon.req_trans_e;
  chk.connect();
  // mailbox assignment
  ini_mon.ini_mb = chk.ini_mb; 
  rsp_mon.rsp_mb = chk.rsp_mb; 

  ->connect_end_e;
end

initial begin: run
  wait(connect_end_e.triggered());

  fork
    ini_mon.run();
    rsp_mon.run();
    chk.run();
  join_none
end

initial begin

  clk  = 0;
  rstn = 1;
  a2f_val = 0;

  #10  rstn = 0;

  #100 rstn = 1;
  @(posedge clk) a2f_id = 0; slv0_len = 0;

  @(posedge clk) a2f_val = 1; a2f_dat = 0;
  @(posedge clk) a2f_val = 0; a2f_dat = 1;
  @(posedge clk) a2f_val = 1; a2f_dat = 2;
  @(posedge clk) a2f_val = 0; a2f_dat = 3;
  @(posedge clk) a2f_val = 1; a2f_dat = 4;
  @(posedge clk) a2f_val = 1; a2f_dat = 6;
  @(posedge clk) a2f_val = 1; a2f_dat = 8;
  @(posedge clk) a2f_val = 1; a2f_dat = 9;
  @(posedge clk) a2f_val = 0;

  wait (fmt_req == 1) 
  repeat(2) @(posedge clk) fmt_grant = 1;
  @(posedge clk) a2f_val = 1; a2f_dat = 10; fmt_grant = 0;
  @(posedge clk) a2f_val = 0; a2f_dat = 11;
  @(posedge clk) a2f_val = 1; a2f_dat = 12;
  @(posedge clk) a2f_val = 0; a2f_dat = 13;
  @(posedge clk) a2f_val = 1; a2f_dat = 14;
  wait (fmt_req == 1) 
  @(posedge clk)   fmt_grant = 1;
  @(posedge clk)   fmt_grant = 0;
  @(posedge clk) a2f_val = 1; a2f_dat = 16;
  @(posedge clk) a2f_val = 1; a2f_dat = 18;
  @(posedge clk) a2f_val = 1; a2f_dat = 19;
  @(posedge clk) a2f_val = 0;
  @(posedge clk) a2f_val = 1; a2f_dat = 20;
  @(posedge clk) a2f_dat = 21;
  @(posedge clk) a2f_dat = 22;
  @(posedge clk) a2f_dat = 23;
  @(posedge clk) a2f_dat = 24;
  @(posedge clk) a2f_dat = 25;
  @(posedge clk) a2f_dat = 26;
  @(posedge clk) a2f_dat = 27;
  @(posedge clk) a2f_dat = 28;
  @(posedge clk) a2f_dat = 29;
  @(posedge clk) a2f_dat = 30;
  @(posedge clk) a2f_dat = 31;
  @(posedge clk) a2f_dat = 32;
  @(posedge clk) a2f_dat = 33;
  @(posedge clk) a2f_dat = 34;
  @(posedge clk) a2f_dat = 35;
  @(posedge clk) a2f_dat = 36;
  @(posedge clk) a2f_dat = 37;
  @(posedge clk) a2f_dat = 38;
  @(posedge clk) a2f_dat = 39;
  @(posedge clk) a2f_dat = 40;
  @(posedge clk) a2f_dat = 41;
  @(posedge clk) a2f_dat = 42;
  @(posedge clk) a2f_dat = 43;
  @(posedge clk) a2f_dat = 44;
  @(posedge clk) a2f_dat = 45;


  
       #500   $stop;
end

always #50 clk=~clk;

formater formater_inst(

                 .clk_i(clk),
                 .rstn_i(rstn),
                 .a2f_val_i(a2f_val),
                 .a2f_id_i(a2f_id),
                 .a2f_dat_i(a2f_dat),
                 .slv0_len_i(slv0_len),
                 .slv1_len_i(slv1_len),
                 .slv2_len_i(slv2_len),                             
                 .f2a_ack_o(f2a_ack),
                 .fmt_chid_o(fmt_chid),                  
                 .fmt_length_o(fmt_length),                  
                 .fmt_req_o(fmt_req),
                 .fmt_grant_i(fmt_grant),
                 .fmt_data_o(fmt_data),
                 .fmt_start_o(fmt_start),
                 .fmt_end_o(fmt_end)
                  );
endmodule


