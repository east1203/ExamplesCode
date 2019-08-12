module uvm_barrier_sync;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component;
    uvm_barrier b1;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      b1 = uvm_barrier_pool::get_global("b1");
    endfunction
    task run_phase(uvm_phase phase);
      #10ns;
      `uvm_info("BSYNC", $sformatf("c1 wait for b1 at %0t ps", $time), UVM_LOW)
      b1.wait_for();
      `uvm_info("BSYNC", $sformatf("c1 is activated at %0t ps", $time), UVM_LOW)
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_barrier b1;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      b1 = uvm_barrier_pool::get_global("b1");
    endfunction
    task run_phase(uvm_phase phase);
      #20ns;
      `uvm_info("BSYNC", $sformatf("c2 wait for b1 at %0t ps", $time), UVM_LOW)
      b1.wait_for();
      `uvm_info("BSYNC", $sformatf("c2 is activated at %0t ps", $time), UVM_LOW)
    endtask
  endclass

  class env1 extends uvm_env;
    comp1 c1;
    comp2 c2;
    uvm_barrier b1;
    `uvm_component_utils(env1)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      c1 = comp1::type_id::create("c1", this);
      c2 = comp2::type_id::create("c2", this);
      b1 = uvm_barrier_pool::get_global("b1");
    endfunction: build_phase

    task run_phase(uvm_phase phase);
      b1.set_threshold(3);
      `uvm_info("BSYNC", $sformatf("env set b1 threshold %d at %0t ps", b1.get_threshold(), $time), UVM_LOW)
      #50ns;
      b1.set_threshold(2);
      `uvm_info("BSYNC", $sformatf("env set b1 threshold %d at %0t ps", b1.get_threshold(), $time), UVM_LOW)
    endtask

  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    env1 env;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      env = env1::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(phase);
      #1us;
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule




// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.env [BSYNC] env set b1 threshold 3 at 0 ps
// UVM_INFO @ 10000: uvm_test_top.env.c1 [BSYNC] c1 wait for b1 at 10000 ps
// UVM_INFO @ 20000: uvm_test_top.env.c2 [BSYNC] c2 wait for b1 at 20000 ps
// UVM_INFO @ 50000: uvm_test_top.env [BSYNC] env set b1 threshold 2 at 50000 ps
// UVM_INFO @ 50000: uvm_test_top.env.c1 [BSYNC] c1 is activated at 50000 ps
// UVM_INFO @ 50000: uvm_test_top.env.c2 [BSYNC] c2 is activated at 50000 ps
