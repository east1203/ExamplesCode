
module config_variable;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component; 
    `uvm_component_utils(comp1)
    int val1 = 1;
    string str1 = "null";
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      `uvm_info("SETVAL", $sformatf("val1 is %d before get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s before get", str1), UVM_LOW)
      uvm_config_db#(int)::get(this, "", "val1", val1);
      uvm_config_db#(string)::get(this, "", "str1", str1);
      `uvm_info("SETVAL", $sformatf("val1 is %d after get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s after get", str1), UVM_LOW)
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    comp1 c1;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      uvm_config_db#(int)::set(this, "c1", "val1", 100);
      uvm_config_db#(string)::set(this, "c1", "str1", "comp1");
      c1 = comp1::type_id::create("c1", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] val1 is           1 before get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] str1 is null before get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] val1 is         100 after get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] str1 is comp1 after get
