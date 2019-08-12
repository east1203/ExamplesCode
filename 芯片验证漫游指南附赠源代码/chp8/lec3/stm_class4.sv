

typedef enum bit [1:0] {IDLE=2'b00, RD=2'b01, WR=2'b10} cmd_t;


typedef struct packed{
  bit [ 1:0] cmd;
  bit [ 7:0] cmd_addr;
  bit [31:0] cmd_data_w;
  bit [31:0] cmd_data_r;
} trans;

class incacc;

  rand trans arr[];

  constraint c1 {foreach(arr[i]) arr[i].cmd inside {IDLE, RD, WR};};
  constraint c2 {foreach(arr[i]) arr[i].cmd_addr inside {'h0, 'h4, 'h8, 'h10, 'h14, 'h18};};
  constraint c3 {foreach(arr[i]) arr[i].cmd_data_w[31:6] == 0;};
  constraint c4 {foreach(arr[i]) arr[i].cmd_data_r == 0;};
  constraint c5 {soft arr.size() >= 2 && arr.size() <= 4;};
  constraint c6 {foreach(arr[i]) (i < arr.size()-1) -> arr[i].cmd_addr < arr[i+1].cmd_addr;};
  constraint c7 {arr.size() >0 -> arr[0].cmd_addr < 'h10;};


  function void print();
    foreach(arr[i]) begin
      $display("arr[%0d].cmd = 'h%0x", i, arr[i].cmd);
      $display("arr[%0d].cmd_addr = 'h%0x", i, arr[i].cmd_addr);
      $display("arr[%0d].cmd_data_w = 'h%0x", i, arr[i].cmd_data_w);
      $display("arr[%0d].cmd_data_r = 'h%0x", i, arr[i].cmd_data_r);
    end
  endfunction
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

virtual task test(stm_ini ini);
endtask

endclass


class test_wr extends basic_test;

incacc acc;

task test(stm_ini ini);
  super.test(ini);
  acc = new();
  //assert(acc.randomize() with {arr.size() == 5;});
  //assert(acc.randomize(null));
  //acc.rand_mode(0);
  //acc.arr.rand_mode(0);
  acc.c6.constraint_mode(0);
  assert(acc.randomize());
  $display("test_wr::test");
  ini.ts = new[acc.arr.size()];
  ini.ts = acc.arr;
  acc.print();
endtask

endclass

class test_rd extends basic_test;

task test(stm_ini ini);
  super.test(ini);
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

incacc acc;

initial begin
  wr = new();
  wr.test(ini);
end

initial begin:setif
  ini.vif = iniif;
end

initial begin:drvrun
  ini.stmgen();
end

initial begin
  int arrsize;
  $display("arrsize = %0d before system randomization", arrsize);
  std::randomize(arrsize) with {arrsize >= 2 && arrsize <= 4;};
  $display("arrsize = %0d after system randomization", arrsize);
end

endmodule
