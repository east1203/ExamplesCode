

module objection_application;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_phase(uvm_phase phase);
      #1ps;
      phase.raise_objection(this);
      `uvm_info("run_phase", "entered ..", UVM_LOW)
      #1us;
      `uvm_info("run_phase", "exited ..", UVM_LOW)
      phase.drop_objection(this);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top [run_phase] entered ..
// UVM_INFO @ 0: uvm_test_top [run_phase] exited ..
// UVM_INFO @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
// UVM_INFO @ 0: reporter [UVM/REPORT/CATCHER]




// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top [run_phase] entered ..
// UVM_INFO @ 0: reporter [UVM/REPORT/CATCHER] 

