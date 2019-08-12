

typedef enum bit [1:0] {IDLE=2'b00, RD=2'b01, WR=2'b10} cmd_t;

module stm_ini;

virtual interface regs_ini_if vif;

typedef struct{
  bit [ 1:0] cmd;
  bit [ 7:0] cmd_addr;
  bit [31:0] cmd_data_w;
  bit [31:0] cmd_data_r;
} trans;

trans ts[];

task op_wr(trans t);
  @(posedge vif.clk);
  vif.cmd <= t.cmd;
  vif.cmd_addr <= t.cmd_addr;
  vif.cmd_data_w <= t.cmd_data_w;
endtask

task op_rd(trans t);
  @(posedge vif.clk);
  vif.cmd <= t.cmd;
  vif.cmd_addr <= t.cmd_addr;
endtask

task op_idle();
  @(posedge vif.clk);
  vif.cmd <= IDLE;
  vif.cmd_addr <= 0;
  vif.cmd_data_w <= 0;
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
  wait(vif != null);
  @(posedge vif.rstn);
  foreach(ts[i]) begin
    op_parse(ts[i]);
  end
  repeat(5) @(posedge vif.clk);
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

stm_ini ini();


initial begin:arrini
  ini.ts = new[3];
  ini.ts[0].cmd         = WR;
  ini.ts[0].cmd_addr    = 0;
  ini.ts[0].cmd_data_w  = 32'hFFFF_FFFF;
  ini.ts[1].cmd         = RD;
  ini.ts[1].cmd_addr    = 0;
  ini.ts[2].cmd         = IDLE;
end

initial begin:setif
  ini.vif = iniif;
end


endmodule
