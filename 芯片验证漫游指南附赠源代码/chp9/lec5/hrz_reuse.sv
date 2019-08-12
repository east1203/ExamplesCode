

package mcdf_global_pkg;
  parameter data_width_p = 64;
  parameter slave_num_p = 4;
endpackage

interface arb_ini_if;
  parameter data_width_p = mcdf_global_pkg::data_width_p;
  logic [data_width_p-1 :0] data;
endinterface

interface arb_rsp_if;
  parameter data_width_p = mcdf_global_pkg::data_width_p;
  logic [data_width_p-1 :0] data;
endinterface



package arb_pkg;
  import mcdf_global_pkg::*;

  class arb_ini_trans; endclass
  class arb_ini_stm;
    virtual interface arb_ini_if #(.data_width_p(data_width_p)) vif;
    task run(); endtask
  endclass
  class arb_ini_mon;
    virtual interface arb_ini_if #(.data_width_p(data_width_p)) vif;
    mailbox #(arb_ini_trans) mb;
    task run(); endtask
  endclass
  class arb_ini_agent;
    virtual interface arb_ini_if #(.data_width_p(data_width_p)) vif;
    arb_ini_stm stm;
    arb_ini_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface arb_ini_if #(.data_width_p(data_width_p)) intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass


  class arb_rsp_trans; endclass
  class arb_rsp_stm;
    virtual interface arb_rsp_if #(.data_width_p(data_width_p)) vif;
    task run(); endtask
  endclass
  class arb_rsp_mon;
    virtual interface arb_rsp_if #(.data_width_p(data_width_p)) vif;
    mailbox #(arb_rsp_trans) mb;
    task run(); endtask
  endclass
  class arb_rsp_agent;
    virtual interface arb_rsp_if #(.data_width_p(data_width_p)) vif;
    arb_rsp_stm stm;
    arb_rsp_mon mon;
    function new();
      stm = new();
      mon = new();
    endfunction
    task run(); endtask
    function void assign_vi(virtual interface arb_rsp_if #(.data_width_p(data_width_p)) intf); 
      vif = intf;
      stm.vif = intf;
      mon.vif = intf;
    endfunction
  endclass

  class arb_checker;
    mailbox #(arb_ini_trans) ini_mb[slave_num_p];
    mailbox #(arb_rsp_trans) rsp_mb;
    function new();
      foreach(ini_mb[i]) ini_mb[i] = new();
      rsp_mb = new();
    endfunction
    function void connect(); endfunction
    task run(); endtask
  endclass

  class arb_env;
    arb_ini_agent arb_ini_agt[slave_num_p];
    arb_rsp_agent arb_rsp_agt;
    arb_checker chk;

    function new();
      foreach(arb_ini_agt[i]) arb_ini_agt[i] = new();
      arb_rsp_agt = new();
      chk = new();
    endfunction

    function void connect();
      foreach(arb_ini_agt[i]) begin
        arb_ini_agt[i].mon.mb = chk.ini_mb[i];
      end
      arb_rsp_agt.mon.mb = chk.rsp_mb;
    endfunction

    task run(); endtask
  endclass
endpackage



module arb_tb;
  arb_ini_if arb_ini_if0();
  arb_ini_if arb_ini_if1();
  arb_ini_if arb_ini_if2();
  arb_ini_if arb_ini_if3();
  arb_rsp_if arb_rsp_if();

import arb_pkg::*;

event build_end_e;
event connect_end_e;

arb_env env;

initial begin
  env = new();
  -> build_end_e;
end

initial begin
  wait(build_end_e.triggered());
  env.arb_ini_agt[0].assign_vi(arb_ini_if0);
  env.arb_ini_agt[1].assign_vi(arb_ini_if1);
  env.arb_ini_agt[2].assign_vi(arb_ini_if2);
  env.arb_ini_agt[3].assign_vi(arb_ini_if3);
  env.arb_rsp_agt.assign_vi(arb_rsp_if);
  env.connect();
  ->connect_end_e;
end

initial begin
  wait(connect_end_e.triggered());
  fork
    env.run();
  join_none
end
endmodule

