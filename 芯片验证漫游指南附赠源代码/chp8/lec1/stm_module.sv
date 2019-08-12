
module stm_ini(
  input         clk,
  input         rstn,
  output [ 1:0] cmd,
  output [ 7:0] cmd_addr,
  output [31:0] cmd_data_w,
  input  [31:0] cmd_data_r
);

logic [ 1:0] v_cmd;
logic [ 7:0] v_cmd_addr;
logic [31:0] v_cmd_data_w;

assign cmd = v_cmd;
assign cmd_addr = v_cmd_addr;
assign cmd_data_w = v_cmd_data_w;

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

initial begin
  ts[0].cmd         = WR;
  ts[0].cmd_addr    = 0;
  ts[0].cmd_data_w  = 32'hFFFF_FFFF;
  ts[1].cmd         = RD;
  ts[1].cmd_addr    = 0;
  ts[2].cmd         = IDLE;
end

task op_wr(trans t);
  @(posedge clk);
  v_cmd <= t.cmd;
  v_cmd_addr <= t.cmd_addr;
  v_cmd_data_w <= t.cmd_data_w;
endtask

task op_rd(trans t);
  @(posedge clk);
  v_cmd <= t.cmd;
  v_cmd_addr <= t.cmd_addr;
endtask

task op_idle();
  @(posedge clk);
  v_cmd <= IDLE;
  v_cmd_addr <= 0;
  v_cmd_data_w <= 0;
endtask

task op_parse(trans t);
  case(t.cmd)
    WR: op_wr(t);
    RD: op_rd(t);
    IDLE: op_idle();
    default: $error("Invalid CMD!");
  endcase
endtask

initial begin: stmgen
  @(posedge rstn);
  foreach(ts[i]) begin
    op_parse(ts[i]);
  end
  repeat(5) @(posedge clk);
  $finish();
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
