

typedef enum bit [1:0] {IDLE=2'b00, RD=2'b01, WR=2'b10} cmd_t;


class trans;
  bit [ 1:0] cmd;
  bit [ 7:0] cmd_addr;
  bit [31:0] cmd_data_w;
  bit [31:0] cmd_data_r;

endclass

class stm_ini;

virtual interface regs_ini_if vif;

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

task stmgen();
  wait(vif != null);
  @(posedge vif.rstn);
  foreach(ts[i]) begin
    op_parse(ts[i]);
  end
endtask

endclass


class basic_test;

int def = 100;
int fin;

virtual task test(stm_ini ini);
  $display("basic_test::test");
endtask

function new(int val);
  $display("basic_test::new");
  $display("basic_test::def = %0d", def);
  fin = val;
  $display("basic_test::fin = %0d", fin);
endfunction
endclass


class test_wr extends basic_test;
int def = 200;

function new();
  super.new(def);
  $display("test_wr::new");
  $display("test_wr::super.def = %0d", super.def);
  $display("test_wr::this.def = %0d", def);
endfunction

task test(stm_ini ini);
  super.test(ini);
  $display("test_wr::test");
endtask
endclass

class test_rd extends basic_test;

function new();
  super.new(def);
  $display("test_rd::new");
endfunction

task test(stm_ini ini);
  super.test(ini);
  $display("test_rd::test");
endtask
endclass

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

stm_ini ini = new();

basic_test t;

test_wr wr;

test_wr hwr;

test_rd hrd;

initial begin
  wr = new();
  t = wr;
  if(!$cast(hwr, t))
    $error("cannot assign t to hwr");
  if(!$cast(hrd, t))
    $error("cannot assign t to hrd");
  //hwr = t;
  //hrd = t;

  $display("wr.def = %0d", wr.def);
  $display("t.def = %0d", t.def);


  $display("wr test starts");
  wr.test(ini);
  $display("wr test ends");

  $display("t test starts");
  t.test(ini);
  $display("t test ends");
end

initial begin:setif
  ini.vif = iniif;
end

initial begin:drvrun
  ini.stmgen();
end


endmodule
