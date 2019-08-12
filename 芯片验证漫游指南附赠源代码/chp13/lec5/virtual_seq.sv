module virtual_seq;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef class mcdf_virtual_sequencer;

  class clk_rst_seq extends uvm_sequence;
    `uvm_object_utils(clk_rst_seq)
    function new(string name = "clk_rst_seq");
      super.new(name);
    endfunction
  endclass

  class reg_cfg_seq extends uvm_sequence;
    `uvm_object_utils(reg_cfg_seq)
    function new(string name = "reg_cfg_seq");
      super.new(name);
    endfunction
  endclass

  class data_trans_seq extends uvm_sequence;
    `uvm_object_utils(data_trans_seq)
    function new(string name = "data_trans_seq");
      super.new(name);
    endfunction
  endclass

  class fmt_slv_cfg_seq extends uvm_sequence;
    `uvm_object_utils(fmt_slv_cfg_seq)
    function new(string name = "fmt_slv_cfg_seq");
      super.new(name);
    endfunction
  endclass

  // element sequences definitions above
  // which belong to different sequencers/agents
  // clk_rst_seq
  // reg_cfg_seq
  // data_trans_seq
  // fmt_slv_cfg_seq

  class mcdf_normal_seq extends uvm_sequence;
    `uvm_object_utils(mcdf_normal_seq)
    `uvm_declare_p_sequencer(mcdf_virtual_sequencer)
    function new(string name = "mcdf_normal_seq");
      super.new(name);
    endfunction
    task body();
      clk_rst_seq clk_seq;
      reg_cfg_seq cfg_seq;
      data_trans_seq data_seq;
      fmt_slv_cfg_seq fmt_seq;

      // virtual sequence is to be attached the
      // virtual sequencer, and further attache
      // its child sequences via p_sequencer.OBJ_SQR_HANDLE

      // configure formatter slave agent 
      `uvm_do_on(fmt_seq, p_sequencer.fmt_sqr)
      // turn on clock and assert reset
      `uvm_do_on(clk_seq, p_sequencer.cr_sqr)
      // configure mcdf registers
      `uvm_do_on(cfg_seq, p_sequencer.reg_sqr)
      // transfer data packets
      fork
        `uvm_do_on(data_seq, p_sequencer.chnl_sqr0)
        `uvm_do_on(data_seq, p_sequencer.chnl_sqr1)
        `uvm_do_on(data_seq, p_sequencer.chnl_sqr2)
      join
    endtask
  endclass

  class cr_master_sequencer extends uvm_sequencer;
    `uvm_component_utils(cr_master_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class reg_master_sequencer extends uvm_sequencer;
    `uvm_component_utils(reg_master_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class chnl_master_sequencer extends uvm_sequencer;
    `uvm_component_utils(chnl_master_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class fmt_slave_sequencer extends uvm_sequencer;
    `uvm_component_utils(fmt_slave_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  
  class reg_master_agent extends uvm_agent;
    reg_master_sequencer sqr;
    // other agents definition/build/connect ignored
    `uvm_component_utils(reg_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = reg_master_sequencer::type_id::create("sqr", this);
    endfunction
  endclass

  class cr_master_agent extends uvm_agent;
    cr_master_sequencer sqr;
    // other agents definition/build/connect ignored
    `uvm_component_utils(cr_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = cr_master_sequencer::type_id::create("sqr", this);
    endfunction
  endclass

  class chnl_master_agent extends uvm_agent;
    chnl_master_sequencer sqr;
    // other agents definition/build/connect ignored
    `uvm_component_utils(chnl_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = chnl_master_sequencer::type_id::create("sqr", this);
    endfunction
  endclass

  class fmt_slave_agent extends uvm_agent;
    fmt_slave_sequencer sqr;
    // other agents definition/build/connect ignored
    `uvm_component_utils(fmt_slave_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = fmt_slave_sequencer::type_id::create("sqr", this);
    endfunction
  endclass

  // element sequencers and agents definition above
  // cr_master_sequencer | cr_master_agent
  // reg_master_sequencer | reg_master_agent
  // chnl_master_sequencer | chnl_master_agent
  // fmt_slave_sequencer | fmt_slave_agent
  class mcdf_virtual_sequencer extends uvm_sequencer;
    cr_master_sequencer cr_sqr;
    reg_master_sequencer reg_sqr;
    chnl_master_sequencer chnl_sqr0;
    chnl_master_sequencer chnl_sqr1;
    chnl_master_sequencer chnl_sqr2;
    fmt_slave_sequencer fmt_sqr;
    `uvm_component_utils(mcdf_virtual_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class mcdf_env extends uvm_env;
    cr_master_agent cr_agt;
    reg_master_agent reg_agt;
    chnl_master_agent chnl_agt0;
    chnl_master_agent chnl_agt1;
    chnl_master_agent chnl_agt2;
    fmt_slave_agent fmt_agt;
    mcdf_virtual_sequencer virt_sqr;
    `uvm_component_utils(mcdf_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      cr_agt = cr_master_agent::type_id::create("cr_agt", this);
      reg_agt = reg_master_agent::type_id::create("reg_agt", this);
      chnl_agt0 = chnl_master_agent::type_id::create("chnl_agt", this);
      chnl_agt1 = chnl_master_agent::type_id::create("chnl_agt", this);
      chnl_agt2 = chnl_master_agent::type_id::create("chnl_agt", this);
      fmt_agt = fmt_slave_agent::type_id::create("fmt_agt", this);
      virt_sqr = mcdf_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      // virtual sequencer connection
      // but no any TLM connection with sequencers
      virt_sqr.cr_sqr = cr_agt.sqr;
      virt_sqr.reg_sqr = reg_agt.sqr;
      virt_sqr.chnl_sqr0 = chnl_agt0.sqr;
      virt_sqr.chnl_sqr1 = chnl_agt1.sqr;
      virt_sqr.chnl_sqr2 = chnl_agt2.sqr;
      virt_sqr.fmt_sqr = fmt_agt.sqr;
    endfunction
  endclass


  class test1 extends uvm_test;
    mcdf_env e;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      e = mcdf_env::type_id::create("e", this);
    endfunction
    task run_phase(uvm_phase phase);
      mcdf_normal_seq seq;
      phase.raise_objection(phase);
      seq = new();
      seq.start(e.virt_sqr);
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule

