
module report_hook;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class test1 extends uvm_test;
    integer f;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_CALL_HOOK);
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
    function bit report_hook(string id, string message, int verbosity, string filename, int line);
      uvm_report_info("RPTHOOK", $sformatf("%s : %s", id, message), UVM_LOW);
      return 1;
    endfunction
    function bit report_error_hook(string id, string message, int verbosity, string filename, int line);
      uvm_report_info("ERRHOOK", $sformatf("%s : %s", id, message), UVM_LOW);
      return 1;
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top [RUN] info2
// UVM_WARNING @ 0: uvm_test_top [RUN] warning1
// UVM_INFO @ 0: uvm_test_top [RPTHOOK] RUN : error1
// UVM_INFO @ 0: uvm_test_top [ERRHOOK] RUN : error1
// UVM_ERROR @ 0: uvm_test_top [RUN] error1
// UVM_INFO @ 0: uvm_test_top [RPTHOOK] RUN : error3
// UVM_INFO @ 0: uvm_test_top [ERRHOOK] RUN : error3
// UVM_ERROR @ 0: uvm_test_top [RUN] error3
