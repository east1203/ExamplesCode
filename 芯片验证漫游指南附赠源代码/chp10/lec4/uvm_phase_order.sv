

module uvm_phase_order;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void start_of_simulation_phase(uvm_phase phase);
      `uvm_info("start_of_simulation", "", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "entered ..", UVM_LOW)
      #1us;
      `uvm_info("run_phase", "exited ..", UVM_LOW)
      phase.drop_objection(this);
    endtask
    task reset_phase(uvm_phase phase);
      `uvm_info("reset_phase", "", UVM_LOW)
    endtask
    task configure_phase(uvm_phase phase);
      `uvm_info("configure_phase", "", UVM_LOW)
    endtask
    task main_phase(uvm_phase phase);
      `uvm_info("main_phase", "", UVM_LOW)
    endtask
    task shutdown_phase(uvm_phase phase);
      `uvm_info("shutdown_phase", "", UVM_LOW)
    endtask
    function void extract_phase(uvm_phase phase);
      `uvm_info("extract_phase", "", UVM_LOW)
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule





// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top [start_of_simulation] 
// UVM_INFO @ 0: uvm_test_top [run_phase] entered ..
// UVM_INFO @ 0: uvm_test_top [reset_phase] 
// UVM_INFO @ 0: uvm_test_top [configure_phase] 
// UVM_INFO @ 0: uvm_test_top [main_phase] 
// UVM_INFO @ 0: uvm_test_top [shutdown_phase] 
// UVM_INFO @ 1000000: uvm_test_top [run_phase] exited ..
// UVM_INFO @ 1000000: uvm_test_top [extract_phase] 
