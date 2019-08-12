
module component_report;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component; 
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_phase(uvm_phase phase);
      uvm_report_info("RUN", "info1", UVM_HIGH);
      uvm_report_info("RUN", "info2", UVM_MEDIUM);
      uvm_report_warning("RUN", "warning1", UVM_LOW);
      uvm_report_error("RUN", "error1", UVM_NONE);
      uvm_report_error("RUN", "error2", UVM_HIGH);
      uvm_report_error("RUN", "error3", UVM_LOW);
    endtask
  endclass

  class test1 extends uvm_test;
    integer f;
    comp1 c1;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      uvm_root top;
      f = $fopen("logfile", "w");
      top = uvm_root::get();
      top.set_report_default_file_hier(f);
      top.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
      top.set_report_severity_action_hier(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
      top.set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG | UVM_COUNT);
      top.set_report_severity_action_hier(UVM_FATAL, UVM_DISPLAY | UVM_LOG | UVM_STOP);
      top.set_report_verbosity_level_hier(UVM_LOW);
      c1 = comp1::type_id::create("c1", this);
    endfunction
    task run_phase(uvm_phase phase);
      uvm_report_info("RUN", "info1", UVM_MEDIUM);
      uvm_report_info("RUN", "info2", UVM_LOW);
      uvm_report_warning("RUN", "warning1", UVM_LOW);
      uvm_report_error("RUN", "error1", UVM_LOW);
      uvm_report_error("RUN", "error2", UVM_HIGH);
      uvm_report_error("RUN", "error3", UVM_LOW);
    endtask
    function void report_phase(uvm_phase phase);
      $fclose(f);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_WARNING @ 0: uvm_test_top.c1 [RUN] warning1
// UVM_ERROR @ 0: uvm_test_top.c1 [RUN] error1
// UVM_ERROR @ 0: uvm_test_top.c1 [RUN] error3
// UVM_INFO @ 0: uvm_test_top [RUN] info2
// UVM_WARNING @ 0: uvm_test_top [RUN] warning1
// UVM_ERROR @ 0: uvm_test_top [RUN] error1
// UVM_ERROR @ 0: uvm_test_top [RUN] error3
