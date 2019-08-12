
interface regs_ini_if; endinterface
interface slv_ini_if; endinterface
interface fmt_rsp_if; endinterface
interface mcdf_if; endinterface

package regs_pkg;
  class regs_ini_trans; endclass
  class regs_ini_stm;
    virtual interface regs_ini_if vif;
    task run(); endtask
  endclass
  class regs_ini_mon;
    virtual interface regs_ini_if vif;
    mailbox #(regs_ini_trans) mb;
    task run(); endtask
  endclass
  class regs_ini_agent;
    virtual interface regs_ini_if vif;
    regs_ini_stm stm;
    regs_ini_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface regs_ini_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass
endpackage

package slv_pkg;
  class slv_ini_trans; endclass
  class slv_ini_stm;
    virtual interface slv_ini_if vif;
    task run(); endtask
  endclass
  class slv_ini_mon;
    virtual interface slv_ini_if vif;
    mailbox #(slv_ini_trans) mb;
    task run(); endtask
  endclass
  class slv_ini_agent;
    virtual interface slv_ini_if vif;
    slv_ini_stm stm;
    slv_ini_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface slv_ini_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass
endpackage

package fmt_pkg;
  class fmt_rsp_trans; endclass
  class fmt_rsp_stm;
    virtual interface fmt_rsp_if vif;
    task run(); endtask
  endclass
  class fmt_rsp_mon;
    virtual interface fmt_rsp_if vif;
    mailbox #(fmt_rsp_trans) mb;
    task run(); endtask
  endclass
  class fmt_rsp_agent;
    virtual interface fmt_rsp_if vif;
    fmt_rsp_stm stm;
    fmt_rsp_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface fmt_rsp_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass
endpackage

package mcdf_pkg;
  import regs_pkg::*;
  import slv_pkg::*;
  import fmt_pkg::*;

  class mcdf_refmod;
    mailbox #(regs_ini_trans) regs_ini_mb;
    mailbox #(slv_ini_trans) slv_ini_mb[3];
    mailbox #(fmt_rsp_trans) exp_mb;
    function new();
      regs_ini_mb = new();
      foreach(slv_ini_mb[i]) slv_ini_mb[i] = new();
      exp_mb = new();
    endfunction
    task run(); endtask
  endclass

  class mcdf_checker;
    mcdf_refmod refmod;
    virtual interface mcdf_if vif;
    mailbox #(regs_ini_trans) regs_ini_mb;
    mailbox #(slv_ini_trans) slv_ini_mb[3];
    mailbox #(fmt_rsp_trans) exp_mb;
    mailbox #(fmt_rsp_trans) rsp_mb;
    function new();
      refmod = new();
      rsp_mb = new();
    endfunction
    function void connect();
      regs_ini_mb = refmod.regs_ini_mb;
      foreach(slv_ini_mb[i]) slv_ini_mb[i] = refmod.slv_ini_mb[i];
      exp_mb = refmod.exp_mb;
    endfunction
    task run(); endtask
  endclass

  class mcdf_env;
    regs_ini_agent regs_ini_agt;
    slv_ini_agent slv_ini_agt[3];
    fmt_rsp_agent fmt_rsp_agt;
    mcdf_checker chk;
    virtual interface mcdf_if vif;
    function new();
      regs_ini_agt = new();
      foreach(slv_ini_agt[i]) slv_ini_agt[i] = new();
      fmt_rsp_agt = new();
      chk = new();
    endfunction
    function void connect();
      chk.connect();
      regs_ini_agt.mon.mb = chk.regs_ini_mb;
      foreach(slv_ini_agt[i]) slv_ini_agt[i].mon.mb = chk.slv_ini_mb[i];
      fmt_rsp_agt.mon.mb = chk.rsp_mb;
    endfunction
    task run();
      fork
        regs_ini_agt.run();
        foreach(slv_ini_agt[i]) slv_ini_agt[i].run();
        fmt_rsp_agt.run();
        chk.run();
      join_none
    endtask
    function void assign_vi(virtual interface mcdf_if intf);
      vif = intf;
      chk.vif = intf;
    endfunction
  endclass
endpackage

module mcdf_tb;

import mcdf_pkg::*;

event build_end_e;
event connect_end_e;
// signals declaration
// interface instantiation
regs_ini_if regs_ini_intf();
slv_ini_if slv_ini_intf0();
slv_ini_if slv_ini_intf1();
slv_ini_if slv_ini_intf2();
fmt_rsp_if fmt_rsp_intf();
mcdf_if mcdf_intf();
// DUT instantiation

// verification environment 
mcdf_env env;

initial begin: build
  env = new();

  -> build_end_e;
end

initial begin: connect
  wait(build_end_e.triggered());

  env.assign_vi(mcdf_intf);
  env.regs_ini_agt.assign_vi(regs_ini_intf);
  env.slv_ini_agt[0].assign_vi(slv_ini_intf0);
  env.slv_ini_agt[1].assign_vi(slv_ini_intf1);
  env.slv_ini_agt[2].assign_vi(slv_ini_intf2);
  env.fmt_rsp_agt.assign_vi(fmt_rsp_intf);

  env.connect();

  ->connect_end_e;
end

initial begin: run
  wait(connect_end_e.triggered());

  fork
    env.run();
  join_none
end
endmodule





