module mcdf_env1;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class reg_master_agent extends uvm_agent;
    uvm_sequencer sequencer;
    `uvm_component_utils(reg_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class chnl_master_agent extends uvm_agent;
    uvm_sequencer sequencer;
    `uvm_component_utils(chnl_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass
  
  class fmt_slave_agent extends uvm_agent;
    uvm_sequencer sequencer;
    `uvm_component_utils(fmt_slave_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class mcdf_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mcdf_scoreboard)
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
    reg_master_agent reg_mst;
    chnl_master_agent chnl_mst1;
    chnl_master_agent chnl_mst2;
    chnl_master_agent chnl_mst3;
    fmt_slave_agent fmt_slv;
    mcdf_virtual_sequencer virt_sqr;
    mcdf_scoreboard sb;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      reg_mst = reg_master_agent::type_id::create("reg_mst", this);
      chnl_mst1 = chnl_master_agent::type_id::create("chnl_mst1", this);
      chnl_mst2 = chnl_master_agent::type_id::create("chnl_mst2", this);
      chnl_mst3 = chnl_master_agent::type_id::create("chnl_mst3", this);
      fmt_slv = fmt_slave_agent::type_id::create("fmt_slv", this);
      virt_sqr = mcdf_virtual_sequencer::type_id::create("virt_sqr", this);
      sb = mcdf_scoreboard::type_id::create("sb", this);
    endfunction: build_phase


    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // virtual sequencer connection
      virt_sqr.reg_sqr = reg_mst.sequencer;
      virt_sqr.chnl_sqr1 = chnl_mst1.sequencer;
      virt_sqr.chnl_sqr2 = chnl_mst2.sequencer;
      virt_sqr.chnl_sqr3 = chnl_mst3.sequencer;
      virt_sqr.fmt_sqr = fmt_slv.sequencer;
      // monitor transactions to scoreboard
      // reg_mst.monitor.ap.connect(sb.reg_export);
      // chnl_mst1.monitor.ap.connect(sb.chnl1_export);
      // chnl_mst2.monitor.ap.connect(sb.chnl2_export);
      // chnl_mst3.monitor.ap.connect(sb.chnl3_export);
      // fmt_slv.monitor.ap.connect(sb.fmt_export);
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


