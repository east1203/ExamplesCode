module mcdf_env1;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class reg_env extends uvm_agent;
    uvm_component master, slave, scoreboard;
    `uvm_component_utils(reg_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class chnl_env extends uvm_agent;
    uvm_component master, slave, scoreboard, reg_cfg;
    `uvm_component_utils(chnl_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class arb_env extends uvm_agent;
    uvm_component master1, master2, master3;
    uvm_component slave, scoreboard, reg_cfg;
    `uvm_component_utils(arb_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class fmt_env extends uvm_agent;
    uvm_agent master, slave, scoreboard, reg_cfg;
    `uvm_component_utils(fmt_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass


  class mcdf_virtual_sequencer extends uvm_sequencer;
    uvm_sequencer chnl_sqr1, chnl_sqr2, chnl_sqr3, fmt_sqr, reg_sqr;
    `uvm_component_utils(mcdf_virtual_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class mcdf_env1 extends uvm_env;
    `uvm_component_utils(mcdf_env1)
    reg_env reg_e;
    chnl_env chnl_e1;
    chnl_env chnl_e2;
    chnl_env chnl_e3;
    fmt_env fmt_e;
    mcdf_virtual_sequencer virt_sqr;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      reg_e = reg_env::type_id::create("reg_e", this);
      chnl_e1 = chnl_env::type_id::create("chnl_e1", this);
      chnl_e2 = chnl_env::type_id::create("chnl_e2", this);
      chnl_e3 = chnl_env::type_id::create("chnl_e3", this);
      fmt_e = fmt_env::type_id::create("fmt_e", this);
      virt_sqr = mcdf_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction: build_phase


    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // active | passive mode set to sub-envs
      uvm_config_db#(int)::set(this, "reg_e.slave", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e1.slave", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e1.reg_cfg", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e2.slave", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e2.reg_cfg", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e3.slave", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "chnl_e3.reg_cfg", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "arb_e.master1", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "arb_e.master2", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "arb_e.master3", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "arb_e.slave", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "arb_e.reg_cfg", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "fmt_e.master", "is_active", UVM_PASSIVE);
      uvm_config_db#(int)::set(this, "fmt_e.reg_cfg", "is_active", UVM_PASSIVE);
      // virtual sequencer connection
      virt_sqr.reg_sqr = reg_e.master.sequencer;
      virt_sqr.chnl_sqr1 = chnl_e1.master.sequencer;
      virt_sqr.chnl_sqr2 = chnl_e2.master.sequencer;
      virt_sqr.chnl_sqr3 = chnl_e3.master.sequencer;
      virt_sqr.fmt_sqr = fmt_e.slave.sequencer;
    endfunction: connect_phase
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    mcdf_env1 env;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      env = mcdf_env1::type_id::create("env", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule


