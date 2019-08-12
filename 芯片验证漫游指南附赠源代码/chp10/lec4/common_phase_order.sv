

module common_phase_order;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class subcomp extends uvm_component;
    `uvm_component_utils(subcomp)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      `uvm_info("build_phase", "", UVM_LOW)
    endfunction
    function void connect_phase(uvm_phase phase);
      `uvm_info("connect_phase", "", UVM_LOW)
    endfunction
    function void end_of_elaboration_phase(uvm_phase phase);
      `uvm_info("end_of_elaboration_phase", "", UVM_LOW)
    endfunction
    function void start_of_simulation_phase(uvm_phase phase);
      `uvm_info("start_of_simulation_phase", "", UVM_LOW)
    endfunction
    task run_phase(uvm_phase phase);
      `uvm_info("run_phase", "", UVM_LOW)
    endtask
    function void extract_phase(uvm_phase phase);
      `uvm_info("extract_phase", "", UVM_LOW)
    endfunction
    function void check_phase(uvm_phase phase);
      `uvm_info("check_phase", "", UVM_LOW)
    endfunction
    function void report_phase(uvm_phase phase);
      `uvm_info("report_phase", "", UVM_LOW)
    endfunction
    function void final_phase(uvm_phase phase);
      `uvm_info("final_phase", "", UVM_LOW)
    endfunction
  endclass

  class topcomp extends subcomp;
    subcomp c1, c2;
    `uvm_component_utils(topcomp)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      `uvm_info("build_phase", "", UVM_LOW)
      c1 = subcomp::type_id::create("c1", this);
      c2 = subcomp::type_id::create("c2", this);
    endfunction
  endclass

  class test1 extends uvm_test;
    topcomp t1;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      t1 = topcomp::type_id::create("t1", this);
    endfunction
  endclass

  initial begin
    //t1 = new("t1", null);
    run_test("test1");
  end
endmodule





// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO common_phase_order.sv(48) @ 0: uvm_test_top.t1 [build_phase] 
// UVM_INFO common_phase_order.sv(13) @ 0: uvm_test_top.t1.c1 [build_phase] 
// UVM_INFO common_phase_order.sv(13) @ 0: uvm_test_top.t1.c2 [build_phase] 
// UVM_INFO common_phase_order.sv(16) @ 0: uvm_test_top.t1.c1 [connect_phase] 
// UVM_INFO common_phase_order.sv(16) @ 0: uvm_test_top.t1.c2 [connect_phase] 
// UVM_INFO common_phase_order.sv(16) @ 0: uvm_test_top.t1 [connect_phase] 
// UVM_INFO common_phase_order.sv(19) @ 0: uvm_test_top.t1.c1 [end_of_elaboration_phase] 
// UVM_INFO common_phase_order.sv(19) @ 0: uvm_test_top.t1.c2 [end_of_elaboration_phase] 
// UVM_INFO common_phase_order.sv(19) @ 0: uvm_test_top.t1 [end_of_elaboration_phase] 
// UVM_INFO common_phase_order.sv(22) @ 0: uvm_test_top.t1.c1 [start_of_simulation_phase] 
// UVM_INFO common_phase_order.sv(22) @ 0: uvm_test_top.t1.c2 [start_of_simulation_phase] 
// UVM_INFO common_phase_order.sv(22) @ 0: uvm_test_top.t1 [start_of_simulation_phase] 
// UVM_INFO common_phase_order.sv(25) @ 0: uvm_test_top.t1.c1 [run_phase] 
// UVM_INFO common_phase_order.sv(25) @ 0: uvm_test_top.t1.c2 [run_phase] 
// UVM_INFO common_phase_order.sv(25) @ 0: uvm_test_top.t1 [run_phase] 
// UVM_INFO common_phase_order.sv(28) @ 0: uvm_test_top.t1.c1 [extract_phase] 
// UVM_INFO common_phase_order.sv(28) @ 0: uvm_test_top.t1.c2 [extract_phase] 
// UVM_INFO common_phase_order.sv(28) @ 0: uvm_test_top.t1 [extract_phase] 
// UVM_INFO common_phase_order.sv(31) @ 0: uvm_test_top.t1.c1 [check_phase] 
// UVM_INFO common_phase_order.sv(31) @ 0: uvm_test_top.t1.c2 [check_phase] 
// UVM_INFO common_phase_order.sv(31) @ 0: uvm_test_top.t1 [check_phase] 
// UVM_INFO common_phase_order.sv(34) @ 0: uvm_test_top.t1.c1 [report_phase] 
// UVM_INFO common_phase_order.sv(34) @ 0: uvm_test_top.t1.c2 [report_phase] 
// UVM_INFO common_phase_order.sv(34) @ 0: uvm_test_top.t1 [report_phase] 
// UVM_INFO common_phase_order.sv(37) @ 0: uvm_test_top.t1 [final_phase] 
// UVM_INFO common_phase_order.sv(37) @ 0: uvm_test_top.t1.c1 [final_phase] 
// UVM_INFO common_phase_order.sv(37) @ 0: uvm_test_top.t1.c2 [final_phase]
