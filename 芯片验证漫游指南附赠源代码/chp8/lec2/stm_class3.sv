

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

virtual function void copy_data(basic_test t);
  t.def = def;
  t.fin = fin;
endfunction

virtual function basic_test copy();
  basic_test t = new(0);
  copy_data(t);
  return t;
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

function void copy_data(basic_test t);
  test_wr h;
  super.copy_data(t);
  $cast(h, t);
  def = h.def;
endfunction

function basic_test copy();
  test_wr t = new();
  copy_data(t);
  return t;
endfunction


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

test_wr wr;
test_wr h;

initial begin
  wr = new();
  $cast(h,wr.copy());
  $display("wr.def = %0d", wr.def);
  $display("h.def = %0d", h.def);
  h.def = 300;
  $display("wr.def = %0d", wr.def);
  $display("h.def = %0d", h.def);
end

initial begin:setif
  ini.vif = iniif;
end

initial begin:drvrun
  ini.stmgen();
end


basic_test t1, t2;

initial begin
  t1 = new(); 
  t2 = t1;
  t1 = new();
  t1 = null;
  t2 = null;
end


endmodule
