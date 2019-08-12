

class arb_trans;
  rand bit [31:0] data;
  rand bit [ 1:0] id;
endclass

interface arb_ini_if;
endinterface

interface arb_rsp_if;
endinterface

class arb_ini_mon;
  virtual interface arb_ini_if vif;
  mailbox #(arb_trans) mb;

  task run();
  endtask

  task mon_trans();
  endtask

  task put_trans(arb_trans t);
    wait(mb != null);
    mb.put(t);
  endtask
endclass


class arb_rsp_mon;
  virtual interface arb_rsp_if vif;
  mailbox #(arb_trans) mb;

  task run();
  endtask

  task mon_trans();
  endtask

  task put_trans(arb_trans t);
    wait(mb != null);
    mb.put(t);
  endtask
endclass


class arb_checker;
  mailbox #(arb_trans) ini1_mb;
  mailbox #(arb_trans) ini2_mb;
  mailbox #(arb_trans) ini3_mb;
  mailbox #(arb_trans) rsp_mb;

  function new();
    ini1_mb = new();
    ini2_mb = new();
    ini3_mb = new();
    rsp_mb  = new();
  endfunction

  task run();
  endtask
endclass


module arb_tb;

arb_ini_mon ini1_mon = new();
arb_ini_mon ini2_mon = new();
arb_ini_mon ini3_mon = new();
arb_rsp_mon rsp_mon  = new();
arb_checker chk      = new();

arb_ini_if ini1_if();
arb_ini_if ini2_if();
arb_ini_if ini3_if();
arb_rsp_if rsp_if();

initial begin: connection
  ini1_mon.vif = ini1_if;
  ini2_mon.vif = ini2_if;
  ini3_mon.vif = ini3_if;
  rsp_mon.vif  = rsp_if;
  ini1_mon.mb  = chk.ini1_mb;
  ini2_mon.mb  = chk.ini2_mb;
  ini3_mon.mb  = chk.ini3_mb;
  rsp_mon.mb   = chk.rsp_mb;
end

initial begin: run
  #1ps; // wait proc::connection finished
  fork
    ini1_mon.run();
    ini2_mon.run();
    ini3_mon.run();
    rsp_mon.run();
    chk.run();
  join_none
end


initial begin
automatic arb_trans t = new();
#2ps;
t.randomize();
ini1_mon.put_trans(t);
t.randomize();
ini2_mon.put_trans(t);
t.randomize();
ini3_mon.put_trans(t);
t.randomize();
rsp_mon.put_trans(t);
end
endmodule




