
module stm_ini(
  input         clk,
  input         rstn,
  output [ 1:0] cmd,
  output [ 7:0] cmd_addr,
  output [31:0] cmd_data_w,
  input  [31:0] cmd_data_r
);

localparam IDLE = 2'b00;
localparam RD   = 2'b01;
localparam WR   = 2'b10;

typedef struct{
  bit [ 1:0] cmd;
  bit [ 7:0] cmd_addr;
  bit [31:0] cmd_data_w;
  bit [31:0] cmd_data_r;
} trans;

trans ts[3];

task automatic op_copy(ref trans t, input trans s);
  t = s;
  $display(" t.cmd='h%0x \n t.cmd_addr='h%0x \n t.cmd_data_w='h%0x",
           t.cmd, t.cmd_addr, t.cmd_data_w);
endtask

function void reff();
  trans s;
  trans t;
  s.cmd = WR;
  s.cmd_addr = 'h10;
  s.cmd_data_w = 'h_3F;
  op_copy(t, s);

endfunction

initial begin
  reff();
end

function automatic int auto_cnt(input a);
  int cnt = 0;
  cnt += a;
  return cnt;
endfunction

function static int static_cnt(input a);
  static int cnt = 0;
  cnt += a;
  return cnt;
endfunction

function int def_cnt(input a);
  static int cnt = 0;
  cnt += a;
  return cnt;
endfunction

initial begin
  $display("@1 auto_cnt = %0d", auto_cnt(1));
  $display("@2 auto_cnt = %0d", auto_cnt(1));
  $display("@1 static_cnt = %0d", static_cnt(1));
  $display("@2 static_cnt = %0d", static_cnt(1));
  $display("@1 def_cnt = %0d", def_cnt(1));
  $display("@2 def_cnt = %0d", def_cnt(1));
end

endmodule


module tb;

regs_cr_if  crif();
regs_ini_if iniif();

assign iniif.clk  = crif.clk;
assign iniif.rstn = crif.rstn;


ctrl_regs dut(
  .clk_i(crif.clk),
  .rstn_i(crif.rstn),
  .cmd_i(iniif.cmd),
  .cmd_addr_i(iniif.cmd_addr),
  .cmd_data_i(iniif.cmd_data_w),
  .cmd_data_o(iniif.cmd_data_r)
);

stm_ini ini(
  .clk(crif.clk),
  .rstn(crif.rstn),
  .cmd(iniif.cmd),
  .cmd_addr(iniif.cmd_addr),
  .cmd_data_w(iniif.cmd_data_w),
  .cmd_data_r(iniif.cmd_data_r)
);



endmodule
