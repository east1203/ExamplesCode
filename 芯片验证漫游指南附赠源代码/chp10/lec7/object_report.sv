
module object_report;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class test1 extends uvm_test;

    integer f;

    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      f = $fopen("logfile", "w");
      set_report_default_file(f);
      set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
      set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
      set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG | UVM_COUNT);
      set_report_severity_action(UVM_FATAL, UVM_DISPLAY | UVM_LOG | UVM_STOP);
      set_report_verbosity_level(UVM_LOW);
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
// UVM_INFO @ 0: uvm_test_top [RUN] info2
// UVM_WARNING @ 0: uvm_test_top [RUN] warning1
// UVM_ERROR @ 0: uvm_test_top [RUN] error1
// UVM_ERROR @ 0: uvm_test_top [RUN] error3
