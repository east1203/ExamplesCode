
interface regs_ini_if; endinterface
interface regs_rsp_if; endinterface
interface slv_ini_if; endinterface
interface slv_rsp_if; endinterface
interface arb_ini_if; endinterface
interface arb_rsp_if; endinterface
interface fmt_ini_if; endinterface
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


  class regs_rsp_trans; endclass
  class regs_rsp_stm;
    virtual interface regs_rsp_if vif;
    task run(); endtask
  endclass
  class regs_rsp_mon;
    virtual interface regs_rsp_if vif;
    mailbox #(regs_rsp_trans) mb;
    task run(); endtask
  endclass
  class regs_rsp_agent;
    virtual interface regs_rsp_if vif;
    regs_rsp_stm stm;
    regs_rsp_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface regs_rsp_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass

  class regs_checker;
    mailbox #(regs_ini_trans) ini_mb;
    mailbox #(regs_rsp_trans) rsp_mb;
    function new();
      ini_mb = new();
      rsp_mb = new();
    endfunction
    function void connect(); endfunction
    task run(); endtask
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

    class slv_rsp_trans; endclass
  class slv_rsp_stm;
    virtual interface slv_rsp_if vif;
    task run(); endtask
  endclass
  class slv_rsp_mon;
    virtual interface slv_rsp_if vif;
    mailbox #(slv_rsp_trans) mb;
    task run(); endtask
  endclass
  class slv_rsp_agent;
    virtual interface slv_rsp_if vif;
    slv_rsp_stm stm;
    slv_rsp_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface slv_rsp_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass

  class slv_checker;
    mailbox #(slv_ini_trans) ini_mb;
    mailbox #(slv_rsp_trans) rsp_mb;
    function new();
      ini_mb = new();
      rsp_mb = new();
    endfunction
    function void connect(); endfunction
    task run(); endtask
  endclass
endpackage


package arb_pkg;
  class arb_ini_trans; endclass
  class arb_ini_stm;
    virtual interface arb_ini_if vif;
    task run(); endtask
  endclass
  class arb_ini_mon;
    virtual interface arb_ini_if vif;
    mailbox #(arb_ini_trans) mb;
    task run(); endtask
  endclass
  class arb_ini_agent;
    virtual interface arb_ini_if vif;
    arb_ini_stm stm;
    arb_ini_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface arb_ini_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass


    class arb_rsp_trans; endclass
  class arb_rsp_stm;
    virtual interface arb_rsp_if vif;
    task run(); endtask
  endclass
  class arb_rsp_mon;
    virtual interface arb_rsp_if vif;
    mailbox #(arb_rsp_trans) mb;
    task run(); endtask
  endclass
  class arb_rsp_agent;
    virtual interface arb_rsp_if vif;
    arb_rsp_stm stm;
    arb_rsp_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface arb_rsp_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass

  class arb_checker;
    mailbox #(arb_ini_trans) ini_mb[3];
    mailbox #(arb_rsp_trans) rsp_mb;
    function new();
      foreach(ini_mb[i]) ini_mb[i] = new();
      rsp_mb = new();
    endfunction
    function void connect(); endfunction
    task run(); endtask
  endclass
endpackage

package fmt_pkg;
  class fmt_ini_trans; endclass
  class fmt_ini_stm;
    virtual interface fmt_ini_if vif;
    task run(); endtask
  endclass
  class fmt_ini_mon;
    virtual interface fmt_ini_if vif;
    mailbox #(fmt_ini_trans) mb;
    task run(); endtask
  endclass
  class fmt_ini_agent;
    virtual interface fmt_ini_if vif;
    fmt_ini_stm stm;
    fmt_ini_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface fmt_ini_if intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass


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

  class fmt_checker;
    mailbox #(fmt_ini_trans) ini_mb;
    mailbox #(fmt_rsp_trans) rsp_mb;
    function new();
      ini_mb = new();
      rsp_mb = new();
    endfunction
    function void connect(); endfunction
    task run(); endtask
  endclass
endpackage

package mcdf_pkg;
  import regs_pkg::*;
  import slv_pkg::*;
  import arb_pkg::*;
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


  typedef enum {MCDF_TB, REGS_TB, SLV_TB, ARB_TB, FMT_TB} tb_mode_t;

  class mcdf_env;
    regs_ini_agent regs_ini_agt;
    regs_rsp_agent regs_rsp_agt;
    regs_checker regs_chk;
    virtual interface regs_ini_if regs_ini_vif;
    virtual interface regs_rsp_if regs_rsp_vif;

    slv_ini_agent slv_ini_agt[3];
    slv_rsp_agent slv_rsp_agt[3];
    slv_checker slv_chk;
    virtual interface slv_ini_if slv_ini_vif[3];
    virtual interface slv_rsp_if slv_rsp_vif[3];

    arb_ini_agent arb_ini_agt[3];
    arb_rsp_agent arb_rsp_agt;
    arb_checker arb_chk;
    virtual interface arb_ini_if arb_ini_vif[3];
    virtual interface arb_rsp_if arb_rsp_vif;

    fmt_ini_agent fmt_ini_agt;
    fmt_rsp_agent fmt_rsp_agt;
    fmt_checker fmt_chk;
    virtual interface fmt_ini_if fmt_ini_vif;
    virtual interface fmt_rsp_if fmt_rsp_vif;

    mcdf_checker chk;
    virtual interface mcdf_if vif;

    tb_mode_t tb_mode;

    function new(tb_mode_t m = MCDF_TB);
      tb_mode = m;
      if(tb_mode == MCDF_TB) begin
        regs_ini_agt = new();
        foreach(slv_ini_agt[i]) slv_ini_agt[i] = new();
        fmt_rsp_agt = new();
        chk = new();
      end
      else if(tb_mode == REGS_TB) begin
        regs_ini_agt = new();
        regs_rsp_agt = new();
        regs_chk = new();
      end
      else if(tb_mode == SLV_TB) begin
        slv_ini_agt[0] = new();
        slv_rsp_agt[0] = new();
        slv_chk = new();
      end
      else if(tb_mode == ARB_TB) begin
        foreach(arb_ini_agt[i]) arb_ini_agt[i] = new();
        arb_rsp_agt = new();
        arb_chk = new();
      end
      else if(tb_mode == FMT_TB) begin
        fmt_ini_agt = new();
        fmt_rsp_agt = new();
        fmt_chk = new();
      end
      else
        $fatal("env:: tb_mode is out of enum type");
    endfunction

    function void connect();
      if(tb_mode == MCDF_TB) begin
        chk.connect();
        regs_ini_agt.mon.mb = chk.regs_ini_mb;
        foreach(slv_ini_agt[i]) slv_ini_agt[i].mon.mb = chk.slv_ini_mb[i];
        fmt_rsp_agt.mon.mb = chk.rsp_mb;
      end
      else if(tb_mode == REGS_TB) begin
        regs_ini_agt.mon.mb = regs_chk.ini_mb;
        regs_rsp_agt.mon.mb = regs_chk.rsp_mb;
      end
      else if(tb_mode == SLV_TB) begin
        slv_ini_agt[0].mon.mb = slv_chk.ini_mb;
        slv_rsp_agt[0].mon.mb = slv_chk.rsp_mb;
      end
      else if(tb_mode == ARB_TB) begin
        foreach(arb_ini_agt[i]) arb_ini_agt[i].mon.mb = arb_chk.ini_mb[i];
        arb_rsp_agt.mon.mb = arb_chk.rsp_mb;
      end
      else if(tb_mode == FMT_TB) begin
        fmt_ini_agt.mon.mb = fmt_chk.ini_mb;
        fmt_rsp_agt.mon.mb = fmt_chk.rsp_mb;
      end
    endfunction

    task run();
      if(tb_mode == MCDF_TB) begin
        fork
          regs_ini_agt.run();
          foreach(slv_ini_agt[i]) slv_ini_agt[i].run();
          fmt_rsp_agt.run();
          chk.run();
        join_none
      end
      else if(tb_mode == REGS_TB) begin
        regs_ini_agt.run();
        regs_rsp_agt.run();
        regs_chk.run();
      end
      else if(tb_mode == SLV_TB) begin
        slv_ini_agt[0].run();
        slv_rsp_agt[0].run();
        slv_chk.run();
      end
      else if(tb_mode == ARB_TB) begin
        foreach(arb_ini_agt[i]) arb_ini_agt[i].run();
        arb_rsp_agt.run();
        arb_chk.run();
      end
      else if(tb_mode == FMT_TB) begin
        fmt_ini_agt.run();
        fmt_rsp_agt.run();
        fmt_chk.run();
      end
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
