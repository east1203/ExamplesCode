module test_hierarchy;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class env extends uvm_env;
    `uvm_component_utils(env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class agent extends uvm_agent;
    `uvm_component_utils(agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    env e1, e2;
    agent a1;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      e1 = env::type_id::create("c1", this);
      e2 = env::type_id::create("c2", this);
      a1 = agent::type_id::create("a1", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] cfg.val1 is          30 after get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] cfg.str1 is   c1 after get
// UVM_INFO @ 0: uvm_test_top.c2 [SETVAL] cfg.val1 is          50 after get
// UVM_INFO @ 0: uvm_test_top.c2 [SETVAL] cfg.str1 is   c2 after get
